package wini.winitest.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import wini.winitest.common.MenuUtil;
import wini.winitest.service.CodeService;
import wini.winitest.service.MenuService;
import wini.winitest.service.RoleService;
import wini.winitest.service.UserService;

@Controller
public class RoleController {
	
	@Resource(name = "menuService")
  private MenuService menuService;
	
	@Resource(name = "roleService")
	private RoleService roleService;
	
	@Resource(name = "codeService")
	private CodeService codeService;

	@Resource(name = "userService")
	private UserService userService;

	/** 롤 관리 목록 */
	@RequestMapping(value = "/role/roleManage.do", method = RequestMethod.POST)
	public String roleManage(@RequestParam Map<String, Object> param, Model model) throws Exception {
		MenuUtil.addMenu(model, menuService);

		// null 방어 및 기본값 설정 — 서비스에 보장된 값만 전달
		if (param.get("currentPageNo") == null || "".equals(param.get("currentPageNo"))) {
			param.put("currentPageNo", "1");
		}
		if (param.get("recordPerPage") == null || "".equals(param.get("recordPerPage"))) {
			param.put("recordPerPage", "10");
		}
		param.put("pageSize", "10");

		try {
			// 검색조건 콤보박스용
			model.addAttribute("useYnOptions",    codeService.selectCodeOptions("USE_YN"));
			model.addAttribute("adminYnOptions",  codeService.selectCodeOptions("ADMIN_YN"));
			model.addAttribute("userTypeOptions", codeService.selectCodeOptions("USER_TYPE"));

			Map<String, Object> result = roleService.selectRoleList(param);
			model.addAttribute("list",           result.get("list"));
			model.addAttribute("search",         result.get("search"));
			model.addAttribute("paginationInfo", result.get("paginationInfo"));
		} catch (Exception e) {
			model.addAttribute("msg", "서버 오류가 발생했습니다.");
			e.printStackTrace();
		}
		return "role/roleManage";
	}

	/** 메뉴별 권한 관리 */
	@RequestMapping(value = "/role/menuPerm.do", method = RequestMethod.POST)
	public String menuPerm(@RequestParam Map<String, Object> param, Model model) throws Exception {
		MenuUtil.addMenu(model, menuService);
		model.addAttribute("roleList", roleService.selectAllRoleList());

		/* 롤 검색 키워드 유지 */
		String keyword = (String) param.get("keyword");
		if (keyword != null && !keyword.isEmpty()) {
			model.addAttribute("keyword", keyword);
		}

		String selectedRoleNoStr = (String) param.get("selectedRoleNo");
		if (selectedRoleNoStr != null && !selectedRoleNoStr.isEmpty()) {
			int selectedRoleNo = Integer.parseInt(selectedRoleNoStr);
			param.put("roleNo", selectedRoleNoStr);
			model.addAttribute("selectedRoleNo", selectedRoleNo);
			model.addAttribute("menuPermList",   roleService.selectMenuPermList(param));
		}
		return "role/menuPerm";
	}

	/** 권한별 사용자 관리 */
	@RequestMapping(value = "/role/userRole.do", method = RequestMethod.POST)
	public String roleUser(@RequestParam Map<String, Object> param, Model model) throws Exception {
		MenuUtil.addMenu(model, menuService);
		model.addAttribute("roleList", roleService.selectAllRoleList());
		model.addAttribute("userList", userService.selectUserListByRole(param));
		return "role/roleUser";
	}

	/** 메뉴 권한 목록 조회 (AJAX) */
	@RequestMapping(value = "/role/menuPermList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> menuPermList(@RequestParam Map<String, Object> param) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("list", roleService.selectMenuPermList(param));
			result.put("msg", "S");
		} catch (Exception e) {
			result.put("msg", "E");
			result.put("desc", "서버 오류가 발생했습니다.");
		}
		return result;
	}

	/** 메뉴별 권한 저장 (AJAX) */
	@RequestMapping(value = "/role/menuPermSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> menuPermSave(@RequestParam Map<String, Object> param, HttpSession session) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			String roleNo = (String) param.get("roleNo");
			if (roleService.isSystemAdmin(roleNo)) {
				result.put("msg",  "E");
				result.put("desc", "시스템관리자의 메뉴 권한은 변경할 수 없습니다.");
				return result;
			}

			Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
			Object modUser = loginUser != null ? loginUser.get("userNo") : null;

			String permsJson = (String) param.get("permsJson");

			List<Map<String, Object>> perms = new ObjectMapper().readValue(
				permsJson, new TypeReference<List<Map<String, Object>>>() {});

			roleService.saveMenuPermList(roleNo, perms, modUser);
			result.put("msg",  "S");
			result.put("desc", "저장이 완료됐습니다.");
		} catch (Exception e) {
			result.put("msg",  "E");
			result.put("desc", "서버 오류가 발생했습니다.");
			e.printStackTrace();
		}
		return result;
	}

	/** 권한별 사용자 권한 일괄 적용 (AJAX) */
	@RequestMapping(value = "/role/userRoleApply.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> userRoleApply(@RequestParam String roleNo,
	                                         @RequestParam(required = false) String[] userNos,
	                                         HttpSession session) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			if (roleService.isSystemAdmin(roleNo)) {
				result.put("msg",  "E");
				result.put("desc", "시스템관리자 권한은 사용자에게 부여할 수 없습니다.");
				return result;
			}
			if (userNos == null || userNos.length == 0) {
				result.put("msg",  "F");
				result.put("desc", "적용할 사용자를 선택해 주세요.");
				return result;
			}
			Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
			Object modUser = loginUser != null ? loginUser.get("userNo") : null;
			Map<String, Object> updateParam = new HashMap<String, Object>();
			updateParam.put("userNos",  userNos);
			updateParam.put("roleNo",   roleNo);
			updateParam.put("modUser",  modUser);
			userService.updateUserRole(updateParam);
			result.put("msg",  "S");
			result.put("desc", userNos.length + "명의 권한이 변경됐습니다.");
		} catch (Exception e) {
			result.put("msg",  "E");
			result.put("desc", "서버 오류가 발생했습니다.");
			e.printStackTrace();
		}
		return result;
	}

	/** 롤 상세 조회 (AJAX) */
	@RequestMapping(value = "/role/roleDetail.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> roleDetail(@RequestParam Map<String, Object> param) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			Map<String, Object> detail = roleService.selectRoleDetail(param);
			if(detail == null) {
				result.put("msg", "F");
				result.put("desc", "데이터가 조회되지 않았습니다.");
			}else {
				result.put("role", detail);
				result.put("msg", "S");
			}
		} catch (Exception e) {
			result.put("msg", "E");
			result.put("desc", "서버 오류가 발생했습니다.");
		}
		return result;
	}
	
	/** 롤 등록/수정 (AJAX) */
	@RequestMapping(value = "/role/roleSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> roleSave(@RequestParam Map<String, Object> param, HttpSession session) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
			if (loginUser != null) {
				param.put("regUser", loginUser.get("userNo"));
				param.put("updUser", loginUser.get("userNo"));
			}

			String roleNo = (String) param.get("roleNo");

			if (roleNo == null || roleNo.isEmpty()) {
				roleService.insertRole(param);
				result.put("msg",  "S");
				result.put("desc", "등록이 완료됐습니다.");
			} else {
				if (roleService.isSystemAdmin(roleNo)) {
					result.put("msg",  "E");
					result.put("desc", "시스템관리자 권한그룹은 수정할 수 없습니다.");
					return result;
				}
				int cnt = roleService.updateRole(param);
				if (cnt > 0) {
					result.put("msg",  "S");
					result.put("desc", "수정이 완료됐습니다.");
				} else {
					result.put("msg",  "F");
					result.put("desc", "수정할 대상이 없습니다.");
				}
			}
		} catch (Exception e) {
			result.put("msg",  "E");
			result.put("desc", "서버 오류가 발생했습니다.");
			e.printStackTrace();
		}
		return result;
	}
	
	
	/** 롤 논리 삭제 (AJAX) */
	@RequestMapping(value = "/role/roleDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> roleDelete(@RequestParam Map<String, Object> param){
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			if (roleService.isSystemAdmin((String) param.get("roleNo"))) {
				result.put("msg",  "E");
				result.put("desc", "시스템관리자 권한그룹은 삭제할 수 없습니다.");
				return result;
			}
			if(roleService.deleteRole(param)) {
				result.put("msg", "S");
				result.put("desc", "삭제가 완료됐습니다.");
			}else {
				result.put("msg", "F");
				result.put("desc", "삭제할 대상이 없습니다");
			}
		} catch (Exception e) {
			result.put("msg", "E");
			result.put("desc", "삭제 중에 서버 오류가 발생했습니다.");
		}
		return result;
	}
}

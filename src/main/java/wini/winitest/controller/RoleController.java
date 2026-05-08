package wini.winitest.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

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

@Controller
public class RoleController {
	
	@Resource(name = "menuService")
  private MenuService menuService;
	
	@Resource(name = "roleService")
	private RoleService roleService;
	
	@Resource(name = "codeService")
	private CodeService codeService;
	
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
	
	/** 롤 등록 (AJAX) */
	@RequestMapping(value = "/role/roleSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> roleSave(@RequestParam Map<String, Object> param){
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			
		} catch (Exception e) {
			
		}
		
		return result;
	}
	
	
	/** 롤 논리 삭제 (AJAX) */
	@RequestMapping(value = "/role/roleDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> roleDelete(@RequestParam Map<String, Object> param){
		Map<String, Object> result = new HashMap<String, Object>();
		try {
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

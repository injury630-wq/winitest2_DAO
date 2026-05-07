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
import wini.winitest.service.MenuService;
import wini.winitest.service.RoleService;

@Controller
public class RoleController {
	
	@Resource(name = "menuService")
  private MenuService menuService;
	
	@Resource(name = "roleService")
	private RoleService roleService;
	
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
			model.addAttribute("useYnCodes",    roleService.selectCodesByGroupCode("USE_YN"));
			model.addAttribute("adminYnCodes",  roleService.selectCodesByGroupCode("ADMIN_YN"));
			model.addAttribute("userTypeCodes", roleService.selectCodesByGroupCode("USER_TYPE"));

			Map<String, Object> result = roleService.selectRoleList(param);
			model.addAttribute("list",           result.get("list"));
			model.addAttribute("search",         result.get("search"));
			model.addAttribute("paginationInfo", result.get("paginationInfo"));
		} catch (Exception e) {
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
			result.put("data", detail);
			result.put("msg", "S");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "E");
		}
		return result;
	}

}

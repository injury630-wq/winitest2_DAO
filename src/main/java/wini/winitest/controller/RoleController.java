package wini.winitest.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

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
	public String roleManage(@RequestParam Map<String, Object> param, Model model) throws Exception{
		try {
			MenuUtil.addMenu(model, menuService);
			if(param.get("currentPageNo") == null) {
				param.put("currentPageNo", 1);
			}
	    param.put("pageSize", 10); // 페이지 개수는 10개로 고정, 페이지당 출력 목록 수는 화면에서 받아옴.
	    
	    Map<String, Object> result = roleService.selectRoleList(param);
	    model.addAttribute("list", result.get("list"));
	    model.addAttribute("paginationInfo", result.get("paginationInfo"));
	    
		} catch (Exception e) {
			model.addAttribute("msg", "E");
		}
		return "role/roleManage";
	}
	
}

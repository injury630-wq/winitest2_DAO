package wini.winitest.controller.common;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import wini.winitest.service.MenuService;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Resource(name = "menuService")
    private MenuService menuService;
    
    private List<Map<String, Object>> cachedMenu;

    @ModelAttribute("menuList")
    public List<Map<String, Object>> menuList() throws Exception {
    	/*if (cachedMenu == null) {
        cachedMenu = menuService.selectMenuList();
	    }
	    return cachedMenu;*/
	    return menuService.selectMenuList();
    }
}
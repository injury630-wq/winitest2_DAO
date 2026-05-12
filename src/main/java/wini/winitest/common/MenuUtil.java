package wini.winitest.common;

import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;

import wini.winitest.service.MenuService;

public class MenuUtil {

    public static void addMenu(Model model, MenuService menuService) throws Exception {
      HttpSession session;
    	model.addAttribute("menuList", menuService.selectMenuListAdmin());
    }
}

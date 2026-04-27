package wini.winitest.common;

import org.springframework.ui.Model;
import wini.winitest.service.MenuService;

public class MenuUtil {

    public static void addMenu(Model model, MenuService menuService) throws Exception {
        model.addAttribute("menuList", menuService.selectMenuList());
    }
}

package wini.winitest.common;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import wini.winitest.service.MenuService;

public class MenuUtil {

    public static void addMenu(Model model, MenuService menuService) throws Exception {
        ServletRequestAttributes attrs =
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();

        HttpServletRequest request = attrs.getRequest();
        HttpSession session = request.getSession();
        if (session == null) return;

        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        if (loginUser == null) return;

        Map<String, Object> param = new HashMap<>();
        param.put("adminYn", loginUser.get("adminYn"));
        param.put("roleNo",  loginUser.get("roleNo"));
        System.out.println(loginUser.get("adminYn"));
        System.out.println(loginUser.get("roleNo"));
        model.addAttribute("menuList", menuService.selectMenuList(param));
    }
}

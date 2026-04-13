package wini.winitest.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import wini.winitest.service.UserService;
import wini.winitest.sessionlistener.EgovHttpSessionBindingListener;

@Controller
public class UserController {

    @Resource(name = "userDAOService")
    private UserService userService;

    // 로그인 페이지 (GET: 로그인 인터셉터용, POST: bridge.jsp 에서 redirect 된 경우)
    @RequestMapping(value = "/user/login.do",
                    method = {RequestMethod.GET, RequestMethod.POST})
    public String loginView(HttpServletRequest request, Model model) {
        // 이미 로그인된 경우 목록으로 이동
        if (request.getSession().getAttribute("loginUser") != null) {
            Map<String, Object> param = new HashMap<>();
            param.put("bridgeUrl", "board/list.do");
            model.addAttribute("param", param);
            return "bridge";
        }
        // bridge.jsp 가 POST 로 전달한 error / join 파라미터를 model 에 노출
        String error = request.getParameter("error");
        String join  = request.getParameter("join");
        if (error != null) model.addAttribute("error", error);
        if (join  != null) model.addAttribute("join",  join);
        return "user/login";
    }

    // 로그인 처리
    @RequestMapping(value = "/user/loginProc.do", method = RequestMethod.POST)
    public String loginProc(@RequestParam Map<String, Object> param,
                            HttpServletRequest request, Model model) throws Exception {
        Map<String, Object> loginUser = userService.selectLoginInfo(param);
        if (loginUser != null && loginUser.get("userId") != null) {
            // 세션에 로그인 정보 저장
            request.getSession().setAttribute("loginUser", loginUser);
            EgovHttpSessionBindingListener listener = new EgovHttpSessionBindingListener();
            request.getSession().setAttribute((String) loginUser.get("userId"), listener);

            param.put("bridgeUrl", "board/list.do");
            model.addAttribute("param", param);
            return "bridge";
        }
        // 로그인 실패: 오류 표시를 위해 error=1 파라미터를 bridge 로 전달
        param.put("error", "1");
        param.put("bridgeUrl", "user/login.do");
        model.addAttribute("param", param);
        return "bridge";
    }

    // 로그아웃
    @RequestMapping(value = "/user/logout.do", method = RequestMethod.POST)
    public String logout(HttpServletRequest request, Model model) {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
        } catch (Exception e) {
            // 이미 만료된 세션 - 무시
        }
        Map<String, Object> param = new HashMap<>();
        param.put("bridgeUrl", "user/login.do");
        model.addAttribute("param", param);
        return "bridge";
    }

    // 회원가입 페이지
    @RequestMapping(value = "/user/register.do", method = RequestMethod.POST)
    public String registerView() {
        return "user/register";
    }

    // 회원가입 처리
    @RequestMapping(value = "/user/registerProc.do", method = RequestMethod.POST)
    public String registerProc(@RequestParam Map<String, Object> param,
                               Model model) throws Exception {
        int result = userService.register(param);
        if (result > 0) {
            // 가입 성공: 로그인 페이지에 join=1 파라미터를 전달해 완료 메시지 표시
            param.put("join", "1");
            param.put("bridgeUrl", "user/login.do");
        } else {
            param.put("bridgeUrl", "user/register.do");
        }
        model.addAttribute("param", param);
        return "bridge";
    }

    // 아이디 중복확인 (Ajax - POST)
    @ResponseBody
    @RequestMapping(value = "/user/idCheck.do", method = RequestMethod.POST)
    public int idCheck(@RequestParam Map<String, Object> param) throws Exception {
        return userService.idCheck(param);
    }
}

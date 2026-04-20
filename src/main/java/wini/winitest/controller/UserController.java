package wini.winitest.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.utl.slm.EgovHttpSessionBindingListener;
import wini.winitest.service.UserService;

@Controller
public class UserController {

    @Resource(name = "userService")
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
    
    // 사용자 목록 조회
    @RequestMapping(value = "/user/userManage.do", method = RequestMethod.POST)
    public String userList(@RequestParam Map<String, Object> params, Model model) throws Exception{
    	Map<String, Object> userList = userService.getUserList(params); // 수정요함  list, search, pagination
    	model.addAttribute("userList", userList);
    	return "user/userManage";
    }

    // 사용자 목록 조회 
    @RequestMapping(value = "/user/userManage2.do", method = RequestMethod.POST)
    public String userManageTest(@RequestParam Map<String, Object> params, Model model) throws Exception {
    	Map<String, Object> result = new HashMap<>();
			result = userService.getUserList(params); // list, search, pagination
    	if(result.get("message").equals("success")){
    		model.addAttribute("list", result.get("list"));
    		model.addAttribute("search", result.get("search"));
    		model.addAttribute("paginationInfo", result.get("paginationInfo"));
    	}else {
    		model.addAttribute("message", "error");
    	}
      return "user/userManage2";
    }
    
    // 사용자 상세조회 (ajax)
    @ResponseBody
    @RequestMapping(value = "/user/userSelect2.do", method = RequestMethod.POST)
    public Map<String, Object> userDetail(@RequestBody Map<String, Object> param) throws Exception {
    	Map<String, Object> result = new HashMap<>();
    	try {
            int userNo = Integer.parseInt(String.valueOf(param.get("userNo")));
            Map<String, Object> user = userService.selectUserDetail(userNo);
            result.put("user", user);
            result.put("message", "success");
	    } catch (Exception e) {
            result.put("message", "fail");
            result.put("error", e.getMessage());
	    }
    	return result;
    }

    // 사용자 등록 (관리자 - Ajax)
    @ResponseBody
    @RequestMapping(value = "/user/userRegist2.do", method = RequestMethod.POST)
    public Map<String, Object> userRegist2(@RequestParam Map<String, Object> param,
                                            HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            int dupCount = userService.idCheck(param);
            if (dupCount > 0) {
                result.put("result", "duplicate");
                return result;
            }
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            param.put("regUser", loginUser.get("userNo"));
            return userService.insertUser(loginUser, param);
        } catch (Exception e) {
            result.put("result", "error");
            result.put("error", e.getMessage());
            return result;
        }
    }

    // 사용자 수정 (관리자 - Ajax)
    @ResponseBody
    @RequestMapping(value = "/user/userUpdate2.do", method = RequestMethod.POST)
    public Map<String, Object> userUpdate2(@RequestParam Map<String, Object> param,
                                            HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            param.put("modUser", loginUser.get("userNo")); // 현재 수정자
            return userService.updateUser(loginUser, param);
        } catch (Exception e) {
            result.put("result", "error");
            result.put("error", e.getMessage());
            return result;
        }
    }

    // 사용자 비활성화 (관리자 - Ajax, 실제 삭제 X)
    @ResponseBody
    @RequestMapping(value = "/user/userDelete2.do", method = RequestMethod.POST)
    public Map<String, Object> userDelete2(@RequestParam Map<String, Object> param,
                                            HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            param.put("modUser", loginUser.get("userNo"));
            return userService.disableUser(loginUser, param);
        } catch (Exception e) {
            result.put("result", "error");
            result.put("error", e.getMessage());
            return result;
        }
    }
}

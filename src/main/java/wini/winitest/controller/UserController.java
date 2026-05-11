package wini.winitest.controller;

import java.util.HashMap;
import java.util.List;
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
import wini.winitest.common.MenuUtil;
import wini.winitest.common.RoleUtil;
import wini.winitest.service.MenuService;
import wini.winitest.service.RoleService;
import wini.winitest.service.UserService;

@Controller
public class UserController {

    @Resource(name = "userService")
    private UserService userService;

    @Resource(name = "menuService")
    private MenuService menuService;

    @Resource(name = "roleService")
    private RoleService roleService;

    // 로그인 페이지
    @RequestMapping(value = "/user/login.do",
                    method = {RequestMethod.GET, RequestMethod.POST})
    public String loginView(HttpServletRequest request, Model model) {
        if (request.getSession().getAttribute("loginUser") != null) {
            Map<String, Object> param = new HashMap<>();
            param.put("bridgeUrl", "board/list.do");
            model.addAttribute("param", param);
            return "bridge";
        }
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
            if ("N".equals(loginUser.get("useYn"))) {
                param.put("error", "disabled");
                param.put("bridgeUrl", "user/login.do");
                model.addAttribute("param", param);
                return "bridge";
            }
            request.getSession().setAttribute("loginUser", loginUser);
            if (!"Y".equals(loginUser.get("adminYn"))) {
                Map<String, Object> permParam = new HashMap<>();
                permParam.put("roleNo", loginUser.get("roleNo"));
                List<Map<String, Object>> permList = roleService.selectMenuPermByRole(permParam);

                Map<String, Map<String, Object>> sessionPerms = new HashMap<>();
                Map<Integer, Map<String, Object>> sessionMenuPerms = new HashMap<>();
                for (Map<String, Object> perm : permList) {
                    String proPath = (String) perm.get("proPath");
                    if (proPath != null && !proPath.isEmpty()) sessionPerms.put(proPath, perm);
                    Object menuNo = perm.get("menuNo");
                    if (menuNo != null) sessionMenuPerms.put((Integer) menuNo, perm);
                }
                request.getSession().setAttribute("sessionPerms",     sessionPerms);
                request.getSession().setAttribute("sessionMenuPerms", sessionMenuPerms);
            }
            EgovHttpSessionBindingListener listener = new EgovHttpSessionBindingListener();
            request.getSession().setAttribute((String) loginUser.get("userId"), listener);
            param.put("bridgeUrl", "board/list.do");
            model.addAttribute("param", param);
            return "bridge";
        }
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
            param.put("join", "1");
            param.put("bridgeUrl", "user/login.do");
        } else {
            param.put("bridgeUrl", "user/register.do");
        }
        model.addAttribute("param", param);
        return "bridge";
    }

    // 아이디 중복확인 (Ajax)
    @ResponseBody
    @RequestMapping(value = "/user/idCheck.do", method = RequestMethod.POST)
    public int idCheck(@RequestParam Map<String, Object> param) throws Exception {
        return userService.idCheck(param);
    }

    // 사용자 목록 조회
    @RequestMapping(value = "/user/userManage.do", method = RequestMethod.POST)
    public String userManage(@RequestParam Map<String, Object> params, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        params.put("recordCountPerPage", 10);
        params.put("pageSize", 10);
        Map<String, Object> result = userService.getUserList(params);
        if ("S".equals(result.get("msg"))) {
            model.addAttribute("list", result.get("list"));
            model.addAttribute("search", result.get("search"));
            model.addAttribute("paginationInfo", result.get("paginationInfo"));
        } else {
            model.addAttribute("msg", "E");
        }
        model.addAttribute("roleList", userService.selectRoleList());
        return "user/userManage";
    }

    // 사용자 상세조회 (Ajax)
    @ResponseBody
    @RequestMapping(value = "/user/userSelect.do", method = RequestMethod.POST)
    public Map<String, Object> userDetail(@RequestBody Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();
        if (param.get("userNo") == null) {
            result.put("msg", "F");
            result.put("desc", "필수 항목이 누락되었습니다.");
            return result;
        }
        int userNo = Integer.parseInt(String.valueOf(param.get("userNo")));
        return userService.selectUserDetail(userNo);
    }

    // 사용자 등록 (관리자 - Ajax)
    @ResponseBody
    @RequestMapping(value = "/user/userRegist.do", method = RequestMethod.POST)
    public Map<String, Object> userRegist(@RequestParam Map<String, Object> param,
                                           HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            int dupCount = userService.idCheck(param);
            if (dupCount > 0) {
                result.put("msg", "D");
                return result;
            }
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            int myRoleRank  = RoleUtil.getRoleRank(loginUser);
            int newRoleRank = Integer.parseInt(String.valueOf(param.get("roleRank")));
            if (myRoleRank <= newRoleRank) {
                result.put("msg", "X");
                result.put("desc", "등록하려는 사용자의 권한이 너무 높습니다.");
                return result;
            }
            param.put("regUser", loginUser.get("userNo"));
            return userService.insertUser(param);
        } catch (Exception e) {
            result.put("msg", "E");
            return result;
        }
    }

    // 사용자 수정 (관리자 - Ajax)
    @ResponseBody
    @RequestMapping(value = "/user/userUpdate.do", method = RequestMethod.POST)
    public Map<String, Object> userUpdate(@RequestParam Map<String, Object> param,
                                            HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            int targetUserNo = Integer.parseInt(String.valueOf(param.get("userNo")));

            Map<String, Object> targetUser = (Map<String, Object>) userService.selectUserDetail(targetUserNo).get("user");
            if (targetUser == null) {
                result.put("msg", "F");
                result.put("desc", "대상 사용자를 찾을 수 없습니다.");
                return result;
            }

            int currentRoleRank = RoleUtil.getRoleRank(targetUser);
            int newRoleRank     = Integer.parseInt(String.valueOf(param.get("roleRank")));
            String newUseYn     = String.valueOf(param.get("useYn"));

            if (RoleUtil.isSelf(loginUser, targetUserNo)) {
                if (newRoleRank > currentRoleRank) {
                    result.put("msg", "X");
                    result.put("desc", "본인의 권한을 상향할 수 없습니다.");
                    return result;
                }
                if (!"Y".equals(newUseYn)) {
                    result.put("msg", "X");
                    result.put("desc", "본인 계정을 비활성화할 수 없습니다.");
                    return result;
                }
            } else {
                if (!RoleUtil.canEditUser(loginUser, targetUserNo, currentRoleRank)) {
                    result.put("msg", "X");
                    result.put("desc", "대상 사용자의 권한이 본인과 같거나 높습니다.");
                    return result;
                }
                if (currentRoleRank != newRoleRank && !RoleUtil.canChangeRole(loginUser, currentRoleRank, newRoleRank)) {
                    result.put("msg", "X");
                    result.put("desc", "변경하려는 권한이 허용 범위를 초과합니다.");
                    return result;
                }
            }

            param.put("modUser", loginUser.get("userNo"));
            result = userService.updateUser(param);

            if ("S".equals(result.get("msg"))) {
                int loginUserNo = (int) loginUser.get("userNo");
                if (loginUserNo == targetUserNo) {
                    Map<String, Object> updatedUser = (Map<String, Object>) result.get("user");
                    session.setAttribute("loginUser", updatedUser);
                }
            }
        } catch (Exception e) {
            result.put("msg", "E");
        }
        return result;
    }

    // 사용자 비활성화 (관리자 - Ajax)
    @ResponseBody
    @RequestMapping(value = "/user/userDelete.do", method = RequestMethod.POST)
    public Map<String, Object> userDelete(@RequestParam Map<String, Object> param,
                                            HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            int targetUserNo = Integer.parseInt(String.valueOf(param.get("userNo")));

            Map<String, Object> targetUser = (Map<String, Object>) userService.selectUserDetail(targetUserNo).get("user");
            if (targetUser == null) {
                result.put("msg", "F");
                result.put("desc", "대상 사용자를 찾을 수 없습니다.");
                return result;
            }

            int targetCodeNo = RoleUtil.getRoleRank(targetUser);
            if (!RoleUtil.canDeleteUser(loginUser, targetUserNo, targetCodeNo)) {
                result.put("msg", "X");
                if (RoleUtil.isSelf(loginUser, targetUserNo)) {
                    result.put("desc", "본인 계정은 비활성화할 수 없습니다.");
                } else {
                    result.put("desc", "대상 사용자의 권한이 본인과 같거나 높습니다.");
                }
                return result;
            }

            param.put("modUser", loginUser.get("userNo"));
            return userService.disableUser(param);
        } catch (Exception e) {
            result.put("msg", "E");
            return result;
        }
    }
}

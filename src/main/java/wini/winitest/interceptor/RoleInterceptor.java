package wini.winitest.interceptor;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

/**
 * 권한 인터셉터 - 로그인 사용자의 roleRank 가 minRoleRank 미만이면 차단.
 * minRoleRank 는 dispatcher-servlet.xml 에서 주입 (예: 70020 = 관리자 이상).
 *
 * AJAX 요청 -> {"result":"forbidden"} JSON 반환
 * 일반 요청 -> 로그인 페이지로 리다이렉트
 */
public class RoleInterceptor implements HandlerInterceptor {

    private final int minRoleRank;

    public RoleInterceptor(int minRoleRank) {
        this.minRoleRank = minRoleRank;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        @SuppressWarnings("unchecked")
        Map<String, Object> loginUser =
            (Map<String, Object>) request.getSession().getAttribute("loginUser");

        int myRoleRank;
        try {
            myRoleRank = Integer.parseInt(String.valueOf(loginUser.get("roleRank")));
        } catch (Exception e) {
            myRoleRank = 0;
        }

        if (myRoleRank >= minRoleRank) {
            return true;
        }

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(403);
            response.getWriter().write("{\"result\":\"forbidden\"}");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/login.do");
        }
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest req, HttpServletResponse res,
                           Object handler, ModelAndView mv) throws Exception {}

    @Override
    public void afterCompletion(HttpServletRequest req, HttpServletResponse res,
                                Object handler, Exception ex) throws Exception {}
}

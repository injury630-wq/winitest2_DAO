package wini.winitest.interceptor;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import wini.winitest.common.RoleUtil;

/**
 * 권한 인터셉터 - requiredRole 미만이면 요청 차단.
 * 로그인 체크는 LoginInterceptor가 담당하므로 여기서는 권한만 확인한다.
 *
 * AJAX 요청 → {"result":"forbidden"} JSON 반환 (프론트에서 alert 처리)
 * 일반 요청 → 로그인 페이지로 리다이렉트
 */
public class RoleInterceptor implements HandlerInterceptor {

    private final String requiredRole;

    public RoleInterceptor(String requiredRole) {
        this.requiredRole = requiredRole;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
    		// 로그인 인터셉터 -> 로그인 사용자 권한 가져오기
        Map<String, Object> loginUser = (Map<String, Object>) request.getSession().getAttribute("loginUser");
        String myRole = String.valueOf(loginUser.get("role"));

        if (RoleUtil.getLevel(myRole) >= RoleUtil.getLevel(requiredRole)) {
            return true;
        }

        // AJAX 요청 → JSON 으로 거부 (프론트에서 alert 처리) 등록아작스 이외 추가되면 변경
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

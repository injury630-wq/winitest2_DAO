// 미사용 - RoleInterceptor 로 교체됨
/*
package wini.winitest.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import wini.winitest.common.AuthUtil;

public class AuthInterceptor implements HandlerInterceptor {

    private final String requiredRole;

    public AuthInterceptor(String requiredRole) {
        this.requiredRole = requiredRole;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        if (AuthUtil.hasRole(request.getSession(false), requiredRole)) {
            return true;
        }

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"result\":\"forbidden\"}");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/login.do");
        }
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                           Object handler, ModelAndView modelAndView) throws Exception {}

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) throws Exception {}
}
*/

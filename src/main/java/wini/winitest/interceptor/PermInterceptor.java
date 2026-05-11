package wini.winitest.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class PermInterceptor implements HandlerInterceptor {

    @SuppressWarnings("unchecked")
    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        if (session == null) return true;

        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        if (loginUser == null) return true;

        // 관리자는 모든 페이지 접근 허용
        if ("Y".equals(loginUser.get("adminYn"))) return true;

        Map<String, Map<String, Object>> sessionPerms =
            (Map<String, Map<String, Object>>) session.getAttribute("sessionPerms");
        if (sessionPerms == null) return true;

        // program 테이블에 등록된 메뉴 URL만 sessionPerms에 존재
        // 저장/삭제 AJAX 등 미등록 URL은 perm == null → 통과 (메뉴 접근권한을 따라감)
        // 메뉴에 등록된 URL이고 viewPerm='N'인 경우만 차단
        String proPath = request.getServletPath();
        Map<String, Object> perm = sessionPerms.get(proPath);
        if (perm != null && "N".equals(perm.get("viewPerm"))) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(
                "<script>alert('접근 권한이 없습니다.'); history.back();</script>"
            );
            return false;
        }

        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                           Object handler, ModelAndView modelAndView) throws Exception {}

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) throws Exception {}
}

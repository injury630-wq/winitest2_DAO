package wini.winitest.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

/**
 * 로그인 인터셉터 - 비로그인 시 접근 차단.
 */
public class LoginInterceptor implements HandlerInterceptor {

	//컨트롤러 실행전 세션 확인
    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        HttpSession session = request.getSession();
        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        // 미로그인시 차단
        if(loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.do");
            return false;
        }
        // 비활성 계정시 차단(세션종료)
        if(loginUser != null) {
        	String status = String.valueOf(loginUser.get("status"));
        	if ("DISABLED".equals(status)) {
        	    request.getSession().invalidate();
        	    response.sendRedirect(request.getContextPath() + "/user/login.do");
        	    return false;
        	}
        }
        return true;
    }

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		
	}
}
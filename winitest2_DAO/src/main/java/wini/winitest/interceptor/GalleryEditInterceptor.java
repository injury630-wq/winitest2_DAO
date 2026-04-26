package wini.winitest.interceptor;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import wini.winitest.service.impl.GalleryDAO;

/**
 * 갤러리 수정 접근 제어 인터셉터
 * - boardNo 파라미터가 없으면(신규 등록) 통과
 * - boardNo 가 있으면(수정 모드) 관리자 또는 작성자만 허용
 */
public class GalleryEditInterceptor implements HandlerInterceptor {

    private final GalleryDAO galleryDAO;

    public GalleryEditInterceptor(GalleryDAO galleryDAO) {
        this.galleryDAO = galleryDAO;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
                             Object handler) throws Exception {
        String boardNoStr = request.getParameter("boardNo");
        if (boardNoStr == null || boardNoStr.trim().isEmpty()) {
            return true;
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> loginUser =
            (Map<String, Object>) request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.do");
            return false;
        }

        if ("Y".equals(loginUser.get("adminYn"))) return true;

        Map<String, Object> param = new HashMap<>();
        param.put("boardNo", Integer.parseInt(boardNoStr.trim()));
        Map<String, Object> board = galleryDAO.selectGalleryDetail(param);

        if (board == null) {
            response.sendRedirect(request.getContextPath() + "/gallery/list.do");
            return false;
        }

        Object myNo      = loginUser.get("userNo");
        Object boardUser = board.get("regUser");
        if (myNo != null && String.valueOf(myNo).equals(String.valueOf(boardUser))) {
            return true;
        }

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(403);
            response.getWriter().write("{\"msg\":\"X\",\"desc\":\"수정 권한이 없습니다.\"}");
        } else {
            response.sendRedirect(request.getContextPath() + "/gallery/list.do");
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

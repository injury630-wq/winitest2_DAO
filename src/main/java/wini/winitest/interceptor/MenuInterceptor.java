package wini.winitest.interceptor;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import wini.winitest.service.impl.MenuDAO;

/**
 * 사이드바 메뉴 인터셉터
 * 매 요청 시 DB에서 메뉴 목록을 조회하여 request 속성으로 주입
 * sidebar.jsp에서 ${menuList}로 접근
 */
public class MenuInterceptor implements HandlerInterceptor {

    private MenuDAO menuDAO;

    public void setMenuDAO(MenuDAO menuDAO) {
        this.menuDAO = menuDAO;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        try {
            List<Map<String, Object>> flatList = menuDAO.selectMenuList();

            // 부모(lev=0) → 자식(lev=1) 2단계 계층 구조로 변환
            Map<String, Map<String, Object>> parentMap = new LinkedHashMap<>();
            for (Map<String, Object> m : flatList) {
                Number lev = (Number) m.get("menuLev");
                if (lev != null && lev.intValue() == 0) {
                    m.put("children", new ArrayList<Map<String, Object>>());
                    parentMap.put(String.valueOf(m.get("menuNo")), m);
                }
            }
            for (Map<String, Object> m : flatList) {
                Number lev = (Number) m.get("menuLev");
                if (lev != null && lev.intValue() == 1) {
                    String parentKey = String.valueOf(m.get("parentNo"));
                    Map<String, Object> parent = parentMap.get(parentKey);
                    if (parent != null) {
                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> children =
                            (List<Map<String, Object>>) parent.get("children");
                        children.add(m);
                    }
                }
            }
            request.setAttribute("menuList", new ArrayList<>(parentMap.values()));
        } catch (Exception e) {
            // 메뉴 조회 실패 시 빈 목록으로 처리 (페이지 진행 유지)
            request.setAttribute("menuList", new ArrayList<>());
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                           Object handler, ModelAndView modelAndView) {}

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) {}
}

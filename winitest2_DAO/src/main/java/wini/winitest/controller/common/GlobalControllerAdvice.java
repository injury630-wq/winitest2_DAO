package wini.winitest.controller.common;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import wini.winitest.service.MenuService;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Resource(name = "menuService")
    private MenuService menuService;

    /**
     * 방식 A (CTE 플랫)  → ${menuList}  : DB가 sort_path 로 정렬한 flat list 그대로 사용
     * 방식 B (Java 트리) → ${menuTree}  : 동일 flat list 를 parent→children 트리로 재구성
     * sidebar.jsp 에서 둘 중 하나를 주석 해제해 사용.
     */
    @ModelAttribute
    public void menuAttributes(Model model) throws Exception {
        List<Map<String, Object>> flat = menuService.selectMenuList();
        model.addAttribute("menuList", flat);
        model.addAttribute("menuTree", buildTree(flat));
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> buildTree(List<Map<String, Object>> flat) {
        List<Map<String, Object>> roots = new ArrayList<>();
        Map<Object, Map<String, Object>> byNo = new LinkedHashMap<>();

        for (Map<String, Object> item : flat) {
            item.put("children", new ArrayList<Map<String, Object>>());
            byNo.put(item.get("menuNo"), item);
        }
        for (Map<String, Object> item : flat) {
            Object parentNo = item.get("parentNo");
            if (parentNo == null || "0".equals(String.valueOf(parentNo))) {
                roots.add(item);
            } else {
                Map<String, Object> parent = byNo.get(parentNo);
                if (parent != null) {
                    ((List<Map<String, Object>>) parent.get("children")).add(item);
                }
            }
        }
        return roots;
    }
}
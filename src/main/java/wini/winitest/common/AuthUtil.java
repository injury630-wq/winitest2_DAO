// 미사용 - RoleUtil 로 교체됨
/*
package wini.winitest.common;

import java.util.Map;
import javax.servlet.http.HttpSession;

public class AuthUtil {

    private static int getLevel(String role) {
        if ("SYSTEM".equals(role)) return 3;
        if ("ADMIN".equals(role))  return 2;
        return 1;
    }

    @SuppressWarnings("unchecked")
    private static Map<String, Object> getLoginUser(HttpSession session) {
        if (session == null) return null;
        return (Map<String, Object>) session.getAttribute("loginUser");
    }

    public static boolean hasRole(HttpSession session, String requiredRole) {
        Map<String, Object> loginUser = getLoginUser(session);
        if (loginUser == null) return false;
        String myRole = String.valueOf(loginUser.get("role"));
        return getLevel(myRole) >= getLevel(requiredRole);
    }

    public static boolean canManage(HttpSession session, String targetRole) {
        Map<String, Object> loginUser = getLoginUser(session);
        if (loginUser == null) return false;
        String myRole = String.valueOf(loginUser.get("role"));
        return getLevel(myRole) > getLevel(targetRole);
    }

    public static boolean isSelf(HttpSession session, int targetUserNo) {
        Map<String, Object> loginUser = getLoginUser(session);
        if (loginUser == null) return false;
        try {
            int myUserNo = Integer.parseInt(String.valueOf(loginUser.get("userNo")));
            return myUserNo == targetUserNo;
        } catch (Exception e) {
            return false;
        }
    }
}
*/

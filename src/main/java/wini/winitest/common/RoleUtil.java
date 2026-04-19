package wini.winitest.common;

import java.util.Map;

public class RoleUtil {

    // 권한 레벨 숫자로 비교 (USER=1, ADMIN=2, SYSTEM=3)
    public static int getLevel(String role) {
        if ("SYSTEM".equals(role)) return 3;
        if ("ADMIN".equals(role))  return 2;
        return 1;
    }

    // 본인 여부 확인
    public static boolean isSelf(Map<String, Object> loginUser, int targetUserNo) {
        if (loginUser == null) return false;
        try {
            return Integer.parseInt(String.valueOf(loginUser.get("userNo"))) == targetUserNo;
        } catch (Exception e) {
            return false;
        }
    }

    // 관리자 여부 확인
    public static boolean isAdmin(Map<String, Object> loginUser) {
        if (loginUser == null) return false;
        return getLevel(String.valueOf(loginUser.get("role"))) >= 2;
    }

    // 수정/삭제 가능 여부 (본인이거나 대상보다 높은 권한)
    public static boolean canEditUser(Map<String, Object> loginUser, int targetUserNo, String targetRole) {
        if (loginUser == null) return false;
        if (isSelf(loginUser, targetUserNo)) return true;
        String myRole = String.valueOf(loginUser.get("role"));
        return getLevel(myRole) > getLevel(targetRole);
    }

    // 권한 변경 가능 여부 (대상과 새 권한 모두 나보다 낮아야)
    public static boolean canChangeRole(Map<String, Object> loginUser, String currentRole, String newRole) {
        if (loginUser == null) return false;
        String myRole = String.valueOf(loginUser.get("role"));
        return getLevel(myRole) > getLevel(currentRole) && getLevel(myRole) > getLevel(newRole);
    }
}
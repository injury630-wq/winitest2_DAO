package wini.winitest.common;

import java.util.Map;

public class RoleUtil {

    /** loginUser/targetUser 맵에서 roleRank를 int로 추출 */
    public static int getRoleRank(Map<String, Object> user) {
        if (user == null) return 0;
        try {
            return Integer.parseInt(String.valueOf(user.get("roleRank")));
        } catch (Exception e) {
            return 0;
        }
    }

    /** 관리자 여부 (user_role.admin_yn = 'Y') */
    public static boolean isAdmin(Map<String, Object> loginUser) {
        if (loginUser == null) return false;
        return "Y".equals(String.valueOf(loginUser.get("adminYn")));
    }

    /** 본인 여부 */
    public static boolean isSelf(Map<String, Object> loginUser, int targetUserNo) {
        if (loginUser == null) return false;
        try {
            return Integer.parseInt(String.valueOf(loginUser.get("userNo"))) == targetUserNo;
        } catch (Exception e) {
            return false;
        }
    }

    /** 수정 가능 여부: 본인이거나 내 roleRank > 대상 roleRank */
    public static boolean canEditUser(Map<String, Object> loginUser, int targetUserNo, int targetRoleRank) {
        if (loginUser == null) return false;
        if (isSelf(loginUser, targetUserNo)) return true;
        return getRoleRank(loginUser) > targetRoleRank;
    }

    /** 비활성화 가능 여부: 본인 불가, 내 roleRank > 대상 roleRank */
    public static boolean canDeleteUser(Map<String, Object> loginUser, int targetUserNo, int targetRoleRank) {
        if (loginUser == null) return false;
        if (isSelf(loginUser, targetUserNo)) return false;
        return getRoleRank(loginUser) > targetRoleRank;
    }

    /** 권한 변경 가능 여부: 대상 현재·변경 roleRank 모두 내 roleRank 미만이어야 함 */
    public static boolean canChangeRole(Map<String, Object> loginUser, int currentRoleRank, int newRoleRank) {
        if (loginUser == null) return false;
        int myRoleRank = getRoleRank(loginUser);
        return myRoleRank > currentRoleRank && myRoleRank > newRoleRank;
    }
}

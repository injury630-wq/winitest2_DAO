package wini.winitest.sessionlistener;

import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpSession;

/**
 * 중복 로그인 방지 - 사용자 ID별 활성 세션 관리
 *
 * 주요 수정 사항:
 * - invalidateByLoginId(): IllegalStateException 방어 처리 추가
 *   (이미 만료된 세션에 invalidate() 재호출 시 예외 방지)
 * - 예외 발생 시 맵에서 해당 항목을 강제 제거하여 잔류 방지
 */
public class EgovMultiLoginPreventor {

    /** 로그인 중인 사용자 ID → 세션 맵 */
    public static ConcurrentHashMap<String, HttpSession> loginUsers = new ConcurrentHashMap<>();

    /** 해당 ID로 활성 세션이 존재하는지 확인 */
    public static boolean findByLoginId(String loginId) {
        return loginUsers.containsKey(loginId);
    }

    /**
     * 해당 ID의 기존 세션을 무효화한다.
     *
     * @param loginId   무효화할 사용자 ID
     * @param exceptSession  이 세션은 무효화 대상에서 제외 (현재 로그인 중인 세션 자신을 보호)
     */
    public static void invalidateByLoginId(String loginId, HttpSession exceptSession) {
        HttpSession prevSession = loginUsers.get(loginId);

        // 저장된 세션이 없거나 현재 로그인 세션과 동일하면 무효화 불필요
        if (prevSession == null || prevSession.equals(exceptSession)) {
            return;
        }

        try {
            prevSession.invalidate();
            // invalidate() 성공 시 valueUnbound()가 호출되어 맵에서 자동 제거됨
        } catch (IllegalStateException e) {
            // 이미 만료된 세션(타임아웃 등)에 invalidate() 재호출 → 예외 무시 후 맵 강제 정리
            loginUsers.remove(loginId, prevSession);
        }
    }
}

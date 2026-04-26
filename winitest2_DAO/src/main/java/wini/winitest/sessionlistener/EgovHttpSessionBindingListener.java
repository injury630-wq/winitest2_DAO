package wini.winitest.sessionlistener;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

/**
 * 중복 로그인 방지 세션 바인딩 리스너
 *
 * 주요 수정 사항:
 * 1. @WebListener 제거
 *    - HttpSessionBindingListener는 세션 속성에 바인딩될 때 자동 호출되는 인터페이스.
 *      @WebListener는 컨테이너 레벨 리스너 등록용으로, 이 인터페이스에 사용하면
 *      Tomcat이 잘못된 방식으로 처리할 수 있어 예기치 않은 동작을 유발한다.
 *
 * 2. valueBound()에서 현재 세션 자신을 무효화하지 않도록 수정
 *    - 같은 세션이 loginProc를 재실행할 경우(새로고침 등) 자기 자신을
 *      invalidate() 하는 문제를 방지한다.
 *    - EgovMultiLoginPreventor.invalidateByLoginId()에 현재 세션을 전달하여
 *      해당 세션은 무효화 대상에서 제외한다.
 */
public class EgovHttpSessionBindingListener implements HttpSessionBindingListener {

    /**
     * 세션에 리스너가 바인딩될 때 자동 호출.
     * 동일 사용자 ID로 이미 활성화된 다른 세션이 있으면 그 세션을 무효화한다.
     */
    @Override
    public void valueBound(HttpSessionBindingEvent event) {
        String loginId          = event.getName();     // setAttribute()의 key = userId
        HttpSession currentSession = event.getSession(); // 현재 새로 로그인하는 세션

        // 기존 세션 무효화 (단, 현재 세션 자신은 제외)
        EgovMultiLoginPreventor.invalidateByLoginId(loginId, currentSession);

        // 현재 세션을 맵에 등록
        EgovMultiLoginPreventor.loginUsers.put(loginId, currentSession);
    }

    /**
     * 세션에서 리스너가 언바인딩될 때 자동 호출 (로그아웃 / 세션 타임아웃).
     * 맵에서 해당 사용자 ID의 세션을 제거한다.
     */
    @Override
    public void valueUnbound(HttpSessionBindingEvent event) {
        // 조건부 remove: 현재 세션과 맵의 세션이 동일할 때만 제거
        // (이미 다른 세션으로 덮어쓰인 경우 실수로 지우지 않도록)
        EgovMultiLoginPreventor.loginUsers.remove(event.getName(), event.getSession());
    }
}

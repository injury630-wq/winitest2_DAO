package wini.winitest.service;

import java.util.Map;

/**
 * 사용자 서비스 인터페이스 - Map 기반 DAO 방식
 */
public interface UserService {

    /** 로그인 정보 단건 조회 */
    Map<String, Object> selectLoginInfo(Map<String, Object> param) throws Exception;

    /** 아이디 중복확인 (0: 사용가능, 1이상: 중복) */
    int idCheck(Map<String, Object> param) throws Exception;

    /** 회원가입 처리 */
    int register(Map<String, Object> param) throws Exception;
}

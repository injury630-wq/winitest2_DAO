package wini.winitest.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

/**
 * 사용자 서비스 인터페이스 - Map 기반 DAO 방식
 */
public interface UserService {
	/** ======== 사용자 관리 ========*/
	/** 사용자 목록 조회(페이징, 검색조건) */
	Map<String, Object> getUserList(Map<String, Object> params) throws Exception;
	/** 사용자 목록 전체건수(검색조건)*/
	int selectUserTotalCount(Map<String, Object> params) throws Exception;
	/**사용자 상세 조회*/
	Map<String, Object> selectUserDetail(int userNo) throws Exception;

    /** 사용자 등록 (관리자) */
    Map<String, Object> insertUser(Map<String, Object> param) throws Exception;

    /** 사용자 수정 (관리자) */
    Map<String, Object> updateUser(Map<String, Object> param) throws Exception;

    /** 사용자 비활성화 (관리자 - 실제 삭제 X) */
    Map<String, Object> disableUser(Map<String, Object> param) throws Exception;

    /** 로그인 정보 단건 조회 */
    Map<String, Object> selectLoginInfo(Map<String, Object> param) throws Exception;

    /** 아이디 중복확인 (0: 사용가능, 1이상: 중복) */
    int idCheck(Map<String, Object> param) throws Exception;

    /** 회원가입 처리 */
    int register(Map<String, Object> param) throws Exception;

    /** 역할 목록 조회 (콤보박스용) */
    List<Map<String, Object>> selectRoleList() throws Exception;
}

package wini.winitest.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * 사용자 DAO - EgovComAbstractDAO 상속
 * SQL ID: userDAO.{queryId} (UserMapper.xml namespace="userDAO")
 */
@Repository("userDAO")
public class UserDAO extends EgovComAbstractDAO {

    /** 로그인 정보 단건 조회 */
    public Map<String, Object> selectLoginInfo(Map<String, Object> param) throws Exception {
        return (Map<String, Object>) selectOne("userDAO.selectLoginInfo", param);
    }

    /** 아이디 중복확인 (0: 사용가능, 1이상: 중복) */
    public int idCheck(Map<String, Object> param) throws Exception {
        return (Integer) selectOne("userDAO.idCheck", param);
    }

    /** 회원가입 처리 */
    public int register(Map<String, Object> param) throws Exception {
        return insert("userDAO.register", param);
    }
}

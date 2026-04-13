package wini.winitest.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import wini.winitest.service.UserService;

/**
 * 사용자 서비스 구현체
 * - EgovAbstractServiceImpl 상속
 * - UserDAO를 통한 DB 접근 (Map 기반)
 */
@Service("userDAOService")
public class UserDAOServiceImpl extends EgovAbstractServiceImpl implements UserService {

    @Resource(name = "userDAO")
    private UserDAO userDAO;

    /** 로그인 정보 단건 조회 */
    @Override
    public Map<String, Object> selectLoginInfo(Map<String, Object> param) throws Exception {
        return userDAO.selectLoginInfo(param);
    }

    /** 아이디 중복확인 (0: 사용가능, 1이상: 중복) */
    @Override
    public int idCheck(Map<String, Object> param) throws Exception {
        return userDAO.idCheck(param);
    }

    /** 회원가입 처리 */
    @Override
    public int register(Map<String, Object> param) throws Exception {
        return userDAO.register(param);
    }
}

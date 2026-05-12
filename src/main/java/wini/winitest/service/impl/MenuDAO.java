package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * 메뉴 DAO - EgovComAbstractDAO 상속
 * SQL ID: menuDAO.{queryId} (MenuMapper.xml namespace="menuDAO")
 */
@Repository("menuDAO")
public class MenuDAO extends EgovComAbstractDAO {

    /** 사이드바 메뉴 목록 조회(관리자용)*/
    public List<Map<String, Object>> selectMenuListAdmin() throws Exception {
        return selectList("menuDAO.selectMenuListAdmin");
    }
    /** 사이드바 메뉴 목록 조회 (일반사용자용 - 권한체크)*/
    public List<Map<String, Object>> selectMenuListUser(Map<String, Object> param) throws Exception {
    	return selectList("menuDAO.selectMenuListUser");
    }
    /** 사이드바 메뉴 목록 조회 (통합용)*/
    public List<Map<String, Object>> selectMenuList(Map<String, Object> param) throws Exception {
    	return selectList("menuDAO.selectMenuListUser");
    }
    
}

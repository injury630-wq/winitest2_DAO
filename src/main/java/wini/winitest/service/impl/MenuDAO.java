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

    /** 사이드바 메뉴 목록 조회 */
    public List<Map<String, Object>> selectMenuList() throws Exception {
        return selectList("menuDAO.selectMenuList");
    }
    
}

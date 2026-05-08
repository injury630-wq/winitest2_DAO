package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * MenuPermDAO - EgovComAbstractDAO 상속
 * SQL ID: menuPermDAO.{queryId} (DummyMapper.xml namespace="MenuPermDAO")
 */
@Repository("menuPermDAO")
public class MenuPermDAO extends EgovComAbstractDAO {

  /** 메뉴별 권한 목록 조회 */
  public List<Map<String, Object>> selectDummyList(Map<String, Object> param) throws Exception {
      return selectList("menuPermDAO.selectDummyList", param);
  }

  /** 메뉴별 권한 등록 */
  public int insertDummy(Map<String, Object> param) {
      return insert("menuPermDAO.insertDummy", param);
  }
}

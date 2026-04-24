package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * Dummy DAO - EgovComAbstractDAO 상속
 * SQL ID: dummyDAO.{queryId} (DummyMapper.xml namespace="DummyDAO")
 */
@Repository("dummyDAO")
public class DummyDAO extends EgovComAbstractDAO {
	 /* ===== Dummy 조회 ===== */

  /** Dummy 목록 조회 (페이징 + 검색 조건) */
  public List<Map<String, Object>> selectDummyList(Map<String, Object> param) throws Exception {
      return selectList("dummyDAO.selectDummyList", param);
  }

  /** Dummy 전체 건수 조회 */
  public int selectDummyTotalCount(Map<String, Object> param) {
      return (Integer) selectOne("dummyDAO.selectDummyTotalCount", param);
  }

  /** Dummy 등록 */
  public int insertDummy(Map<String, Object> param) {
      return insert("dummyDAO.insertDummy", param);
  }
}

package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * RoleDAO DAO - EgovComAbstractDAO 상속
 * SQL ID: roleDAO.{queryId} (RoleMapper.xml namespace="RoleDAO")
 */
@Repository("roleDAO")
public class RoleDAO extends EgovComAbstractDAO {
	 /* ===== Role 조회 ===== */

  /** 권한 그룹 목록 조회 (페이징 + 검색 조건) */
  public List<Map<String, Object>> selectRoleList(Map<String, Object> param) throws Exception {
      return selectList("roleDAO.selectRoleList", param);
  }

  /** 권한 그룹 전체 건수 조회 (검색 조건) */
  public int selectRoleTotalCount(Map<String, Object> param) {
      return (Integer) selectOne("roleDAO.selectRoleTotalCount", param);
  }

  /** 권한 그룹 등록 */
  public int insertDummy(Map<String, Object> param) {
      return insert("roleDAO.insertDummy", param);
  }
}

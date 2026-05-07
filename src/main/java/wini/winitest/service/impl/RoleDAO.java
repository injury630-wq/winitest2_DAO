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

  /** 권한 그룹 단건 상세 조회 */
  public Map<String, Object> selectRoleDetail(Map<String, Object> param) throws Exception {
      return (Map<String, Object>) selectOne("roleDAO.selectRoleDetail", param);
  }

  /** 코드 그룹명으로 코드 목록 조회 (콤보박스용) */
  public List<Map<String, Object>> selectCodesByGroupCode(String groupCode) throws Exception {
      return selectList("roleDAO.selectCodesByGroupCode", groupCode);
  }
}

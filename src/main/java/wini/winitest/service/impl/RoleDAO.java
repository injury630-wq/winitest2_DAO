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
  
  /** 권한 그룹 단건 등록 */
  public int insertRole(Map<String, Object> param) throws Exception {
  	return (Integer) insert("roleDAO.insertRole", param);
  }
  
  /** 권한 그룹 단건 논리 삭제 */
  public int deleteRole(Map<String, Object> param) throws Exception {
  	return (Integer) update("roleDAO.deleteRole", param);
  }
  
}

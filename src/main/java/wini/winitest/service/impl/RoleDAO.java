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

  /** 신규 등록 전 동일 sort_ord 이상인 기존 롤 순서 +1 밀기 */
  public void shiftSortOrd(Map<String, Object> param) throws Exception {
      update("roleDAO.shiftSortOrd", param);
  }

  /** 권한 그룹 단건 등록 */
  public int insertRole(Map<String, Object> param) throws Exception {
      return (Integer) insert("roleDAO.insertRole", param);
  }

  /** 롤코드(role_id) 업데이트 (insertRole 직후 호출) */
  public void updateRoleId(Map<String, Object> param) throws Exception {
      update("roleDAO.updateRoleId", param);
  }

  /** 수정 전 현재 정렬 순서 조회 */
  public int selectSortOrd(Map<String, Object> param) throws Exception {
      return (Integer) selectOne("roleDAO.selectSortOrd", param);
  }

  /** 수정 시 앞으로 이동: new < old 구간 데이터 +1 */
  public void shiftSortOrdUp(Map<String, Object> param) throws Exception {
      update("roleDAO.shiftSortOrdUp", param);
  }

  /** 수정 시 뒤로 이동: new > old 구간 데이터 -1 */
  public void shiftSortOrdDown(Map<String, Object> param) throws Exception {
      update("roleDAO.shiftSortOrdDown", param);
  }

  /** 권한 그룹 수정 */
  public int updateRole(Map<String, Object> param) throws Exception {
      return update("roleDAO.updateRole", param);
  }

  /** 롤 전체 목록 조회 (콤보박스용) */
  public List<Map<String, Object>> selectAllRoleList() throws Exception {
      return selectList("roleDAO.selectAllRoleList");
  }

  /** 권한 그룹 단건 논리 삭제 */
  public int deleteRole(Map<String, Object> param) throws Exception {
      return (Integer) update("roleDAO.deleteRole", param);
  }

  /** 롤에 배정된 활성 사용자 수 조회 */
  public int countUserByRole(int roleNo) throws Exception {
      return (Integer) selectOne("roleDAO.countUserByRole", roleNo);
  }

  /** 롤 사용자 구분 코드 조회 (시스템관리자 여부 확인용) */
  public Integer selectRoleRank(int roleNo) throws Exception {
      return (Integer) selectOne("roleDAO.selectRoleRank", roleNo);
  }

}

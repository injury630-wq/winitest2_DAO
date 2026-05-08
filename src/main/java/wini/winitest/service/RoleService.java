package wini.winitest.service;

import java.util.Map;

/**
 *  권한 서비스 인터페이스 - Map 기반 DAO 방식
 */
public interface RoleService {
  /** 권한 그룹  목록 조회 (페이징 + 검색 조건 포함) */
  public Map<String, Object> selectRoleList(Map<String, Object> param) throws Exception;

  /** 권한 그룹 전체 건수 조회 (검색 조건 포함) */
  public int selectRoleTotalCount(Map<String, Object> param) throws Exception;

  /** 권한 그룹 단건 상세 조회 */
  public Map<String, Object> selectRoleDetail(Map<String, Object> param) throws Exception;

  /** 권한 그룹 등록 */
  public void insertRole(Map<String, Object> param) throws Exception;

  /** 권한 그룹 수정 */
  public int updateRole(Map<String, Object> param) throws Exception;

  /** 권한 그룹 삭제 (논리삭제)*/
  public boolean deleteRole(Map<String, Object> param) throws Exception;

}

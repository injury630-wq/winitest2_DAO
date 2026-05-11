package wini.winitest.service;

import java.util.List;
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

  /** 롤 전체 목록 조회 (콤보박스용) */
  public List<Map<String, Object>> selectAllRoleList() throws Exception;

  /** 롤별 메뉴 권한 목록 조회 */
  public List<Map<String, Object>> selectMenuPermList(Map<String, Object> param) throws Exception;

  /** 메뉴별 권한 일괄 저장 */
  public void saveMenuPermList(String roleNo, List<Map<String, Object>> perms, Object modUser) throws Exception;

  /** 세션 저장용 - 롤별 메뉴 권한 목록 조회 */
  public List<Map<String, Object>> selectMenuPermByRole(Map<String, Object> param) throws Exception;

  /** 롤에 배정된 활성 사용자 수 조회 */
  public int countUserByRole(int roleNo) throws Exception;

  /** 시스템관리자(role_rank=70030) 여부 확인 */
  public boolean isSystemAdmin(String roleNo) throws Exception;

}

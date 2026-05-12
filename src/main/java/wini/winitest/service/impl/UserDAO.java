package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * 사용자 DAO - EgovComAbstractDAO 상속
 * SQL ID: userDAO.{queryId} (UserMapper.xml namespace="userDAO")
 */
@Repository("userDAO")
public class UserDAO extends EgovComAbstractDAO {
	/** ======== 사용자 관리 ========*/
	// 사용자 목록 조회 (페이징, 검색조건)
	public List<Map<String, Object>> selectUserList(Map<String, Object> params) throws Exception{
		return selectList("userDAO.selectUserList", params);
	}
	// 사용자 목록 전체 건수 조회(검색조건)
	public int selectUserTotalCount(Map<String, Object> params) throws Exception{
		return selectOne("userDAO.selectUserTotalCount", params);
	}
	
	/**사용자 상세조회*/
	public Map<String, Object> selectUserDetail(@Param("userNo") int userNo) throws Exception{
		return (Map<String, Object>)selectOne("userDAO.selectUserDetail", userNo);
	}

  /** 사용자 등록 (관리자) */
  public int insertUser(Map<String, Object> param) throws Exception {
      return insert("userDAO.insertUser", param);
  }

  /** 사용자 수정 (관리자) */
  public int updateUser(Map<String, Object> param) throws Exception {
      return update("userDAO.updateUser", param);
  }

  /** 사용자 비활성화 (관리자 - 실제 삭제 X) */
  public int disableUser(Map<String, Object> param) throws Exception {
      return update("userDAO.disableUser", param);
  }

  /** 로그인 정보 단건 조회 */
  public Map<String, Object> selectLoginInfo(Map<String, Object> param) throws Exception {
      return (Map<String, Object>) selectOne("userDAO.selectLoginInfo", param);
  }

  /** 아이디 중복확인 (0: 사용가능, 1이상: 중복) */
  public int idCheck(Map<String, Object> param) throws Exception {
      return (Integer) selectOne("userDAO.idCheck", param);
  }

  /** 회원가입 처리 */
  public int register(Map<String, Object> param) throws Exception {
      return insert("userDAO.register", param);
  }

  /** 최초 등록자 자기 자신으로 업데이트 (회원가입 INSERT 직후 호출) */
  public int updateRegUser(Map<String, Object> param) throws Exception {
      return update("userDAO.updateRegUser", param);
  }

  /** 역할 목록 조회 (콤보박스용) */
  public List<Map<String, Object>> selectRoleList() throws Exception {
      return selectList("userDAO.selectRoleList");
  }

  /** 권한별 사용자 목록 조회 */
  public List<Map<String, Object>> selectUserListByRole(Map<String, Object> param) throws Exception {
      return selectList("userDAO.selectUserListByRole", param);
  }

  /** 권한별 사용자 전체 건수 조회 */
  public int selectUserTotalCountByRole(Map<String, Object> param) throws Exception {
      return (Integer) selectOne("userDAO.selectUserTotalCountByRole", param);
  }

  /** 사용자 권한 변경 */
  public int updateUserRole(Map<String, Object> param) throws Exception {
      return update("userDAO.updateUserRole", param);
  }

}

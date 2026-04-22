package wini.winitest.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.common.PagingUtil;
import wini.winitest.common.RoleUtil;
import wini.winitest.service.UserService;

/**
 * 사용자 서비스 구현체 - EgovAbstractServiceImpl 상속 - UserDAO를 통한 DB 접근 (Map 기반)
 */
@Service("userService")
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService {

	@Resource(name = "userDAO")
	private UserDAO userDAO;

	/** 사용자 정보 목록 조회(페이징,검색조건) */
	@Override
	public Map<String, Object> getUserList(Map<String, Object> params) throws Exception {// params => 검색조건, 현페이지번호
		Map<String, Object> result = new HashMap<>();
		result.put("message", "error");
		try {
			PaginationInfo paginationInfo = PagingUtil.create(params, 10, 10);

			int totalCount = selectUserTotalCount(params); // 검색 조건 전체 건수 계산
			paginationInfo.setTotalRecordCount(totalCount);

			List<Map<String, Object>> userList = userDAO.selectUserList(params);

			result.put("list", userList);
			result.put("paginationInfo", paginationInfo);
			result.put("search", params); // 검색조건 따로 보관
			result.put("message", "success");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/** 사용자 정보 목록 전체 건수 (검색조건) */
	@Override
	public int selectUserTotalCount(Map<String, Object> params) throws Exception {
		return userDAO.selectUserTotalCount(params);
	}

	/** 사용자 상세 조회 */
	@Override
	public Map<String, Object> selectUserDetail(int userNo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		try {
			Map<String, Object> user = userDAO.selectUserDetail(userNo);
			if(user == null) {
				result.put("message", "fail");
			}
			result.put("user", user);
			result.put("message", "success");
		} catch (Exception e) {
			result.put("messsage", "error");
		}

		return result;
	}

	/** 사용자 등록 (관리자) - 등록할 역할이 본인보다 낮아야 함 */
	@Override
	public Map<String, Object> insertUser(Map<String, Object> loginUser, Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<>();
    
		String myRole = String.valueOf(loginUser.get("role"));
		String newRole = String.valueOf(param.get("role"));
		if (RoleUtil.getLevel(myRole) <= RoleUtil.getLevel(newRole)) {
			result.put("result", "forbidden");
			return result;
		}
		userDAO.insertUser(param);
		int userNo = Integer.parseInt(String.valueOf(param.get("userNo")));
		result.put("result", "success");
		result.put("user", userDAO.selectUserDetail(userNo));
		return result;
	}
	/** 사용자 등록 (관리자) - 등록할 역할이 본인보다 낮아야 함 */
//	@Override
//	public Map<String, Object> insertUser(Map<String, Object> loginUser, Map<String, Object> param) throws Exception {
//		Map<String, Object> result = new HashMap<>();
//		try {
//			int dupCount = idCheck(param);
//			if (dupCount > 0) {
//				result.put("result", "duplicate");
//				return result;
//			}
//			String myRole = String.valueOf(loginUser.get("role"));
//			String newRole = String.valueOf(param.get("role"));
//			if (RoleUtil.getLevel(myRole) <= RoleUtil.getLevel(newRole)) {
//				result.put("result", "forbidden");
//				return result;
//			}
//			userDAO.insertUser(param);
//			int userNo = Integer.parseInt(String.valueOf(param.get("userNo")));
//			result.put("result", "success");
//			result.put("user", userDAO.selectUserDetail(userNo));
//			return result;
//			
//		} catch (Exception e) {
//			result.put("result", "error");
//			return result;
//		}
//	}

	/** 사용자 수정 - 본인(권한 상향 불가) 또는 자신보다 낮은 권한의 사용자만 수정 가능 */
  @Override
  public Map<String, Object> updateUser(Map<String, Object> loginUser, Map<String, Object> param) throws Exception {
      Map<String, Object> result = new HashMap<>();
      int targetUserNo    = Integer.parseInt(String.valueOf(param.get("userNo"))); // 선택 유저 번호
      Map<String, Object> targetUser   = userDAO.selectUserDetail(targetUserNo);
      String currentRole   = String.valueOf(targetUser.get("role"));
//      String currentStatus = String.valueOf(targetUser.get("status"));
      String newRole = String.valueOf(param.get("role"));
      String newStatus = String.valueOf(param.get("status"));


      if (RoleUtil.isSelf(loginUser, targetUserNo)) { // 선택 - 본인
          // 본인: 자신의 권한을 올리는 것만 불가
          if (RoleUtil.getLevel(newRole) > RoleUtil.getLevel(currentRole)) {
              result.put("result", "forbidden");
              return result;
          }
          if(!newStatus.equals("ACTIVE")) { // 본인 비활성화 요청시 반려
          	result.put("result", "forbidden");
          	return result;
          }
      } else {
          // 타인: 자신보다 낮은 권한의 사용자만 수정, 부여 권한도 나보다 낮아야
          if (!RoleUtil.canEditUser(loginUser, targetUserNo, currentRole)) {
              result.put("result", "forbidden");
              return result;
          }
          // 권한 변경시 && 대상과 수정 권한 자신 권한보다 낮아야
          if (!currentRole.equals(newRole) && !RoleUtil.canChangeRole(loginUser, currentRole, newRole)) {
              result.put("result", "forbidden");
              return result;
          }
      }

      int count = userDAO.updateUser(param);
      if(count > 0 ) {
      	result.put("result", "success");
      	result.put("user", userDAO.selectUserDetail(targetUserNo));
      }
      return result;
  }

	/** 사용자 비활성화 - 자신보다 낮은 권한의 사용자만 삭제 가능 */
	@Override
	public Map<String, Object> disableUser(Map<String, Object> loginUser, Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<>();
		int targetUserNo = Integer.parseInt(String.valueOf(param.get("userNo")));
		Map<String, Object> targetUser = userDAO.selectUserDetail(targetUserNo);
		String targetRole = String.valueOf(targetUser.get("role"));

		// 본인보다 낮은 권한의 사용자만 삭제 가능
		if (!RoleUtil.canDeleteUser(loginUser, targetUserNo, targetRole)) {
			result.put("result", "forbidden");
			return result;
		}

		userDAO.disableUser(param);
		result.put("result", "success");
		result.put("user", userDAO.selectUserDetail(targetUserNo));
		return result;
	}

	/** 로그인 정보 단건 조회 */
	@Override
	public Map<String, Object> selectLoginInfo(Map<String, Object> param) throws Exception {
		return userDAO.selectLoginInfo(param);
	}

	/** 아이디 중복확인 (0: 사용가능, 1이상: 중복) */
	@Override
	public int idCheck(Map<String, Object> param) throws Exception {
		return userDAO.idCheck(param);
	}

	/** 회원가입 처리 - INSERT 후 reg_user 를 자기 자신(userNo)으로 UPDATE */
	@Override
	public int register(Map<String, Object> param) throws Exception {
		int result = userDAO.register(param);
		// useGeneratedKeys 로 param 에 userNo 가 채워진 후 자기 자신을 등록자로 세팅
		if (result > 0) {
			userDAO.updateRegUser(param);
		}
		return result;
	}

}

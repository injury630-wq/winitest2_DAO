package wini.winitest.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.common.PagingUtil;
import wini.winitest.service.UserService;

@Service("userService")
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService {

	@Resource(name = "userDAO")
	private UserDAO userDAO;

	/** 사용자 정보 목록 조회(페이징, 검색조건) */
	@Override
	public Map<String, Object> getUserList(Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<>();
		result.put("msg", "E");
		try {
			int recordPerPage = Integer.parseInt(String.valueOf(params.get("recordCountPerPage")));
			int pageSize      = Integer.parseInt(String.valueOf(params.get("pageSize")));
			PaginationInfo paginationInfo = PagingUtil.create(params, recordPerPage, pageSize);
			int totalCount = selectUserTotalCount(params);
			paginationInfo.setTotalRecordCount(totalCount);
			List<Map<String, Object>> userList = userDAO.selectUserList(params);
			result.put("list", userList);
			result.put("paginationInfo", paginationInfo);
			result.put("search", params);
			result.put("msg", "S");
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
			if (user == null) {
				result.put("msg", "F");
				return result;
			}
			result.put("user", user);
			result.put("msg", "S");
		} catch (Exception e) {
			result.put("msg", "E");
		}
		return result;
	}

	/** 사용자 등록 (관리자) - 권한 검사는 컨트롤러에서 수행 */
	@Override
	public Map<String, Object> insertUser(Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<>();
		userDAO.insertUser(param);
		int userNo = Integer.parseInt(String.valueOf(param.get("userNo")));
		result.put("msg", "S");
		result.put("user", userDAO.selectUserDetail(userNo));
		return result;
	}

	/** 사용자 수정 - 권한 검사는 컨트롤러에서 수행 */
	@Override
	public Map<String, Object> updateUser(Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<>();
		int targetUserNo = Integer.parseInt(String.valueOf(param.get("userNo")));
		int count = userDAO.updateUser(param);
		if (count > 0) {
			result.put("msg", "S");
			result.put("user", userDAO.selectUserDetail(targetUserNo));
		} else {
			result.put("msg", "F");
		}
		return result;
	}

	/** 사용자 비활성화 - 권한 검사는 컨트롤러에서 수행 */
	@Override
	public Map<String, Object> disableUser(Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<>();
		int targetUserNo = Integer.parseInt(String.valueOf(param.get("userNo")));
		userDAO.disableUser(param);
		result.put("msg", "S");
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
		if (result > 0) {
			userDAO.updateRegUser(param);
		}
		return result;
	}

	/** 역할 목록 조회 (콤보박스용) */
	@Override
	public List<Map<String, Object>> selectRoleList() throws Exception {
		return userDAO.selectRoleList();
	}
}

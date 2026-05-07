package wini.winitest.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.common.PagingUtil;
import wini.winitest.service.RoleService;

/**
 * Role 서비스 구현체 - EgovAbstractServiceImpl 상속 - RoleDAO를 통한 DB 접근 (Map 기반)
 */
@Service("roleService")
public class RoleServiceImpl extends EgovAbstractServiceImpl implements RoleService {

	@Resource(name = "roleDAO")
	private RoleDAO roleDAO;

	/** 권한 그룹 목록 조회 (페이징, 검색조건) */
	@Override
	public Map<String, Object> selectRoleList(Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		int currentPageNo = Integer.parseInt((String) param.get("currentPageNo"));
		int recordPerPage = Integer.parseInt((String) param.get("recordPerPage"));
		int pageSize      = Integer.parseInt((String) param.get("pageSize"));

		PaginationInfo paginationInfo = PagingUtil.create(currentPageNo, recordPerPage, pageSize);
		paginationInfo.setTotalRecordCount(roleDAO.selectRoleTotalCount(param));

		param.put("firstIndex",         paginationInfo.getFirstRecordIndex());
		param.put("recordCountPerPage", recordPerPage);

		// 검색 조건만 별도로 담아 반환 (페이징용으로 param에 추가된 값은 제외)
		Map<String, Object> search = new HashMap<String, Object>();
		search.put("searchRoleId",   param.get("searchRoleId"));
		search.put("searchRoleName", param.get("searchRoleName"));
		search.put("searchRoleRank", param.get("searchRoleRank"));
		search.put("searchUseYn",    param.get("searchUseYn"));
		search.put("searchAdminYn",  param.get("searchAdminYn"));
		search.put("recordPerPage",  param.get("recordPerPage"));

		result.put("list",           roleDAO.selectRoleList(param));
		result.put("paginationInfo", paginationInfo);
		result.put("search",         search);

		return result;
	}
	
	/** 권한 그룹 전체 건수 (검색조건)*/
	@Override
	public int selectRoleTotalCount(Map<String, Object> param) throws Exception {
		return roleDAO.selectRoleTotalCount(param);
	}

	@Override
	public Map<String, Object> selectRoleDetail(Map<String, Object> param) throws Exception {
		return roleDAO.selectRoleDetail(param);
	}

	@Override
	public int insertRole(Map<String, Object> param) throws Exception {
		return 0;
	}

	@Override
	public int updateRole(Map<String, Object> param) throws Exception {
		return 0;
	}

	@Override
	public int deleteRole(Map<String, Object> param) throws Exception {
		return 0;
	}

	/** 코드 그룹명으로 코드 목록 조회 (콤보박스용) */
	@Override
	public List<Map<String, Object>> selectCodesByGroupCode(String groupCode) throws Exception {
		return roleDAO.selectCodesByGroupCode(groupCode);
	}

}

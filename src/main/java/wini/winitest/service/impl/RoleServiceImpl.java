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

	/** 권한 그룹 목록 조회 (페이징, 검색조건)*/
	@Override
	public Map<String, Object> selectRoleList(Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		
		// 페이징 정보(검색조건)
		int currentPageNo = Integer.parseInt(String.valueOf(param.get("currentPageNo")));
		int recordPerPage = Integer.parseInt(String.valueOf(param.get("recordPerPage")));;
		int pageSize 			= Integer.parseInt(String.valueOf(param.get("pageSize")));;;
		int totalCount		= selectRoleTotalCount(param);
		PaginationInfo paginationInfo = PagingUtil.create(currentPageNo, recordPerPage, pageSize);
		paginationInfo.setTotalRecordCount(totalCount);
		
		// 목록 조회(검색조건, 페이징)
		param.put("firstIndex", paginationInfo.getFirstRecordIndex());
		param.put("recordCountPerPage", recordPerPage);
		List<Map<String, Object>> roleList = roleDAO.selectRoleList(param);
		
		result.put("list", roleList);
		result.put("paginationInfo", paginationInfo);
		
		return result;
	}
	
	/** 권한 그룹 전체 건수 (검색조건)*/
	@Override
	public int selectRoleTotalCount(Map<String, Object> param) throws Exception {
		return roleDAO.selectRoleTotalCount(param);
	}

	@Override
	public Map<String, Object> selectRoleDetail(Map<String, Object> param) throws Exception {
		return null;
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

}

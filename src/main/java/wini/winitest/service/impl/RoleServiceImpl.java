package wini.winitest.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

	@Resource(name = "menuRolePermDAO")
	private MenuRolePermDAO menuRolePermDAO;

	/** 권한 그룹 목록 조회 (페이징, 검색조건) */
	@Override
	public Map<String, Object> selectRoleList(Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		int currentPageNo = Integer.parseInt((String) param.get("currentPageNo"));
		int recordPerPage = Integer.parseInt((String) param.get("recordPerPage"));
		int pageSize      = Integer.parseInt((String) param.get("pageSize"));

		PaginationInfo paginationInfo = PagingUtil.create(currentPageNo, recordPerPage, pageSize);
		paginationInfo.setTotalRecordCount(roleDAO.selectRoleTotalCount(param)); // 검색조건에 따른 전체 건수

		// 목록 조회 LIMIT 조건 추가
		param.put("firstIndex",         paginationInfo.getFirstRecordIndex());
		param.put("recordCountPerPage", recordPerPage);

		Map<String, Object> search = new HashMap<String, Object>();
		search.put("searchRoleId",   param.get("searchRoleId"));
		search.put("searchRoleName", param.get("searchRoleName"));
		search.put("searchRoleRank", param.get("searchRoleRank"));
		search.put("searchUseYn",    param.get("searchUseYn"));
		search.put("searchAdminYn",  param.get("searchAdminYn"));
		search.put("recordPerPage",  param.get("recordPerPage"));

		result.put("list",  roleDAO.selectRoleList(param));
		result.put("paginationInfo", paginationInfo);
		result.put("search",  search);

		return result;
	}

	/** 권한 그룹 전체 건수 (검색조건) */
	@Override
	public int selectRoleTotalCount(Map<String, Object> param) throws Exception {
		return roleDAO.selectRoleTotalCount(param);
	}

	/** 권한 그룹 상세 조회 */
	@Override
	public Map<String, Object> selectRoleDetail(Map<String, Object> param) throws Exception {
		return roleDAO.selectRoleDetail(param);
	}

	/** 권한 그룹 단건 등록 — sort_ord 밀기 => INSERT => roleId 생성 → 메뉴 권한 초기 등록 */
	@Override
	@Transactional
	public void insertRole(Map<String, Object> param) throws Exception {
		roleDAO.shiftSortOrd(param);
		roleDAO.insertRole(param);
		int roleNo = Integer.parseInt(String.valueOf(param.get("roleNo")));
		param.put("roleId", buildRoleId((String) param.get("roleRank"), roleNo));
		roleDAO.updateRoleId(param);
		menuRolePermDAO.insertDefaultMenuRolePerm(param);
	}

	/** 권한 그룹 수정 */
	@Override
	@Transactional
	public int updateRole(Map<String, Object> param) throws Exception {
		int oldSortOrd = roleDAO.selectSortOrd(param);
		int newSortOrd = Integer.parseInt(String.valueOf(param.get("sortOrd")));
		if (newSortOrd != oldSortOrd) {
			param.put("oldSortOrd", oldSortOrd);
			param.put("newSortOrd", newSortOrd);
			if (newSortOrd < oldSortOrd) {
				roleDAO.shiftSortOrdUp(param);
			} else {
				roleDAO.shiftSortOrdDown(param);
			}
		}
		return roleDAO.updateRole(param);
	}

	/** 권한 그룹 논리 삭제 */
	@Override
	@Transactional
	public boolean deleteRole(Map<String, Object> param) throws Exception {
		return roleDAO.deleteRole(param) > 0;
	}

	/** 롤 전체 목록 조회 (콤보박스용) */
	@Override
	public List<Map<String, Object>> selectAllRoleList() throws Exception {
		return roleDAO.selectAllRoleList();
	}

	/** 롤별 메뉴 권한 목록 조회 */
	@Override
	public List<Map<String, Object>> selectMenuPermList(Map<String, Object> param) throws Exception {
		return menuRolePermDAO.selectMenuPermList(param);
	}

	/** 세션 저장용 - 롤별 메뉴 권한 목록 조회 */
	@Override
	public List<Map<String, Object>> selectMenuPermByRole(Map<String, Object> param) throws Exception {
		return menuRolePermDAO.selectMenuPermByRole(param);
	}

	/** 메뉴별 권한 일괄 저장 */
	@Override
	@Transactional
	public void saveMenuPermList(String roleNo, List<Map<String, Object>> perms, Object modUser) throws Exception {
		for (Map<String, Object> perm : perms) {
			perm.put("roleNo",   roleNo);
			perm.put("modUser",  modUser);
			menuRolePermDAO.updateMenuPerm(perm);
		}
	}

	/** 롤에 배정된 활성 사용자 수 조회 */
	@Override
	public int countUserByRole(int roleNo) throws Exception {
		return roleDAO.countUserByRole(roleNo);
	}

	/** 시스템관리자(role_rank=70030) 여부 확인 */
	@Override
	public boolean isSystemAdmin(String roleNo) throws Exception {
		if (roleNo == null || roleNo.isEmpty()) return false;
		Integer rank = roleDAO.selectRoleRank(Integer.parseInt(roleNo));
		return rank != null && rank.intValue() == 70030;
	}

	/** roleRank 코드값으로 prefix 결정 후 roleId 생성 (70020=관리자→MGR, 그 외→USER) */
	private String buildRoleId(String roleRank, int roleNo) {
		String prefix = "70020".equals(roleRank) ? "MGR" : "USER";
		return prefix + String.format("%04d", roleNo);
	}

}

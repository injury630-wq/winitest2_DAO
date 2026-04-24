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
import wini.winitest.service.MenuService;
import wini.winitest.service.UserService;

/**
 * 사용자 서비스 구현체 - EgovAbstractServiceImpl 상속 - menuDAO를 통한 DB 접근 (Map 기반)
 */
@Service("menuService")
public class MenuServiceImpl extends EgovAbstractServiceImpl implements MenuService {

	@Resource(name = "menuDAO")
	private MenuDAO menuDAO;

	@Override
	public List<Map<String, Object>> selectMenuList() throws Exception {
		return menuDAO.selectMenuList();
	}

	

}

package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import wini.winitest.service.MenuService;

/**
 * 사용자 서비스 구현체 - EgovAbstractServiceImpl 상속 - menuDAO를 통한 DB 접근 (Map 기반)
 */
@Service("menuService")
public class MenuServiceImpl extends EgovAbstractServiceImpl implements MenuService {

	@Resource(name = "menuDAO")
	private MenuDAO menuDAO;

	/** (권한체크) 일반사용자용 메뉴 리스트*/
	@Override
	public List<Map<String, Object>> selectMenuListUser(Map<String, Object> param) throws Exception {
		return menuDAO.selectMenuListUser(param);
	}
	/** 관리자용 메뉴 리스트*/
	@Override
	public List<Map<String, Object>> selectMenuListAdmin() throws Exception {
		return menuDAO.selectMenuListAdmin();
	}

	/** 통합용 메뉴 리스트 */
	@Override
	public List<Map<String, Object>> selectMenuList(Map<String, Object> param) throws Exception {
		return menuDAO.selectMenuList(param);
	}

}

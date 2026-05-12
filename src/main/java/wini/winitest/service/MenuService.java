package wini.winitest.service;

import java.util.List;
import java.util.Map;

public interface MenuService {
	/** (권한체크) 일반사용자용 메뉴 리스트*/
	List<Map<String, Object>> selectMenuListUser(Map<String, Object> param) throws Exception;
	
	/** (권한체크) 관리자용 메뉴 리스트*/
	List<Map<String, Object>> selectMenuListAdmin() throws Exception;

	/** (권한체크) 통합용 메뉴 리스트*/
	List<Map<String, Object>> selectMenuList(Map<String, Object> param) throws Exception;
}

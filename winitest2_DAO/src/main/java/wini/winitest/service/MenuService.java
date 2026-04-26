package wini.winitest.service;

import java.util.List;
import java.util.Map;

public interface MenuService {
	List<Map<String, Object>> selectMenuList() throws Exception;
}

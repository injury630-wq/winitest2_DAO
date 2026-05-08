package wini.winitest.service;

import java.util.List;
import java.util.Map;

public interface CodeService {

	/** 코드 그룹명으로 코드 목록 조회 (콤보박스용) */
	List<Map<String, Object>> selectCodeOptions(String groupCode) throws Exception;

}

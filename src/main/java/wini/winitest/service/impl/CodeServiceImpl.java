package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import wini.winitest.service.CodeService;

/**
 * xxx 서비스 구현체 - EgovAbstractServiceImpl 상속 - xxxDAO를 통한 DB 접근 (Map 기반)
 */
@Service("codeService")
public class CodeServiceImpl extends EgovAbstractServiceImpl implements CodeService {

	@Resource(name = "codeDAO")
	private CodeDAO codeDAO;
	
	/** 코드 그룹명으로 코드 목록 조회 (콤보박스용) */
	@Override
	public List<Map<String, Object>> selectCodeOptions(String groupCode) throws Exception {
		return codeDAO.selectCodeOptions(groupCode);
	}

}

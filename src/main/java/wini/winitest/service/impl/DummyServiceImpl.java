package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import wini.winitest.service.DummyService;

/**
 * Dummy 서비스 구현체 - EgovAbstractServiceImpl 상속 - DummyDAO를 통한 DB 접근 (Map 기반)
 */
@Service("dummyService")
public class DummyServiceImpl extends EgovAbstractServiceImpl implements DummyService {

	@Resource(name = "dummyDAO")
	private DummyDAO DummyDAO;

	
	/** Dummy 정보 목록 조회(페이징,검색조건) */
	@Override
	public List<Map<String, Object>> selectDummyList(Map<String, Object> param) throws Exception {
		return null;
	}

	@Override
	public int selectDummyTotalCount(Map<String, Object> param) throws Exception {
		return 0;
	}

	@Override
	public Map<String, Object> selectDummyDetail(Map<String, Object> param) throws Exception {
		return null;
	}

	@Override
	public int insertDummy(Map<String, Object> param) throws Exception {
		return 0;
	}

	@Override
	public int updateDummy(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteDummy(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

}

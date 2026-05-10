package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * CodeDAO - EgovComAbstractDAO 상속
 * SQL ID: codeDAO.{queryId} (CodeMapper.xml namespace="CodeDAO")
 */
@Repository("codeDAO")
public class CodeDAO extends EgovComAbstractDAO {

  /** 코드 그룹명으로 코드 목록 조회 (콤보박스용) */
	public List<Map<String, Object>> selectCodeOptions(String groupCode) throws Exception {
    return selectList("codeDAO.selectCodeOptions", groupCode);
  }

}

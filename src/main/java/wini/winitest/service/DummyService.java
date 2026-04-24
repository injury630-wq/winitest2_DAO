package wini.winitest.service;

import java.util.List;
import java.util.Map;

/**
 *  xxx 서비스 인터페이스 - Map 기반 DAO 방식
 */
public interface DummyService {
  /** 더미 목록 조회 (페이징 + 검색 조건 포함) */
  public List<Map<String, Object>> selectDummyList(Map<String, Object> param) throws Exception;

  /** 더미 전체 건수 조회 (검색 조건 포함) */
  public int selectDummyTotalCount(Map<String, Object> param) throws Exception;

  /** 더미 단건 상세 조회 */
  public Map<String, Object> selectDummyDetail(Map<String, Object> param) throws Exception;

  /** 더미 등록 */
  public int insertDummy(Map<String, Object> param) throws Exception;

  /** 더미 수정 */
  public int updateDummy(Map<String, Object> param) throws Exception;

  /** 더미 삭제 */
  public int deleteDummy(Map<String, Object> param) throws Exception;

}

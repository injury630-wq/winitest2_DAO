package wini.winitest.service;

import java.util.List;
import java.util.Map;

/**
 * 게시판 서비스 인터페이스 - Map 기반 DAO 방식
 * 모든 파라미터/반환값은 Map 사용 (VO 미사용)
 */
public interface BoardService {

    /* ===== 게시글 조회 ===== */

    /** 게시글 목록 조회 (페이징 + 검색 조건 포함) */
    List<Map<String, Object>> selectList(Map<String, Object> param) throws Exception;

    /** 게시글 전체 건수 조회 (검색 조건 포함) */
    int selectBoardTotalCount(Map<String, Object> param) throws Exception;

    /** 게시글 단건 상세 조회 */
    Map<String, Object> selectBoardDetail(Map<String, Object> param) throws Exception;

    /* ===== 게시글 처리 ===== */

    /** 조회수 증가 */
    int updateHit(Map<String, Object> param) throws Exception;

    /** 게시글 등록 */
    int insertBoard(Map<String, Object> param) throws Exception;

    /** 게시글 수정 */
    int updateBoard(Map<String, Object> param) throws Exception;

    /** 게시글 삭제 */
    int deleteBoard(Map<String, Object> param) throws Exception;

    /** 특정 글(boardNo)의 직접 자식 수 조회 (부모글당 최대 5개 제한 체크용) */
    int countChildReply(Map<String, Object> param) throws Exception;

    /** 답변글 등록 (re_seq 처리 포함) */
    int insertReply(Map<String, Object> param) throws Exception;

    /* ===== 첨부파일 ===== */

    /** 첨부파일 목록 조회 */
    List<Map<String, Object>> selectBoardFileList(Map<String, Object> param) throws Exception;

    /** 첨부파일 단건 조회 */
    Map<String, Object> selectBoardFileDetail(Map<String, Object> param) throws Exception;

    /** 첨부파일 등록 */
    int insertBoardFile(Map<String, Object> param) throws Exception;

    /** 첨부파일 단건 삭제 */
    int deleteBoardFile(Map<String, Object> param) throws Exception;
}

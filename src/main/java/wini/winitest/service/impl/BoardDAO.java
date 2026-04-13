package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * 게시판 DAO - EgovComAbstractDAO 상속
 * SQL ID: boardDAO.{queryId} (BoardMapper.xml namespace="boardDAO")
 */
@Repository("boardDAO")
public class BoardDAO extends EgovComAbstractDAO {

    /* ===== 게시글 조회 ===== */

    /** 게시글 목록 조회 (페이징 + 검색 조건) */
    public List<Map<String, Object>> selectList(Map<String, Object> param) {
        return selectList("boardDAO.selectBoardList", param);
    }

    /** 게시글 전체 건수 조회 */
    public int selectBoardTotalCount(Map<String, Object> param) {
        return (Integer) selectOne("boardDAO.selectBoardTotalCount", param);
    }

    /** 게시글 단건 상세 조회 */
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectBoardDetail(Map<String, Object> param) {
        return (Map<String, Object>) selectOne("boardDAO.getBoardDetail", param);
    }

    /* ===== 게시글 처리 ===== */

    /** 조회수 증가 */
    public int updateHit(Map<String, Object> param) {
        return update("boardDAO.updateHit", param);
    }

    /** 게시글 등록 */
    public int insertBoard(Map<String, Object> param) {
        return insert("boardDAO.insertBoard", param);
    }

    /** ref 업데이트 (원글 등록 후 boardNo로 자기 참조) */
    public int updateRef(Map<String, Object> param) {
        return update("boardDAO.updateRef", param);
    }

    /** 특정 글(boardNo)의 직접 자식 수 조회 (부모글당 최대 5개 제한 체크용) */
    public int countChildReply(Map<String, Object> param) {
        return (Integer) selectOne("boardDAO.countChildReply", param);
    }

    /** 답변글 re_seq 밀기 */
    public int updateReSeq(Map<String, Object> param) {
        return update("boardDAO.updateReSeq", param);
    }

    /** 게시글 수정 */
    public int updateBoard(Map<String, Object> param) {
        return update("boardDAO.updateBoard", param);
    }

    /** 직접 자식글 조회 (parent_no 기반 계층 삭제용) */
    public List<Map<String, Object>> selectChildBoardNos(Map<String, Object> param) {
        return selectList("boardDAO.selectChildBoardNos", param);
    }

    /** 게시글 복수 삭제 (계층 삭제용) */
    public int deleteBoardByIds(Map<String, Object> param) {
        return delete("boardDAO.deleteBoardByIds", param);
    }


    /** 첨부파일 목록 조회 */
    public List<Map<String, Object>> selectBoardFileList(Map<String, Object> param) {
        return selectList("boardDAO.getBoardFileList", param);
    }

    /** 첨부파일 단건 조회 */
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectBoardFileDetail(Map<String, Object> param) {
        return (Map<String, Object>) selectOne("boardDAO.getBoardFileDetail", param);
    }

    /** 첨부파일 등록 */
    public int insertBoardFile(Map<String, Object> param) {
        return insert("boardDAO.insertBoardFile", param);
    }

    /** 첨부파일 단건 삭제 */
    public int deleteBoardFile(Map<String, Object> param) {
        return delete("boardDAO.deleteBoardFile", param);
    }

    /** 첨부파일 목록 조회 (게시글 복수 ID 기반) */
    public List<Map<String, Object>> selectFileListByIds(Map<String, Object> param) {
        return selectList("boardDAO.selectFileListByIds", param);
    }

    /** 첨부파일 복수 삭제 (계층 삭제용) */
    public int deleteBoardFilesByBoardIds(Map<String, Object> param) {
        return delete("boardDAO.deleteBoardFilesByBoardIds", param);
    }
}

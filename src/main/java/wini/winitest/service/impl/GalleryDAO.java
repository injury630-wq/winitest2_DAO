package wini.winitest.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * 갤러리 DAO - EgovComAbstractDAO 상속
 * SQL ID: galleryDAO.{queryId} (GalleryMapper.xml namespace="galleryDAO")
 */
@Repository("galleryDAO")
public class GalleryDAO extends EgovComAbstractDAO {

    /** 게시글 번호 채번 (BOARD_COMMON_SEQ) */
    public int selectNextBoardNo() throws Exception {
        return (Integer) selectOne("galleryDAO.selectNextBoardNo", new HashMap<>());
    }

    /** 이미지 게시글 목록 조회 (페이징 + 검색) */
    public List<Map<String, Object>> selectGalleryList(Map<String, Object> param) throws Exception {
        return selectList("galleryDAO.selectGalleryList", param);
    }

    /** 이미지 게시글 전체 건수 (페이징용) */
    public int selectGalleryTotalCount(Map<String, Object> param) {
        return (Integer) selectOne("galleryDAO.selectGalleryTotalCount", param);
    }

    /** 이미지 게시글 단건 상세 조회 */
    public Map<String, Object> selectGalleryDetail(Map<String, Object> param) throws Exception {
        return (Map<String, Object>) selectOne("galleryDAO.selectGalleryDetail", param);
    }

    /** 이미지 게시글 등록 */
    public int insertGallery(Map<String, Object> param) throws Exception {
        return insert("galleryDAO.insertGallery", param);
    }

    /** 이미지 게시글 수정 */
    public int updateGallery(Map<String, Object> param) throws Exception {
        return update("galleryDAO.updateGallery", param);
    }

    /** 이미지 게시글 논리 삭제 (use_yn 'Y'→'N') */
    public int logicalDeleteGallery(Map<String, Object> param) throws Exception {
        return update("galleryDAO.logicalDeleteGallery", param);
    }

    /** 임시 파일 등록 (Ajax 업로드 직후 - use_yn='N', board_no=0) */
    public int insertTempFile(Map<String, Object> param) throws Exception {
        return insert("galleryDAO.insertTempFile", param);
    }

    /** 파일 활성화 (게시글 저장 시 use_yn 'N'→'Y', board_no 확정) */
    public int activateFiles(Map<String, Object> param) throws Exception {
        return update("galleryDAO.activateFiles", param);
    }

    /** 파일 등록 (직접 저장 방식 - 구방식 롤백용) */
    public int insertGalleryFile(Map<String, Object> param) throws Exception {
        return insert("galleryDAO.insertGalleryFile", param);
    }

    /** 파일 목록 조회 (게시글번호 기준, 활성 파일만) */
    public List<Map<String, Object>> selectGalleryFiles(Map<String, Object> param) throws Exception {
        return selectList("galleryDAO.selectGalleryFiles", param);
    }

    /** 파일 단건 조회 (imgView 다운로드용 - use_yn 조건 없음, 임시파일 포함) */
    public Map<String, Object> selectGalleryFileDetail(Map<String, Object> param) throws Exception {
        return (Map<String, Object>) selectOne("galleryDAO.selectGalleryFileDetail", param);
    }

    /** 파일 논리 삭제 (use_yn 'Y'→'N') */
    public int logicalDeleteFile(Map<String, Object> param) throws Exception {
        return update("galleryDAO.logicalDeleteFile", param);
    }

    /** 조회수 증가 */
    public int updateHit(Map<String, Object> param) throws Exception {
        return update("galleryDAO.updateHit", param);
    }
}

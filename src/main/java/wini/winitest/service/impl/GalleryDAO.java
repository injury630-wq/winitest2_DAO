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

    public int selectNextBoardNo() throws Exception {
        return (Integer) selectOne("galleryDAO.selectNextBoardNo", new HashMap<>());
    }

    public List<Map<String, Object>> selectGalleryList(Map<String, Object> param) throws Exception {
        return selectList("galleryDAO.selectGalleryList", param);
    }

    public int selectGalleryTotalCount(Map<String, Object> param) {
        return (Integer) selectOne("galleryDAO.selectGalleryTotalCount", param);
    }

    public Map<String, Object> selectGalleryDetail(Map<String, Object> param) throws Exception {
        return (Map<String, Object>) selectOne("galleryDAO.selectGalleryDetail", param);
    }

    public int insertGallery(Map<String, Object> param) throws Exception {
        return insert("galleryDAO.insertGallery", param);
    }

    public int updateGallery(Map<String, Object> param) throws Exception {
        return update("galleryDAO.updateGallery", param);
    }

    public int logicalDeleteGallery(Map<String, Object> param) throws Exception {
        return update("galleryDAO.logicalDeleteGallery", param);
    }

    /* ===== Ajax 임시업로드 방식 추가 ===== */
    public int insertTempFile(Map<String, Object> param) throws Exception {
        return insert("galleryDAO.insertTempFile", param);
    }

    public int activateFiles(Map<String, Object> param) throws Exception {
        return update("galleryDAO.activateFiles", param);
    }
    /* ===== Ajax 임시업로드 방식 끝 ===== */

    public int insertGalleryFile(Map<String, Object> param) throws Exception {
        return insert("galleryDAO.insertGalleryFile", param);
    }

    public List<Map<String, Object>> selectGalleryFiles(Map<String, Object> param) throws Exception {
        return selectList("galleryDAO.selectGalleryFiles", param);
    }

    public Map<String, Object> selectGalleryFileDetail(Map<String, Object> param) throws Exception {
        return (Map<String, Object>) selectOne("galleryDAO.selectGalleryFileDetail", param);
    }

    public int logicalDeleteFile(Map<String, Object> param) throws Exception {
        return update("galleryDAO.logicalDeleteFile", param);
    }

    public int updateHit(Map<String, Object> param) throws Exception {
        return update("galleryDAO.updateHit", param);
    }
}

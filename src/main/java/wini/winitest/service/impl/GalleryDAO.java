package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * 갤러리 DAO - EgovComAbstractDAO 상속
 * SQL ID: galleryDAO.{queryId} (GalleryMapper.xml namespace="GalleryDAO")
 */
@Repository("galleryDAO")
public class GalleryDAO extends EgovComAbstractDAO {
	 /* ===== 갤러리 조회 ===== */

  /** 갤러리 목록 조회 (페이징 + 검색 조건) */
  public List<Map<String, Object>> selectGalleryList(Map<String, Object> param) throws Exception {
      return selectList("galleryDAO.selectGalleryList", param);
  }

  /** 갤러리 전체 건수 조회 */
  public int selectGalleryTotalCount(Map<String, Object> param) {
      return (Integer) selectOne("galleryDAO.selectGalleryTotalCount", param);
  }

  /** 갤러리 등록 */
  public int insertGallery(Map<String, Object> param) {
      return insert("galleryDAO.insertGallery", param);
  }
}

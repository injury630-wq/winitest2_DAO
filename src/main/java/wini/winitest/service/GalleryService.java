package wini.winitest.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface GalleryService {

    Map<String, Object> getGalleryList(Map<String, Object> param) throws Exception;

    Map<String, Object> getGalleryDetail(Map<String, Object> param) throws Exception;

    /** [Ajax 임시업로드] 파일 즉시 저장 후 fileNo 목록 반환 (use_yn='N') */
    List<Map<String, Object>> saveTempFiles(List<MultipartFile> files, Object regUser) throws Exception;

    Map<String, Object> saveGallery(Map<String, Object> param, List<MultipartFile> files) throws Exception;

    Map<String, Object> editGallery(Map<String, Object> param, List<MultipartFile> files) throws Exception;

    Map<String, Object> deleteGallery(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> getGalleryFiles(Map<String, Object> param) throws Exception;

    void logicalDeleteFile(Map<String, Object> param) throws Exception;

    Map<String, Object> selectFileDetail(Map<String, Object> param) throws Exception;

    int updateHit(Map<String, Object> param) throws Exception;
}

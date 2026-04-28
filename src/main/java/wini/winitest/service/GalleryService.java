package wini.winitest.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

/** 갤러리 서비스 인터페이스 - Map 기반 DAO 방식 */
public interface GalleryService {

    /** 갤러리 목록 조회 (페이징, 검색조건) + 전체 건수 */
    Map<String, Object> getGalleryList(Map<String, Object> param) throws Exception;

    /** 갤러리 게시글 상세 조회 */
    Map<String, Object> getGalleryDetail(Map<String, Object> param) throws Exception;

    /** [Ajax 임시업로드] 파일 즉시 저장 후 fileNo 목록 반환 (use_yn='N') */
    List<Map<String, Object>> saveTempFiles(List<MultipartFile> files, Object regUser) throws Exception;

    /** 갤러리 게시글 등록 (파일 활성화 + 썸네일 설정 포함) */
    Map<String, Object> saveGallery(Map<String, Object> param) throws Exception;

    /** 갤러리 게시글 수정 (파일 삭제·활성화·썸네일 재설정 포함) */
    Map<String, Object> editGallery(Map<String, Object> param) throws Exception;

    /** 갤러리 게시글 삭제 (연결 파일 논리삭제 포함) */
    Map<String, Object> deleteGallery(Map<String, Object> param) throws Exception;

    /** 게시글에 연결된 파일 목록 조회 */
    List<Map<String, Object>> getGalleryFiles(Map<String, Object> param) throws Exception;

    /** 파일 논리삭제 (use_yn 'Y'->'N') */
    void logicalDeleteFile(Map<String, Object> param) throws Exception;

    /** 파일 단건 조회 (이미지 스트리밍용) */
    Map<String, Object> selectFileDetail(Map<String, Object> param) throws Exception;

    /** 조회수 1 증가 후 갱신된 조회수 반환 */
    int updateHit(Map<String, Object> param) throws Exception;
}

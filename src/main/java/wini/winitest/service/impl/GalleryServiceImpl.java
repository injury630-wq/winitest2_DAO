package wini.winitest.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import wini.winitest.common.FileUploadUtil;
import wini.winitest.service.GalleryService;

@Service("galleryService")
public class GalleryServiceImpl extends EgovAbstractServiceImpl implements GalleryService {

    @Resource(name = "galleryDAO")
    private GalleryDAO galleryDAO;

    @Value("${gallery.upload.path}")
    private String uploadPath;

    /** 목록 + 전체 건수를 Map 하나로 묶어 반환 */
    @Override
    public Map<String, Object> getGalleryList(Map<String, Object> param) throws Exception {
        List<Map<String, Object>> list = galleryDAO.selectGalleryList(param);
        int totalCount = galleryDAO.selectGalleryTotalCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("list",       list);
        result.put("totalCount", totalCount);
        return result;
    }

    /** 게시글 단건 조회 */
    @Override
    public Map<String, Object> getGalleryDetail(Map<String, Object> param) throws Exception {
        return galleryDAO.selectGalleryDetail(param);
    }

    /** 임시 파일 저장 (Ajax 업로드 직후 - use_yn='N', board_no=0) */
    @Override
    public List<Map<String, Object>> saveTempFiles(List<MultipartFile> files,
                                                    Object regUser) throws Exception {
        List<Map<String, Object>> savedFiles = FileUploadUtil.saveImages(files, uploadPath);
        for (Map<String, Object> fp : savedFiles) {
            fp.put("boardNo", 0);
            fp.put("regUser", regUser);
            galleryDAO.insertTempFile(fp);
        }
        return savedFiles;
    }

    /** board_no -> 파일 활성화 -> 썸네일 확정 -> 게시글 Insert */
    @Transactional
    @Override
    public Map<String, Object> saveGallery(Map<String, Object> param) throws Exception {
        int boardNo = galleryDAO.selectNextBoardNo();
        param.put("boardNo", boardNo);
        activateFiles(param, boardNo);
        resolveThumb(param);
        galleryDAO.insertGallery(param);

        Map<String, Object> result = new HashMap<>();
        result.put("msg",     "S");
        result.put("boardNo", boardNo);
        return result;
    }

    /** 삭제 파일 논리삭제 -> 신규 파일 활성화 -> 썸네일 재설정 -> 게시글 Update */
    @Transactional
    @Override
    public Map<String, Object> editGallery(Map<String, Object> param) throws Exception {
        int boardNo = Integer.parseInt(param.get("boardNo").toString());

        List<String> deleteFileNos = (List<String>) param.get("deleteFileNos");
        if (deleteFileNos != null) {
            for (String fn : deleteFileNos) {
                Map<String, Object> fp = new HashMap<>();
                fp.put("fileNo", Integer.parseInt(fn.trim()));
                galleryDAO.logicalDeleteFile(fp);
            }
        }

        activateFiles(param, boardNo);
        resolveThumb(param);
        galleryDAO.updateGallery(param);

        Map<String, Object> result = new HashMap<>();
        result.put("msg", "S");
        return result;
    }

    /** 연결 파일 전체 논리삭제 후 게시글 논리삭제 */
    @Transactional
    @Override
    public Map<String, Object> deleteGallery(Map<String, Object> param) throws Exception {
        Map<String, Object> boardParam = new HashMap<>();
        boardParam.put("boardNo", Integer.parseInt(String.valueOf(param.get("boardNo"))));

        List<Map<String, Object>> files = galleryDAO.selectGalleryFiles(boardParam);
        for (Map<String, Object> f : files) {
            Map<String, Object> fp = new HashMap<>();
            fp.put("fileNo", f.get("fileNo"));
            galleryDAO.logicalDeleteFile(fp);
        }
        galleryDAO.logicalDeleteGallery(param);

        Map<String, Object> result = new HashMap<>();
        result.put("msg", "S");
        return result;
    }

    /**  */
    @Override
    public List<Map<String, Object>> getGalleryFiles(Map<String, Object> param) throws Exception {
        return galleryDAO.selectGalleryFiles(param);
    }

    /**  */
    @Override
    public void logicalDeleteFile(Map<String, Object> param) throws Exception {
        galleryDAO.logicalDeleteFile(param);
    }

    @Override
    public Map<String, Object> selectFileDetail(Map<String, Object> param) throws Exception {
        return galleryDAO.selectGalleryFileDetail(param);
    }

    /** 조회수 1 증가 후 갱신된 조회수 반환 */
    @Override
    public int updateHit(Map<String, Object> param) throws Exception {
        galleryDAO.updateHit(param);
        Map<String, Object> board = galleryDAO.selectGalleryDetail(param);
        return board != null ? ((Number) board.get("hit")).intValue() : 0;
    }

    /** 임시 파일 활성화 (use_yn 'N'-'Y', board_no 확정) */
    private void activateFiles(Map<String, Object> param, int boardNo) throws Exception {
        List<String> activeFileNos = (List<String>) param.get("activeFileNos");
        if (activeFileNos == null || activeFileNos.isEmpty()) return;
        List<Integer> fileNoInts = new ArrayList<>();
        for (String s : activeFileNos) fileNoInts.add(Integer.parseInt(s.trim()));
        Map<String, Object> ap = new HashMap<>();
        ap.put("boardNo", boardNo);
        ap.put("fileNos", fileNoInts);
        galleryDAO.activateFiles(ap);
    }

    /** thumbFileNo 문자열 - Integer 변환 */
    private void resolveThumb(Map<String, Object> param) {
        String s = param.get("thumbFileNo") != null ? String.valueOf(param.get("thumbFileNo")) : "";
        param.put("thumbFileNo", (!s.isEmpty() && !"null".equals(s) && !"0".equals(s))
                                 ? Integer.parseInt(s) : null);
    }
}

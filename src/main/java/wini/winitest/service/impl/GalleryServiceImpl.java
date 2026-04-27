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

    @Override
    public Map<String, Object> getGalleryList(Map<String, Object> param) throws Exception {
        List<Map<String, Object>> list = galleryDAO.selectGalleryList(param);
        int totalCount = galleryDAO.selectGalleryTotalCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("list",       list);
        result.put("totalCount", totalCount);
        return result;
    }

    @Override
    public Map<String, Object> getGalleryDetail(Map<String, Object> param) throws Exception {
        return galleryDAO.selectGalleryDetail(param);
    }

    /* ===== Ajax 임시업로드 방식 추가 ===== */
    @Override
    public List<Map<String, Object>> saveTempFiles(List<MultipartFile> files,
                                                    Object regUser) throws Exception {
        List<Map<String, Object>> savedFiles = FileUploadUtil.saveImages(files, uploadPath, regUser);
        for (Map<String, Object> fp : savedFiles) {
            fp.put("boardNo", 0);
            galleryDAO.insertTempFile(fp);
        }
        return savedFiles;
    }

    private void activateNewFiles(Map<String, Object> param, int boardNo) throws Exception {
        @SuppressWarnings("unchecked")
        List<String> activeFileNos = (List<String>) param.get("activeFileNos");
        if (activeFileNos == null || activeFileNos.isEmpty()) return;
        List<Integer> fileNoInts = new ArrayList<>();
        for (String s : activeFileNos) fileNoInts.add(Integer.parseInt(s.trim()));
        Map<String, Object> ap = new HashMap<>();
        ap.put("boardNo", boardNo);
        ap.put("fileNos", fileNoInts);
        galleryDAO.activateFiles(ap);
    }

    private void resolveThumbDirect(Map<String, Object> param) {
        String thumbStr = param.get("thumbFileNo") != null
                          ? String.valueOf(param.get("thumbFileNo")) : "";
        if (!thumbStr.isEmpty() && !"null".equals(thumbStr) && !"0".equals(thumbStr)) {
            param.put("thumbFileNo", Integer.parseInt(thumbStr));
        } else {
            param.put("thumbFileNo", null);
        }
    }
    /* ===== Ajax 임시업로드 방식 끝 ===== */

    @Transactional
    @Override
    public Map<String, Object> saveGallery(Map<String, Object> param,
                                            List<MultipartFile> files) throws Exception {
        // 1. boardNo 채번
        int boardNo = galleryDAO.selectNextBoardNo();
        param.put("boardNo", boardNo);

        /* ===== [신방식] Ajax 임시업로드 활성화 =====
         * 파일은 업로드 시점에 이미 file_master(use_yn='N')에 저장됨.
         * board_no 확정 + use_yn='Y' 로 변경만 수행. */
        activateNewFiles(param, boardNo);
        resolveThumbDirect(param);
        /* ===== [신방식] 끝 ===== */

        /* ===== [구방식 - 롤백용 주석] __IMG_N__ 치환 방식 =====
        Object regUser = param.get("regUser");
        List<Map<String, Object>> savedFiles = FileUploadUtil.saveImages(files, uploadPath, regUser);
        for (Map<String, Object> fp : savedFiles) {
            fp.put("boardNo", boardNo);
            galleryDAO.insertGalleryFile(fp);
        }
        String content = (String) param.get("content");
        if (content != null) {
            for (int i = 0; i < savedFiles.size(); i++) {
                content = content.replace(
                    "__IMG_" + i + "__",
                    "gallery/imgView.do?fileNo=" + savedFiles.get(i).get("fileNo")
                );
            }
        }
        param.put("content", content);
        resolveThumb(param, savedFiles);
        ===== [구방식] 끝 ===== */

        // 2. 게시글 저장
        galleryDAO.insertGallery(param);

        Map<String, Object> result = new HashMap<>();
        result.put("msg",     "S");
        result.put("boardNo", boardNo);
        return result;
    }

    @Transactional
    @Override
    public Map<String, Object> editGallery(Map<String, Object> param,
                                            List<MultipartFile> files) throws Exception {
        int boardNo = Integer.parseInt(param.get("boardNo").toString());

        // 기존 파일 논리 삭제 (구방식·신방식 공통)
        @SuppressWarnings("unchecked")
        List<String> deleteFileNos = (List<String>) param.get("deleteFileNos");
        if (deleteFileNos != null) {
            for (String fn : deleteFileNos) {
                Map<String, Object> fp = new HashMap<>();
                fp.put("fileNo", Integer.parseInt(fn.trim()));
                galleryDAO.logicalDeleteFile(fp);
            }
        }

        /* ===== [신방식] Ajax 임시업로드 활성화 ===== */
        activateNewFiles(param, boardNo);
        resolveThumbDirect(param);
        /* ===== [신방식] 끝 ===== */

        /* ===== [구방식 - 롤백용 주석] __IMG_N__ 치환 방식 =====
        Object modUser = param.get("modUser");
        List<Map<String, Object>> savedFiles = FileUploadUtil.saveImages(files, uploadPath, modUser);
        for (Map<String, Object> fp : savedFiles) {
            fp.put("boardNo", boardNo);
            galleryDAO.insertGalleryFile(fp);
        }
        String content = (String) param.get("content");
        if (content != null) {
            for (int i = 0; i < savedFiles.size(); i++) {
                content = content.replace(
                    "__IMG_" + i + "__",
                    "gallery/imgView.do?fileNo=" + savedFiles.get(i).get("fileNo")
                );
            }
        }
        param.put("content", content);
        resolveThumb(param, savedFiles);
        ===== [구방식] 끝 ===== */

        // 게시글 수정
        galleryDAO.updateGallery(param);

        Map<String, Object> result = new HashMap<>();
        result.put("msg", "S");
        return result;
    }

    @Transactional
    @Override
    public Map<String, Object> deleteGallery(Map<String, Object> param) throws Exception {
        int boardNo = Integer.parseInt(param.get("boardNo").toString());
        Map<String, Object> boardParam = new HashMap<>();
        boardParam.put("boardNo", boardNo);

        // 파일 논리 삭제
        List<Map<String, Object>> files = galleryDAO.selectGalleryFiles(boardParam);
        for (Map<String, Object> f : files) {
            Map<String, Object> fp = new HashMap<>();
            fp.put("fileNo", f.get("fileNo"));
            galleryDAO.logicalDeleteFile(fp);
        }

        // 게시글 논리 삭제
        galleryDAO.logicalDeleteGallery(param);

        Map<String, Object> result = new HashMap<>();
        result.put("msg", "S");
        return result;
    }

    @Override
    public List<Map<String, Object>> getGalleryFiles(Map<String, Object> param) throws Exception {
        return galleryDAO.selectGalleryFiles(param);
    }

    @Override
    public void logicalDeleteFile(Map<String, Object> param) throws Exception {
        galleryDAO.logicalDeleteFile(param);
    }

    @Override
    public Map<String, Object> selectFileDetail(Map<String, Object> param) throws Exception {
        return galleryDAO.selectGalleryFileDetail(param);
    }

    @Override
    public int updateHit(Map<String, Object> param) throws Exception {
        galleryDAO.updateHit(param);
        Map<String, Object> board = galleryDAO.selectGalleryDetail(param);
        return (Integer)board.get("hit");
    }

    /* ===== [구방식 - 롤백용 주석] resolveThumb =====
    private void resolveThumb(Map<String, Object> param, List<Map<String, Object>> savedFiles) {
        String thumbFileNoStr = param.get("thumbFileNo") != null
                                ? String.valueOf(param.get("thumbFileNo")) : "";
        String thumbIndexStr  = param.get("thumbIndex") != null
                                ? String.valueOf(param.get("thumbIndex")) : "";

        if (!thumbFileNoStr.isEmpty() && !thumbFileNoStr.equals("null")) {
            param.put("thumbFileNo", Integer.parseInt(thumbFileNoStr));
            return;
        }
        if (!thumbIndexStr.isEmpty() && !thumbIndexStr.equals("-1")) {
            int idx = Integer.parseInt(thumbIndexStr);
            if (idx >= 0 && idx < savedFiles.size()) {
                param.put("thumbFileNo", savedFiles.get(idx).get("fileNo"));
                return;
            }
        }
        param.put("thumbFileNo", savedFiles.isEmpty() ? null : savedFiles.get(0).get("fileNo"));
    }
    ===== [구방식] 끝 ===== */
}

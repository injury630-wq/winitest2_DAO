package wini.winitest.service.impl;

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

    @Transactional
    @Override
    public Map<String, Object> saveGallery(Map<String, Object> param,
                                            List<MultipartFile> files) throws Exception {
        Object regUser = param.get("regUser");

        // 1. boardNo 채번
        int boardNo = galleryDAO.selectNextBoardNo();
        param.put("boardNo", boardNo);

        // 2. 이미지 파일 저장 + file_master 삽입 (useGeneratedKeys → fileNo 채워짐)
        List<Map<String, Object>> savedFiles = FileUploadUtil.saveImages(files, uploadPath, regUser);
        for (Map<String, Object> fp : savedFiles) {
            fp.put("boardNo", boardNo);
            galleryDAO.insertGalleryFile(fp);
        }

        // 3. 내용 내 __IMG_{idx}__ 를 실제 imgView URL 로 치환
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

        // 4. 썸네일 결정
        resolveThumb(param, savedFiles);

        // 5. 게시글 저장
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
        int boardNo   = Integer.parseInt(param.get("boardNo").toString());
        Object modUser = param.get("modUser");

        // 기존 파일 논리 삭제
        @SuppressWarnings("unchecked")
        List<String> deleteFileNos = (List<String>) param.get("deleteFileNos");
        if (deleteFileNos != null) {
            for (String fn : deleteFileNos) {
                Map<String, Object> fp = new HashMap<>();
                fp.put("fileNo", Integer.parseInt(fn.trim()));
                galleryDAO.logicalDeleteFile(fp);
            }
        }

        // 1. 신규 이미지 파일 저장 + file_master 삽입
        List<Map<String, Object>> savedFiles = FileUploadUtil.saveImages(files, uploadPath, modUser);
        for (Map<String, Object> fp : savedFiles) {
            fp.put("boardNo", boardNo);
            galleryDAO.insertGalleryFile(fp);
        }

        // 2. 내용 내 __IMG_{idx}__ 치환
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

        // 3. 썸네일 결정
        resolveThumb(param, savedFiles);

        // 4. 게시글 수정
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
        return board != null ? ((Number) board.get("hit")).intValue() : 0;
    }

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
}

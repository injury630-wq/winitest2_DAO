package wini.winitest.controller;

import java.io.File;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.common.PagingUtil;
import wini.winitest.service.GalleryService;

@Controller
public class GalleryController {

    @Resource(name = "galleryService")
    private GalleryService galleryService;

    private boolean anyBlank(Map<String, Object> param, String... keys) {
        for (String key : keys) {
            Object val = param.get(key);
            if (val == null || String.valueOf(val).trim().isEmpty()) return true;
        }
        return false;
    }

    /*
     * [GET 허용 이유] list.do · detail.do 는 save/delete 처리 후 sendRedirect 의 목적지로 사용된다.
     * HTTP sendRedirect 는 스펙상 항상 GET 으로 전환되므로 redirect 대상 엔드포인트에만 GET 을 허용한다.
     * 파라미터는 Flash Attribute(세션 1회용) 로 전달하여 URL 에 노출되지 않는다.
     * 사용자가 직접 URL 을 입력하면 flash 가 없어 boardNo 가 null → 목록으로 보낸다.
     */

    // 갤러리 목록 (POST: 사용자 직접 이동 / GET: 삭제 후 redirect)
    @RequestMapping(value = "/gallery/list.do", method = {RequestMethod.GET, RequestMethod.POST})
    public String galleryList(@RequestParam Map<String, Object> param, Model model) throws Exception {
        PaginationInfo paginationInfo = PagingUtil.create(param, 8, 5);
        Map<String, Object> result = galleryService.getGalleryList(param);
        int totalCount = (int) result.get("totalCount");
        paginationInfo.setTotalRecordCount(totalCount);
        model.addAttribute("paginationInfo", paginationInfo);
        model.addAttribute("galleryList",    result.get("list"));
        model.addAttribute("totalCount",     totalCount);
        return "gallery/list";
    }

    // 갤러리 상세 (POST: 사용자 직접 이동 / GET: 저장·수정 후 redirect 전용)
    @RequestMapping(value = "/gallery/detail.do", method = {RequestMethod.GET, RequestMethod.POST})
    public String galleryDetail(@RequestParam Map<String, Object> param,
                                 HttpServletRequest request, Model model) throws Exception {
        if ("GET".equals(request.getMethod())) {
            // GET은 redirect 전용. Flash Attribute 없으면 직접 URL 접근으로 간주 → 목록으로
            // (?boardNo=3 같은 쿼리스트링 직접 입력도 여기서 차단)
            if (!model.asMap().containsKey("boardNo")) {
                return "redirect:/gallery/list.do";
            }
            param.clear();
            param.put("boardNo", String.valueOf(model.asMap().get("boardNo")));
        }
        if (anyBlank(param, "boardNo")) {
            return "redirect:/gallery/list.do";
        }
        Map<String, Object> gallery = galleryService.getGalleryDetail(param);
        if (gallery == null) {
            return "redirect:/gallery/list.do";
        }
        model.addAttribute("gallery", gallery);
        return "gallery/detail";
    }

    // ===== Ajax 임시업로드 방식 추가 =====
    // 파일 선택 즉시 서버 저장 (use_yn='N') → fileNo 반환 → 에디터에 실제 URL 표시
    @ResponseBody
    @RequestMapping(value = "/gallery/uploadTempFile.do", method = RequestMethod.POST)
    public Map<String, Object> uploadTempFile(MultipartHttpServletRequest mreq,
                                               HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            List<MultipartFile> files = mreq.getFiles("uploadFile");
            List<Map<String, Object>> saved = galleryService.saveTempFiles(files, loginUser.get("userNo"));
            result.put("msg",   "S");
            result.put("files", saved);
        } catch (Exception e) {
            result.put("msg", "E");
        }
        return result;
    }
    // ===== Ajax 임시업로드 방식 끝 =====

    // 조회수 증가 (AJAX)
    @RequestMapping(value = "/gallery/updateHitAjax.do", method = RequestMethod.POST)
    public void updateHitAjax(@RequestParam Map<String, Object> param,
                               HttpServletResponse response) throws Exception {
        int hit = galleryService.updateHit(param);
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write(String.valueOf(hit));
    }

    // 등록/수정 폼 (POST only - 사용자가 버튼을 눌러 진입)
    @RequestMapping(value = "/gallery/form.do", method = RequestMethod.POST)
    public String galleryForm(@RequestParam Map<String, Object> param, Model model) throws Exception {
        String boardNoStr = (String) param.get("boardNo");
        if (boardNoStr != null && !boardNoStr.trim().isEmpty()) {
            Map<String, Object> gallery = galleryService.getGalleryDetail(param);
            if (gallery == null) {
                return "redirect:/gallery/list.do";
            }
            Map<String, Object> fileParam = new HashMap<>();
            fileParam.put("boardNo", Integer.parseInt(boardNoStr.trim()));
            model.addAttribute("gallery",       gallery);
            model.addAttribute("existingFiles", galleryService.getGalleryFiles(fileParam));
        }
        return "gallery/form";
    }

    // 등록/수정 처리
    @RequestMapping(value = "/gallery/save.do", method = RequestMethod.POST)
    public String gallerySave(@RequestParam Map<String, Object> param,
                               MultipartHttpServletRequest mreq,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) throws Exception {
        if (anyBlank(param, "title")) {
            return "redirect:/gallery/list.do";
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        List<MultipartFile> files = mreq.getFiles("uploadFile");

        // ===== [신방식] 활성화할 fileNo 목록 수집 =====
        String[] activeNos = mreq.getParameterValues("activeFileNo");
        if (activeNos != null && activeNos.length > 0) {
            param.put("activeFileNos", Arrays.asList(activeNos));
        }
        // ===== [신방식] 끝 =====

        String boardNoStr = (String) param.get("boardNo");
        if (boardNoStr == null || boardNoStr.trim().isEmpty()) {
            param.put("regUser", loginUser.get("userNo"));
            Map<String, Object> result = galleryService.saveGallery(param, files);
            redirectAttributes.addFlashAttribute("boardNo", result.get("boardNo"));
        } else {
            param.put("modUser", loginUser.get("userNo"));
            String[] deleteNos = mreq.getParameterValues("deleteFileNo");
            if (deleteNos != null && deleteNos.length > 0) {
                param.put("deleteFileNos", Arrays.asList(deleteNos));
            }
            galleryService.editGallery(param, files);
            redirectAttributes.addFlashAttribute("boardNo", boardNoStr.trim());
            redirectAttributes.addFlashAttribute("noHit", "Y");
        }

        return "redirect:/gallery/detail.do";
    }

    // 삭제
    @RequestMapping(value = "/gallery/delete.do", method = RequestMethod.POST)
    public String galleryDelete(@RequestParam Map<String, Object> param,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) throws Exception {
        if (anyBlank(param, "boardNo")) {
            return "redirect:/gallery/list.do";
        }

        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        Map<String, Object> gallery = galleryService.getGalleryDetail(param);

        if (gallery == null) {
            return "redirect:/gallery/list.do";
        }

        boolean isOwner = String.valueOf(loginUser.get("userNo"))
                                .equals(String.valueOf(gallery.get("regUser")));
        boolean isAdmin = "Y".equals(loginUser.get("adminYn"));

        if (!isOwner && !isAdmin) {
            redirectAttributes.addFlashAttribute("boardNo", param.get("boardNo"));
            return "redirect:/gallery/detail.do";
        }

        param.put("modUser", loginUser.get("userNo"));
        galleryService.deleteGallery(param);

        return "redirect:/gallery/list.do";
    }

    // 이미지 스트리밍 (내용에 삽입된 이미지 + 목록 썸네일)
    @RequestMapping(value = "/gallery/imgView.do", method = RequestMethod.GET)
    public void imgView(@RequestParam Map<String, Object> param,
                        HttpServletResponse response) throws Exception {
        Map<String, Object> file = galleryService.selectFileDetail(param);
        if (file == null) { response.sendError(404); return; }

        File f = new File((String) file.get("filePath"), (String) file.get("fileName"));
        if (!f.exists()) { response.sendError(404); return; }

        String ext = String.valueOf(file.get("fileExt")).toLowerCase();
        String contentType = "image/" + ("jpg".equals(ext) ? "jpeg" : ext);
        response.setContentType(contentType);
        response.setContentLengthLong(f.length());
        Files.copy(f.toPath(), response.getOutputStream());
        response.flushBuffer();
    }
}

package wini.winitest.controller;

import java.io.File;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.common.MenuUtil;
import wini.winitest.common.PagingUtil;
import wini.winitest.service.GalleryService;
import wini.winitest.service.MenuService;

@Controller
public class GalleryController {

	@Resource(name = "galleryService")
	private GalleryService galleryService;

	@Resource(name = "menuService")
	private MenuService menuService;

	// 갤러리 목록
	@RequestMapping(value = "/gallery/list.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String galleryList(@RequestParam Map<String, Object> param, Model model) throws Exception {
		MenuUtil.addMenu(model, menuService);
		PaginationInfo paginationInfo = PagingUtil.create(param, 8, 10);
		Map<String, Object> result = galleryService.getGalleryList(param);
		int totalCount = (int) result.get("totalCount");
		paginationInfo.setTotalRecordCount(totalCount);
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("galleryList", result.get("list"));
		model.addAttribute("totalCount", totalCount);
		return "gallery/list";
	}

	// 갤러리 상세 (POST only - goPost()로 진입)
	@RequestMapping(value = "/gallery/detail.do", method = RequestMethod.POST)
	public String galleryDetail(@RequestParam Map<String, Object> param, Model model) throws Exception {
		MenuUtil.addMenu(model, menuService);
		Map<String, Object> gallery = galleryService.getGalleryDetail(param);
		if (gallery == null)
			return "redirect:/gallery/list.do";
		model.addAttribute("gallery", gallery);
		model.addAttribute("noHit", param.get("noHit"));
		return "gallery/detail";
	}

	// 임시 파일 업로드 (Ajax - 파일 선택 즉시 서버 저장, use_yn='N')
	@ResponseBody
	@RequestMapping(value = "/gallery/uploadTempFile.do", method = RequestMethod.POST)
	public Map<String, Object> uploadTempFile(MultipartHttpServletRequest mreq, HttpSession session) throws Exception {
		Map<String, Object> result = new HashMap<>();
		try {
			Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
			List<MultipartFile> files = mreq.getFiles("uploadFile");
			result.put("msg", "S");
			result.put("files", galleryService.saveTempFiles(files, loginUser.get("userNo")));
		} catch (Exception e) {
			result.put("msg", "E");
		}
		return result;
	}

	// 조회수 증가 (Ajax)
	@ResponseBody
	@RequestMapping(value = "/gallery/updateHitAjax.do", method = RequestMethod.POST)
	public Map<String, Object> updateHitAjax(@RequestParam Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<>();
		result.put("hit", galleryService.updateHit(param));
		return result;
	}

	// 등록/수정 폼 ()
	@RequestMapping(value = "/gallery/form.do", method = RequestMethod.POST)
	public String galleryForm(@RequestParam Map<String, Object> param, Model model) throws Exception {
		MenuUtil.addMenu(model, menuService);
		String boardNoStr = (String) param.get("boardNo");
		if (boardNoStr != null && !boardNoStr.trim().isEmpty()) {
			Map<String, Object> gallery = galleryService.getGalleryDetail(param);
			if (gallery == null) {
				return "redirect:/gallery/list.do";
			}
			Map<String, Object> fileParam = new HashMap<>();
			fileParam.put("boardNo", Integer.parseInt(boardNoStr.trim()));
			model.addAttribute("gallery", gallery);
			model.addAttribute("existingFiles", galleryService.getGalleryFiles(fileParam));
		}
		return "gallery/form";
	}

	// 등록/수정 처리 (Ajax - 성공 시 프론트에서 goPost()로 detail 이동)
	@ResponseBody
	@RequestMapping(value = "/gallery/saveAjax.do", method = RequestMethod.POST)
	public Map<String, Object> gallerySave(@RequestParam Map<String, Object> param,
			@RequestParam(value = "activeFileNo", required = false) String[] activeNos,
			@RequestParam(value = "deleteFileNo", required = false) String[] deleteNos, HttpSession session)
			throws Exception {

		Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
		Map<String, Object> result = new HashMap<>();
		String boardNo = (String) param.get("boardNo");

		if (activeNos != null) {
			param.put("activeFileNos", Arrays.asList(activeNos));
		}

		if (boardNo == null || boardNo.isEmpty()) {
			param.put("regUser", loginUser.get("userNo"));
			Map<String, Object> saveResult = galleryService.saveGallery(param);
			result.put("boardNo", saveResult.get("boardNo"));
			result.put("mode", "insert");
		} else {
			Map<String, Object> gallery = galleryService.getGalleryDetail(param);
			if (gallery == null) {
				result.put("msg", "F");
				return result;
			}

			// 권한 확인
			boolean isOwner = String.valueOf(loginUser.get("userNo")).equals(String.valueOf(gallery.get("regUser")));
			boolean isAdmin = "Y".equals(loginUser.get("adminYn"));
			if (!isOwner && !isAdmin) {
				result.put("msg", "X");
				return result;
			}

			param.put("modUser", loginUser.get("userNo"));
			if (deleteNos != null)
				param.put("deleteFileNos", Arrays.asList(deleteNos));
			galleryService.editGallery(param);
			result.put("boardNo", boardNo);
			result.put("mode", "update");
		}

		result.put("msg", "S");
		return result;
	}

	// 삭제 (Ajax - 성공 시 프론트에서 goPost()로 list 이동)
	@ResponseBody
	@RequestMapping(value = "/gallery/delete.do", method = RequestMethod.POST)
	public Map<String, Object> galleryDelete(@RequestParam Map<String, Object> param, HttpSession session)
			throws Exception {
		Map<String, Object> result = new HashMap<>();
		Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
		Map<String, Object> gallery = galleryService.getGalleryDetail(param);

		if (gallery == null) {
			result.put("msg", "F");
			return result;
		}
		// 권한 확인
		boolean isOwner = String.valueOf(loginUser.get("userNo")).equals(String.valueOf(gallery.get("regUser")));
		boolean isAdmin = "Y".equals(loginUser.get("adminYn"));
		if (!isOwner && !isAdmin) {
			result.put("msg", "X");
			return result;
		}

		param.put("modUser", loginUser.get("userNo"));
		galleryService.deleteGallery(param);
		result.put("msg", "S");
		return result;
	}

	// 이미지 스트리밍 (내용 삽입 이미지 + 목록 썸네일)
	@RequestMapping(value = "/gallery/imgView.do", method = RequestMethod.GET)
	public void imgView(@RequestParam Map<String, Object> param, HttpServletResponse response) throws Exception {
		// 파일 조회
		Map<String, Object> file = galleryService.selectFileDetail(param);
		if (file == null) {
			response.sendError(404);
			return;
		}

		File f = new File((String) file.get("filePath"), (String) file.get("fileName"));
		if (!f.exists()) {
			response.sendError(404);
			return;
		}

		// http 이미지 설정
		String ext = String.valueOf(file.get("fileExt")).toLowerCase();
		response.setContentType("image/" + ("jpg".equals(ext) ? "jpeg" : ext));
		response.setContentLengthLong(f.length());
		Files.copy(f.toPath(), response.getOutputStream());
		response.flushBuffer();
	}
}

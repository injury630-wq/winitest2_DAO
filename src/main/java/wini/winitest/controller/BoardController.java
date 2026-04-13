package wini.winitest.controller;

import java.io.File;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.service.BoardService;

@Controller
public class BoardController {

    @Resource(name = "boardDAOService")
    private BoardService boardService;
    private static final String path = "C:/upload/board/";

    // 업로드 디렉터리 경로 반환 (없으면 자동 생성)
    private String uploadPath(HttpServletRequest request) {
        //String path = request.getServletContext().getRealPath("/upload/board/");
        File dir = new File(path);
        if (!dir.exists()) dir.mkdirs();
        return path;
    }

    // 첨부파일 저장 후 board_file 테이블에 등록
    private void saveFiles(HttpServletRequest request, Object boardNo) throws Exception {
        if (!(request instanceof MultipartHttpServletRequest)) return;
        MultipartHttpServletRequest mr = (MultipartHttpServletRequest) request;
        List<MultipartFile> files = mr.getFiles("uploadFile");
        String path = uploadPath(request);

        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;
            String original = file.getOriginalFilename();
            // UUID 로 파일명 중복 방지
            String saved = UUID.randomUUID().toString() + "_" + original;
            file.transferTo(new File(path, saved));

            Map<String, Object> fp = new HashMap<>();
            fp.put("boardNo",  boardNo);
            fp.put("fileName", original);
            fp.put("filePath", saved);
            fp.put("fileSize", file.getSize());
            boardService.insertBoardFile(fp);
        }
    }

    // 물리 파일 삭제
    private void deletePhysicalFile(HttpServletRequest request, String filePath) {
        File f = new File(uploadPath(request), filePath);
        if (f.exists()) f.delete();
    }

    // 게시글 목록
    @RequestMapping(value = "/board/list.do", method = RequestMethod.POST)
    public String boardList(@RequestParam Map<String, Object> param, Model model) throws Exception {
        try {
            // 전자정부 페이징 설정
            PaginationInfo paginationInfo = new PaginationInfo();
            // null 이거나 빈 문자열("") 이면 1페이지로 처리
            // 빈 문자열을 parseInt 하면 NumberFormatException 이 발생하므로 반드시 체크
            String cpnStr = (String) param.get("currentPageNo");
            int currentPageNo = (cpnStr != null && !cpnStr.isEmpty()) ? Integer.parseInt(cpnStr) : 1;
            paginationInfo.setCurrentPageNo(currentPageNo);       // 현재 페이지
            paginationInfo.setRecordCountPerPage(10);             // 페이지당 게시물 수
            paginationInfo.setPageSize(10);                       // 페이징 버튼 수

            param.put("firstIndex", paginationInfo.getFirstRecordIndex());
            param.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

            // 전체 건수 조회 후 PaginationInfo에 등록
            int totalCount = boardService.selectBoardTotalCount(param);
            paginationInfo.setTotalRecordCount(totalCount);

            // 목록 조회
            List<Map<String, Object>> list = boardService.selectList(param);

            model.addAttribute("paginationInfo", paginationInfo);
            model.addAttribute("list", list);
            model.addAttribute("param", param); // 검색 조건 유지용
            

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("err", "목록 조회 중 오류가 발생했습니다.");
        }
        return "board/list";
    }

    // 조회수 증가 Ajax (detail.jsp 에서 DOMContentLoaded 시 호출, 단순 숫자 반환)
    @ResponseBody
    @RequestMapping(value = "/board/updateHitAjax.do", method = RequestMethod.POST)
    public int updateHitAjax(@RequestParam Map<String, Object> param) throws Exception {
        return boardService.updateHit(param);
    }

    // 게시글 상세
    @RequestMapping(value = "/board/detail.do", method = RequestMethod.POST)
    public String boardDetail(@RequestParam Map<String, Object> param, Model model) throws Exception {
        try {
            	Map<String, Object> board = boardService.selectBoardDetail(param);
	            if (board == null) { //조회 안되면 바로 목록으로 보내기
	                param.put("bridgeUrl", "board/list.do");
	                model.addAttribute("param", param);
	                return "bridge";
	            }
	            // 파일목록 가져오기 나중에 ajax 처리 고려
	            List<Map<String, Object>> fileList = boardService.selectBoardFileList(param);

	            // 같은 ref 그룹 내 답글 수 조회 (답글 5개 제한 체크용)
	            int replyCount = boardService.countChildReply(board);

	            // 답글인 경우 부모글 제목 조회 (detail.jsp 상단 원글 표시용)
	            // parentNo 가 null 이면 원글이미로 조회 생뷽
	            Object parentNo = board.get("parentNo");
	            if (parentNo != null) {
	                Map<String, Object> parentParam = new HashMap<>();
	                parentParam.put("boardNo", parentNo);
	                Map<String, Object> parentBoard = boardService.selectBoardDetail(parentParam);
	                if (parentBoard != null) {
	                    model.addAttribute("parentBoard", parentBoard);
	                }
	            }

	            // 비밀번호 오류 경우 별도 model 에 세팅 (detail.jsp 에서 조회수 증가 방지용)
	            if ("1".equals(param.get("pwError"))) {
	                model.addAttribute("pwError", "1");
	            }

	            model.addAttribute("board",      board);
	            model.addAttribute("fileList",   fileList);
	            model.addAttribute("replyCount", replyCount);
	            model.addAttribute("param",      param);

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("err", "상세 조회 중 오류가 발생했습니다.");
        }
        return "board/detail";
    }

    // 게시글 작성 폼
    @RequestMapping(value = "/board/write.do", method = RequestMethod.POST)
    public String writeView(@RequestParam Map<String, Object> param, Model model) {
        model.addAttribute("param", param);
        return "board/write";
    }

    // 게시글 등록 처리
    @RequestMapping(value = "/board/writeProc.do", method = RequestMethod.POST)
    public String writeProc(@RequestParam Map<String, Object> param,
                            HttpSession session, Model model,
                            HttpServletRequest request) throws Exception {
        try {
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            param.put("userNo", loginUser.get("userNo"));
            param.put("ref",   0);
            param.put("reLev", 0);
            param.put("reSeq", 0);

            boardService.insertBoard(param); // useGeneratedKeys 로 boardNo 가 param 에 자동 세팅됨
            saveFiles(request, param.get("boardNo"));

        } catch (Exception e) {
            e.printStackTrace();
        }
        // 목록 1페이지로 이동 (검색 조건 유지)
        param.put("currentPageNo", "1");
        param.put("bridgeUrl", "board/list.do");
        model.addAttribute("param", param);
        return "bridge";
    }

    // 게시글 수정 폼 (비밀번호 확인 포함)
    @RequestMapping(value = "/board/edit.do", method = RequestMethod.POST)
    public String editView(@RequestParam Map<String, Object> param, Model model) throws Exception {
        Map<String, Object> board = boardService.selectBoardDetail(param);
        if (board == null) {
            param.put("bridgeUrl", "board/list.do");
            model.addAttribute("param", param);
            return "bridge";
        }
        String writerPw = (String) param.get("writerPw");
        if (!board.get("writerPw").equals(writerPw)) {
            // 비밀번호 불일치: 상세 페이지로 돌아가면서 오류 표시
            // replyCount 를 함께 담아야 detail.jsp 의 답변 버튼 표시 조건이 정상 동작한다.
            // 누락 시 ${replyCount} 가 null → JSTL 비교에서 0 으로 평가 → 5개 도달해도 버튼이 다시 나타남
            model.addAttribute("pwError",    "1");
            model.addAttribute("board",      board);
            model.addAttribute("fileList",   boardService.selectBoardFileList(param));
            model.addAttribute("replyCount", boardService.countChildReply(board));
            // 답글인 경우 부모글 제목 조회 (parentBoard 누뽕 시 detail.jsp 원글 표시 안 됨)
            Object parentNo2 = board.get("parentNo");
            if (parentNo2 != null) {
                Map<String, Object> parentParam2 = new HashMap<>();
                parentParam2.put("boardNo", parentNo2);
                Map<String, Object> parentBoard2 = boardService.selectBoardDetail(parentParam2);
                if (parentBoard2 != null) {
                    model.addAttribute("parentBoard", parentBoard2);
                }
            }
            model.addAttribute("param",      param);
            return "board/detail";
        }
        model.addAttribute("board",    board);
        model.addAttribute("fileList", boardService.selectBoardFileList(param));
        model.addAttribute("param",    param);
        return "board/edit";
    }

    // 게시글 수정 처리
    @RequestMapping(value = "/board/editProc.do", method = RequestMethod.POST)
    public String editProc(@RequestParam Map<String, Object> param, Model model,
                           HttpServletRequest request) throws Exception {
        boardService.updateBoard(param);
        saveFiles(request, param.get("boardNo"));

        param.put("bridgeUrl", "board/detail.do");
        model.addAttribute("param", param);
        return "bridge";
    }

    // 게시글 삭제 처리
    @RequestMapping(value = "/board/delete.do", method = RequestMethod.POST)
    public String delete(@RequestParam Map<String, Object> param, Model model,
                         HttpServletRequest request) throws Exception {
        Map<String, Object> board = boardService.selectBoardDetail(param);
        if (board == null) {
            param.put("bridgeUrl", "board/list.do");
            model.addAttribute("param", param);
            return "bridge";
        }
        if (!board.get("writerPw").equals(param.get("writerPw"))) {
            // 비밀번호 불일치: 상세 페이지로 돌아가면서 오류 표시
            param.put("pwError",   "1");
            param.put("bridgeUrl", "board/detail.do");
            model.addAttribute("param", param);
            return "bridge";
        }

        // 계층 삭제: 서비스가 param 에 "_deleteFileList" 세팅 후 DB 삭제
        boardService.deleteBoard(param);

        // DB 삭제 후 물리 파일 삭제
        List<Map<String, Object>> fileList = (List<Map<String, Object>>) param.get("_deleteFileList");
        if (fileList != null) {
            for (Map<String, Object> file : fileList) {
                deletePhysicalFile(request, (String) file.get("filePath"));
            }
        }

        param.put("bridgeUrl", "board/list.do");
        model.addAttribute("param", param);
        return "bridge";
    }

    // 답변 폼
    @RequestMapping(value = "/board/reply.do", method = RequestMethod.POST)
    public String replyView(@RequestParam Map<String, Object> param, Model model) throws Exception {
        Map<String, Object> board = boardService.selectBoardDetail(param);

        // 같은 ref 그룹 내 답글 수 조회 (답글 5개 제한 체크용)
        int replyCount = boardService.countChildReply(board);

        // 이미 답글이 5개 이상이면 상세 페이지로 돌려보냄 (서버 이중 방어)
        if (replyCount >= 5) {
            param.put("bridgeUrl", "board/detail.do");
            model.addAttribute("param", param);
            return "bridge";
        }

        model.addAttribute("board", board);
        model.addAttribute("param", param);
        return "board/reply";
    }

    // 답변 등록 처리
    @RequestMapping(value = "/board/replyProc.do", method = RequestMethod.POST)
    public String replyProc(@RequestParam Map<String, Object> param,
                            HttpSession session, Model model,
                            HttpServletRequest request) throws Exception {

        // 답글 등록 직전 재확인: reply.jsp form 에서 parentNo 로 넘어온 부모글 boardNo 기준 직접 자식 수 커운트
        java.util.Map<String, Object> replyCheckParam = new java.util.HashMap<>();
        replyCheckParam.put("boardNo", param.get("parentNo"));
        int replyCount = boardService.countChildReply(replyCheckParam);
        if (replyCount >= 5) {
            param.put("bridgeUrl", "board/detail.do");
            model.addAttribute("param", param);
            return "bridge";
        }

        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        param.put("userNo", loginUser.get("userNo"));

        boardService.insertReply(param); // useGeneratedKeys 로 boardNo 가 param 에 자동 세팅됨
        saveFiles(request, param.get("boardNo"));

        param.put("bridgeUrl", "board/list.do");
        model.addAttribute("param", param);
        return "bridge";
    }

    // 첨부파일 다운로드 (POST)
    @RequestMapping(value = "/board/download.do", method = RequestMethod.POST)
    public void download(@RequestParam Map<String, Object> param,
                         HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, Object> file = boardService.selectBoardFileDetail(param);
        if (file == null) return;

        File f = new File(uploadPath(request), (String) file.get("filePath"));
        if (!f.exists()) return;

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + URLEncoder.encode((String) file.get("fileName"), "UTF-8") + "\"");
        response.setContentLengthLong(f.length());
        Files.copy(f.toPath(), response.getOutputStream());
        response.getOutputStream().flush();
    }

    // 첨부파일 단건 삭제 (Ajax GET, JSON 반환)
    @ResponseBody
    @RequestMapping(value = "/board/deleteFile.do", method = RequestMethod.GET)
    public Map<String, Object> deleteFile(@RequestParam Map<String, Object> param,
                                          HttpServletRequest request) throws Exception {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> file = boardService.selectBoardFileDetail(param);
            if (file == null) {
                result.put("msg", "notFound");
                return result;
            }
            deletePhysicalFile(request, (String) file.get("filePath"));
            boardService.deleteBoardFile(param);

            // 삭제 후 남은 파일 목록 반환 (edit.jsp 에서 화면 갱신에 사용)
            Map<String, Object> listParam = new HashMap<>();
            listParam.put("boardNo", file.get("boardNo"));
            result.put("msg",      "success");
            result.put("fileList", boardService.selectBoardFileList(listParam));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("msg", "error");
        }
        return result;
    }
}

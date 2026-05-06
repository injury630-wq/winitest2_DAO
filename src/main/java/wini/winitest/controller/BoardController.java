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
import wini.winitest.common.MenuUtil;
import wini.winitest.service.BoardService;
import wini.winitest.service.MenuService;

@Controller
public class BoardController {

    @Resource(name = "boardDAOService")
    private BoardService boardService;

    @Resource(name = "menuService")
    private MenuService menuService;
    
    private static final String path = "C:/upload/board/";
 // 업로드 디렉터리 경로 반환 (없으면 자동 생성)
    private String uploadPath(HttpServletRequest request) {
        File dir = new File(path);
        if (!dir.exists()) dir.mkdirs();
        return path;
    }
    // 물리 파일 삭제 (filePath: 저장 디렉터리, fileName: UUID 기반 서버 파일명)
    private void deletePhysicalFile(String filePath, String fileName) {
        File f = new File(filePath, fileName);
        if (f.exists()) f.delete();
    }
    
    // 게시글 목록
    @RequestMapping(value = "/board/list.do", method = RequestMethod.POST)
    public String boardList(@RequestParam Map<String, Object> param, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        try {
            // 전자정부 페이징 설정
            PaginationInfo paginationInfo = new PaginationInfo();
            // null 이거나 빈 문자열("") 이면 1페이지로 처리
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
        MenuUtil.addMenu(model, menuService);
        try {
        		// 선택한 게시글 정보 조회
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
	            // parentNo 가 null 이면 원글이므로 조회 생략
	            Object parentNo = board.get("parentNo");
	            if (parentNo != null) {
	                Map<String, Object> parentParam = new HashMap<>();
	                parentParam.put("boardNo", parentNo);
	                Map<String, Object> parentBoard = boardService.selectBoardDetail(parentParam);
	                if (parentBoard != null) {
	                    model.addAttribute("parentBoard", parentBoard); // 부모글 제목 표시용
	                }
	            }

	            // 비밀번호 오류 경우 별도 model 에 세팅 (detail.jsp 에서 조회수 증가 방지용)
	            if ("1".equals(param.get("pwError"))) {
	                model.addAttribute("pwError", "1");
	            }

	            model.addAttribute("board",      board); 		//조회 게시글
	            model.addAttribute("fileList",   fileList);		//조회 게시글 파일리스트
	            model.addAttribute("replyCount", replyCount);	//조회 게시글 자식수
	            model.addAttribute("param",      param);		//boardNo, 검색조건

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("err", "상세 조회 중 오류가 발생했습니다.");
        }
        return "board/detail";
    }

    // 게시글 작성 폼 (list -> write 검색 조건 전달)
    @RequestMapping(value = "/board/write.do", method = RequestMethod.POST)
    public String writeView(@RequestParam Map<String, Object> param, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        model.addAttribute("param", param);
        return "board/write";
    }

    // 게시글 등록 처리 (검색 조건 유지) 원글 작성만 처리
    @RequestMapping(value = "/board/writeProc.do", method = RequestMethod.POST)
    public String writeProc(@RequestParam Map<String, Object> param,
                            HttpSession session, Model model,
                        HttpServletRequest request) throws Exception {
        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        param.put("userNo", loginUser.get("userNo"));
        /*원글은 무조건 000으로 설정*/
        param.put("ref",   0); //그룹
        param.put("reLev", 0); //그룹깊이
        param.put("reSeq", 0); //그룹순서
        param.put("mode", "write"); // 저장 모드설정
        boardService.insertBoardWithFiles(param, request); // board, file 테이블 저장 + 물리파일저장
//        boardService.insertBoard(param); // useGeneratedKeys 로 boardNo 가 param 에 자동 세팅됨
//        saveFiles(request, param.get("boardNo")); // 실제 파일 저장 DB삽입

        // 목록 1페이지로 이동 (검색 조건 유지/param에 저장)
        param.put("currentPageNo", "1");
        param.put("bridgeUrl", "board/list.do");
        model.addAttribute("param", param);
        return "bridge";
    }

    // 게시글 수정 폼 (1.원글 수정/2.답글 수정 - 게시글작성자/비밀번호 확인(수정권한) - 수정페이지) 
    @RequestMapping(value = "/board/edit.do", method = RequestMethod.POST)
    public String editView(@RequestParam Map<String, Object> param, Model model, HttpSession session) throws Exception {
        MenuUtil.addMenu(model, menuService);
        try {
        	Map<String, Object> board = boardService.selectBoardDetail(param);
        	if (board == null) { //게시글 없음: 목록조회
        		param.put("bridgeUrl", "board/list.do");
        		model.addAttribute("param", param);
        		return "bridge";
        	}
        	Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser"); // 게시글 주인과 사용자 일치 비교용
        	String writerPw = (String) param.get("writerPw");
        	// 입력한 비밀번호 같음 || 로그인 정보와 게시글의 작성자 정보 같음 -> 수정폼 이동
        	if (board.get("writerPw").equals(writerPw) || board.get("userNo").equals(loginUser.get("userNo"))) {
        		model.addAttribute("board",    board);
        		model.addAttribute("fileList", boardService.selectBoardFileList(param));
        		model.addAttribute("param",    param);
        		return "board/edit";
        	}
        	// 비밀번호 불일치: 상세 페이지로 돌아가면서 오류 표시
        	// replyCount 를 함께 담아야 detail.jsp 의 답변 버튼 표시 조건이 정상 동작한다.
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
        	model.addAttribute("param", param);
        	return "board/detail";
			
		} catch (Exception e) {
			e.printStackTrace();
			return "common/error";
		}
    }

    // 게시글 수정 처리 (권한은 수정폼 올때 확인)
    @RequestMapping(value = "/board/editProc.do", method = RequestMethod.POST)
    public String editProc(@RequestParam Map<String, Object> param, Model model,
                           HttpServletRequest request) throws Exception {
    	param.put("mode", "edit");
    	boardService.insertBoardWithFiles(param, request);
//        boardService.updateBoard(param);
//        saveFiles(request, param.get("boardNo"));

        param.put("bridgeUrl", "board/detail.do");
        model.addAttribute("param", param);
        return "bridge";
    }

/*	게시글 삭제 처리 (본인 글 -> 삭제 /타인 글 -> 입력 비밀번호 비교)
	계층 삭제(parent_no) 자신 - 자식 - 자손 일괄삭제*/
    @RequestMapping(value = "/board/delete.do", method = RequestMethod.POST)
    public String delete(@RequestParam Map<String, Object> param, Model model,
                         HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser"); // 게시글 주인과 사용자 일치 비교용
        
        Map<String, Object> board = boardService.selectBoardDetail(param);
        // 게시글 없으면 목록 이동
        if (board == null) {
        	param.put("bridgeUrl", "board/list.do");
        	model.addAttribute("param", param);
        	return "bridge";
        }
        
        boolean isOwner = false; // 게시글 삭제 권한
        
        // 1. 로그인 사용자
        if(loginUser != null) {
        	isOwner = board.get("userNo").equals(loginUser.get("userNo")); // 작성자 = 로그인/권한 업데이트
        }
        
        // 2. 게시글 비밀번호(로그인사용자 불일치)
        if(!isOwner) {
        	isOwner = board.get("writerPw").equals(param.get("writerPw")); // 입력 비밀번호 <> 게시글 비밀번호
        }
        
        // 3. 삭제(권한 있으면 삭제)
        if(isOwner) {
        	// 계층 삭제: 서비스가 param 에 "_deleteFileList" 세팅 후 DB 삭제
        	boardService.deleteBoard(param);
        	
        	// DB 삭제 후 물리 파일 삭제
        	List<Map<String, Object>> fileList = (List<Map<String, Object>>) param.get("deleteFileList");
        	if (fileList != null) {
        		for (Map<String, Object> file : fileList) {
        			deletePhysicalFile((String) file.get("filePath"), (String) file.get("fileName"));
        		}
        	}
        	
        	param.put("bridgeUrl", "board/list.do");
        	model.addAttribute("param", param);
        	return "bridge";
        }else {
        	// 비밀번호 불일치: 상세 페이지로 돌아가면서 오류 표시
        	param.put("pwError",   "1");
        	param.put("bridgeUrl", "board/detail.do");
        	model.addAttribute("param", param);
        	return "bridge";
        }
        
    }

    // 답변 폼
    @RequestMapping(value = "/board/reply.do", method = RequestMethod.POST)
    public String replyView(@RequestParam Map<String, Object> param, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        Map<String, Object> board = boardService.selectBoardDetail(param);

        // 같은 ref 그룹 내 답글 수 조회 (답글 5개 제한 체크용)
        int replyCount = boardService.countChildReply(board);

        // 이미 답글이 5개 이상이면 상세 페이지로 돌려보냄 
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

        // 답글 등록 직전 재확인: reply.jsp form 에서 parentNo 로 넘어온 부모글 boardNo 기준 직자식 수 커운트
        Map<String, Object> replyCheckParam = new HashMap<>();
        replyCheckParam.put("boardNo", param.get("parentNo"));
        int replyCount = boardService.countChildReply(replyCheckParam);
        if (replyCount >= 5) {
            param.put("bridgeUrl", "board/detail.do");
            model.addAttribute("param", param);
            return "bridge";
        }

        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        param.put("userNo", loginUser.get("userNo"));
        
        param.put("mode", "reply");
        boardService.insertBoardWithFiles(param, request);

//        boardService.insertReply(param); // useGeneratedKeys 로 boardNo 가 param 에 자동 세팅됨
//        saveFiles(request, param.get("boardNo"));

        param.put("bridgeUrl", "board/list.do");
        model.addAttribute("param", param);
        return "bridge";
    }

    // 첨부파일 다운로드 (POST)
    @RequestMapping(value = "/board/download.do", method = RequestMethod.POST)
    public void download(@RequestParam Map<String, Object> param,
                         HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, Object> file = boardService.selectBoardFileDetail(param); // {fileNo : ?}
        if (file == null) return; // DB에 파일 정보 없을때

        File f = new File((String) file.get("filePath"), (String) file.get("fileName"));
        if (!f.exists()) return;

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + URLEncoder.encode((String) file.get("orgName"), "UTF-8") + "\"");
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
            deletePhysicalFile((String) file.get("filePath"), (String) file.get("fileName"));
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

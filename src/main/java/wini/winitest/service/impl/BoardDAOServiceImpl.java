package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import wini.winitest.service.BoardService;

/**
 * 게시판 서비스 구현체
 * - EgovAbstractServiceImpl 상속
 * - BoardDAO를 통한 DB 접근 (Map 기반)
 */
@Service("boardDAOService")
public class BoardDAOServiceImpl extends EgovAbstractServiceImpl implements BoardService {

    @Resource(name = "boardDAO")
    private BoardDAO boardDAO;
    
    private static final String path = "C:/upload/board/";

    // 업로드 디렉터리 경로 반환 (없으면 자동 생성)
    private String uploadPath(HttpServletRequest request) {
        File dir = new File(path);
        if (!dir.exists()) dir.mkdirs();
        return path;
    }

    // 첨부파일 저장 후 file_master 테이블에 등록
    private void saveFiles(HttpServletRequest request, Object boardNo) throws Exception {
        if (!(request instanceof MultipartHttpServletRequest)) return;
        MultipartHttpServletRequest mr = (MultipartHttpServletRequest) request;
        List<MultipartFile> files = mr.getFiles("uploadFile");
        String uploadDir = uploadPath(request);

        Object regUser = null;
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session != null) {
            java.util.Map<?, ?> loginUser = (java.util.Map<?, ?>) session.getAttribute("loginUser");
            if (loginUser != null) regUser = loginUser.get("userNo");
        }

        int sortOrd = 0;
        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;
            String orgName = file.getOriginalFilename();
            int dotIdx = (orgName != null) ? orgName.lastIndexOf('.') : -1;
            String ext = (dotIdx >= 0) ? orgName.substring(dotIdx + 1).toLowerCase() : "";
            String fileName = UUID.randomUUID().toString() + (ext.isEmpty() ? "" : "." + ext);
            file.transferTo(new File(uploadDir, fileName));

            Map<String, Object> fp = new HashMap<>();
            fp.put("boardNo",  boardNo);
            fp.put("filePath", uploadDir); // 저장 디렉터리
            fp.put("fileName", fileName);  // 서버 저장 파일명 (UUID 기반)
            fp.put("orgName",  orgName);   // 원본 파일명 (사용자 표시용)
            fp.put("fileExt",  ext);
            fp.put("fileSize", file.getSize());
            fp.put("sortOrd",  sortOrd++);
            fp.put("regUser",  regUser);
            boardDAO.insertBoardFile(fp);
        }
    }

    // 물리 파일 삭제
    private void deletePhysicalFile(HttpServletRequest request, String filePath) {
        File f = new File(uploadPath(request), filePath);
        if (f.exists()) f.delete();
    }


    /* ===== 게시글 조회 ===== */

    @Override
    public List<Map<String, Object>> selectList(Map<String, Object> param) throws Exception {
        return boardDAO.selectList(param);
    }

    @Override
    public int selectBoardTotalCount(Map<String, Object> param) throws Exception {
        return boardDAO.selectBoardTotalCount(param);
    }

    @Override
    public Map<String, Object> selectBoardDetail(Map<String, Object> param) throws Exception {
        return boardDAO.selectBoardDetail(param);
    }

    /* ===== 게시글 처리 ===== */

    // 조회수 증가
    @Transactional
    @Override
    public int updateHit(Map<String, Object> param) throws Exception {
    	boardDAO.updateHit(param);
    	Map<String, Object> board = boardDAO.selectBoardDetail(param);
        return (Integer)board.get("hit");
    }

    @Override
    public int insertBoard(Map<String, Object> param) throws Exception {
        int result = boardDAO.insertBoard(param);
        //boardDAO.insertBoardFile(param);
        // 원글 등록 후 boardNo로 ref 자기 참조 업데이트
        if (result > 0) {
            boardDAO.updateRef(param);
        }
        return result;
    }

    @Override
    public int updateBoard(Map<String, Object> param) throws Exception {
        return boardDAO.updateBoard(param);
    }

    /**
     * 계층 삭제 (parent_no 기반)
     * - 자신 - 자식(lev1) - 손자(lev2) 2단계 조회 후 일괄 삭제
     * - 파일 삭제 - 게시글 삭제 순서로 처리
     */
    @Transactional
    @Override
    public int deleteBoard(Map<String, Object> param) throws Exception {
        List<Object> deleteIds = new ArrayList<>();

        // 자신
        deleteIds.add(param.get("boardNo"));

        // 자식글 (parent_no = 삭제 대상 boardNo)
        List<Map<String, Object>> children = boardDAO.selectChildBoardNos(param);
        for (Map<String, Object> child : children) {
            deleteIds.add(child.get("boardNo"));

            // 손자글 (parent_no = 자식글 boardNo)
            Map<String, Object> childParam = new HashMap<>();
            childParam.put("boardNo", child.get("boardNo"));
            List<Map<String, Object>> grandChildren = boardDAO.selectChildBoardNos(childParam);
            for (Map<String, Object> gc : grandChildren) {
                deleteIds.add(gc.get("boardNo"));
            }
        }

        Map<String, Object> deleteParam = new HashMap<>();
        deleteParam.put("ids", deleteIds);

        // DB 삭제 전 물리 파일 경로 수집 -> 컨트롤러에서 파일 시스템 삭제에 사용
        List<Map<String, Object>> fileList = boardDAO.selectFileListByIds(deleteParam);
        param.put("deleteFileList", fileList);

        boardDAO.deleteBoardFilesByBoardIds(deleteParam);
        boardDAO.deleteBoardByIds(deleteParam);
        return deleteIds.size();
    }
//    @Transactional
//    @Override
//    public int deleteBoardTest(Map<String, Object> param) throws Exception {
//    	List<Object> deleteIds = new ArrayList<>();
//    	
//    	// 자신
//    	deleteIds.add(param.get("boardNo"));
//    	
//    	// 자식글 (parent_no = 삭제 대상 boardNo)
//    	List<Map<String, Object>> children = boardDAO.selectChildBoardNos(param);
//    	for (Map<String, Object> child : children) {
//    		deleteIds.add(child.get("boardNo"));
//    		
//    		// 손자글 (parent_no = 자식글 boardNo)
//    		Map<String, Object> childParam = new HashMap<>();
//    		childParam.put("boardNo", child.get("boardNo"));
//    		List<Map<String, Object>> grandChildren = boardDAO.selectChildBoardNos(childParam);
//    		for (Map<String, Object> gc : grandChildren) {
//    			deleteIds.add(gc.get("boardNo"));
//    		}
//    	}
//    	
//    	Map<String, Object> deleteParam = new HashMap<>();
//    	deleteParam.put("ids", deleteIds);
//    	
//    	// DB 삭제 전 물리 파일 경로 수집 -> 컨트롤러에서 파일 시스템 삭제에 사용
//    	List<Map<String, Object>> fileList = boardDAO.selectFileListByIds(deleteParam);
//    	param.put("_deleteFileList", fileList);
//    	
//    	boardDAO.deleteBoardFilesByBoardIds(deleteParam);
//    	boardDAO.deleteBoardByIds(deleteParam);
//    	return deleteIds.size();
//    }

    // 특정 글(boardNo)의 직접 자식 수 조회
    @Override
    public int countChildReply(Map<String, Object> param) throws Exception {
        return boardDAO.countChildReply(param);
    }

    /**
     * 답변글 등록
     * - 같은 ref 내 부모 re_seq 초과 항목들 +1 밀기
     * - 새 답변글: reLev = 부모+1, reSeq = 부모+1, ref = 부모와 동일
     */
    @Transactional
    @Override
    public int insertReply(Map<String, Object> param) throws Exception {
        boardDAO.updateReSeq(param); //답변글 re_seq 밀기 (같은 ref 선택글 위치 이후 항목 +1)

        int parentReLev = Integer.parseInt(param.get("reLev").toString());
        int parentReSeq = Integer.parseInt(param.get("reSeq").toString());
        // 깊이와 순서 증가(선택글의 답변으로 들어가므로 깊이 +1, 순서 +1)
        param.put("reLev", parentReLev + 1);
        param.put("reSeq", parentReSeq + 1);

        // HTTP 파라미터로 온 parentNo(String)를 Integer로 명시 변환
        Object parentNoObj = param.get("parentNo");
        if (parentNoObj != null && !parentNoObj.toString().isEmpty()) {
            param.put("parentNo", Integer.parseInt(parentNoObj.toString()));
        }

        return boardDAO.insertBoard(param);
    }

    /* ===== 첨부파일 ===== */

    @Override
    public List<Map<String, Object>> selectBoardFileList(Map<String, Object> param) throws Exception {
        return boardDAO.selectBoardFileList(param);
    }

    @Override
    public Map<String, Object> selectBoardFileDetail(Map<String, Object> param) throws Exception {
        return boardDAO.selectBoardFileDetail(param);
    }

    @Override
    public int insertBoardFile(Map<String, Object> param) throws Exception {
        return boardDAO.insertBoardFile(param);
    }

    @Override
    public int deleteBoardFile(Map<String, Object> param) throws Exception {
        return boardDAO.deleteBoardFile(param);
    }
    
    // 게시글 저장 + 파일 저장
    @Transactional
    @Override
    public void insertBoardWithFiles(Map<String, Object> param,
                                      HttpServletRequest request) throws Exception {

    	String mode = (String) param.get("mode"); 
        // write / edit / reply 구분용 (선택)

        if ("write".equals(mode)) {
        	insertBoard(param);
        } 
        else if ("edit".equals(mode)) {
            updateBoard(param);
        } 
        else if ("reply".equals(mode)) {
            insertReply(param);
        }


        // 2. 파일 저장 (DB + 물리)
        saveFiles(request, param.get("boardNo"));
    }
}

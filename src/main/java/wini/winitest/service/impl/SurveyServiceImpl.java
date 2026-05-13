package wini.winitest.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.common.FileUploadUtil;
import wini.winitest.common.PagingUtil;
import wini.winitest.service.SurveyService;

/** 설문 서비스 구현체 */
@Service("surveyService")
public class SurveyServiceImpl extends EgovAbstractServiceImpl implements SurveyService {

    @Value("${survey.upload.path}")
    private String uploadPath;

    @Value("${image.allowed.extensions}")
    private String allowedExtensions;

    @Resource(name = "surveyDAO")
    private SurveyDAO surveyDAO;

    /** 설문 목록 조회 (페이징, 검색조건) + 전체 건수 */
    @Override
    public Map<String, Object> selectSurveyList(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("msg", "E");
        try {
            int recordPerPage = Integer.parseInt(String.valueOf(param.get("recordCountPerPage")));
            int pageSize  = Integer.parseInt(String.valueOf(param.get("pageSize")));
            PaginationInfo paginationInfo = PagingUtil.create(param, recordPerPage, pageSize);
            int totalCount = surveyDAO.selectSurveyTotalCount(param);
            paginationInfo.setTotalRecordCount(totalCount);
            result.put("list", surveyDAO.selectSurveyList(param));
            result.put("paginationInfo", paginationInfo);
            result.put("search", param);
            result.put("msg",  "S");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /** 설문 상세 조회 */
    @Override
    public Map<String, Object> selectSurvey(int surveyNo) throws Exception {
        return surveyDAO.selectSurvey(surveyNo);
    }

    /** 질문 유형 코드 목록 */
    @Override
    public List<Map<String, Object>> selectQuestionTypes() throws Exception {
        return surveyDAO.selectQuestionTypes();
    }

    /** 설문 문항+보기 목록 조회 (수정 폼용) */
    @Override
    public List<Map<String, Object>> selectQuestionsWithOptions(int surveyNo) throws Exception {
        List<Map<String, Object>> questions  = surveyDAO.selectQuestionsBySurveyNo(surveyNo); // 설문 질문
        List<Map<String, Object>> allOptions = surveyDAO.selectOptionsBySurveyNo(surveyNo); // 설문 보기
        for (Map<String, Object> q : questions) { // 각 질문에 맞는 보기 매핑
            int boardNo = ((Number) q.get("boardNo")).intValue();
            List<Map<String, Object>> opts = new ArrayList<>(); //보기 배열
            for (Map<String, Object> opt : allOptions) {
                if (((Number) opt.get("qNo")).intValue() == boardNo) {
                    opts.add(opt);
                }
            }
            q.put("options", opts);
        }
        return questions;
    }

    /** 설문 등록 */
    @Override
    @Transactional
    public Map<String, Object> insertSurvey(Map<String, Object> param) throws Exception {
        surveyDAO.insertSurvey(param);
        int surveyNo = ((Number) param.get("surveyNo")).intValue();

        List<Map<String, Object>> questions = (List<Map<String, Object>>) param.get("questions");
        if (questions != null) {
            for (Map<String, Object> q : questions) {
                q.put("surveyNo", surveyNo);
                q.put("regUser",  param.get("regUser"));
                surveyDAO.insertQuestion(q);
                int boardNo = ((Number) q.get("boardNo")).intValue();
                activateImage(q, boardNo);
                insertOptions(q, boardNo);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("msg",      "S");
        return result;
    }

    /**
     * 설문 수정
     * [설문] 단순 UPDATE
     * [질문] DB 비교 후 처리
     * [보기] 전체 논리삭제 후 재INSERT
     */
    @Override
    @Transactional
    public Map<String, Object> updateSurvey(Map<String, Object> param) throws Exception {

        // JSON으로 넘어온 surveyNo는 String 타입 -> int로 변환 후 다시 param에 넣어 MyBatis #{surveyNo} 바인딩에 사용
        int surveyNo = Integer.parseInt(String.valueOf(param.get("surveyNo")));
        param.put("surveyNo", surveyNo);

        // [설문] 단순 UPDATE
        surveyDAO.updateSurvey(param);

        List<Map<String, Object>> questions = (List<Map<String, Object>>) param.get("questions");

        // [질문 1단계] 제출된 질문의 boardNo를 HashSet에 모음 (DB와 비교용)
        // boardNo=0인 신규 질문은 아직 DB에 없으므로 제외
        Set<Integer> submittedBoardNos = new HashSet<>();
        if (questions != null) {
            for (Map<String, Object> q : questions) {
                Object bnObj = q.get("boardNo");
                int bn = (bnObj != null) ? Integer.parseInt(String.valueOf(bnObj)) : 0;
                if (bn > 0) {
                    submittedBoardNos.add(bn);
                }
            }
        }

        // [질문 2단계] DB 질문 목록과 비교해서 제출 목록에 없는 질문을 논리삭제
        // 예) DB: [10, 11, 12] / 제출: [10, 12] -> 11번이 화면에서 삭제된 것 -> 논리삭제
        // 1.보기 삭제  2.질문 삭제 (논리삭제)
        List<Map<String, Object>> dbQuestions = surveyDAO.selectQuestionsBySurveyNo(surveyNo);
        for (Map<String, Object> dbQ : dbQuestions) {
            int boardNo = Integer.parseInt(String.valueOf(dbQ.get("boardNo")));
            if (!submittedBoardNos.contains(boardNo)) {
                surveyDAO.deleteOptionsByQuestionNo(boardNo);
                surveyDAO.deleteQuestion(boardNo);
            }
        }

        // [질문 3단계] 제출된 질문 순회 - boardNo=0이면 신규 INSERT, 양수면 기존 UPDATE
        if (questions != null) {
            for (Map<String, Object> q : questions) {
                q.put("surveyNo", surveyNo);
                q.put("regUser",  param.get("regUser"));

                Object boardNoObj = q.get("boardNo");
                int boardNo = (boardNoObj != null) ? Integer.parseInt(String.valueOf(boardNoObj)) : 0;

                if (boardNo == 0) {
                    // 신규 질문: INSERT 후 시퀀스  boardNo를 q에 저장
                    surveyDAO.insertQuestion(q);
                    boardNo = Integer.parseInt(String.valueOf(q.get("boardNo")));
                } else {
                    // 기존 질문: 내용만 UPDATE (boardNo 유지 -> 이미지 연결 유지)
                    surveyDAO.updateQuestion(q);
                }

                // boardNo 확정 후 이미지 처리 (신규 질문은 INSERT 완료 후에 boardNo가 생기므로 여기서 처리)
                activateImage(q, boardNo);

                // [보기] 기존 보기 전체 논리삭제 후 제출된 보기 전체 재INSERT
                surveyDAO.deleteOptionsByQuestionNo(boardNo);
                insertOptions(q, boardNo);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("msg",      "S");
        return result;
    }

    /** 질문 이미지 처리 - 기존 이미지 비활성화 후 새 이미지 활성화 */
    private void activateImage(Map<String, Object> q, int boardNo) throws Exception {
        /* 기존에 연결된 이미지를 먼저 비활성화 - 이미지 삭제/교체 시 이전 파일이 남지 않도록 */
        surveyDAO.deactivateImageByQuestion(boardNo);

        Object imgFileNoObj = q.get("imageFileNo");
        if (imgFileNoObj == null) {
            return; // imageFileNo 키 자체가 없으면 종료
        }
        int imageFileNo = Integer.parseInt(String.valueOf(imgFileNoObj));
        if (imageFileNo <= 0) {
            return; // 0이면 이미지 없음 (삭제된 경우 포함)
        }

        /* 임시 저장(use_yn='N') 상태의 이미지를 이 질문과 연결하면서 활성화(use_yn='Y') */
        Map<String, Object> imgParam = new HashMap<>();
        imgParam.put("fileNo",  imageFileNo);
        imgParam.put("boardNo", boardNo);
        surveyDAO.activateSurveyImage(imgParam);
    }

    /** 보기 전체 INSERT (기존 보기 전체 삭제 => insert) */
    private void insertOptions(Map<String, Object> q, int boardNo) throws Exception {
        List<Map<String, Object>> options = (List<Map<String, Object>>) q.get("options");
        if (options == null) return;
        for (Map<String, Object> opt : options) {
            opt.put("qNo", boardNo);
            surveyDAO.insertOption(opt);
        }
    }

    /** 사용자용 설문 목록 */
    @Override
    public Map<String, Object> getSurveyListForUser(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("msg", "E");
        try {
            int recordPerPage = Integer.parseInt(String.valueOf(param.get("recordCountPerPage")));
            int pageSize      = Integer.parseInt(String.valueOf(param.get("pageSize")));
            PaginationInfo paginationInfo = PagingUtil.create(param, recordPerPage, pageSize);
            int totalCount = surveyDAO.selectSurveyTotalCountForUser(param);
            paginationInfo.setTotalRecordCount(totalCount);
            result.put("list",   surveyDAO.selectSurveyListForUser(param));
            result.put("paginationInfo", paginationInfo);
            result.put("search",   param);
            result.put("msg",   "S");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /** 중복 응답 여부 확인 — 컨트롤러에서 saveResponse 호출 전에 먼저 확인 */
    @Override
    public int selectResponseCount(Map<String, Object> param) throws Exception {
        return surveyDAO.selectResponseCount(param);
    }

    /**
     * 응답 ㄴ저장
     */
    @Override
    @Transactional
    public Map<String, Object> saveResponse(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();

        surveyDAO.insertResponse(param); // 응답 헤더 저장
        int resNo = ((Number) param.get("resNo")).intValue();

        List<Map<String, Object>> answers = (List<Map<String, Object>>) param.get("answers");
        if (answers != null) {
            for (Map<String, Object> answer : answers) {
                String type   = (String) answer.get("type");
                int boardNo   = ((Number) answer.get("boardNo")).intValue();
                if ("checkbox".equals(type)) {
                    List<Object> optionNos = (List<Object>) answer.get("optionNos");
                    if (optionNos != null) {
                        for (Object optNo : optionNos) {
                            Map<String, Object> detail = new HashMap<>();
                            detail.put("resNo", resNo);
                            detail.put("qNo", boardNo);
                            detail.put("optionNo", ((Number) optNo).intValue());
                            detail.put("answerContent", null);
                            detail.put("regUser", param.get("regUser"));
                            surveyDAO.insertResponseDetail(detail);
                        }
                    }
                } else if ("radio".equals(type) || "select".equals(type)) {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("resNo",         resNo);
                    detail.put("qNo",           boardNo);
                    detail.put("optionNo",      ((Number) answer.get("optionNo")).intValue());
                    detail.put("answerContent", null);
                    detail.put("regUser", param.get("regUser"));
                    surveyDAO.insertResponseDetail(detail);
                } else {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("resNo",         resNo);
                    detail.put("qNo",           boardNo);
                    detail.put("optionNo",      null);
                    detail.put("answerContent", answer.get("content"));
                    detail.put("regUser", param.get("regUser"));
                    surveyDAO.insertResponseDetail(detail);
                }
            }
        }

        result.put("msg", "S");
        return result;
    }

    /** 통계 조회 */
    @Override
    public Map<String, Object> getSurveyStat(int surveyNo) throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("msg", "E");
        try {
            List<Map<String, Object>> questions = surveyDAO.selectQuestionsBySurveyNo(surveyNo); // 설문의 질문 전체
            List<Map<String, Object>> allOptions = surveyDAO.selectOptionsBySurveyNo(surveyNo); // 설문의 객관식 보기 전체
            List<Map<String, Object>> choiceStats = surveyDAO.selectStatChoice(surveyNo); //객관식 보기별 응답과 응답건수
            List<Map<String, Object>> textAnswers = surveyDAO.selectStatText(surveyNo); // 설문의 서술형 답변 전체
            List<Map<String, Object>> textCounts  = surveyDAO.selectStatTextCount(surveyNo); // 설문의 서술형 응답 전체 건수

            for (Map<String, Object> q : questions) {
                int boardNo = ((Number) q.get("boardNo")).intValue();

                List<Map<String, Object>> opts = new ArrayList<>();
                for (Map<String, Object> opt : allOptions) { // 전체 보기 순회: 현재 질문 번호 같을때 추가
                    if (((Number) opt.get("qNo")).intValue() == boardNo) opts.add(opt);
                }
                q.put("options", opts);

                List<Map<String, Object>> stats = new ArrayList<>();
                for (Map<String, Object> stat : choiceStats) {
                    if (((Number) stat.get("boardNo")).intValue() == boardNo) stats.add(stat);
                }
                q.put("stats", stats);

                List<Map<String, Object>> ansList = new ArrayList<>();
                for (Map<String, Object> ans : textAnswers) {
                    if (((Number) ans.get("boardNo")).intValue() == boardNo) ansList.add(ans);
                }
                q.put("answers", ansList);

                int answerCount = 0;
                for (Map<String, Object> tc : textCounts) {
                    if (((Number) tc.get("boardNo")).intValue() == boardNo) {
                        answerCount = ((Number) tc.get("answerCount")).intValue();
                        break;
                    }
                }
                q.put("answerCount", answerCount);
            }

            result.put("survey",     surveyDAO.selectSurvey(surveyNo));
            result.put("questions",  questions);
            result.put("totalCount", surveyDAO.selectTotalResponseCount(surveyNo));
            result.put("msg", "S");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /** 응답자 목록 조회 */
    @Override
    public List<Map<String, Object>> selectRespondentList(int surveyNo) throws Exception {
        return surveyDAO.selectRespondentList(surveyNo);
    }

    /** 응답자별 답변 상세 조회 */
    @Override
    public List<Map<String, Object>> selectRespondentDetail(int surveyNo, int userNo) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("surveyNo", surveyNo);
        param.put("userNo",   userNo);
        return surveyDAO.selectRespondentDetail(param);
    }

    /** 질문 첨부 이미지 임시 업로드 */
    @Override
    public Map<String, Object> saveTempImage(MultipartFile file, Object regUser) throws Exception {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> saved = FileUploadUtil.saveImages(Arrays.asList(file), uploadPath, allowedExtensions);
        if (saved.isEmpty()) {
            result.put("msg",  "F");
            result.put("desc", "허용되지 않는 파일 형식입니다.");
            return result;
        }
        Map<String, Object> fileInfo = saved.get(0);
        fileInfo.put("regUser", regUser);
        surveyDAO.insertSurveyTempImage(fileInfo);
        result.put("msg","S");
        result.put("fileNo", fileInfo.get("fileNo"));
        return result;
    }

    /** 질문 첨부 이미지 조회 (이미지 서빙용) */
    @Override
    public Map<String, Object> getImageByFileNo(int fileNo) throws Exception {
        return surveyDAO.selectSurveyImageByFileNo(fileNo);
    }

    /**
     * 설문 논리삭제
     */
    @Override
    @Transactional
    public Map<String, Object> deleteSurvey(int surveyNo) throws Exception {
        Map<String, Object> result = new HashMap<>();
        surveyDAO.deleteSurvey(surveyNo);
        result.put("msg", "S");
        return result;
    }
}

package wini.winitest.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.common.PagingUtil;
import wini.winitest.service.SurveyService;

/** 설문 서비스 구현체 */
@Service("surveyService")
public class SurveyServiceImpl extends EgovAbstractServiceImpl implements SurveyService {

    @Resource(name = "surveyDAO")
    private SurveyDAO surveyDAO;

    /** 설문 목록 조회 (페이징, 검색조건) + 전체 건수 */
    @Override
    public Map<String, Object> getSurveyList(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("msg", "E");
        try {
            int recordPerPage = Integer.parseInt(String.valueOf(param.getOrDefault("recordCountPerPage", 10)));
            int pageSize      = Integer.parseInt(String.valueOf(param.getOrDefault("pageSize", 10)));
            PaginationInfo paginationInfo = PagingUtil.create(param, recordPerPage, pageSize);
            int totalCount = surveyDAO.selectSurveyTotalCount(param);
            paginationInfo.setTotalRecordCount(totalCount);
            result.put("list",           surveyDAO.selectSurveyList(param));
            result.put("paginationInfo", paginationInfo);
            result.put("search",         param);
            result.put("msg",            "S");
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
        List<Map<String, Object>> questions  = surveyDAO.selectQuestionsBySurveyNo(surveyNo);
        List<Map<String, Object>> allOptions = surveyDAO.selectOptionsBySurveyNo(surveyNo);
        for (Map<String, Object> q : questions) {
            int boardNo = ((Number) q.get("boardNo")).intValue();
            List<Map<String, Object>> opts = new java.util.ArrayList<>();
            for (Map<String, Object> opt : allOptions) {
                if (((Number) opt.get("qNo")).intValue() == boardNo) {
                    opts.add(opt);
                }
            }
            q.put("options", opts);
        }
        return questions;
    }

    /**
     * 설문 저장 (등록/수정 통합)
     */
    @Override
    @Transactional
    public Map<String, Object> saveSurvey(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();

        String surveyNoStr = (String) param.get("surveyNo");
        boolean isNew = (surveyNoStr == null || surveyNoStr.isEmpty() || "null".equals(surveyNoStr));

        if (isNew) {
            surveyDAO.insertSurvey(param);
        } else {
            param.put("surveyNo", Integer.parseInt(surveyNoStr));
            surveyDAO.updateSurvey(param);
        }
        int surveyNo = ((Number) param.get("surveyNo")).intValue();

        /* 삭제 요청된 보기/문항 처리 */
        List<Object> deletedOptionNos   = (List<Object>) param.get("deletedOptionNos");
        List<Object> deletedQuestionNos = (List<Object>) param.get("deletedQuestionNos");
        if (deletedOptionNos != null) {
            for (Object o : deletedOptionNos) {
                surveyDAO.deleteOption(((Number) o).intValue());
            }
        }
        if (deletedQuestionNos != null) {
            for (Object o : deletedQuestionNos) {
                int boardNo = ((Number) o).intValue();
                surveyDAO.deleteOptionsByQuestionNo(boardNo);
                surveyDAO.deleteQuestion(boardNo);
            }
        }

        /* 문항 저장 */
        List<Map<String, Object>> questions = (List<Map<String, Object>>) param.get("questions");
        if (questions != null) {
            for (Map<String, Object> q : questions) {
                q.put("surveyNo", surveyNo);
                q.put("regUser",  param.get("regUser"));
                int boardNo = ((Number) q.getOrDefault("boardNo", 0)).intValue();
                if (boardNo == 0) {
                    surveyDAO.insertQuestion(q);
                    boardNo = ((Number) q.get("boardNo")).intValue();
                } else {
                    surveyDAO.updateQuestion(q);
                }

                /* 보기 저장 */
                List<Map<String, Object>> options = (List<Map<String, Object>>) q.get("options");
                if (options != null) {
                    for (Map<String, Object> opt : options) {
                        opt.put("qNo", boardNo);
                        int optionNo = ((Number) opt.getOrDefault("optionNo", 0)).intValue();
                        if (optionNo == 0) {
                            surveyDAO.insertOption(opt);
                        } else {
                            surveyDAO.updateOption(opt);
                        }
                    }
                }
            }
        }

        result.put("msg",      "S");
        result.put("surveyNo", surveyNo);
        return result;
    }

    /** 사용자용 설문 목록 */
    @Override
    public Map<String, Object> getSurveyListForUser(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("msg", "E");
        try {
            int recordPerPage = Integer.parseInt(String.valueOf(param.getOrDefault("recordCountPerPage", 10)));
            int pageSize      = Integer.parseInt(String.valueOf(param.getOrDefault("pageSize", 10)));
            PaginationInfo paginationInfo = PagingUtil.create(param, recordPerPage, pageSize);
            int totalCount = surveyDAO.selectSurveyTotalCountForUser(param);
            paginationInfo.setTotalRecordCount(totalCount);
            result.put("list",           surveyDAO.selectSurveyListForUser(param));
            result.put("paginationInfo", paginationInfo);
            result.put("search",         param);
            result.put("msg",            "S");
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
     * 응답 저장
     */
    @Override
    @Transactional
    public Map<String, Object> saveResponse(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<>();

        surveyDAO.insertResponse(param);
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
                            detail.put("resNo",         resNo);
                            detail.put("qNo",           boardNo);
                            detail.put("optionNo",      ((Number) optNo).intValue());
                            detail.put("answerContent", null);
                            surveyDAO.insertResponseDetail(detail);
                        }
                    }
                } else if ("radio".equals(type) || "select".equals(type)) {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("resNo",         resNo);
                    detail.put("qNo",           boardNo);
                    detail.put("optionNo",      ((Number) answer.get("optionNo")).intValue());
                    detail.put("answerContent", null);
                    surveyDAO.insertResponseDetail(detail);
                } else {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("resNo",         resNo);
                    detail.put("qNo",           boardNo);
                    detail.put("optionNo",      null);
                    detail.put("answerContent", answer.get("content"));
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
            List<Map<String, Object>> questions      = surveyDAO.selectQuestionsBySurveyNo(surveyNo);
            List<Map<String, Object>> allOptions     = surveyDAO.selectOptionsBySurveyNo(surveyNo);
            List<Map<String, Object>> choiceStats    = surveyDAO.selectStatChoice(surveyNo);
            List<Map<String, Object>> textAnswers    = surveyDAO.selectStatText(surveyNo);
            List<Map<String, Object>> textCounts     = surveyDAO.selectStatTextCount(surveyNo);

            for (Map<String, Object> q : questions) {
                int boardNo = ((Number) q.get("boardNo")).intValue();

                List<Map<String, Object>> opts = new java.util.ArrayList<>();
                for (Map<String, Object> opt : allOptions) {
                    if (((Number) opt.get("qNo")).intValue() == boardNo) opts.add(opt);
                }
                q.put("options", opts);

                List<Map<String, Object>> stats = new java.util.ArrayList<>();
                for (Map<String, Object> stat : choiceStats) {
                    if (((Number) stat.get("boardNo")).intValue() == boardNo) stats.add(stat);
                }
                q.put("stats", stats);

                List<Map<String, Object>> ansList = new java.util.ArrayList<>();
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
            result.put("msg",        "S");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
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

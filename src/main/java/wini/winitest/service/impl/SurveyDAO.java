package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/** 설문 DAO */
@Repository("surveyDAO")
public class SurveyDAO extends EgovComAbstractDAO {

    /** 설문 목록 조회 (페이징, 검색조건) */
    public List<Map<String, Object>> selectSurveyList(Map<String, Object> param) throws Exception {
        return selectList("surveyDAO.selectSurveyList", param);
    }

    /** 설문 목록 전체 건수 */
    public int selectSurveyTotalCount(Map<String, Object> param) throws Exception {
        return selectOne("surveyDAO.selectSurveyTotalCount", param);
    }

    /** 설문 상세 조회 */
    public Map<String, Object> selectSurvey(int surveyNo) throws Exception {
        return selectOne("surveyDAO.selectSurvey", surveyNo);
    }

    /** 질문 유형 코드 목록 */
    public List<Map<String, Object>> selectQuestionTypes() throws Exception {
        return selectList("surveyDAO.selectQuestionTypes");
    }

    /** 설문 등록 */
    public void insertSurvey(Map<String, Object> param) throws Exception {
        insert("surveyDAO.insertSurvey", param);
    }

    /** 설문 수정 */
    public void updateSurvey(Map<String, Object> param) throws Exception {
        update("surveyDAO.updateSurvey", param);
    }

    /** 문항 등록 (selectKey로 boardNo 채번) */
    public void insertQuestion(Map<String, Object> param) throws Exception {
        insert("surveyDAO.insertQuestion", param);
    }

    /** 문항 수정 */
    public void updateQuestion(Map<String, Object> param) throws Exception {
        update("surveyDAO.updateQuestion", param);
    }

    /** 보기 등록 */
    public void insertOption(Map<String, Object> param) throws Exception {
        insert("surveyDAO.insertOption", param);
    }

    /** 보기 수정 */
    public void updateOption(Map<String, Object> param) throws Exception {
        update("surveyDAO.updateOption", param);
    }

    /** 보기 논리삭제 (단건) */
    public void deleteOption(int optionNo) throws Exception {
        update("surveyDAO.deleteOption", optionNo);
    }

    /** 문항의 보기 전체 논리삭제 */
    public void deleteOptionsByQuestionNo(int boardNo) throws Exception {
        update("surveyDAO.deleteOptionsByQuestionNo", boardNo);
    }

    /** 문항 논리삭제 (단건) */
    public void deleteQuestion(int boardNo) throws Exception {
        update("surveyDAO.deleteQuestion", boardNo);
    }

    /** 설문 논리삭제 */
    public void deleteSurvey(int surveyNo) throws Exception {
        update("surveyDAO.deleteSurvey", surveyNo);
    }

    /** 설문의 문항 전체 조회 */
    public List<Map<String, Object>> selectQuestionsBySurveyNo(int surveyNo) throws Exception {
        return selectList("surveyDAO.selectQuestionsBySurveyNo", surveyNo);
    }

    /** 설문에 속한 보기 전체 조회 */
    public List<Map<String, Object>> selectOptionsBySurveyNo(int surveyNo) throws Exception {
        return selectList("surveyDAO.selectOptionsBySurveyNo", surveyNo);
    }

    /** 사용자용 설문 목록 */
    public List<Map<String, Object>> selectSurveyListForUser(Map<String, Object> param) throws Exception {
        return selectList("surveyDAO.selectSurveyListForUser", param);
    }

    /** 사용자용 설문 목록 전체 건수 */
    public int selectSurveyTotalCountForUser(Map<String, Object> param) throws Exception {
        return selectOne("surveyDAO.selectSurveyTotalCountForUser", param);
    }

    /** 응답 헤더 등록 */
    public void insertResponse(Map<String, Object> param) throws Exception {
        insert("surveyDAO.insertResponse", param);
    }

    /** 응답 상세 등록 */
    public void insertResponseDetail(Map<String, Object> param) throws Exception {
        insert("surveyDAO.insertResponseDetail", param);
    }

    /** 중복 응답 여부 확인 */
    public int selectResponseCount(Map<String, Object> param) throws Exception {
        return selectOne("surveyDAO.selectResponseCount", param);
    }

    /** 통계: 선택형 옵션별 응답 건수 */
    public List<Map<String, Object>> selectStatChoice(int surveyNo) throws Exception {
        return selectList("surveyDAO.selectStatChoice", surveyNo);
    }

    /** 통계: 텍스트형 답변 목록 */
    public List<Map<String, Object>> selectStatText(int surveyNo) throws Exception {
        return selectList("surveyDAO.selectStatText", surveyNo);
    }

    /** 통계: 텍스트형 답변 건수 */
    public List<Map<String, Object>> selectStatTextCount(int surveyNo) throws Exception {
        return selectList("surveyDAO.selectStatTextCount", surveyNo);
    }

    /** 총 응답자 수 */
    public int selectTotalResponseCount(int surveyNo) throws Exception {
        return selectOne("surveyDAO.selectTotalResponseCount", surveyNo);
    }

    /** 질문 첨부 이미지 임시 등록 */
    public void insertSurveyTempImage(Map<String, Object> param) throws Exception {
        insert("surveyDAO.insertSurveyTempImage", param);
    }

    /** 질문 첨부 이미지 활성화 (board_no 확정) */
    public void activateSurveyImage(Map<String, Object> param) throws Exception {
        update("surveyDAO.activateSurveyImage", param);
    }

    /** 질문 첨부 이미지 단건 조회 (이미지 서빙용) */
    public Map<String, Object> selectSurveyImageByFileNo(int fileNo) throws Exception {
        return selectOne("surveyDAO.selectSurveyImageByFileNo", fileNo);
    }

    /** 질문 첨부 이미지 논리삭제 */
    public void logicalDeleteSurveyImage(int fileNo) throws Exception {
        update("surveyDAO.logicalDeleteSurveyImage", fileNo);
    }
}

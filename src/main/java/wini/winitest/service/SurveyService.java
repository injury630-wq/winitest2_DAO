package wini.winitest.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;


/** 설문 서비스 인터페이스 */
public interface SurveyService {

    /** 설문 목록 조회 (페이징, 검색조건) + 전체 건수 */
    Map<String, Object> selectSurveyList(Map<String, Object> param) throws Exception;

    /** 설문 기본정보 조회 */
    Map<String, Object> selectSurvey(int surveyNo) throws Exception;

    /** 설문 문항+보기 목록 조회 (수정 폼용) */
    List<Map<String, Object>> selectQuestionsWithOptions(int surveyNo) throws Exception;

    /** 질문 유형 코드 목록 (Q_TYPE 콤보박스용) */
    List<Map<String, Object>> selectQuestionTypes() throws Exception;

    /** 설문 등록 */
    Map<String, Object> insertSurvey(Map<String, Object> param) throws Exception;

    /** 설문 수정 */
    Map<String, Object> updateSurvey(Map<String, Object> param) throws Exception;

    /** 설문 삭제 (문항·보기 포함) */
    Map<String, Object> deleteSurvey(int surveyNo) throws Exception;

    /** 사용자용 설문 목록 (참여가능+참여여부 포함) */
    Map<String, Object> getSurveyListForUser(Map<String, Object> param) throws Exception;

    /** 중복 응답 여부 확인 */
    int selectResponseCount(Map<String, Object> param) throws Exception;

    /** 응답 저장 */
    Map<String, Object> saveResponse(Map<String, Object> param) throws Exception;

    /** 통계 조회 */
    Map<String, Object> getSurveyStat(int surveyNo) throws Exception;

    /** 응답자 목록 조회 */
    List<Map<String, Object>> selectRespondentList(int surveyNo) throws Exception;

    /** 응답자별 답변 상세 조회 */
    List<Map<String, Object>> selectRespondentDetail(int surveyNo, int userNo) throws Exception;

    /** 질문 첨부 이미지 임시 업로드 */
    Map<String, Object> saveTempImage(MultipartFile file, Object regUser) throws Exception;

    /** 질문 첨부 이미지 조회 (이미지 서빙용) */
    Map<String, Object> getImageByFileNo(int fileNo) throws Exception;
}

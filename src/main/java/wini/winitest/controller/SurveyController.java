package wini.winitest.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import wini.winitest.common.FileUploadUtil;
import wini.winitest.common.MenuUtil;
import wini.winitest.service.MenuService;
import wini.winitest.service.SurveyService;

@Controller
public class SurveyController {

    @Resource(name = "surveyService")
    private SurveyService surveyService;

    @Resource(name = "menuService")
    private MenuService menuService;

    /** 설문 목록 */
    @RequestMapping(value = "/survey/surveyManage.do", method = RequestMethod.POST)
    public String surveyManage(@RequestParam Map<String, Object> param, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        param.put("recordCountPerPage", 10);
        param.put("pageSize", 10);
        Map<String, Object> result = surveyService.selectSurveyList(param);
        if ("S".equals(result.get("msg"))) {
            model.addAttribute("list",           result.get("list"));
            model.addAttribute("search",         result.get("search"));
            model.addAttribute("paginationInfo", result.get("paginationInfo"));
        }
        return "survey/surveyManage";
    }

    /** 설문 등록/수정 폼 */
    @RequestMapping(value = "/survey/surveyForm.do", method = RequestMethod.POST)
    public String surveyForm(@RequestParam Map<String, Object> param, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        model.addAttribute("questionTypes", surveyService.selectQuestionTypes()); // 콤보박스용
        String surveyNoStr = (param.get("surveyNo") != null) ? String.valueOf(param.get("surveyNo")) : null;
        if (surveyNoStr != null && !surveyNoStr.isEmpty()) {
            int surveyNo = Integer.parseInt(surveyNoStr);
            model.addAttribute("survey",     surveyService.selectSurvey(surveyNo));
            model.addAttribute("questions",  surveyService.selectQuestionsWithOptions(surveyNo));
        }
        return "survey/surveyForm";
    }

    /** 설문 저장 (등록/수정 AJAX JSON) */
    @RequestMapping(value = "/survey/surveySave.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> surveySave(@RequestBody Map<String, Object> param,
                                          HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            if (loginUser != null) param.put("regUser", loginUser.get("userNo"));
            String surveyNoStr = String.valueOf(param.get("surveyNo")); // 화면에서 null or 숫자값으로 보냄
            boolean isNew = "null".equals(surveyNoStr) || surveyNoStr.isEmpty();
            if(isNew) {
            	surveyService.insertSurvey(param);
            	result.put("msg", "S");
            }else {
            	surveyService.updateSurvey(param);
            	result.put("msg", "S");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            result.put("msg", "E");
            return result;
        }
    }

    /** 설문 삭제 (AJAX) */
    @RequestMapping(value = "/survey/surveyDelete.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> surveyDelete(@RequestParam Map<String, Object> param) {
        Map<String, Object> err = new HashMap<>();
        try {
            int surveyNo = Integer.parseInt((String) param.get("surveyNo"));
            return surveyService.deleteSurvey(surveyNo);
        } catch (Exception e) {
            e.printStackTrace();
            err.put("msg", "E");
            return err;
        }
    }

    /** 사용자용 설문 참여 목록 */
    @RequestMapping(value = "/survey/surveyList.do", method = RequestMethod.POST)
    public String surveyList(@RequestParam Map<String, Object> param,
                             Model model, HttpSession session) throws Exception {
        MenuUtil.addMenu(model, menuService);
        Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
        if (loginUser != null) {
            param.put("userNo", loginUser.get("userNo"));
        }
        param.put("recordCountPerPage", 10);
        param.put("pageSize", 10);
        Map<String, Object> result = surveyService.getSurveyListForUser(param);
        if ("S".equals(result.get("msg"))) {
            model.addAttribute("list",           result.get("list"));
            model.addAttribute("search",         result.get("search"));
            model.addAttribute("paginationInfo", result.get("paginationInfo"));
        }
        return "survey/surveyList";
    }

    /** 설문 응답 폼 */
    @RequestMapping(value = "/survey/surveyResponse.do", method = RequestMethod.POST)
    public String surveyResponse(@RequestParam Map<String, Object> param,
                                 Model model, HttpSession session) throws Exception {
        MenuUtil.addMenu(model, menuService);
        int surveyNo = Integer.parseInt((String) param.get("surveyNo"));
        model.addAttribute("survey",    surveyService.selectSurvey(surveyNo));
        model.addAttribute("questions", surveyService.selectQuestionsWithOptions(surveyNo));
        return "survey/surveyResponse";
    }

    /** 설문 응답 저장 (AJAX JSON) */
    @RequestMapping(value = "/survey/surveyResponseSave.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> surveyResponseSave(@RequestBody Map<String, Object> param,
                                                  HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            if (loginUser != null) {
                param.put("regUser", loginUser.get("userNo"));
                param.put("userNo",  loginUser.get("userNo"));
            }
            // 설문참여 중복 확인
            if (surveyService.selectResponseCount(param) > 0) {
                result.put("msg", "D");
                return result;
            }
            result = surveyService.saveResponse(param);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            result.put("msg", "E");
            return result;
        }
    }

    /** 설문 통계 */
    @RequestMapping(value = "/survey/surveyStat.do", method = RequestMethod.POST)
    public String surveyStat(@RequestParam Map<String, Object> param, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        int surveyNo = Integer.parseInt(String.valueOf(param.get("surveyNo")));
        Map<String, Object> result = surveyService.getSurveyStat(surveyNo);
        if ("S".equals(result.get("msg"))) {
            model.addAttribute("survey",     result.get("survey"));
            model.addAttribute("questions",  result.get("questions"));
            model.addAttribute("totalCount", result.get("totalCount"));
        }
        return "survey/surveyStat";
    }

    /** 응답자 목록 */
    @RequestMapping(value = "/survey/surveyRespondent.do", method = RequestMethod.POST)
    public String surveyRespondent(@RequestParam Map<String, Object> param, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        int surveyNo = Integer.parseInt((String) param.get("surveyNo"));
        model.addAttribute("survey",   surveyService.selectSurvey(surveyNo));
        model.addAttribute("respondentList", surveyService.selectRespondentList(surveyNo));
        model.addAttribute("surveyNo", surveyNo);
        return "survey/surveyRespondent";
    }

    /** 응답자별 답변 상세 */
    @RequestMapping(value = "/survey/surveyRespondentDetail.do", method = RequestMethod.POST)
    public String surveyRespondentDetail(@RequestParam Map<String, Object> param, Model model) throws Exception {
        MenuUtil.addMenu(model, menuService);
        int surveyNo = Integer.parseInt((String) param.get("surveyNo"));
        int userNo   = Integer.parseInt((String) param.get("userNo"));
        model.addAttribute("survey",      surveyService.selectSurvey(surveyNo));
        model.addAttribute("answers",     surveyService.selectRespondentDetail(surveyNo, userNo));
        model.addAttribute("surveyNo",    surveyNo);
        model.addAttribute("userNo",      userNo);
        return "survey/surveyRespondentDetail";
    }

    /** 질문 이미지 임시 업로드 */
    @RequestMapping(value = "/survey/surveyImageUpload.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> surveyImageUpload(@RequestParam("file") MultipartFile file,
                                                 HttpSession session) {
        Map<String, Object> err = new HashMap<>();
        try {
            Map<String, Object> loginUser = (Map<String, Object>) session.getAttribute("loginUser");
            Object regUser = (loginUser != null) ? loginUser.get("userNo") : null;
            return surveyService.saveTempImage(file, regUser);
        } catch (Exception e) {
            e.printStackTrace();
            err.put("msg", "E");
            return err;
        }
    }

    /** 질문 이미지 삭제 (임시 파일 물리 삭제) */
    @RequestMapping(value = "/survey/surveyImageDelete.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> surveyImageDelete(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            int fileNo = Integer.parseInt((String) param.get("fileNo"));
            Map<String, Object> fileInfo = surveyService.getImageByFileNo(fileNo);
            if (fileInfo != null) {
                FileUploadUtil.deletePhysical(
                    (String) fileInfo.get("filePath"),
                    (String) fileInfo.get("fileName")
                );
            }
            result.put("msg", "S");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("msg", "E");
        }
        return result;
    }

    /** 질문 이미지 서빙 */
    @RequestMapping(value = "/survey/getImage.do", method = RequestMethod.GET)
    public void getImage(@RequestParam("fileNo") int fileNo,
                         HttpServletResponse response) throws Exception {
        Map<String, Object> fileInfo = surveyService.getImageByFileNo(fileNo);
        if (fileInfo == null) {// DB 조회 안됨
            response.setStatus(404);
            return;
        }
        File f = new File((String) fileInfo.get("filePath"), (String) fileInfo.get("fileName"));
        if (!f.exists()) {
            response.setStatus(404);
            return;
        }
        FileUploadUtil.streamImage(f, response);
    }
}

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">응답자 답변 상세</h2>
    </div>

    <!-- 설문 기본 정보 -->
    <div class="bg-white border p-3 mb-3" style="font-size: 14px;">
        <table class="table table-bordered mb-0">
            <colgroup>
                <col style="width: 15%"><col>
            </colgroup>
            <tbody>
                <tr>
                    <td class="table-light fw-semibold">설문 제목</td>
                    <td><c:out value="${survey.title}"/></td>
                </tr>
                <tr>
                    <td class="table-light fw-semibold">설문 기간</td>
                    <td><c:out value="${survey.startDate}"/> ~ <c:out value="${survey.endDate}"/></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 답변 목록 -->
    <div class="bg-white border mb-3">
        <div class="px-3 pt-2 pb-1 border-bottom">
            <span class="fw-semibold" style="font-size: 14px;">질문별 답변</span>
        </div>
        <table class="table table-bordered mb-0" style="font-size: 13px;">
            <colgroup>
                <col style="width: 8%">
                <col style="width: 42%">
                <col>
            </colgroup>
            <thead class="table-light">
                <tr>
                    <th class="text-center">번호</th>
                    <th class="text-center">질문</th>
                    <th class="text-center">답변</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty answers}">
                        <tr>
                            <td colspan="3" class="text-center text-muted py-3">답변 데이터가 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:set var="prevQNo" value=""/>
                        <c:forEach var="a" items="${answers}" varStatus="vs">
                        <tr>
                            <td class="text-center align-middle">
                                <c:if test="${a.qNo != prevQNo}">Q<c:out value="${a.sortOrd + 1}"/></c:if>
                            </td>
                            <td class="align-middle">
                                <c:if test="${a.qNo != prevQNo}"><c:out value="${a.qContent}"/></c:if>
                            </td>
                            <td class="align-middle">
                                <c:choose>
                                    <c:when test="${not empty a.optionContent}">
                                        <c:out value="${a.optionContent}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${a.answerContent}"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <c:set var="prevQNo" value="${a.qNo}"/>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 하단 버튼 -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-outline-secondary px-4"
                onclick="goPost('survey/surveyRespondent.do', {surveyNo: '${surveyNo}'})">응답자 목록</button>
    </div>

</div>

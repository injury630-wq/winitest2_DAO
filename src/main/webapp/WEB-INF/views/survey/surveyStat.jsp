<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>

<div class="px-1">

    <!-- 헤더 -->
    <div class=" mb-3">
      <h2>통계</h2>
      <span class="">(총 응답자: ${totalCount}명)</span>
    </div>
    <!-- 설문지 정보  -->
		<table class="table table-bordered">
			<colgroup>
			  <col style="width: 15%"><col>
			</colgroup>
		  <thead>
		    <tr>
		      <td class="bg-light">제목</td>
		      <td class="text-truncate" style="max-width: 300px; min-width: 200px"><c:out value="${survey.title}"/></td>
		    </tr>
		  </thead>
		  <tbody>
		    <tr>
		      <td class="bg-light">개요</td>
		      <td class="text-truncate" style="max-width: 300px; min-width: 200px"><c:out value="${survey.content}"/></td>
		    </tr>
		    <tr>
		      <td class="bg-light">설문 기간</td>
		      <td><c:out value="${survey.startDate} ~ ${survey.endDate }"/></td>
		    </tr>
		  </tbody>
		</table>

    <!-- 질문별 통계 -->
    <c:forEach var="q" items="${questions}" varStatus="vs">
        <div class="bg-white border mb-3">
            <table class="table table-bordered mb-0" style="font-size: 14px;">
                <colgroup>
                    <col style="width: 15%"><col>
                </colgroup>
                <tbody>
                    <!-- 헤더: 질문 번호 + 내용 -->
                    <tr class="table-light">
                        <td class="text-center align-middle fw-bold">Q${vs.index + 1}</td>
                        <td class="align-middle fw-semibold">
                            <c:out value="${q.content}"/>
                        </td>
                    </tr>
                    <!-- 통계 영역 -->
                    <tr>
                        <th class="table-light align-middle text-center">통계</th>
                        <td>
                            <c:choose>
                                <c:when test="${q.type eq 'radio' or q.type eq 'select' or q.type eq 'checkbox'}">
                                    <c:choose>
                                        <c:when test="${empty q.stats}">
                                            <span class="text-muted">응답 없음</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="stat" items="${q.stats}">
                                                <div style="font-size: 13px;">
                                                    <c:out value="${stat.optionContent}"/>[<c:out value="${stat.cnt}"/>건]
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <p class="mb-1 fw-semibold" style="font-size: 13px;">
                                        응답 목록 (${q.answerCount}건):
                                    </p>
                                    <c:choose>
                                        <c:when test="${empty q.answers}">
                                            <span class="text-muted">응답 없음</span>
                                        </c:when>
                                        <c:otherwise>
                                            <ul class="mb-0 ps-3" style="font-size: 13px;">
                                                <c:forEach var="ans" items="${q.answers}">
                                                    <li><c:out value="${ans.answerContent}"/></li>
                                                </c:forEach>
                                            </ul>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </c:forEach>

    <!-- 하단 목록 버튼 -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-outline-secondary px-4"
                onclick="goPost('survey/surveyManage.do')">목록</button>
    </div>

</div>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">응답자 목록</h2>
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
                <tr>
                    <td class="table-light fw-semibold">총 응답자</td>
                    <td>
                    <c:choose>
								        <c:when test="${respondentList != null && respondentList.size() > 0}">
								            <c:out value="${respondentList.size()}"/>명
								        </c:when>
								        <c:otherwise>없음</c:otherwise>
								    </c:choose>
									  </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 응답자 목록 -->
    <div class="bg-white border mb-3">
        <table class="table table-bordered table-hover mb-0" style="font-size: 13px;">
            <colgroup>
                <col style="width: 8%">
                <col style="width: 25%">
                <col style="width: 25%">
                <col style="width: 25%">
                <col style="width: 17%">
            </colgroup>
            <thead class="table-light">
                <tr>
                    <th class="text-center">NO</th>
                    <th class="text-center">아이디</th>
                    <th class="text-center">이름</th>
                    <th class="text-center">응답일</th>
                    <th class="text-center">상세</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty respondentList}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-3">응답자가 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="r" items="${respondentList}" varStatus="vs">
                        <tr>
                            <td class="text-center"><c:out value="${vs.count}"/></td>
                            <td class="text-center"><c:out value="${r.userId}"/></td>
                            <td class="text-center"><c:out value="${r.userName}"/></td>
                            <td class="text-center"><c:out value="${r.regDate}"/></td>
                            <td class="text-center">
                                <button type="button" class="btn btn-outline-primary btn-sm px-3"
                                        onclick="goDetail(${r.userNo})">답변 보기</button>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 하단 버튼 -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-outline-secondary px-4"
                onclick="goPost('survey/surveyStat.do', {surveyNo: '${surveyNo}'})">통계로 돌아가기</button>
    </div>

</div>

<form id="detailForm" method="post" action="survey/surveyRespondentDetail.do">
    <input type="hidden" name="surveyNo" value="${surveyNo}"/>
    <input type="hidden" name="userNo"   id="userNo"/>
</form>

<script>
function goDetail(userNo) {
    $('#userNo').val(userNo);
    $('#detailForm').submit();
}
</script>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">설문 참여</h2>
    </div>

    <!-- 1. 검색 영역 -->
    <form id="searchForm" method="post" action="survey/surveyList.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1" />
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <input type="text" name="searchKeyword" class="form-control"
                       value="<c:out value="${search.searchKeyword}"/>"
                       placeholder="설문 제목 검색" maxlength="100" />
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-danger px-4">검색</button>
            </div>
        </div>
    </form>

    <!-- 2. 목록 영역 -->
    <div class="bg-white border mb-2">
        <div class="px-3 pt-2 pb-1">
            <small class="text-muted">전체 :
                <strong style="color: #c0392b;">
                    <fmt:formatNumber value="${paginationInfo.totalRecordCount}" pattern="#,###"/>
                </strong>건
            </small>
        </div>
        <table class="table table-bordered table-hover mb-0" style="font-size: 14px;">
            <thead class="table-light">
                <tr>
                    <th class="text-center" style="width: 7%">순번</th>
                    <th class="text-center">제목</th>
                    <th class="text-center">개요</th>
                    <th class="text-center" style="width: 20%">설문기간</th>
                    <th class="text-center" style="width: 8%">참여</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-3">참여 가능한 설문이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="s" items="${list}" varStatus="vs">
                            <tr>
                                <td class="text-center">
                                    ${paginationInfo.totalRecordCount
                                      - (paginationInfo.currentPageNo - 1) * paginationInfo.recordCountPerPage
                                      - vs.index}
                                </td>
                                <td><c:out value="${s.title}"/></td>
                                <td class="text-muted" style="white-space: pre-wrap; font-size: 13px;"><c:out value="${s.content}"/></td>
                                <td class="text-center">
                                    <c:out value="${s.startDate}"/> ~ <c:out value="${s.endDate}"/>
                                </td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-primary btn-sm"
                                            onclick="participate('${s.surveyNo}', '${s.availYn}', '${s.responded}')">
                                        참여
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 3. 페이징 영역 -->
    <div class="paging mb-3">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}"
                               type="customRenderer" jsFunction="linkPage"/>
            </ul>
        </nav>
    </div>

</div>

<script>
function linkPage(pageNo) {
    $('#currentPageNo').val(pageNo);
    $('#searchForm').submit();
}

function participate(surveyNo, availYn, responded) {
    if (responded === 'Y') {
        alert('이미 참여한 설문입니다.');
        return;
    }
    if (availYn === 'N') {
        alert('설문 기간이 아닙니다.');
        return;
    }
    goPost('survey/surveyResponse.do', {surveyNo: surveyNo});
}
</script>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">설문 관리</h2>
    </div>

    <!-- 1. 검색 영역 -->
    <form id="searchForm" method="post" action="survey/surveyManage.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1" />
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <input type="text" name="searchKeyword" class="form-control"
                       value='<c:out value="${search.searchKeyword}"/>'
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
            <colgroup>
                <col style="width: 7%">
                <col>
                <col style="width: 10%">
                <col style="width: 10%">
                <col style="width: 20%">
                <col style="width: 10%">
                <col style="width: 8%">
                <col style="width: 8%">
            </colgroup>
            <thead class="table-light">
                <tr>
                    <th class="text-center">순번</th>
                    <th class="text-center">제목</th>
                    <th class="text-center">사용여부</th>
                    <th class="text-center">응답가능여부</th>
                    <th class="text-center">설문 기간</th>
                    <th class="text-center">작성자</th>
                    <th class="text-center">수정</th>
                    <th class="text-center">통계</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="8" class="text-center text-muted py-3">등록된 설문이 없습니다.</td>
                    </tr>
                </c:if>
                <c:forEach var="s" items="${list}" varStatus="vs">
                    <tr>
                        <td class="text-center">
                            <c:out value="${paginationInfo.totalRecordCount
                              - (paginationInfo.currentPageNo - 1) * paginationInfo.recordCountPerPage
                              - vs.index}"/>
                        </td>
                        <td><c:out value="${s.title}"/></td>
                        <td class="text-center"><c:out value="${s.useYn}"/></td>
                        <td class="text-center"><c:out value="${s.resAvail}"/></td>
                        <td class="text-center">
                            <c:out value="${s.startDate}"/> ~ <c:out value="${s.endDate}"/>
                        </td>
                        <td class="text-center"><c:out value="${s.regUserName}"/></td>
                        <td class="text-center">
                          <c:choose>
                            <c:when test="${s.canEdit eq 'Y'}">
                              <%-- 설문 시작 전: 권한 클래스 부여 -> applyButtonPerms()가 권한에 따라 활성/비활성 --%>
                              <button type="button" class="btn btn-secondary btn-sm btn-perm-upd"
                                      onclick="goPost('survey/surveyForm.do', {surveyNo: '${s.surveyNo}'})">
                                수정
                              </button>
                            </c:when>
                            <c:otherwise>
                              <%-- 설문 시작 후: 권한 클래스 없이 disabled 고정 -> applyButtonPerms() 영향 없음 --%>
                              <button type="button" class="btn btn-secondary btn-sm" disabled>
                                수정
                              </button>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td class="text-center">
                            <button type="button" class="btn btn-secondary btn-sm"
                                    onclick="goPost('survey/surveyStat.do', {surveyNo: '${s.surveyNo}'})">
                                통계
                            </button>
                        </td>
                    </tr>
                </c:forEach>
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

    <!-- 4. 버튼 영역 -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-primary btn-sm px-3 btn-perm-ins"
                onclick="goPost('survey/surveyForm.do')">+ 설문 등록</button>
    </div>

</div>

<script>
function linkPage(pageNo) {
    $('#currentPageNo').val(pageNo);
    $('#searchForm').submit();
}

</script>

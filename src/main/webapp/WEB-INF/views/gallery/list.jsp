<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">
    <h2 class="h5 fw-bold mb-3">이미지 게시판</h2>

    <!-- 검색 -->
    <form id="searchForm" method="post" action="gallery/list.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1"/>
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <select name="searchType" class="form-select" style="width:auto; min-width:100px;">
                    <option value="">전체</option>
                    <option value="title"   <c:if test="${param.searchType == 'title'  }">selected</c:if>>제목</option>
                    <option value="writer"  <c:if test="${param.searchType == 'writer' }">selected</c:if>>작성자</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control"
                       value="<c:out value="${param.searchKeyword}"/>"
                       placeholder="검색어를 입력하세요." maxlength="100"/>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-danger px-4">검색</button>
            </div>
        </div>
    </form>

    <!-- 목록 -->
    <div class="bg-white border mb-2 p-3">
        <div class="pb-2">
            <small class="text-muted">전체 : <strong class="text-danger">${totalCount}</strong>건</small>
        </div>

        <c:choose>
            <c:when test="${empty galleryList}">
                <div class="text-center text-muted py-5">등록된 게시글이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <div class="row g-3">
                    <c:forEach var="item" items="${galleryList}">
                        <div class="col-md-3">
                            <div class="card h-100" style="cursor:pointer;"
                                 onclick="goPost('gallery/detail.do', {boardNo:'${item.boardNo}'})">
                                <c:choose>
                                    <c:when test="${not empty item.thumbFileNo}">
                                        <img src="gallery/imgView.do?fileNo=${item.thumbFileNo}"
                                             class="card-img-top"
                                             style="height:180px; object-fit:cover;"
                                             alt="<c:out value="${item.title}"/>">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top bg-light d-flex align-items-center justify-content-center"
                                             style="height:180px;">
                                            <span class="text-muted small">이미지 없음</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body p-2">
                                    <h6 class="card-title mb-1 text-truncate">
                                        <c:out value="${item.title}"/>
                                    </h6>
                                    <div class="text-muted small"><c:out value="${item.regUserName}"/></div>
                                    <div class="d-flex justify-content-between small text-muted">
                                        <span>${item.regDate}</span>
                                        <span>조회 ${item.hit}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 페이징 -->
    <div class="paging">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="customRenderer" jsFunction="linkPage"/>
            </ul>
        </nav>
    </div>

    <!-- 버튼 -->
    <div class="text-end mt-2">
        <button type="button" class="btn btn-danger" onclick="goPost('gallery/form.do')">글쓰기</button>
    </div>
</div>

<script>
function linkPage(pageNo) {
    document.getElementById('currentPageNo').value = pageNo;
    document.getElementById('searchForm').submit();
}
</script>

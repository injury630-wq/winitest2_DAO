<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>

<div class="container">
    <h2><a href="javascript:void(0);" onclick="goPost('board/list.do');">게시판 목록</a></h2>
    <form id="searchForm" action="board/list.do" method="post">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1"/>
        <div class="border p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <select name="searchType" class="form-select" style="width:auto; min-width:100px;">
                    <option value="">전체</option>
                    <option value="title"      <c:if test="${param.searchType == 'title'}"      >selected</c:if>>제목</option>
                    <option value="writer_name" <c:if test="${param.searchType == 'writer_name'}">selected</c:if>>작성자</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control"
                       value="<c:out value="${param.searchKeyword}"/>" placeholder="검색어를 입력하세요." maxlength="100"/>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-danger px-4">검색</button>
            </div>
        </div>
    </form>

    <p class="mb-2" style="font-size:14px;">전체 : <strong style="color:#c0392b;"><fmt:formatNumber value="${paginationInfo.totalRecordCount}" pattern="#,###"/></strong>건</p>

    <table class="board-list">
        <thead>
            <tr>
                <th style="width:10%">순번</th>
                <th style="width:30%">제목</th>
                <th style="width:8%">첨부</th>
                <th style="width:20%">작성자</th>
                <th style="width:17%">등록일</th>
                <th style="width:10%">조회수</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr><td colspan="5">게시글이 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="board" items="${list}" varStatus="status">
                        <tr onclick="goDetail('${board.boardNo}')" style="cursor:pointer;">
                            <td>${paginationInfo.totalRecordCount
                                - (paginationInfo.currentPageNo - 1) * paginationInfo.recordCountPerPage
                                - status.index}</td>
                            <td class="title">
                                <div class="d-flex align-items-center gap-1">
                                    <span class="text-truncate re-lev${board.reLev}">
                                        <c:if test="${board.reLev > 0}">ㄴ </c:if><c:out value="${board.title}"/>
                                    </span>
                                </div>
                            </td>
                            <td>
                            <c:if test="${board.fileCount > 0}">
                                <span class="badge bg-danger">${board.fileCount}</span>
                            </c:if>
                            </td>
                            <td><c:out value="${board.writerName}"/></td>
                            <td>${board.regDate}</td>
                            <td>${board.hit}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="paging">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="customRenderer" jsFunction="linkPage"/>
            </ul>
        </nav>
    </div>

    <div class="text-end mt-2">
        <button type="button" class="btn btn-danger" onclick="goWrite()">글쓰기</button>
    </div>
</div>

<form id="boardMoveForm" method="post">
    <input type="hidden" name="boardNo"       id="fBoardNo"/>
    <input type="hidden" name="searchType"    value="<c:out value="${param.searchType}"/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value="${param.searchKeyword}"/>"/>
    <input type="hidden" name="currentPageNo" id="fCurrentPageNo" value="${paginationInfo.currentPageNo}"/>
</form>

<script>
    function linkPage(pageNo) {
        document.querySelector('#currentPageNo').value = pageNo;
        document.querySelector('#searchForm').submit();
    }

    function goDetail(boardNo) {
        let form = document.querySelector('#boardMoveForm');
        form.action = 'board/detail.do';
        document.querySelector('#fBoardNo').value = boardNo;
        form.submit();
    }

    function goWrite(){
    	let form = document.querySelector('#boardMoveForm');
        form.action = 'board/write.do';
        form.submit();
    }

    window.onpageshow = function(event) {
        if (event.persisted || (window.performance && window.performance.navigation.type == 2)) {
            window.location.reload();
        }
    };
</script>

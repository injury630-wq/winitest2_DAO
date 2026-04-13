<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>
<%--
    list.jsp 에는 form 이 두 개 있다.

    [1] searchForm (id="searchForm")
        용도: 검색 + 페이지 이동 전용
        이유: 페이지 이동(linkPage)과 검색(버튼 클릭)이 모두 같은 board/list.do 를 향하므로
              하나의 form 으로 통합하면 편하다.
              currentPageNo hidden 을 JS 로 바꿔서 submit 하면 모든 이동이 가능하다.
              goPost(__navForm) 를 쓰지 않는 이유: searchType/searchKeyword 유지가 필요하고
              페이지 번호만 바꿔서 같은 URL 로 반복 호출하는 패턴이라 전용 form 이 더 깔끔하다.

    [2] boardMoveForm (id="boardMoveForm")
        용도: 게시글 상세 이동 전용 (검색 조건 + 현재 페이지 유지)
        이유: 상세 페이지에서 목록으로 돌아올 때 검색 조건과 현재 페이지를 그대로 유지해야 한다.
              boardNo 는 행 클릭 시 JS 로 동적으로 바뀌므로 searchForm 과 분리한다.
              goPost 를 쓰지 않는 이유: searchType/searchKeyword/currentPageNo 가 이미
              이 form 에 서버에서 렌더링된 값으로 들어있으므로 별도 파라미터 주입이 불필요하다.
--%>

<div class="container">
    <h2>게시판 목록</h2>

    <%-- searchForm: 검색 제출 및 페이지 이동 공용. currentPageNo 는 JS 로 세팅 후 submit --%>
    <form id="searchForm" action="board/list.do" method="post">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1"/>
        <div class="border p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <select name="searchType" class="form-select" style="width:auto; min-width:90px;">
                    <option value="">전체</option>
                    <option value="title"      <c:if test="${param.searchType == 'title'}"      >selected</c:if>>제목</option>
                    <option value="writer_name" <c:if test="${param.searchType == 'writerName'}">selected</c:if>>작성자</option>
                </select>
                <%-- maxlength: DB column searchKeyword 제한에 맞춰 100자 제한 --%>
                <input type="text" name="searchKeyword" class="form-control"
                       value="${param.searchKeyword}" placeholder="검색어를 입력하세요." maxlength="100"/>
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
                <th style="width:38%">제목</th>
                <th style="width:20%">작성자</th>
                <th style="width:17%">등록일</th>
                <th style="width:15%">조회수</th>
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
                            <%--
                                title td: Bootstrap text-truncate 로 말줄임표 처리
                                header.jsp CSS 의 td.title 에 max-width:280px 이 설정되어 있어
                                text-truncate (overflow:hidden + text-overflow:ellipsis + white-space:nowrap) 가 동작한다.
                                첨부파일 배지(badge)를 앞에 두어 제목이 길어도 배지가 잘리지 않게 한다.
                            --%>
                            <%--
                                title td: 제목(왼쪽)과 첨부파일 배지(오른쪽)를 flex 로 배치.
                                text-truncate 를 td 가 아닌 내부 span 에 적용해야 flex 에서 말줄임표가 동작한다.
                                span 에 min-width:0 필수 — flex 아이템은 기본적으로 min-width:auto 여서
                                내용물보다 작게 줄어들지 않기 때문에 min-width:0 을 명시해야 줄어든다.
                                배지는 flex-shrink:0 으로 고정 크기 유지.
                            --%>
                            <td class="title">
                                <div class="d-flex align-items-center gap-1">
                                    <span class="text-truncate re-lev${board.reLev}" style="flex:1; min-width:0;">
                                        <c:if test="${board.reLev > 0}">ㄴ </c:if>${board.title}
                                    </span>
                                    <c:if test="${board.fileCount > 0}">
                                        <span class="badge bg-danger" style="flex-shrink:0;">${board.fileCount}</span>
                                    </c:if>
                                </div>
                            </td>
                            <td>${board.writerName}</td>
                            <td>${board.regDate}</td>
                            <td>${board.hit}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <%-- 페이지네이션: CustomPaginationRenderer 사용 (<<, <, 페이지번호, >, >>) --%>
    <div class="paging">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="customRenderer" jsFunction="linkPage"/>
            </ul>
        </nav>
    </div>

    <div class="text-end mt-2">
        <%-- goPost: 글쓰기는 파라미터 없이 단순 이동이므로 header.jsp 의 공용 __navForm 사용 --%>
        <button type="button" class="btn btn-danger" onclick="goPost('board/write.do')">글쓰기</button>
    </div>
</div>

<%--
    boardMoveForm: 상세 페이지 이동 전용 숨겨진 폼
    검색 조건(searchType/searchKeyword)과 현재 페이지(currentPageNo)를 함께 전달해야
    상세 조회 후 목록으로 돌아올 때 검색 결과와 페이지 위치가 유지된다.
    boardNo 만 JS 로 동적 세팅하면 되므로 나머지는 서버에서 렌더링된 값을 그대로 사용한다.
--%>
<form id="boardMoveForm" method="post">
    <input type="hidden" name="boardNo"       id="fBoardNo"/>
    <input type="hidden" name="searchType"    value="${param.searchType}"/>
    <input type="hidden" name="searchKeyword" value="${param.searchKeyword}"/>
    <input type="hidden" name="currentPageNo" id="fCurrentPageNo" value="${paginationInfo.currentPageNo}"/>
</form>

<script>
    // linkPage(pageNo): 페이지네이션 버튼 클릭 시 CustomPaginationRenderer 가 호출한다.
    // searchForm 의 currentPageNo 를 바꿔서 submit → 검색 조건을 유지하면서 해당 페이지로 이동
    function linkPage(pageNo) {
        document.querySelector('#currentPageNo').value = pageNo;
        document.querySelector('#searchForm').submit();
    }

    // goDetail(boardNo): 목록 행 클릭 시 상세 페이지로 이동
    // boardMoveForm 에 boardNo 를 세팅해서 submit → 검색 조건 + 페이지 번호 유지
    function goDetail(boardNo) {
        let form = document.querySelector('#boardMoveForm');
        form.action = 'board/detail.do';
        document.querySelector('#fBoardNo').value = boardNo;
        form.submit();
    }

    // onpageshow: 브라우저 뒤로가기로 목록에 돌아왔을 때 캐시된 화면을 강제 새로고침
    // 이유: 뒤로가기 캐시로 복원되면 조회수 등 실시간 데이터가 갱신되지 않는다.
    // event.persisted: 사파리/iOS 에서 캐시 복원 시 true
    // performance.navigation.type == 2: 크롬 등 다른 브라우저의 뒤로가기 감지
    window.onpageshow = function(event) {
        if (event.persisted || (window.performance && window.performance.navigation.type == 2)) {
            window.location.reload();
        }
    };
</script>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container detail-container">
    <h2>게시판 조회</h2>

    <%-- 답글인 경우: 부모글 제목을 reply.jsp 와 동일한 스타일로 상단에 표시 --%>
    <c:if test="${not empty parentBoard}">
        <div class="bg-light p-3 text-truncate mb-3" style="max-width:100%;">
            <span>(원글제목) </span>${parentBoard.title}
        </div>
    </c:if>

    <%--
        detail-table: th 너비를 고정(10%)하여 내용 길이와 무관하게 레이아웃 유지.
        table-layout:fixed + 명시적 열 너비가 없으면 브라우저가 내용에 따라 th 를 압축하여
        "첨부파일" 같은 긴 th 텍스트가 세로로 줄바꿈된다.
    --%>
    <table class="detail-table">
        <tr>
            <th>제목</th>
            <%-- max-width:0 + text-truncate: 테이블 셀에서 말줄임표를 적용하는 표준 기법.
                 max-width:0 으로 설정하면 셀이 테이블 레이아웃이 할당한 너비만 사용하고,
                 text-truncate(overflow:hidden + ellipsis + nowrap)가 동작하게 된다.
                 title 속성으로 전체 제목을 툴팁으로 볼 수 있다. --%>
            <td colspan="3" class="text-truncate" style="max-width:0;" title="${board.title}">
                ${board.title}
            </td>
        </tr>
        <tr>
            <th>작성자</th>
            <td>${board.writerName}</td>
            <th>등록일</th>
            <td>${board.regDate} </td>
        </tr>
        <tr>
            <th>조회수</th>
            <td colspan="3" id="hit">${board.hit}</td>
        </tr>
        <tr>
            <th>내용</th>
            <%-- content-area 를 div 로 감싸는 이유:
                 브라우저는 <td> 에 적용된 min-height 를 무시한다 (table cell 스펙).
                 div 로 감싸면 min-height/max-height 가 정상 동작하여
                 내용이 짧아도 일정 높이를 유지하고, 길어지면 스크롤 처리된다. --%>
            <td colspan="3"><div class="content-area">${board.content}</div></td>
        </tr>
        <tr>
            <th>첨부파일</th>
            <td colspan="3">
                <c:choose>
                    <c:when test="${empty fileList}">첨부파일 없음</c:when>
                    <c:otherwise>
                        <c:forEach var="file" items="${fileList}">
                            <div>
                                <a href="#" onclick="goDownload('${file.fileNo}'); return false;">
                                    ${file.fileName}
                                </a>
                                [<fmt:formatNumber value="${file.fileSize}" pattern="#,###"/> byte]
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>

    <c:if test="${pwError == '1'}">
        <p class="error-msg">비밀번호가 틀렸습니다.</p>
    </c:if>

    <%--
        버튼 영역: 목록(왼쪽) / 수정·삭제·답변등록(오른쪽) 분리
        답변 제한 안내문은 버튼 행 아래에 별도 출력 (버튼 옆에 두면 줄바꿈·밀림 발생)
        align-items-start: 안내문이 생겼을 때 목록 버튼이 수직 중앙으로 밀리지 않도록
    --%>
    <div class="d-flex justify-content-between align-items-start mt-3">
        <div>
            <button class="btn btn-secondary" onclick="goList()">목록</button>
        </div>
        <div>
            <%-- 버튼 행: 비밀번호 + 수정 + 삭제 + (답변등록) --%>
            <div class="d-flex gap-2 align-items-center">
                <input type="password" id="writerPw" class="form-control" style="width:150px;" placeholder="비밀번호 입력"/>
                <button class="btn btn-success" onclick="goEdit()">수정</button>
                <button class="btn btn-danger" onclick="goDelete()">삭제</button>
                <%-- 답변 가능한 경우에만 버튼 표시 (c:if 로 조건 충족 시에만 렌더링) --%>
                <c:if test="${board.reLev < 2 and replyCount < 5}">
                    <button class="btn btn-info" onclick="goReply()">답변등록</button>
                </c:if>
            </div>
            <%-- 답변 불가 안내문: 버튼 행 아래에 오른쪽 정렬로 표시
                 우선순위 1: reLev 2(답답글)이면 더 이상 답변 불가 (최대 2레벨)
                 우선순위 2: 직접 자식 수(replyCount) 5개 이상이면 불가 --%>
            <c:choose>
                <c:when test="${board.reLev >= 2}">
                    <small class="text-muted d-block text-end mt-1">더 이상 답변을 달 수 없습니다.</small>
                </c:when>
                <c:when test="${replyCount >= 5}">
                    <small class="text-muted d-block text-end mt-1">답글이 최대(5개)에 도달하여 더 이상 달 수 없습니다.</small>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>
<%--
    actionForm: detail.jsp 전용 공용 POST 이동 폼
    [왜 goPost(__navForm) 대신 전용 form 을 쓰는가?]
    이 페이지에서는 목록/수정/삭제/답변 이동 시 모두 동일한 파라미터 묶음
    (boardNo + writerPw + searchType + searchKeyword + currentPageNo) 을 함께 전달해야 한다.
    writerPw 는 JS 로 비밀번호 입력 후 동적으로 세팅되는 값이므로,
    전용 form 을 하나 두고 action 만 바꿔가며 submit 하는 방식이 가장 깔끔하다.
    goPost 를 쓰면 매번 5개 파라미터를 params 객체에 나열해야 해서 코드가 길어진다.
--%>
<form id="actionForm" method="post">
    <input type="hidden" name="boardNo"       id="boardNo"    value="${board.boardNo}"/>
    <input type="hidden" name="writerPw"      id="fWriterPw"  value=""/>
    <input type="hidden" name="searchType"    value="${param.searchType}"/>
    <input type="hidden" name="searchKeyword" value="${param.searchKeyword}"/>
    <input type="hidden" name="currentPageNo" value="${param.currentPageNo}"/>
</form>

<script>
    // goList(): 목록 버튼 클릭 시 목록 페이지로 이동 (검색 조건 + 페이지 번호 유지)
    function goList() {
        let f = document.querySelector('#actionForm');
        f.action = 'board/list.do';
        f.submit();
    }

    // goEdit(): 수정 버튼 클릭 시 비밀번호 확인 후 수정 폼으로 이동
    function goEdit() {
        let pw = document.querySelector('#writerPw').value.trim();
        if (!pw) { alert('비밀번호를 입력하세요.'); return; }
        document.querySelector('#fWriterPw').value = pw; // 입력한 비밀번호를 hidden 에 세팅
        let f = document.querySelector('#actionForm');
        f.action = 'board/edit.do';
        f.submit();
    }

    // goDelete(): 삭제 버튼 클릭 시 비밀번호 확인 + confirm 후 삭제 처리
    function goDelete() {
        let pw = document.querySelector('#writerPw').value.trim();
        if (!pw) { alert('비밀번호를 입력하세요.'); return; }
        if (!confirm('삭제하시겠습니까?')) return;
        document.querySelector('#fWriterPw').value = pw;
        let f = document.querySelector('#actionForm');
        f.action = 'board/delete.do';
        f.submit();
    }

    // goReply(): 답변등록 버튼 클릭 시 답변 폼으로 이동 (boardNo 포함)
    function goReply() {
        let f = document.querySelector('#actionForm');
        f.action = 'board/reply.do';
        f.submit();
    }

    // goDownload(fileNo): 첨부파일 링크 클릭 시 POST 방식으로 다운로드 요청
    // 이유: 다운로드도 POST 전용 컨트롤러이므로 <a href="..."> 대신 form 을 동적 생성해서 전송
    function goDownload(fileNo) {
        let form = document.createElement('form');
        form.method = 'post';
        form.action = 'board/download.do';
        let inp = document.createElement('input');
        inp.type  = 'hidden';
        inp.name  = 'fileNo';
        inp.value = fileNo;
        form.appendChild(inp);
        document.body.appendChild(form);
        form.submit();
    }

    // updateHit(): 페이지 로드 시 Ajax 로 조회수 +1 후 화면 갱신
    // Ajax 를 쓰는 이유: 조회수 증가 후 페이지 전체를 리로드하지 않기 위해
    async function updateHit() {
        try {
            let boardNo  = document.querySelector('#boardNo').value;
            let response = await fetch('board/updateHitAjax.do', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ boardNo: boardNo })
            });
            let hit = await response.text(); // 컨트롤러가 숫자(증가된 조회수)만 반환
            document.querySelector('#hit').innerText = hit;
        } catch (e) {
            console.error(e);
        }
    }

    // DOMContentLoaded: 비밀번호 오류로 돌아온 경우(pwError=1)는 조회수 중복 증가 방지
    document.addEventListener('DOMContentLoaded', function() {
        if ('${pwError}' !== '1') updateHit();
    });
</script>

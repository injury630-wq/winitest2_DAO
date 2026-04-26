<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container detail-container">
    <h2>게시판 조회</h2>

    <c:if test="${not empty parentBoard}">
        <div class="bg-light p-3 text-truncate mb-3" style="max-width:100%;">
            <span>(원글제목) </span><c:out value="${parentBoard.title}"/>
        </div>
    </c:if>
    <table class="detail-table">
        <tr>
            <th>제목</th>
            <td colspan="3" class="text-truncate" style="max-width:0;" title="<c:out value="${board.title}"/>">
                <c:out value="${board.title}"/>
            </td>
        </tr>
        <tr>
            <th>작성자</th>
            <td><c:out value="${board.writerName}"/></td>
            <th>등록일</th>
            <td>${board.regDate}</td>
        </tr>
        <tr>
            <th>조회수</th>
            <td colspan="3" id="hit">${board.hit}</td>
        </tr>
        <tr>
            <th>내용</th>
            <td colspan="3"><div class="content-area"><c:out value="${board.content}"/></div></td>
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
                                    <c:out value="${file.orgName}"/>
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

    <div class="d-flex justify-content-between align-items-start mt-3">
        <div>
            <button class="btn btn-secondary" onclick="goList()">목록</button>
        </div>
        <div>
            <div class="d-flex gap-2 align-items-center">
              	<input type="${board.userNo != loginUser.userNo ? 'password' : 'hidden'}" id="writerPw" class="form-control" style="width:150px;" placeholder="비밀번호 입력"/>
                <button class="btn btn-success" onclick="goEdit(${loginUser.userNo})">수정</button>
                <button class="btn btn-danger" onclick="goDelete(${loginUser.userNo})">삭제</button>
                <c:if test="${board.reLev < 2 and replyCount < 5}">
                    <button class="btn btn-info" onclick="goReply()">답변등록</button>
                </c:if>
            </div>
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

<form id="actionForm" method="post">
    <input type="hidden" name="boardNo"       id="boardNo"    value="${board.boardNo}"/>
    <input type="hidden" name="writerPw"      id="fWriterPw"  value=""/>
    <input type="hidden" name="searchType"    value="<c:out value="${param.searchType}"/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value="${param.searchKeyword}"/>"/>
    <input type="hidden" name="currentPageNo" value="${param.currentPageNo}"/>
</form>

<script>
    function goList() {
        let f = document.querySelector('#actionForm');
        f.action = 'board/list.do';
        f.submit();
    }

    function goEdit(loginUserNo) {
    	let boardUserNo = ${board.userNo};
    	const pwInput = document.querySelector('#writerPw');
        let f = document.querySelector('#actionForm');
        if (loginUserNo != boardUserNo) {
            let pw = pwInput.value.trim();
            if (!pw) {
                alert('비밀번호를 입력하세요.');
                return;
            }
            document.querySelector('#fWriterPw').value = pw;
        }
        f.action = 'board/edit.do';
        f.submit();
    }

    function goDelete(loginUserNo) {
    	let boardUserNo = ${board.userNo};
    	const pwInput = document.querySelector('#writerPw');
        let f = document.querySelector('#actionForm');
        if (loginUserNo != boardUserNo) {
            let pw = pwInput.value.trim();
            if (!pw) {
                alert('비밀번호를 입력하세요.');
                return;
            }
            document.querySelector('#fWriterPw').value = pw;
        }
        if (!confirm('삭제하시겠습니까?')) return;
        f.action = 'board/delete.do';
        f.submit();
    }

    function goReply() {
        let f = document.querySelector('#actionForm');
        f.action = 'board/reply.do';
        f.submit();
    }

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

    async function updateHit() {
        try {
            let boardNo  = document.querySelector('#boardNo').value;
            let response = await fetch('board/updateHitAjax.do', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ boardNo: boardNo })
            });
            let hit = await response.text();
            document.querySelector('#hit').innerText = hit;
        } catch (e) {
            console.error(e);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        if ('${pwError}' !== '1') updateHit();
    });
</script>

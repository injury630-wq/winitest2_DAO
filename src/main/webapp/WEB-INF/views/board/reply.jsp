<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
    reply.jsp 는 goPost(__navForm) 대신 직접 <form> 을 보유한다.
--%>
<div class="container">
    <h2>답변글 등록</h2>

    <div class="bg-light p-3 text-truncate" style="max-width: 100%;"> <span>(원글제목) </span> ${board.title}</div>

    <form action="board/replyProc.do" method="post" enctype="multipart/form-data">
        <%-- boardNo: replyProc 에서 답글 수 체크(countReplyByRef)를 위한 ref 값이 이 form 에 포함됨 --%>
        <input type="hidden" name="parentNo" value="${board.boardNo}"/>
        <input type="hidden" name="ref"      value="${board.ref}"/>
        <input type="hidden" name="reLev"    value="${board.reLev}"/>
        <input type="hidden" name="reSeq"    value="${board.reSeq}"/>
        <input type="hidden" name="searchType"    value="${param.searchType}"/>
        <input type="hidden" name="searchKeyword"    value="${param.searchKeyword}"/>
        <input type="hidden" name="currentPageNo"    value="${param.currentPageNo}"/>
        <table>
            <tr>
                <th><span class="required">*</span>작성자</th>
                <td>
                    <input type="text" name="writerId" class="form-control" value="${sessionScope.loginUser.userName}" readonly required/>
                </td>
                <th><span class="required">*</span>비밀번호</th>
                <td>
                    <input type="password" name="writerPw" class="form-control" placeholder="비밀번호 입력" maxlength="50" required/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>제목</th>
                <td colspan="3">
                    <input type="text" name="title" class="form-control" value="Re: ${board.title}" maxlength="160" required/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>내용</th>
                <td colspan="3">
                    <textarea name="content" class="form-control" rows="8" placeholder="내용 입력" maxlength="2800" required></textarea>
                </td>
            </tr>
            <tr>
                <th>첨부파일</th>
                <td colspan="3">
                    <input type="file" multiple name="uploadFile" class="form-control" id="replyFileInput"/>
                    <span class="text-muted" style="font-size:12px;">shift 혹은 ctrl을 눌러 여러 파일 등록가능합니다.</span>
                    <%-- 선택한 파일 목록 표시 영역 --%>
                    <div id="replyFileList"></div>
                </td>
            </tr>
        </table>
        <div class="d-flex justify-content-center gap-2 mt-3">
            <button type="button" class="btn btn-outline-secondary"
                    onclick="goPost('board/detail.do', {boardNo:'${board.boardNo}', currentPageNo:'${param.currentPageNo}', searchKeyword:'${param.searchKeyword}', searchType:'${param.searchType}'})">취소</button>
            <button type="submit" class="btn btn-danger" onclick="return validate()">저장</button>
        </div>
    </form>
</div>

<script>
function validate() {
    let writerPw = document.querySelector("input[name=writerPw]").value.trim();
    let title    = document.querySelector("input[name=title]").value.trim();
    let content  = document.querySelector("textarea[name=content]").value.trim();
    if (!writerPw) { alert('비밀번호를 입력하세요.'); return false; }
    if (!title)    { alert('제목을 입력하세요.'); return false; }
    if (!content)  { alert('내용을 입력하세요.'); return false; }
    return true;
}

// 파일 첨부 선택 시 개수/개별 용량/총 용량 제한 체크 및 목록 표시
document.getElementById('replyFileInput').addEventListener('change', function () {
    const MAX_COUNT = 5;
    const MAX_FILE_SIZE  = 10 * 1024 * 1024; // 파일 1개당 10MB
    const MAX_TOTAL_SIZE = 50 * 1024 * 1024; // 전체 합산 50MB

    let files = this.files;
    let replyFileList = document.getElementById('replyFileList');

    // 목록 초기화
    replyFileList.innerHTML = "";

    if (!files || files.length === 0) return;

    // 개수 체크
    if (files.length > MAX_COUNT) {
        alert("파일은 최대 " + MAX_COUNT + "개까지만 첨부할 수 있습니다.");
        this.value = "";
        return;
    }

    // 개별 용량 및 총 용량 체크
    let totalSize = 0;
    for (const file of files) {
        if (file.size > MAX_FILE_SIZE) {
            alert("[" + file.name + "] 파일은 10MB를 초과합니다.");
            this.value = "";
            return;
        }
        totalSize += file.size;
    }
    if (totalSize > MAX_TOTAL_SIZE) {
        alert("첨부파일 총 용량이 50MB를 초과합니다.");
        this.value = "";
        return;
    }

    // 선택한 파일 목록 표시
    for (let i = 0; i < files.length; i++) {
        let file = files[i];
        let div  = document.createElement('div');
        div.className = "file-item";
        div.textContent = file.name + "  [" + file.size.toLocaleString() + " bytes]";
        replyFileList.appendChild(div);
    }
});
</script>

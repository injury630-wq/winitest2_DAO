<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container">
    <h2>게시판 등록</h2>
    <form action="board/writeProc.do" method="post" enctype="multipart/form-data">
        <input type="hidden" name="searchType"    value="<c:out value="${param.searchType}"/>"/>
        <input type="hidden" name="searchKeyword" value="<c:out value="${param.searchKeyword}"/>"/>
        <table>
            <tr>
                <th><span class="required">*</span>작성자</th>
                <td>
                    <input type="text" name="writerId" class="form-control"
                           value="<c:out value="${sessionScope.loginUser.userName}"/>" readonly/>
                </td>
                <th><span class="required">*</span>비밀번호</th>
                <td>
                    <input type="password" name="writerPw" class="form-control" placeholder="비밀번호 입력" maxlength="50" required/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>제목</th>
                <td colspan="3">
                    <input type="text" name="title" class="form-control" placeholder="제목 입력" maxlength="160" required/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>내용</th>
                <td colspan="3">
                    <textarea name="content" class="form-control" rows="8" placeholder="내용 입력" maxlength="2800" required></textarea>
                </td>
            </tr>
            <tr>
                <th>첨부</th>
                <td colspan="3">
                    <input type="file" multiple name="uploadFile" class="form-control" id="fileInput"/>
                    <span class="text-muted" style="font-size:12px;">shift 혹은 ctrl을 눌러 여러 파일 등록가능합니다.</span>
					<div class="file-item file-item-temp" style="display:none;">
					    <span class="file-name">파일이름[byte]</span>
					</div>
					<div id="fileList"></div>
                </td>
            </tr>
        </table>
        <div class="d-flex justify-content-center gap-2 mt-3">
            <button type="button" class="btn btn-outline-secondary" onclick="goCancel()">취소</button>
            <button type="submit" class="btn btn-danger" onclick="return validate()">저장</button>
        </div>
    </form>
</div>

<%-- 취소 버튼용 폼: 검색 조건 유지하여 목록 복귀 --%>
<form id="cancelForm" method="post" action="board/list.do">
    <input type="hidden" name="searchType"    value="<c:out value="${param.searchType}"/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value="${param.searchKeyword}"/>"/>
</form>

<script>
function goCancel() {
    document.querySelector('#cancelForm').submit();
}

function validate() {
    let writerPw = document.querySelector("input[name=writerPw]").value.trim();
    let title    = document.querySelector("input[name=title]").value.trim();
    let content  = document.querySelector("textarea[name=content]").value.trim();
    if (!writerPw) { alert("비밀번호를 입력하세요."); return false; }
    if (!title)    { alert("제목을 입력하세요."); return false; }
    if (!content)  { alert("내용을 입력하세요."); return false; }
    return true;
}

const fileInput = document.getElementById('fileInput');

fileInput.addEventListener('change', function () {
    const MAX_COUNT      = 5;
    const MAX_FILE_SIZE  = 10 * 1024 * 1024;
    const MAX_TOTAL_SIZE = 50 * 1024 * 1024;

    let files    = this.files;
    let fileList = document.querySelector("#fileList");
    let template = document.querySelector(".file-item-temp");

    fileList.innerHTML = "";

    if (!files || files.length === 0) return;

    if (files.length > MAX_COUNT) {
        alert("파일은 최대 " + MAX_COUNT + "개까지만 첨부할 수 있습니다.");
        this.value = "";
        return;
    }

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

    for (let i = 0; i < files.length; i++) {
        let file  = files[i];
        let clone = template.cloneNode(true);
        clone.style.display = "block";
        clone.querySelector(".file-name").textContent =
            file.name + "  [" + file.size.toLocaleString() + " bytes]";
        fileList.appendChild(clone);
    }
});
</script>

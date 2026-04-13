<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
    edit.jsp 는 goPost(__navForm) 대신 직접 <form> 을 보유한다.
    이유: 파일 첨부(신규 파일 추가)가 있으므로 enctype="multipart/form-data" 가 필요하다.
         boardNo/writerPw 는 서버에서 렌더링된 값으로 이미 hidden 에 들어있어
         전용 form 이 가장 간단하다.
--%>
<div class="container">
    <h2>게시판 수정</h2>
    <form action="board/editProc.do" method="post" enctype="multipart/form-data">
        <input type="hidden" name="boardNo"       value="${board.boardNo}"/>
        <input type="hidden" name="writerPw"      value="${board.writerPw}"/>
        <input type="hidden" name="searchType"    value="${param.searchType}"/>
        <input type="hidden" name="searchKeyword" value="${param.searchKeyword}"/>
        <input type="hidden" name="currentPageNo" value="${param.currentPageNo}"/>
        <table>
            <tr>
                <th>작성자</th>
                <td>
                    <input type="text" class="form-control" value="${board.writerName}" readonly/>
                </td>
                <th>등록일</th>
                <td>
                    <input type="text" class="form-control" value="${board.regDate}" readonly/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>제목</th>
                <td colspan="3">
                    <input type="text" name="title" class="form-control" value="${board.title}" maxlength="200"/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>내용</th>
                <td colspan="3">
                    <textarea name="content" class="form-control" rows="8" maxlength="3000">${board.content}</textarea>
                </td>
            </tr>
            <tr>
                <th>첨부파일</th>
                <td colspan="3">
                    <div class="file-item" id="file-item-temp" style="display:none;">
                        <span class="file-name"></span>
                        <button type="button" class="btn btn-danger btn-sm js-file-delete">X</button>
                    </div>
                    <div id="file-item-wrap">
                        <c:if test="${not empty fileList}">
                            <c:forEach var="file" items="${fileList}">
                                <%-- data-file-size: 기존 파일 용량 합산 체크에 사용 --%>
                                <div class="file-item" data-file-size="${file.fileSize}">
                                    <span>${file.fileName}
                                        [<fmt:formatNumber value="${file.fileSize}" pattern="#,###"/> byte]
                                    </span>
                                    <button type="button" class="btn btn-danger btn-sm"
                                            onclick="deleteFile(${file.fileNo})">X</button>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>
                    <div class="mt-2">
                        <input type="file" multiple name="uploadFile" class="form-control" id="editFileInput"/>
                        <span class="text-muted" style="font-size:12px;">shift 혹은 ctrl을 눌러 여러 파일 등록가능합니다.</span>
                        <%-- 새로 선택한 파일 목록 표시 영역 --%>
                        <div id="newFileList"></div>
                    </div>
                </td>
            </tr>
        </table>
        <div class="d-flex justify-content-center gap-2 mt-3">
            <button type="button" class="btn btn-outline-secondary"
                    onclick="goPost('board/detail.do', {boardNo:'${board.boardNo}', searchType:'${param.searchType}', searchKeyword:'${param.searchKeyword}', currentPageNo:'${param.currentPageNo}'})">취소</button>
            <button type="submit" class="btn btn-danger" onclick="return validate()">저장</button>
        </div>
    </form>
</div>

<script>
async function deleteFile(fileNo) {
    if (!confirm('파일을 삭제하시겠습니까?')) return;
    try {
        let response = await fetch('board/deleteFile.do?fileNo=' + fileNo);
        let result   = await response.json();
        if (result.msg === 'success') {
            alert('삭제됐습니다.');
            let wrap = document.querySelector('#file-item-wrap');
            wrap.innerHTML = '';
            result.fileList.forEach(function(file) {
                let row = document.querySelector('#file-item-temp').cloneNode(true);
                row.removeAttribute('id');
                row.style.display = '';
                row.querySelector('.file-name').textContent =
                    file.fileName + ' [' + file.fileSize.toLocaleString() + ' byte]';
                row.querySelector('.js-file-delete').addEventListener('click', function() {
                    deleteFile(file.fileNo);
                });
                wrap.appendChild(row);
            });
        } else {
            alert('삭제에 실패했습니다.');
        }
    } catch (e) {
        alert('오류가 발생했습니다.');
    }
}

function validate() {
    let title   = document.querySelector("input[name=title]").value.trim();
    let content = document.querySelector("textarea[name=content]").value.trim();
    if (!title)   { alert('제목을 입력하세요.'); return false; }
    if (!content) { alert('내용을 입력하세요.'); return false; }
    return true;
}

// 파일 첨부 선택 시 개수/용량 제한 체크 (기존 파일 + 새 파일 합산)
document.getElementById('editFileInput').addEventListener('change', function () {
    const MAX_COUNT = 5;
    const MAX_FILE_SIZE = 10 * 1024 * 1024; // 파일 1개당 10MB
    const MAX_TOTAL_SIZE = 50 * 1024 * 1024; // 전체 합산 50MB

    let newFiles = this.files; // input의 fileList
    let newFileList = document.getElementById('newFileList'); // 새 파일 view

    // 새 파일 목록 초기화
    newFileList.innerHTML = "";

    if (!newFiles || newFiles.length === 0) return;

    // 현재 남아있는 기존 파일 수와 용량 합산
    let existingItems = document.querySelectorAll('#file-item-wrap .file-item');
    let existingCount = existingItems.length;
    let existingTotalSize = 0;
    existingItems.forEach(function (item) {
    	// 기존 파일들의 크기 문자열 숫자로 변환&합산
    	let fileSize = (item.dataset.fileSize) ? parseInt(item.dataset.fileSize, 10) : 0;
        existingTotalSize += fileSize;
    });

    // 기존 + 새 파일 개수 체크
    if (existingCount + newFiles.length > MAX_COUNT) {
        alert("파일은 기존 파일 포함 최대 " + MAX_COUNT + "개까지 첨부할 수 있습니다.\n현재 기존 파일: " + existingCount + "개");
        this.value = "";
        return;
    }

    // 새 파일 개별 용량 체크 및 총 용량 체크
    let newTotalSize = 0;
    for (const file of newFiles) {
        if (file.size > MAX_FILE_SIZE) {
            alert("[" + file.name + "] 파일은 10MB를 초과합니다.");
            this.value = "";
            return;
        }
        newTotalSize += file.size;
    }
    if (existingTotalSize + newTotalSize > MAX_TOTAL_SIZE) {
        alert("첨부파일 총 용량이 50MB를 초과합니다.");
        this.value = "";
        return;
    }

    // 선택한 새 파일 목록 표시
    for (let i = 0; i < newFiles.length; i++) {
        let file = newFiles[i];
        let div  = document.createElement('div');
        div.className = "file-item";
        div.textContent = file.name + "  [" + file.size.toLocaleString() + " bytes]";
        newFileList.appendChild(div);
    }
});
</script>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container">
    <h2><c:choose>
        <c:when test="${not empty gallery}">이미지 게시글 수정</c:when>
        <c:otherwise>이미지 게시글 등록</c:otherwise>
    </c:choose></h2>

    <form id="galleryForm" enctype="multipart/form-data">
        <input type="hidden" name="boardNo"     value="${gallery.boardNo}"/>
        <input type="hidden" name="content"     id="contentInput"/>
        <input type="hidden" name="thumbFileNo" id="thumbFileNo"/>

        <table>
            <tr>
                <th><span class="required">*</span>제목</th>
                <td>
                    <input type="text" name="title" id="titleInput" class="form-control"
                           value="<c:out value="${gallery.title}"/>" placeholder="제목 입력" maxlength="160"/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>내용</th>
                <td>
                    <div id="savedContent" style="display:none"><c:out value="${gallery.content}" escapeXml="false"/></div>
                    <div id="editor" contenteditable="true"
                         style="min-height:200px; max-height:500px; overflow-y:auto; overflow-x:hidden;
                                border:1px solid #ced4da; border-radius:4px; padding:8px; word-break:break-all;"></div>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>이미지 첨부</th>
                <td>
                    <%-- 파일 행 템플릿 (cloneNode용, 화면에 표시 안 됨) --%>
                    <div class="file-template" style="display:none;">
                        <input type="radio" name="thumbSelect"/>
                        <span class="file-name"></span>
                        <button type="button" class="btn btn-danger btn-sm">X</button>
                    </div>

                    <div id="fileList" class="mb-1">
                        <c:forEach var="file" items="${existingFiles}">
                            <div class="file-item d-flex align-items-center gap-2" id="file_${file.fileNo}">
                                <input type="radio" name="thumbSelect" value="${file.fileNo}"/>
                                <span><c:out value="${file.orgName}"/> [<fmt:formatNumber value="${file.fileSize}" pattern="#,###"/> byte]</span>
                                <button type="button" class="btn btn-danger btn-sm" onclick="removeFile(${file.fileNo}, false)">X</button>
                            </div>
                        </c:forEach>
                    </div>
                    <div id="deletedFileNos"></div>
                    <input type="file" id="fileInput" class="form-control" accept="image/*" multiple/>
                </td>
            </tr>
        </table>

        <div class="d-flex justify-content-center gap-2 mt-3">
            <button type="button" class="btn btn-outline-secondary" onclick="$('#cancelForm').submit()">취소</button>
            <button type="button" id="btnSave" class="btn btn-danger" onclick="validateAndSave()">저장</button>
        </div>
    </form>
</div>

<form id="cancelForm" method="post"
      action="${not empty gallery.boardNo ? 'gallery/detail.do' : 'gallery/list.do'}">
    <input type="hidden" name="boardNo" value="${gallery.boardNo}"/>
</form>

<style>
#editor img {
    width: 300px; height: 300px; object-fit: contain;
    background-color: #f8f9fa; border-radius: 4px;
    margin: 4px; display: inline-block; vertical-align: top;
}
</style>

<script>
var MAX_COUNT = 5, MAX_PER = 10 * 1024 * 1024, MAX_TOTAL = 50 * 1024 * 1024;

/*
 * - 수정 모드: 서버에서 받은 기존 내용을 에디터에 복원하고 기존 썸네일 라디오를 선택 상태로 설정
 * - 파일 선택 이벤트: 개수/용량 검사 후 서버에 임시 업로드, 성공하면 addFile() 호출 */
$(function () {
    var saved = $('#savedContent').html();
    if (saved) $('#editor').html(saved);

    let thumbNo = '${gallery.thumbFileNo}';
    if (thumbNo) $('input[name="thumbSelect"][value="' + thumbNo + '"]').prop('checked', true);

    $('#fileInput').on('change', function () {
        var files = this.files;
        if (!files.length) return;

        var currentCount = $('#fileList .file-item').length;
        if (currentCount + files.length > MAX_COUNT) {
            alert('파일은 최대 ' + MAX_COUNT + '개까지 첨부할 수 있습니다. (현재 ' + currentCount + '개)');
            $(this).val(''); return;
        }

        var totalSize = 0;
        $('#editor img[data-filesize]').each(function () { totalSize += parseInt($(this).data('filesize')) || 0; });
        for (var i = 0; i < files.length; i++) {
            if (files[i].size > MAX_PER) { alert('[' + files[i].name + '] 파일은 10MB를 초과합니다.'); $(this).val(''); return; }
            totalSize += files[i].size;
        }
        if (totalSize > MAX_TOTAL) { alert('총 용량이 50MB를 초과합니다.'); $(this).val(''); return; }

        var formData = new FormData();
        $.each(files, function (i, f) { formData.append('uploadFile', f); });
        $(this).val('');
        $('#btnSave').prop('disabled', true);

        $.ajax({
            url: 'gallery/uploadTempFile.do', type: 'POST',
            data: formData, processData: false, contentType: false,
            success: function (res) {
                if (res.msg === 'S') $.each(res.files, function (i, f) { addFile(f); });
                else alert('업로드 중 오류가 발생했습니다.');
            },
            error:    function () { alert('업로드 중 오류가 발생했습니다.'); },
            complete: function () { $('#btnSave').prop('disabled', false); }
        });
    });
});

/* 서버 임시 업로드 완료 후 호출
 * - 에디터에 이미지 미리보기 삽입 (data-fileno: 신규 파일 식별, data-filesize: 용량 합산용)
 * - 파일 템플릿을 복제해서 파일 목록에 행 추가 (라디오·파일명·X버튼 세팅)
 * - 첫 번째 파일이면 썸네일 라디오 자동 선택 */
function addFile(f) {
    $('#editor').append(
        '<img src="gallery/imgView.do?fileNo=' + f.fileNo + '"'
        + ' data-fileno="' + f.fileNo + '" data-filesize="' + (f.fileSize || 0) + '">'
    );

    var clone = document.querySelector('.file-template').cloneNode(true);
    clone.className = 'file-item d-flex align-items-center gap-2';
    clone.id        = 'file_' + f.fileNo;
    clone.querySelector('input[type="radio"]').value = f.fileNo;
    clone.querySelector('.file-name').textContent    = f.orgName + ' [' + Number(f.fileSize || 0).toLocaleString() + ' bytes]';
    clone.querySelector('button').onclick = function () { removeFile(f.fileNo, true); };
    document.getElementById('fileList').appendChild(clone);

    if (!document.querySelector('input[name="thumbSelect"]:checked')) {
        clone.querySelector('input[type="radio"]').checked = true;
    }
}

/* 파일 제거
 * - isNew=true (신규): 에디터에서 data-fileno로 img 제거
 * - isNew=false (기존): 에디터에서 src로 img 제거 + deleteFileNo hidden 추가 (서버에서 논리삭제 처리)
 * - 제거한 파일이 썸네일이었으면 첫 번째 남은 라디오를 자동 선택 */
function removeFile(fileNo, isNew) {
    var wasChecked = document.querySelector('#file_' + fileNo + ' input[type="radio"]').checked;
    $('#file_' + fileNo).remove();
    if (isNew) {
        $('#editor img[data-fileno="' + fileNo + '"]').remove();
    } else {
        $('#editor img[src*="fileNo=' + fileNo + '"]').remove();
        $('#deletedFileNos').append('<input type="hidden" name="deleteFileNo" value="' + fileNo + '">');
    }
    if (wasChecked) {
        var first = document.querySelector('input[name="thumbSelect"]');
        if (first) first.checked = true;
    }
}

/* 저장 버튼 클릭
 * - 제목·이미지·썸네일 선택 검증
 * - 에디터의 신규 img(data-fileno)를 순회해서 activeFileNo hidden 추가 (서버에서 임시→활성 전환)
 * - 에디터 innerHTML을 content hidden에 담아 Ajax로 전송 */
function validateAndSave() {
    if (!$('#titleInput').val().trim())                 { alert('제목을 입력하세요.'); return; }
    if ($('#editor img').length === 0)                  { alert('이미지를 최소 1개 등록해야 합니다.'); return; }
    if (!$('input[name="thumbSelect"]:checked').length) { alert('썸네일을 선택해야 합니다.'); return; }

    $('#thumbFileNo').val($('input[name="thumbSelect"]:checked').val());

    $('input[name="activeFileNo"]').remove();
    $('#editor img[data-fileno]').each(function () {
        $('#galleryForm').append($('<input type="hidden" name="activeFileNo">').val($(this).data('fileno')));
    });
    $('#contentInput').val($('#editor').html().trim());

    $.ajax({
        url: 'gallery/saveAjax.do', type: 'POST',
        data: new FormData($('#galleryForm')[0]),
        processData: false, contentType: false,
        success: function (res) {
            if      (res.msg === 'S') { alert(res.mode === 'insert' ? '등록되었습니다.' : '수정되었습니다.'); goPost('gallery/detail.do', { boardNo: res.boardNo, noHit: 'Y' }); }
            else if (res.msg === 'X') { alert('수정 권한이 없습니다.'); }
            else                      { alert('처리 실패'); }
        },
        error: function () { alert('서버 오류'); }
    });
}
</script>

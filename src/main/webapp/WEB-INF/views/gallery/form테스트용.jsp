<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container">
    <h2>이미지 게시글 ${empty gallery ? '등록' : '수정'}</h2>

    <form id="galleryForm">
        <input type="hidden" name="boardNo" value="${gallery.boardNo}"/>
        <input type="hidden" name="content" id="contentInput"/>
        <input type="hidden" name="thumbFileNo" id="thumbFileNoInput"/>

        <table class="table border">
            <tr>
                <th width="20%">작성자</th>
                <td><input type="text" class="form-control" value="${sessionScope.loginUser.userName}" readonly/></td>
            </tr>
            <tr>
                <th>제목</th>
                <td>
                    <input type="text" name="title" id="titleInput" class="form-control" 
                           value="<c:out value='${gallery.title}'/>" placeholder="제목을 입력하세요."/>
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <div id="editor" contenteditable="true" class="form-control" 
                         style="min-height:300px; height:auto; overflow-y:auto; word-break:break-all;">
                        <c:out value="${gallery.content}" escapeXml="false"/>
                    </div>
                    <small class="text-muted">이미지는 아래에서 첨부 시 본문에 삽입됩니다.</small>
                </td>
            </tr>
            <tr>
                <th>이미지 첨부</th>
                <td>
                    <div id="fileListContainer" class="mb-2">
                        <c:forEach var="file" items="${existingFiles}">
                            <div class="file-item d-flex align-items-center gap-2 mb-1" data-file-no="${file.fileNo}">
                                <label class="mb-0">
                                    <input type="radio" name="thumbSelect" value="${file.fileNo}" 
                                           ${gallery.thumbFileNo == file.fileNo ? 'checked' : ''}> 썸네일
                                </label>
                                <span class="file-info">${file.orgName}</span>
                                <button type="button" class="btn btn-sm btn-danger py-0" onclick="removeFile('${file.fileNo}')">x</button>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <input type="file" id="fileInput" class="form-control" accept="image/*" multiple/>
                    <div id="deletedFileNos"></div> </td>
            </tr>
        </table>

        <div class="text-center mt-3">
            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
            <button type="button" id="btnSave" class="btn btn-primary" onclick="validateAndSave()">저장</button>
        </div>
    </form>
</div>

<style>
    #editor { border: 1px solid #dee2e6; padding: 15px; outline: none; }
    #editor:focus { border-color: #86b7fe; box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25); }
    #editor img { max-width: 100%; height: auto; display: block; margin: 10px 0; border: 1px solid #eee; }
    .file-item { background: #f8f9fa; padding: 5px 10px; border-radius: 4px; border: 1px solid #e9ecef; }
</style>

<script>
/**
 * [핵심 로직]
 * 1. 파일 선택 즉시 서버 업로드 (임시 상태)
 * 2. 성공 시 본문에 <img> 태그 삽입 (data-file-no 속성 부여)
 * 3. 삭제 시 본문의 <img>와 목록의 item을 data-file-no로 찾아 동시 삭제
 * 4. 저장 시 본문에 남아있는 <img>의 data-file-no들만 수집하여 '사용' 처리
 */

$(function() {
    // 파일 선택 이벤트
    $('#fileInput').on('change', function() {
        const files = this.files;
        if (!files.length) return;

        const formData = new FormData();
        for (let file of files) formData.append('uploadFile', file);

        $('#btnSave').prop('disabled', true);

        $.ajax({
            url: 'gallery/uploadTempFile.do',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(res) {
                if (res.msg === 'S') {
                    res.files.forEach(file => addFileElement(file));
                } else {
                    alert('업로드 실패');
                }
            },
            complete: () => {
                $('#btnSave').prop('disabled', false);
                $('#fileInput').val(''); // 파일 input 초기화
            }
        });
    });
});

// 파일 요소 추가 (에디터 이미지 + 하단 목록)
function addFileElement(file) {
    // 1. 에디터에 이미지 삽입 (현재 커서 위치 또는 끝)
    const imgHtml = `<img src="gallery/imgView.do?fileNo=${file.fileNo}" data-file-no="${file.fileNo}">`;
    document.getElementById('editor').focus();
    document.execCommand('insertHTML', false, imgHtml);

    // 2. 하단 목록 추가
    const itemHtml = `
        <div class="file-item d-flex align-items-center gap-2 mb-1" data-file-no="${file.fileNo}">
            <label class="mb-0">
                <input type="radio" name="thumbSelect" value="${file.fileNo}"> 썸네일
            </label>
            <span class="file-info">${file.orgName} (${Math.round(file.fileSize/1024)}KB)</span>
            <button type="button" class="btn btn-sm btn-danger py-0" onclick="removeFile('${file.fileNo}')">x</button>
        </div>`;
    $('#fileListContainer').append(itemHtml);

    // 첫 이미지면 자동 썸네일 체크
    if ($('input[name="thumbSelect"]:checked').length === 0) {
        $('input[name="thumbSelect"][value="' + file.fileNo + '"]').prop('checked', true);
    }
}

// 파일 삭제 (통합)
function removeFile(fileNo) {
    // 본문 이미지 제거
    $(`#editor img[data-file-no="${fileNo}"]`).remove();
    // 목록 제거
    $(`.file-item[data-file-no="${fileNo}"]`).remove();
    
    // 기존에 저장되어있던 파일이면 삭제 목록(hidden)에 추가
    // (보통 숫자면 기존 파일, 'new_' 같은 식별자면 신규 파일로 구분 가능)
    // 여기서는 단순화하여 기존 파일 리스트에 있었는지 확인 후 추가
    if (!isNaN(fileNo)) { 
        $('#deletedFileNos').append(`<input type="hidden" name="deleteFileNo" value="${fileNo}">`);
    }
}

// 저장 전 데이터 수집 및 검증
function validateAndSave() {
    const $editor = $('#editor');
    const title = $('#titleInput').val().trim();
    const thumbNo = $('input[name="thumbSelect"]:checked').val();

    if (!title) return alert('제목을 입력하세요.');
    if ($editor.find('img').length === 0) return alert('이미지를 최소 1개 등록해야 합니다.');
    if (!thumbNo) return alert('썸네일을 선택해주세요.');

    // 1. 본문 내용 셋팅
    $('#contentInput').val($editor.html().trim());
    
    // 2. 선택된 썸네일 번호 셋팅
    $('#thumbFileNoInput').val(thumbNo);

    // 3. 현재 에디터 본문에 "실제로 남아있는" 이미지 번호들만 수집
    // (업로드 후 삭제한 이미지는 여기서 제외됨)
    const formData = new FormData($('#galleryForm')[0]);
    $editor.find('img').each(function() {
        formData.append('activeFileNos', $(this).data('file-no'));
    });

    $.ajax({
        url: 'gallery/saveAjax.do',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(res) {
            if (res.msg === 'S') {
                alert('저장되었습니다.');
                location.href = 'gallery/detail.do?boardNo=' + res.boardNo;
            } else {
                alert('처리 중 오류 발생');
            }
        }
    });
}
</script>
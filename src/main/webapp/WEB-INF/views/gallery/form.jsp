<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container">
    <h2><c:choose>
        <c:when test="${not empty gallery}">이미지 게시글 수정</c:when>
        <c:otherwise>이미지 게시글 등록</c:otherwise>
    </c:choose></h2>

    <form id="galleryForm" action="gallery/save.do" method="post" enctype="multipart/form-data">
        <input type="hidden" name="boardNo"     value="${gallery.boardNo}"/>
        <input type="hidden" name="content"     id="contentInput" value=""/>
        <input type="hidden" name="thumbFileNo" id="thumbFileNo"  value=""/>
        <%-- [구방식 롤백용] thumbIndex: __IMG_N__ 방식에서 신규 파일 인덱스로 썸네일 지정 시 사용
        <input type="hidden" name="thumbIndex"  id="thumbIndex"   value="-1"/>
        --%>

        <table>
            <tr>
                <th><span class="required">*</span>작성자</th>
                <td>
                    <input type="text" class="form-control"
                           value="<c:out value="${sessionScope.loginUser.userName}"/>" readonly/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>제목</th>
                <td>
                    <input type="text" name="title" id="titleInput" class="form-control"
                           value="<c:out value="${gallery.title}"/>"
                           placeholder="제목 입력" maxlength="160"/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>내용</th>
                <td>
                    <div id="savedContent" style="display:none">${gallery.content}</div>
                    <div id="editor" contenteditable="true"
                         style="min-height:200px; max-height:500px; overflow-y:auto;
                                overflow-x:hidden; border:1px solid #ced4da;
                                border-radius:4px; padding:8px; word-break:break-all;"></div>
                    <small class="text-muted">이미지는 아래에서 첨부하면 미리보기로 표시됩니다.</small>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>이미지 첨부</th>
                <td>
                    <%-- 수정 모드: 기존 파일 목록 --%>
                    <c:if test="${not empty existingFiles}">
                        <div id="existingFileList" class="mb-2">
                            <c:forEach var="file" items="${existingFiles}">
                                <div class="file-item d-flex align-items-center gap-2"
                                     id="existingFile_${file.fileNo}">
                                    <label class="d-flex align-items-center gap-1 mb-0">
                                        <input type="radio" name="thumbSelect"
                                               value="existing_${file.fileNo}"
                                               onchange="onThumbChange(this)"/>
                                        <span>썸네일</span>
                                    </label>
                                    <span class="file-name">
                                        <c:out value="${file.orgName}"/>
                                        [<fmt:formatNumber value="${file.fileSize}" pattern="#,###"/> byte]
                                    </span>
                                    <button type="button" class="btn btn-danger btn-sm"
                                            onclick="removeExistingFile(${file.fileNo})">X</button>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    <div id="deletedFileNos"></div>

                    <div id="newFileList" class="mb-1"></div>
                    <div id="uploadStatus" class="text-muted small mb-1" style="display:none;">업로드 중...</div>

                    <div>
                        <input type="file" class="form-control" id="fileInput"
                               accept="image/*" multiple/>
                        <small class="text-muted">최대 5개(기존 포함), 개별 10MB, 총 50MB / 이미지 파일만 가능</small>
                    </div>
                </td>
            </tr>
        </table>

        <div class="d-flex justify-content-center gap-2 mt-3">
            <button type="button" class="btn btn-outline-secondary" onclick="goCancel()">취소</button>
            <button type="button" id="btnSave" class="btn btn-danger" onclick="validateAndSave()">저장</button>
        </div>
    </form>
</div>

<%-- 취소 폼 --%>
<form id="cancelForm" method="post"
      action="${not empty gallery.boardNo ? 'gallery/detail.do' : 'gallery/list.do'}">
    <input type="hidden" name="boardNo" value="${gallery.boardNo}"/>
</form>

<style>
#editor img {
    width: 300px;
    height: 300px;
    object-fit: contain;
    background-color: #f8f9fa;
    border-radius: 4px;
    margin: 4px;
    display: inline-block;
    vertical-align: top;
}
</style>

<script>
/* ===== [신방식] Ajax 임시업로드 ===== */
var fileEntries = []; /* {fileNo, orgName, fileSize, imgEl, listEl, radioEl, deleted} */

var MAX_COUNT      = 5;
var MAX_FILE_SIZE  = 10 * 1024 * 1024;
var MAX_TOTAL_SIZE = 50 * 1024 * 1024;

/* 수정 모드: 저장된 내용 에디터 로드 + 현재 썸네일 라디오 선택 */
(function () {
    var saved = document.getElementById('savedContent').innerHTML.trim();
    if (saved) document.getElementById('editor').innerHTML = saved;

    var currentThumb = '${gallery.thumbFileNo}';
    if (!currentThumb) return;
    document.getElementById('thumbFileNo').value = currentThumb;
    var radio = document.querySelector(
        'input[name="thumbSelect"][value="existing_' + currentThumb + '"]'
    );
    if (radio) radio.checked = true;
}());

function onThumbChange(radio) {
    document.getElementById('thumbFileNo').value = radio.value.replace('existing_', '').replace('new_', '');
}

/* 파일 선택 → 용량 검사 → Ajax 업로드 */
document.getElementById('fileInput').addEventListener('change', function () {
    var files = this.files;
    if (!files || files.length === 0) { this.value = ''; return; }

    var existingDbCount  = document.querySelectorAll('#existingFileList .file-item').length;
    var existingNewCount = fileEntries.filter(function (e) { return !e.deleted; }).length;
    var totalCurrent     = existingDbCount + existingNewCount;
    if (totalCurrent + files.length > MAX_COUNT) {
        alert('파일은 최대 ' + MAX_COUNT + '개까지 첨부할 수 있습니다. (현재 ' + totalCurrent + '개)');
        this.value = ''; return;
    }

    var totalSize = 0;
    fileEntries.filter(function (e) { return !e.deleted; })
               .forEach(function (e) { totalSize += e.fileSize; });
    for (var i = 0; i < files.length; i++) {
        if (files[i].size > MAX_FILE_SIZE) {
            alert('[' + files[i].name + '] 파일은 10MB를 초과합니다.');
            this.value = ''; return;
        }
        totalSize += files[i].size;
    }
    if (totalSize > MAX_TOTAL_SIZE) {
        alert('첨부파일 총 용량이 50MB를 초과합니다.');
        this.value = ''; return;
    }

    /* Ajax 업로드 */
    var formData = new FormData();
    for (var j = 0; j < files.length; j++) {
        formData.append('uploadFile', files[j]);
    }

    var status = document.getElementById('uploadStatus');
    var btn    = document.getElementById('btnSave');
    status.style.display = '';
    btn.disabled = true;
    this.value = '';

    fetch('gallery/uploadTempFile.do', { method: 'POST', body: formData })
        .then(function (res) { return res.json(); })
        .then(function (result) {
            if (result.msg === 'S') {
                result.files.forEach(function (f) { addUploadedFile(f); });
            } else {
                alert('업로드 중 오류가 발생했습니다.');
            }
        })
        .catch(function () { alert('업로드 중 오류가 발생했습니다.'); })
        .finally(function () {
            status.style.display = 'none';
            btn.disabled = false;
        });
});

/* 업로드 완료된 파일을 에디터 + 목록에 추가 */
function addUploadedFile(f) {
    /* 에디터에 실제 imgView URL로 미리보기 */
    var img = document.createElement('img');
    img.src           = 'gallery/imgView.do?fileNo=' + f.fileNo;
    img.dataset.fileno = f.fileNo;
    document.getElementById('editor').appendChild(img);

    /* 파일 목록 행 */
    var radio = document.createElement('input');
    radio.type  = 'radio';
    radio.name  = 'thumbSelect';
    radio.value = 'new_' + f.fileNo;
    radio.addEventListener('change', function () { onThumbChange(this); });

    var label = document.createElement('label');
    label.className = 'd-flex align-items-center gap-1 mb-0';
    label.appendChild(radio);
    var labelText = document.createElement('span');
    labelText.textContent = '썸네일';
    label.appendChild(labelText);

    var nameSpan = document.createElement('span');
    nameSpan.className = 'file-name';
    nameSpan.textContent = f.orgName + ' [' + (f.fileSize || 0).toLocaleString() + ' bytes]';

    var delBtn = document.createElement('button');
    delBtn.type = 'button';
    delBtn.className = 'btn btn-danger btn-sm';
    delBtn.textContent = 'X';
    var fileNo = f.fileNo;
    delBtn.addEventListener('click', function () { removeNewFile(fileNo); });

    var div = document.createElement('div');
    div.id        = 'newFile_' + f.fileNo;
    div.className = 'file-item d-flex align-items-center gap-2';
    div.appendChild(label);
    div.appendChild(nameSpan);
    div.appendChild(delBtn);
    document.getElementById('newFileList').appendChild(div);

    var entry = { fileNo: f.fileNo, orgName: f.orgName, fileSize: f.fileSize || 0,
                  imgEl: img, listEl: div, radioEl: radio, deleted: false };
    fileEntries.push(entry);

    /* 썸네일 미선택이면 첫 파일 자동 선택 */
    if (!document.querySelector('input[name="thumbSelect"]:checked')) {
        radio.checked = true;
        onThumbChange(radio);
    }
}

/* 신규 파일 제거 */
function removeNewFile(fileNo) {
    var entry = fileEntries.find(function (e) { return e.fileNo === fileNo; });
    if (!entry || entry.deleted) return;
    var wasSelected = entry.radioEl.checked;
    entry.deleted = true;
    entry.imgEl.remove();
    entry.listEl.remove();

    if (wasSelected) {
        document.getElementById('thumbFileNo').value = '';
        var first = document.querySelector('input[name="thumbSelect"]');
        if (first) { first.checked = true; onThumbChange(first); }
    }
}

/* 기존 파일 제거 */
function removeExistingFile(fileNo) {
    var row = document.getElementById('existingFile_' + fileNo);
    if (row) {
        var radio = row.querySelector('input[type="radio"]');
        var wasSelected = radio && radio.checked;
        row.remove();
        if (wasSelected) {
            document.getElementById('thumbFileNo').value = '';
            var first = document.querySelector('input[name="thumbSelect"]');
            if (first) { first.checked = true; onThumbChange(first); }
        }
    }
    var img = document.querySelector(
        '#editor img[src*="imgView.do?fileNo=' + fileNo + '"]'
    );
    if (img) img.remove();

    var inp = document.createElement('input');
    inp.type  = 'hidden';
    inp.name  = 'deleteFileNo';
    inp.value = fileNo;
    document.getElementById('deletedFileNos').appendChild(inp);
}

function goCancel() {
    document.getElementById('cancelForm').submit();
}

// 컨트롤러에서 전부 처리 플래십
function validate() {
    var title = document.getElementById('titleInput').value.trim();
    if (!title) { alert('제목을 입력하세요.'); return false; }

    var imgCount = document.getElementById('editor').querySelectorAll('img').length;
    if (imgCount === 0) { alert('이미지를 최소 1개 등록해야 합니다.'); return false; }

    if (!document.querySelector('input[name="thumbSelect"]:checked')) {
        alert('썸네일을 선택해야 합니다.'); return false;
    }

    /* 이전 제출 시 추가된 activeFileNo 제거 (중복 방지) */
    document.querySelectorAll('input[name="activeFileNo"]').forEach(function (el) { el.remove(); });

    /* 활성화할 신규 파일 목록 hidden input으로 추가 */
    var form = document.getElementById('galleryForm');
    fileEntries.filter(function (e) { return !e.deleted; }).forEach(function (e) {
        var inp = document.createElement('input');
        inp.type  = 'hidden';
        inp.name  = 'activeFileNo';
        inp.value = e.fileNo;
        form.appendChild(inp);
    });

    /* content: 에디터 HTML 그대로 저장 (이미 실제 imgView URL 사용 중) */
    document.getElementById('contentInput').value =
        document.getElementById('editor').innerHTML.trim();
    saveGallery();
    return true;
}

function validateAndSave() {
  var title = document.getElementById('titleInput').value.trim();
  if (!title) { alert('제목을 입력하세요.'); return false; }

  var imgCount = document.getElementById('editor').querySelectorAll('img').length;
  if (imgCount === 0) { alert('이미지를 최소 1개 등록해야 합니다.'); return false; }

  if (!document.querySelector('input[name="thumbSelect"]:checked')) {
      alert('썸네일을 선택해야 합니다.'); return false;
  }

  /* 이전 제출 시 추가된 activeFileNo 제거 (중복 방지) */
  document.querySelectorAll('input[name="activeFileNo"]').forEach(function (el) { el.remove(); });

  /* 활성화할 신규 파일 목록 hidden input으로 추가 */
  var form = document.getElementById('galleryForm');
  fileEntries.filter(function (e) { return !e.deleted; }).forEach(function (e) {
      var inp = document.createElement('input');
      inp.type  = 'hidden';
      inp.name  = 'activeFileNo';
      inp.value = e.fileNo;
      form.appendChild(inp);
  });

  /* content: 에디터 HTML 그대로 저장 (이미 실제 imgView URL 사용 중) */
  document.getElementById('contentInput').value =
      document.getElementById('editor').innerHTML.trim();
  saveGallery();
}

/* ===== [신방식] 끝 ===== */

/* 등록/수정 ajax 요청 */
function saveGallery() {

   	let formData = new FormData($("#galleryForm")[0]);

    $.ajax({
        url: "gallery/saveAjax.do",
        type: "POST",
        data: formData,
        processData: false, //문자열 변환금지
        contentType: false, // 헤더 자동설정 금지 multipart 폼 데이터로 그대로 보내기
        success: function(res) {

            if (res.msg === "S") {

                if (res.mode === "insert") {
                    alert("등록되었습니다.");
                } else {
                    alert("수정되었습니다.");
                }

                goPost("gallery/detail.do", {
                    boardNo: res.boardNo,
                    noHit: "Y"
                });

            } else {
                alert("처리 실패");
            }
        },
        error: function() {
            alert("서버 오류");
        }
    });
}

/* ===== [구방식 롤백용 주석] DataTransfer + blob URL + __IMG_N__ 방식 =====

var fileEntries = [];

(function () {
    var saved = document.getElementById('savedContent').innerHTML.trim();
    if (!saved) return;
    document.getElementById('editor').innerHTML = saved;
    var currentThumb = '${gallery.thumbFileNo}';
    if (!currentThumb) return;
    document.getElementById('thumbFileNo').value = currentThumb;
    var radio = document.querySelector('input[name="thumbSelect"][value="existing_' + currentThumb + '"]');
    if (radio) radio.checked = true;
}());

function onThumbChange(radio) {
    var val = radio.value;
    if (val.indexOf('existing_') === 0) {
        document.getElementById('thumbFileNo').value = val.replace('existing_', '');
        document.getElementById('thumbIndex').value  = '-1';
    } else {
        document.getElementById('thumbFileNo').value = '';
        document.getElementById('thumbIndex').value  = val.replace('new_', '');
    }
}

document.getElementById('fileInput').addEventListener('change', function () {
    var MAX_COUNT = 5, MAX_FILE_SIZE = 10*1024*1024, MAX_TOTAL_SIZE = 50*1024*1024;
    var files = this.files;
    if (!files || files.length === 0) { this.value = ''; return; }
    var existingDbCount  = document.querySelectorAll('#existingFileList .file-item').length;
    var existingNewCount = fileEntries.filter(function (e) { return !e.deleted; }).length;
    var totalCurrent = existingDbCount + existingNewCount;
    if (totalCurrent + files.length > MAX_COUNT) {
        alert('파일은 최대 ' + MAX_COUNT + '개까지 첨부할 수 있습니다. (현재 ' + totalCurrent + '개)');
        this.value = ''; return;
    }
    var totalSize = 0;
    fileEntries.filter(function (e) { return !e.deleted; }).forEach(function (e) { totalSize += e.file.size; });
    for (var i = 0; i < files.length; i++) {
        if (files[i].size > MAX_FILE_SIZE) { alert('[' + files[i].name + '] 파일은 10MB를 초과합니다.'); this.value = ''; return; }
        totalSize += files[i].size;
    }
    if (totalSize > MAX_TOTAL_SIZE) { alert('첨부파일 총 용량이 50MB를 초과합니다.'); this.value = ''; return; }
    for (var j = 0; j < files.length; j++) addImageFile(files[j]);
    this.value = '';
});

function addImageFile(file) {
    var idx = fileEntries.length;
    var dt = new DataTransfer(); dt.items.add(file);
    var inp = document.createElement('input');
    inp.type = 'file'; inp.name = 'uploadFile'; inp.style.display = 'none'; inp.files = dt.files;
    document.getElementById('galleryForm').appendChild(inp);
    var url = URL.createObjectURL(file);
    var img = document.createElement('img'); img.src = url; img.dataset.idx = idx;
    document.getElementById('editor').appendChild(img);
    var radio = document.createElement('input');
    radio.type = 'radio'; radio.name = 'thumbSelect'; radio.value = 'new_' + idx;
    radio.addEventListener('change', function () { onThumbChange(this); });
    var label = document.createElement('label'); label.className = 'd-flex align-items-center gap-1 mb-0';
    label.appendChild(radio); var lt = document.createElement('span'); lt.textContent = '썸네일'; label.appendChild(lt);
    var nameSpan = document.createElement('span'); nameSpan.className = 'file-name';
    nameSpan.textContent = file.name + ' [' + file.size.toLocaleString() + ' bytes]';
    var delBtn = document.createElement('button'); delBtn.type = 'button'; delBtn.className = 'btn btn-danger btn-sm'; delBtn.textContent = 'X';
    delBtn.addEventListener('click', (function (i) { return function () { removeFile(i); }; }(idx)));
    var div = document.createElement('div'); div.className = 'file-item d-flex align-items-center gap-2';
    div.appendChild(label); div.appendChild(nameSpan); div.appendChild(delBtn);
    document.getElementById('newFileList').appendChild(div);
    var entry = { file: file, inputEl: inp, imgEl: img, listEl: div, radioEl: radio, deleted: false, idx: idx };
    fileEntries.push(entry);
    if (!document.querySelector('input[name="thumbSelect"]:checked')) { radio.checked = true; onThumbChange(radio); }
}

function removeFile(idx) {
    var entry = fileEntries[idx]; if (!entry || entry.deleted) return;
    var wasSelected = entry.radioEl.checked; entry.deleted = true;
    entry.inputEl.remove(); entry.imgEl.remove(); entry.listEl.remove(); URL.revokeObjectURL(entry.imgEl.src);
    if (wasSelected) {
        document.getElementById('thumbFileNo').value = ''; document.getElementById('thumbIndex').value = '-1';
        var first = document.querySelector('input[name="thumbSelect"]');
        if (first) { first.checked = true; onThumbChange(first); }
    }
}

function removeExistingFile(fileNo) {
    var row = document.getElementById('existingFile_' + fileNo);
    if (row) {
        var radio = row.querySelector('input[type="radio"]'); var wasSelected = radio && radio.checked; row.remove();
        if (wasSelected) {
            document.getElementById('thumbFileNo').value = ''; document.getElementById('thumbIndex').value = '-1';
            var first = document.querySelector('input[name="thumbSelect"]'); if (first) { first.checked = true; onThumbChange(first); }
        }
    }
    var img = document.querySelector('#editor img[src*="imgView.do?fileNo=' + fileNo + '"]'); if (img) img.remove();
    var inp = document.createElement('input'); inp.type = 'hidden'; inp.name = 'deleteFileNo'; inp.value = fileNo;
    document.getElementById('deletedFileNos').appendChild(inp);
}

function validate() {
    var title = document.getElementById('titleInput').value.trim();
    if (!title) { alert('제목을 입력하세요.'); return false; }
    var editor = document.getElementById('editor');
    if (editor.querySelectorAll('img').length === 0) { alert('이미지를 최소 1개 등록해야 합니다.'); return false; }
    if (!document.querySelector('input[name="thumbSelect"]:checked')) { alert('썸네일을 선택해야 합니다.'); return false; }
    var clone = editor.cloneNode(true);
    clone.querySelectorAll('img[data-idx]').forEach(function (img) {
        img.src = '__IMG_' + img.dataset.idx + '__'; img.removeAttribute('data-idx');
    });
    document.getElementById('contentInput').value = clone.innerHTML.trim();
    return true;
}

===== [구방식] 끝 ===== */
</script>

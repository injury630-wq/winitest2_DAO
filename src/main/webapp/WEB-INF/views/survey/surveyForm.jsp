<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">${empty survey ? '설문 등록' : '설문 수정'}</h2>
    </div>

    <!-- ===== 1. 기본정보 ===== -->
    <div class="bg-white border p-3 mb-3">
        <h6 class="fw-bold mb-3 pb-2 border-bottom">기본 정보</h6>
        <table class="table table-bordered mb-0" style="font-size: 14px;">
            <colgroup>
                <col style="width: 15%"><col style="width: 85%">
            </colgroup>
            <tbody>
                <tr>
                    <th class="table-light align-middle">설문 제목 <span class="text-danger">*</span></th>
                    <td>
                        <input type="text" id="title" class="form-control form-control-sm"
                               maxlength="200" placeholder="설문 제목을 입력하세요."
                               value="<c:out value='${survey.title}'/>" />
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">개요</th>
                    <td>
                        <textarea id="content" class="form-control form-control-sm"
                                  rows="3" maxlength="2000"
                                  placeholder="설문에 대한 설명을 입력하세요."><c:out value="${survey.content}"/></textarea>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">설문 기간 <span class="text-danger">*</span></th>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <input type="date" id="startDate" class="form-control form-control-sm"
                                   style="width: auto;" value="<c:out value='${survey.startDate}'/>" />
                            <span class="text-muted">~</span>
                            <input type="date" id="endDate" class="form-control form-control-sm"
                                   style="width: auto;" value="<c:out value='${survey.endDate}'/>" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">사용여부</th>
                    <td>
                        <div class="d-flex gap-3">
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="useYn" id="useYnY" value="Y"
                                       ${survey.useYn eq 'N' ? '' : 'checked'}>
                                <label class="form-check-label" for="useYnY">Y</label>
                            </div>
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="useYn" id="useYnN" value="N"
                                       ${survey.useYn eq 'N' ? 'checked' : ''}>
                                <label class="form-check-label" for="useYnN">N</label>
                            </div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ===== 2. 질문 추가 패널 ===== -->
    <div class="bg-white border p-3 mb-3">
        <h6 class="fw-bold mb-3 pb-2 border-bottom" id="addPanelTitle">질문 추가</h6>
        <table class="table table-bordered mb-3" style="font-size: 14px;">
            <colgroup>
                <col style="width: 15%"><col style="width: 85%">
            </colgroup>
            <tbody>
                <tr>
                    <th class="table-light align-middle text-center">질문 유형</th>
                    <td>
                        <select id="qType" class="form-select form-select-sm" style="width: 150px;" onchange="onAddTypeChange()">
                            <c:forEach var="t" items="${questionTypes}">
                                <option value="${t.codeNo}"><c:out value="${t.codeName}"/></option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">질문 내용 <span class="text-danger">*</span></th>
                    <td>
                        <textarea id="qContent" class="form-control form-control-sm" rows="2"
                                  placeholder="질문 내용을 입력하세요." maxlength="500"></textarea>
                    </td>
                </tr>
                <tr id="addOptionRow" class="d-none">
                    <th class="table-light align-middle text-center">보기</th>
                    <td>
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <input type="text" id="optionInput" class="form-control form-control-sm"
                                   style="max-width: 300px;" placeholder="보기 내용 입력" />
                            <button type="button" class="btn btn-outline-secondary btn-sm px-3"
                                    onclick="addOptionTag()">보기 추가</button>
                        </div>
                        <div id="optionTagList"></div>
                    </td>
                </tr>
                <tr id="addTextRow">
                    <th class="table-light align-middle text-center">응답 미리보기</th>
                    <td>
                        <input type="text" class="form-control form-control-sm" style="max-width: 300px;"
                               disabled placeholder="단답형 응답 미리보기" />
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">이미지</th>
                    <td>
                        <input type="file" id="imageFileInput" class="form-control form-control-sm" accept="image/*" onchange="uploadQuestionImage(this)" />
                        <div id="imagePreviewArea" class="mt-2 d-none">
                            <img id="imagePreview" src="" alt="미리보기"
                                 style="max-width: 100%; max-height: 600px; border: 1px solid #dee2e6; border-radius: 4px;" />
                            <br/>
                            <button type="button" class="btn btn-outline-danger btn-sm mt-1"
                                    onclick="removeQuestionImage()">이미지 삭제</button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-primary btn-sm px-4" id="addBtn" onclick="commitQuestion()">+ 질문 추가</button>
            <button type="button" class="btn btn-outline-secondary btn-sm px-3 d-none" id="cancelEditBtn" onclick="cancelEdit()">취소</button>
        </div>
    </div>

    <!-- ===== 3. 질문 목록 ===== -->
    <div class="bg-white border mb-3">
        <div class="px-3 pt-2 pb-1 border-bottom d-flex justify-content-between align-items-center">
            <span class="fw-semibold" style="font-size: 14px;">질문 목록</span>
            <small class="text-muted">총 <strong id="qCount">0</strong>개</small>
        </div>
        <div id="questionList" class="p-2">
            <div id="emptyGuide" class="text-center text-muted py-4" style="font-size: 13px;">
                질문을 추가해주세요.
            </div>
        </div>
    </div>

    <!-- ===== 4. 버튼 영역 ===== -->
    <div class="d-flex justify-content-end gap-2 mb-4">
        <button type="button" class="btn btn-primary px-4" onclick="saveSurvey()">저장</button>
        <button type="button" class="btn btn-outline-secondary px-4" onclick="goPost('survey/surveyManage.do')">목록</button>
        <c:if test="${not empty survey}">
            <button type="button" class="btn btn-outline-danger px-4" onclick="deleteSurvey()">삭제</button>
        </c:if>
    </div>

    <!-- ===== 5. JSTL 질문 데이터 (스크립트가 읽기 위한 hidden 영역) ===== -->
    <div id="questionData" class="d-none">
        <c:forEach var="q" items="${questions}">
            <div class="q-item"
                 data-board-no="${q.boardNo}"
                 data-content="<c:out value='${q.content}'/>"
                 data-type="${q.type}"
                 data-sort-ord="${q.sortOrd}"
                 data-image-file-no="${q.imageFileNo}">
                <c:forEach var="opt" items="${q.options}">
                    <div class="opt-item"
                         data-option-no="${opt.optionNo}"
                         data-content="<c:out value='${opt.content}'/>"
                         data-sort-ord="${opt.sortOrd}"></div>
                </c:forEach>
            </div>
        </c:forEach>
    </div>

</div>

<script>
/* 수정 화면이면 surveyNo, 등록 화면이면 빈 문자열 -> surveySave.do에서 insert/update 분기 */
const SURVEY_NO = '${survey.surveyNo}';

/*
 * questionList : 현재 폼의 질문 배열. 유일한 데이터 원본.
 *   - 등록 시: 빈 배열로 시작
 *   - 수정 시: #questionData hidden div에서 읽어서 채움
 * boardNo=0이면 신규 질문, 0보다 크면 DB에 이미 있는 질문.
 */
var questionList = [];
$('#questionData .q-item').each(function() {
    var $q = $(this);
    var opts = [];
    $q.find('.opt-item').each(function() {
        var $o = $(this);
        opts.push({
            optionNo: parseInt($o.data('option-no')) || 0,
            content : $o.data('content') || '',
            sortOrd : parseInt($o.data('sort-ord')) || 0
        });
    });
    questionList.push({
        boardNo     : parseInt($q.data('board-no')) || 0,
        content     : $q.data('content') || '',
        type        : $q.data('type') || '',
        sortOrd     : parseInt($q.data('sort-ord')) || 0,
        imageFileNo : parseInt($q.data('image-file-no')) || 0,
        options     : opts
    });
});

/* 질문 유형 코드 -> 이름 매핑. #qType select가 이미 렌더링돼 있으므로 재활용/ 질문목록 뱃지표시용도*/
var typeNames = {};
$('#qType option').each(function() {
    typeNames[$(this).val()] = $(this).text();
});

/* editingIdx : 질문 목록에서 수정 중인 항목 인덱스. -1이면 추가 모드 */
var editingIdx  = -1;
/* pendingOpts : 추가 패널에서 입력 중인 보기 목록. commitQuestion() 시 questionList에 합쳐짐 */
var pendingOpts  = [];
/* pendingImageFileNo : 추가 패널에 업로드된 이미지 fileNo. 0이면 이미지 없음 */
var pendingImageFileNo = 0;

/* ── 추가 패널 유형 변경 ── */
function onAddTypeChange() {
    var type     = $('#qType').val();
    var isChoice = (type === 'radio' || type === 'checkbox' || type === 'select');
		// 추가 패널에서 객관식 선택시 보기 영역 show 텍스트 영역 hide
    if (isChoice) {
        $('#addOptionRow').removeClass('d-none');
        $('#addTextRow').addClass('d-none');
    } else {
        $('#addOptionRow').addClass('d-none');
        $('#addTextRow').removeClass('d-none');
        var placeholder = type === 'textarea' ? '장문형 응답 미리보기' : '단답형 응답 미리보기';
        var newEl = type === 'textarea'
            ? '<textarea class="form-control form-control-sm" style="max-width:300px;" rows="2" disabled placeholder="' + placeholder + '"></textarea>'
            : '<input type="text" class="form-control form-control-sm" style="max-width:300px;" disabled placeholder="' + placeholder + '" />';
        $('#addTextRow td').html(newEl); // 답변 미리보기 input textarea 분기
    }
}

/* ── 보기 태그 추가 ── */
function addOptionTag() {
    var val = $('#optionInput').val().trim();
    if (!val) return;
    pendingOpts.push({ optionNo: 0, content: val });
    renderOptionTags();
    $('#optionInput').val('').focus();
}

/* 보기 태그 삭제 */
function removeOptionTag(idx) {
    pendingOpts.splice(idx, 1); // 보기 태그 배열에서 제거
    renderOptionTags(); // 재렌더링
}

/* 보기 태그 렌더링  */
function renderOptionTags() {
    var html = '';
    pendingOpts.forEach(function(opt, i) {
        html += '<div class="d-flex align-items-center gap-1 mb-1">'
              + '<span class="text-muted me-1">' + (i + 1) + '.</span>'
              + '<span>' + escHtml(opt.content) + '</span>'
              + '<button type="button" class="btn-close ms-1" onclick="removeOptionTag(' + i + ')"></button>'
              + '</div>';
    });
    $('#optionTagList').html(html);
}

/* ── 질문 추가 / 수정 확정 ── */
function commitQuestion() {
    var content  = $('#qContent').val().trim();
    var type     = $('#qType').val();
    var isChoice = (type === 'radio' || type === 'checkbox' || type === 'select');

    if (!content) {
        alert('질문 내용을 입력하세요.');
        return;
    }
    if (isChoice && pendingOpts.length === 0) {
        alert('선택형 질문은 보기를 1개 이상 추가하세요.');
        return;
    }

    var q = {
        boardNo     : 0,
        content     : content,
        type        : type,
        sortOrd     : 0,
        imageFileNo : pendingImageFileNo,
        /* slice()로 얕은 복사 - resetAddPanel()이 pendingOpts를 비워도 저장된 보기에 영향 없음 */
        options     : pendingOpts.slice()
    };

    if (editingIdx >= 0) {
        /* 수정 모드: 기존 boardNo 유지 (0이면 신규, 양수면 DB에 있는 기존 질문) */
        q.boardNo = questionList[editingIdx].boardNo; // boardNo 복원
        questionList[editingIdx] = q; // 배열의 해당 위치를 새 객체로 교체
        editingIdx = -1; // 수정 모드 종료 -> 추가 모드로 복귀
    } else {
        /* 추가 모드: 목록 맨 앞에 삽입 */
        questionList.unshift(q);
    }

    resetAddPanel();
    renderQuestionList();
}

/* ── 수정 모드 진입 ── */
function startEdit(idx) {
    editingIdx = idx;
    var q = questionList[idx];

    $('#qType').val(q.type);
    $('#qContent').val(q.content);
   	// 추가(수정) 패널에서 입력 중인 보기 목록 새로운 List<Map> 형태로 반환
    pendingOpts = q.options.map(function(o) { return { optionNo: o.optionNo, content: o.content }; });
		
   	// 추가(수정) 패널 업로드된 이미지
    pendingImageFileNo = q.imageFileNo || 0; // 0 => 이미지 없음
    $('#imageFileInput').val('');
    if (pendingImageFileNo > 0) {
        $('#imagePreview').attr('src', 'survey/getImage.do?fileNo=' + pendingImageFileNo);
        $('#imagePreviewArea').removeClass('d-none');
    } else {
        $('#imagePreviewArea').addClass('d-none');
    }

    onAddTypeChange(); // 패널 타입에 맞춰 보기 변경
    renderOptionTags(); // 보기 렌더링

    $('#addPanelTitle').text('질문 수정');
    $('#addBtn').text('수정 완료');
    $('#cancelEditBtn').removeClass('d-none');
    $('#qContent').focus();
    $('html, body').animate({ scrollTop: $('#addPanelTitle').offset().top - 10 }, 300);
}

/* ── 수정 취소 ── */
function cancelEdit() {
    editingIdx = -1; // 추가모드로 변경
    resetAddPanel(); // 추가패널 값 초기화
}

/* ── 추가 패널 초기화 ── */
function resetAddPanel() {
    pendingImageFileNo = 0;
    $('#imageFileInput').val('');
    $('#imagePreviewArea').addClass('d-none');
    $('#imagePreview').attr('src', '');

    $('#qContent').val('');
    $('#optionInput').val('');
    pendingOpts = []; // 보기 지우기
    renderOptionTags(); // 보기 재렌더링
    $('#addPanelTitle').text('질문 추가');
    $('#addBtn').text('+ 질문 추가');
    $('#cancelEditBtn').addClass('d-none');
    onAddTypeChange(); // 응답 미리보기 type에 맞게 변경
}

/* ── 질문 삭제 ── */
function removeQuestion(idx) {
    questionList.splice(idx, 1); // 질문 배열에서 삭제
    /* 수정 중이던 질문을 삭제하면 추가 패널도 초기화 */
    if (editingIdx === idx) {
        editingIdx = -1;
        resetAddPanel();
    }
    renderQuestionList();
}

/* ── 질문 순서 이동 ── */
function moveQuestion(idx, dir) {
    var ti = idx + dir; // dir: -1 위로 1 아래로 
    if (ti < 0 || ti >= questionList.length) {// 질문 개수 안에서만 변경
        return;
    }
    /* 배열 swap */
    var tmp = questionList[idx];
    questionList[idx] = questionList[ti];
    questionList[ti]  = tmp;
    /* 수정 중인 항목이 이동하면 editingIdx도 함께 이동 (노란 배경 유지) */
    if (editingIdx === idx) {
        editingIdx = ti;
    } else if (editingIdx === ti) {
        editingIdx = idx;
    }
    renderQuestionList();
}

/*
 * 질문 목록 렌더링
 * - questionList가 바뀔 때마다 #questionList 전체를 재생성.
 * - 버튼 onclick에 인덱스(i)를 직접 박아야 해서 부분 업데이트가 어렵기 때문.
 */
function renderQuestionList() {
    $('#qCount').text(questionList.length);

    if (questionList.length === 0) {
        $('#questionList').html('<div id="emptyGuide" class="text-center text-muted py-4">질문을 추가해주세요.</div>');
        return;
    }

    var html = '';
    questionList.forEach(function(q, i) {
        var isChoice  = (q.type === 'radio' || q.type === 'checkbox' || q.type === 'select');
        var typeName  = typeNames[q.type] || q.type;
        var isEditing = (editingIdx === i);

        html += '<div class="d-flex align-items-start gap-2 py-2 px-2 border-bottom' + (isEditing ? ' bg-warning bg-opacity-10' : '') + '">';
        html += '<span class="fw-bold text-muted flex-shrink-0" style="width:24px;">' + (i + 1) + '</span>';
        html += '<div class="flex-grow-1">';
        html += '<span class="badge text-bg-secondary me-1">' + escHtml(typeName) + '</span>';
        html += escHtml(q.content);

        if (isChoice && q.options.length > 0) {
            html += '<div class="mt-1">';
            q.options.forEach(function(opt, oi) {
                html += '<div class="text-muted">' + (oi + 1) + '. ' + escHtml(opt.content) + '</div>';
            });
            html += '</div>';
        } else if (!isChoice) {
            var ph = q.type === 'textarea' ? '장문형' : '단답형';
            html += '<div class="mt-1"><input type="text" class="form-control form-control-sm" style="max-width:200px;" disabled placeholder="' + ph + ' 응답"></div>';
        }

        if (q.imageFileNo > 0) {
            html += '<div class="mt-1"><img src="' + 'survey/getImage.do?fileNo=' + q.imageFileNo
                 + '" alt="이미지" style="max-width:100%; max-height:600px; border:1px solid #dee2e6; border-radius:4px;"></div>';
        }

        html += '</div>';
        html += '<div class="d-flex gap-1 flex-shrink-0">';
        html += '<button type="button" class="btn btn-outline-secondary btn-sm px-1" onclick="moveQuestion(' + i + ',-1)">▲</button>';
        html += '<button type="button" class="btn btn-outline-secondary btn-sm px-1" onclick="moveQuestion(' + i + ', 1)">▼</button>';
        html += '<button type="button" class="btn btn-outline-primary btn-sm px-2" onclick="startEdit(' + i + ')">수정</button>';
        html += '<button type="button" class="btn btn-outline-danger btn-sm px-2" onclick="removeQuestion(' + i + ')">삭제</button>';
        html += '</div>';
        html += '</div>';
    });

    $('#questionList').html(html);
}

/*
 * 이미지 업로드 (1단계)
 * - 파일 선택 즉시 서버로 전송 -> DB에 use_yn='N'으로 임시 저장 -> fileNo 반환
 * - 저장 버튼(saveSurvey) 시 해당 fileNo를 질문과 연결하면서 use_yn='Y'로 활성화
 * - processData:false, contentType:false 는 파일 전송 시 jQuery 기본 처리를 막는 필수 옵션
 */
function uploadQuestionImage(input) {
    if (!input.files || !input.files[0]) {
        return;
    }
    var formData = new FormData();
    formData.append('file', input.files[0]);
    $.ajax({
        url        : 'survey/surveyImageUpload.do',
        type       : 'POST',
        data       : formData,
        processData: false,
        contentType: false,
        success    : function(res) {
            if (res.msg === 'S') {
                pendingImageFileNo = res.fileNo;
                $('#imagePreview').attr('src', 'survey/getImage.do?fileNo=' + res.fileNo);
                $('#imagePreviewArea').removeClass('d-none');
            } else {
                alert(res.desc || '이미지 업로드에 실패했습니다.');
                $(input).val('');
            }
        },
        error: function() { 
	        	alert('서버 오류가 발생했습니다.'); 
	        	$(input).val(''); 
        	}
    });
}

/* ── 이미지 제거 (패널에서) ── */
function removeQuestionImage() {
    pendingImageFileNo = 0;
    $('#imageFileInput').val('');
    $('#imagePreviewArea').addClass('d-none');
    $('#imagePreview').attr('src', '');
}

/* ── 저장 ── */
function saveSurvey() {
    var title     = $('#title').val().trim();
    var startDate = $('#startDate').val();
    var endDate   = $('#endDate').val();

    if (!title) {
        alert('설문 제목을 입력하세요.');
        return;
    }
    if (!startDate) {
        alert('시작일을 입력하세요.');
        return;
    }
    if (!endDate) {
        alert('종료일을 입력하세요.');
        return;
    }
    if (startDate > endDate) {
        alert('종료일이 시작일보다 빠릅니다.');
        return;
    }
    if (questionList.length === 0) {
        alert('질문을 1개 이상 추가하세요.');
        return;
    }

    /* sortOrd를 현재 배열 순서(i)로 덮어써서 사용자가 이동시킨 순서를 반영 */
    var questions = questionList.map(function(q, i) {
        return {
            boardNo     : q.boardNo || 0,
            content     : q.content,
            type        : q.type,
            sortOrd     : i,
            imageFileNo : q.imageFileNo || 0,
            options     : q.options.map(function(o, j) {
                return { optionNo: o.optionNo || 0, content: o.content, sortOrd: j };
            })
        };
    });

    /*
     * SURVEY_NO가 빈 문자열이면 등록(insert), 값이 있으면 수정(update).
     * 서버 SurveyController.surveySave()에서 이 값으로 분기.
     */
    var payload = {
        surveyNo  : SURVEY_NO || null,
        title     : title,
        content   : $('#content').val().trim(),
        startDate : startDate,
        endDate   : endDate,
        useYn     : $('input[name=useYn]:checked').val(),
        questions : questions
    };

    $.ajax({
        type    : 'post',
        url     : 'survey/surveySave.do',
        headers : { 'Content-Type' : 'application/json' },
        dataType: 'json',
        data    : JSON.stringify(payload),
        success : function(result) {
            if (result.msg === 'S') {
                alert('저장되었습니다.');
                goPost('survey/surveyManage.do');
            } else {
                alert('저장 중 오류가 발생하였습니다.');
            }
        },
        error : function() { alert('서버 오류가 발생하였습니다.'); }
    });
}

/* ── 삭제 ── */
function deleteSurvey() {
    if (!confirm('설문을 삭제하시겠습니까?')) return;
    $.ajax({
        type    : 'post',
        url     : 'survey/surveyDelete.do',
        dataType: 'json',
        data    : { surveyNo : SURVEY_NO },
        success : function(result) {
            if (result.msg === 'S') {
                alert('삭제되었습니다.');
                goPost('survey/surveyManage.do');
            } else {
                alert('삭제 중 오류가 발생하였습니다.');
            }
        },
        error : function() { alert('서버 오류가 발생하였습니다.'); }
    });
}

/* JS로 HTML을 직접 조립할 때 XSS 방지용. jQuery가 text()로 넣으면 자동 이스케이프됨 */
function escHtml(str) {
    return $('<div>').text(str || '').html();
}

/* ── 초기 렌더링 ── */
onAddTypeChange();   /* 유형 select 초기값에 맞게 보기/텍스트 행 toggle */
renderQuestionList(); /* 수정 화면이면 기존 질문 목록 표시, 등록이면 빈 안내 문구 표시 */
</script>

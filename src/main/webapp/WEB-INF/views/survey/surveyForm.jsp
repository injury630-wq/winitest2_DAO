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
                                   style="max-width: 300px;" placeholder="보기 내용 입력"
                                   onkeydown="if(event.key==='Enter'){event.preventDefault();addOptionTag();}" />
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
        <button type="button" class="btn btn-primary px-4"           onclick="saveSurvey()">저장</button>
        <button type="button" class="btn btn-outline-secondary px-4"  onclick="goPost('survey/surveyManage.do')">목록</button>
        <c:if test="${not empty survey}">
            <button type="button" class="btn btn-outline-danger px-4" onclick="deleteSurvey()">삭제</button>
        </c:if>
    </div>

</div>

<script>
const SURVEY_NO = '${survey.surveyNo}';
const deletedQuestionNos = [];
const deletedOptionNos   = [];

/* ── 질문 목록 (메모리) ── */
var questionList = [];  /* [{boardNo, content, type, sortOrd, options:[{optionNo,content}]}] */
var editingIdx   = -1;  /* 수정 중인 인덱스 (-1: 추가 모드) */
var pendingOpts  = [];  /* 추가 패널의 보기 [{optionNo, content}] */

/* ── 기존 질문 데이터 로드 (수정 모드) ── */
<c:if test="${not empty questions}">
<c:forEach var="q" items="${questions}" varStatus="vs">
questionList.push({
    boardNo : ${q.boardNo},
    content : '<c:out value="${q.content}" escapeXml="false"/>'.replace(/'/g,"'").replace(/\\/g,"\\\\"),
    type    : '${q.type}',
    sortOrd : ${vs.index},
    options : [
        <c:forEach var="opt" items="${q.options}" varStatus="os">
        { optionNo: ${opt.optionNo}, content: '<c:out value="${opt.content}" escapeXml="false"/>'.replace(/'/g,"'") }<c:if test="${!os.last}">,</c:if>
        </c:forEach>
    ]
});
</c:forEach>
</c:if>

/* ── 타입 코드 → 이름 매핑 ── */
var typeNames = {};
<c:forEach var="t" items="${questionTypes}">
typeNames['${t.codeNo}'] = '<c:out value="${t.codeName}"/>';
</c:forEach>

/* ── 추가 패널 유형 변경 ── */
function onAddTypeChange() {
    var type = document.getElementById('qType').value;
    var isChoice = (type === 'radio' || type === 'checkbox' || type === 'select');
    var optRow = document.getElementById('addOptionRow');
    var txtRow = document.getElementById('addTextRow');

    if (isChoice) {
        optRow.classList.remove('d-none');
        txtRow.classList.add('d-none');
    } else {
        optRow.classList.add('d-none');
        txtRow.classList.remove('d-none');
        var placeholder = type === 'textarea' ? '장문형 응답 미리보기' : '단답형 응답 미리보기';
        var newEl;
        if (type === 'textarea') {
            newEl = '<textarea class="form-control form-control-sm" style="max-width:300px;" rows="2" disabled placeholder="' + placeholder + '"></textarea>';
        } else {
            newEl = '<input type="text" class="form-control form-control-sm" style="max-width:300px;" disabled placeholder="' + placeholder + '" />';
        }
        txtRow.querySelector('td').innerHTML = newEl;
    }
}

/* ── 보기 태그 추가 ── */
function addOptionTag() {
    var val = document.getElementById('optionInput').value.trim();
    if (!val) return;
    pendingOpts.push({ optionNo: 0, content: val });
    renderOptionTags();
    document.getElementById('optionInput').value = '';
    document.getElementById('optionInput').focus();
}

function removeOptionTag(idx) {
    var removed = pendingOpts.splice(idx, 1);
    if (removed[0] && removed[0].optionNo > 0) {
        deletedOptionNos.push(removed[0].optionNo);
    }
    renderOptionTags();
}

function renderOptionTags() {
    var html = '';
    pendingOpts.forEach(function(opt, i) {
        html += '<div class="d-flex align-items-center gap-1 mb-1">'
              + '<span class="text-muted me-1">' + (i + 1) + '.</span>'
              + '<span>' + escHtml(opt.content) + '</span>'
              + '<button type="button" class="btn-close ms-1" onclick="removeOptionTag(' + i + ')"></button>'
              + '</div>';
    });
    document.getElementById('optionTagList').innerHTML = html;
}

/* ── 질문 추가 / 수정 확정 ── */
function commitQuestion() {
    var content = document.getElementById('qContent').value.trim();
    var type    = document.getElementById('qType').value;
    var isChoice = (type === 'radio' || type === 'checkbox' || type === 'select');

    if (!content) { alert('질문 내용을 입력하세요.'); return; }
    if (isChoice && pendingOpts.length === 0) { alert('선택형 질문은 보기를 1개 이상 추가하세요.'); return; }

    var q = {
        boardNo : 0,
        content : content,
        type    : type,
        sortOrd : 0,
        options : pendingOpts.slice()
    };

    if (editingIdx >= 0) {
        q.boardNo = questionList[editingIdx].boardNo;
        questionList[editingIdx] = q;
        editingIdx = -1;
    } else {
        questionList.unshift(q);  /* 상단에 추가 */
    }

    resetAddPanel();
    renderQuestionList();
}

/* ── 수정 모드 진입 ── */
function startEdit(idx) {
    editingIdx = idx;
    var q = questionList[idx];

    document.getElementById('qType').value    = q.type;
    document.getElementById('qContent').value = q.content;
    pendingOpts = q.options.map(function(o) { return { optionNo: o.optionNo, content: o.content }; });

    onAddTypeChange();
    renderOptionTags();

    document.getElementById('addPanelTitle').innerText = '질문 수정';
    document.getElementById('addBtn').innerText = '수정 완료';
    document.getElementById('cancelEditBtn').classList.remove('d-none');
    document.getElementById('qContent').focus();
    document.getElementById('addPanelTitle').scrollIntoView({ behavior: 'smooth', block: 'start' });
}

/* ── 수정 취소 ── */
function cancelEdit() {
    editingIdx = -1;
    resetAddPanel();
}

/* ── 추가 패널 초기화 ── */
function resetAddPanel() {
    document.getElementById('qContent').value = '';
    document.getElementById('optionInput').value = '';
    pendingOpts = [];
    renderOptionTags();
    document.getElementById('addPanelTitle').innerText = '질문 추가';
    document.getElementById('addBtn').innerText = '+ 질문 추가';
    document.getElementById('cancelEditBtn').classList.add('d-none');
    onAddTypeChange();
}

/* ── 질문 삭제 ── */
function removeQuestion(idx) {
    var q = questionList.splice(idx, 1)[0];
    if (q.boardNo > 0) {
        deletedQuestionNos.push(q.boardNo);
        q.options.forEach(function(o) { if (o.optionNo > 0) deletedOptionNos.push(o.optionNo); });
    }
    if (editingIdx === idx) { editingIdx = -1; resetAddPanel(); }
    renderQuestionList();
}

/* ── 질문 순서 이동 ── */
function moveQuestion(idx, dir) {
    var ti = idx + dir;
    if (ti < 0 || ti >= questionList.length) return;
    var tmp = questionList[idx];
    questionList[idx] = questionList[ti];
    questionList[ti]  = tmp;
    if      (editingIdx === idx) editingIdx = ti;
    else if (editingIdx === ti)  editingIdx = idx;
    renderQuestionList();
}

/* ── 질문 목록 렌더링 ── */
function renderQuestionList() {
    document.getElementById('qCount').innerText = questionList.length;
    var container = document.getElementById('questionList');

    if (questionList.length === 0) {
        container.innerHTML = '<div id="emptyGuide" class="text-center text-muted py-4">질문을 추가해주세요.</div>';
        return;
    }

    var html = '';
    questionList.forEach(function(q, i) {
        var isChoice = (q.type === 'radio' || q.type === 'checkbox' || q.type === 'select');
        var typeName = typeNames[q.type] || q.type;
        var isEditing = (editingIdx === i);

        html += '<div class="d-flex align-items-start gap-2 py-2 px-2 border-bottom' + (isEditing ? ' bg-warning bg-opacity-10' : '') + '">';

        /* 번호 */
        html += '<span class="fw-bold text-muted flex-shrink-0" style="width:24px;">' + (i + 1) + '</span>';

        /* 내용 */
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
        html += '</div>';

        /* 버튼 */
        html += '<div class="d-flex gap-1 flex-shrink-0">';
        html += '<button type="button" class="btn btn-outline-secondary btn-sm px-1" onclick="moveQuestion(' + i + ',-1)">▲</button>';
        html += '<button type="button" class="btn btn-outline-secondary btn-sm px-1" onclick="moveQuestion(' + i + ', 1)">▼</button>';
        html += '<button type="button" class="btn btn-outline-primary btn-sm px-2" onclick="startEdit(' + i + ')">수정</button>';
        html += '<button type="button" class="btn btn-outline-danger btn-sm px-2" onclick="removeQuestion(' + i + ')">삭제</button>';
        html += '</div>';

        html += '</div>';
    });

    container.innerHTML = html;
}

/* ── 저장 ── */
function saveSurvey() {
    var title     = document.getElementById('title').value.trim();
    var startDate = document.getElementById('startDate').value;
    var endDate   = document.getElementById('endDate').value;

    if (!title)     { alert('설문 제목을 입력하세요.'); return; }
    if (!startDate) { alert('시작일을 입력하세요.'); return; }
    if (!endDate)   { alert('종료일을 입력하세요.'); return; }
    if (startDate > endDate) { alert('종료일이 시작일보다 빠릅니다.'); return; }
    if (questionList.length === 0) { alert('질문을 1개 이상 추가하세요.'); return; }

    var questions = questionList.map(function(q, i) {
        return {
            boardNo : q.boardNo || 0,
            content : q.content,
            type    : q.type,
            sortOrd : i,
            options : q.options.map(function(o, j) {
                return { optionNo: o.optionNo || 0, content: o.content, sortOrd: j };
            })
        };
    });

    var payload = {
        surveyNo           : SURVEY_NO || null,
        title              : title,
        content            : document.getElementById('content').value.trim(),
        startDate          : startDate,
        endDate            : endDate,
        useYn              : document.querySelector('input[name=useYn]:checked').value,
        questions          : questions,
        deletedQuestionNos : deletedQuestionNos,
        deletedOptionNos   : deletedOptionNos
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
    if (!confirm('설문을 삭제하시겠습니까?\n(사용여부가 N으로 변경됩니다.)')) return;
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

function escHtml(str) {
    var d = document.createElement('div');
    d.appendChild(document.createTextNode(str || ''));
    return d.innerHTML;
}

/* ── 초기 렌더링 ── */
onAddTypeChange();
renderQuestionList();
</script>

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
                                   style="width: auto;"
                                   value="<c:out value='${survey.startDate}'/>" />
                            <span class="text-muted">~</span>
                            <input type="date" id="endDate" class="form-control form-control-sm"
                                   style="width: auto;"
                                   value="<c:out value='${survey.endDate}'/>" />
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

    <!-- ===== 2. 질문 관리 ===== -->
    <div class="bg-white border p-3 mb-3">
        <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
            <h6 class="fw-bold mb-0">질문 관리</h6>
            <button type="button" class="btn btn-outline-primary btn-sm px-3"
                    onclick="addQuestion()">+ 질문 추가</button>
        </div>

        <div id="questionContainer">
            <c:choose>
                <c:when test="${not empty questions}">
                    <c:forEach var="q" items="${questions}" varStatus="vs">
                        <div class="question-block mb-3"
                             data-question-no="${q.boardNo}"
                             data-sort-ord="${vs.index}">
                            <table class="table table-bordered mb-0" style="font-size: 14px;">
                                <colgroup>
                                    <col style="width: 15%"><col>
                                </colgroup>
                                <tbody>
                                    <!-- 1행: 번호 · 유형 · 이동/삭제 -->
                                    <tr class="table-light">
                                        <td class="text-center align-middle fw-bold question-num">${vs.index + 1}</td>
                                        <td>
                                            <div class="d-flex align-items-center justify-content-between">
                                                <select class="form-select form-select-sm q-type" style="width: 140px;"
                                                        onchange="onTypeChange(this)">
                                                    <c:forEach var="t" items="${questionTypes}">
                                                        <option value="${t.codeNo}" ${t.codeNo eq q.type ? 'selected' : ''}>
                                                            <c:out value="${t.codeName}"/>
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <div class="d-flex gap-1">
                                                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="moveQuestion(this,-1)">▲</button>
                                                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="moveQuestion(this, 1)">▼</button>
                                                    <button type="button" class="btn btn-outline-danger    btn-sm" onclick="removeQuestion(this)">삭제</button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- 2행: 질문내용 -->
                                    <tr>
                                        <th class="table-light align-middle text-center">질문내용</th>
                                        <td>
                                            <textarea class="form-control form-control-sm q-content" rows="2"
                                                      placeholder="질문 내용을 입력하세요."><c:out value="${q.content}"/></textarea>
                                        </td>
                                    </tr>
                                    <!-- 3행: 보기 (선택형만) -->
                                    <tr class="option-area <c:if test="${not (q.type eq 'radio' or q.type eq 'select' or q.type eq 'checkbox')}">d-none</c:if>">
                                        <th class="table-light align-middle text-center">응답</th>
                                        <td>
                                            <div class="option-list mb-2">
                                                <c:forEach var="opt" items="${q.options}" varStatus="os">
                                                    <div class="d-flex align-items-center gap-1 mb-1 option-row">
                                                        <c:choose>
                                                            <c:when test="${q.type eq 'radio'}">
                                                                <input type="radio" disabled class="flex-shrink-0">
                                                            </c:when>
                                                            <c:when test="${q.type eq 'checkbox'}">
                                                                <input type="checkbox" disabled class="flex-shrink-0">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted flex-shrink-0 opt-num" style="width:20px;">${os.index + 1}.</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <input type="text" class="form-control form-control-sm opt-content"
                                                               value="<c:out value='${opt.content}'/>" placeholder="보기 내용"
                                                               data-option-no="${opt.optionNo}" />
                                                        <button type="button" class="btn btn-outline-secondary btn-sm px-1" onclick="moveOption(this,-1)">▲</button>
                                                        <button type="button" class="btn btn-outline-secondary btn-sm px-1" onclick="moveOption(this, 1)">▼</button>
                                                        <button type="button" class="btn btn-outline-danger    btn-sm px-1" onclick="removeOption(this)">✕</button>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <button type="button" class="btn btn-outline-secondary btn-sm"
                                                    onclick="addOption(this)">+ 보기 추가</button>
                                        </td>
                                    </tr>
                                    <!-- 4행: 텍스트형 응답 미리보기 -->
                                    <tr class="text-preview <c:if test="${not (q.type eq 'text' or q.type eq 'textarea')}">d-none</c:if>">
                                        <th class="table-light align-middle text-center">응답</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${q.type eq 'textarea'}">
                                                    <textarea class="form-control form-control-sm" rows="2" disabled placeholder="장문형 응답"></textarea>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="text" class="form-control form-control-sm" disabled placeholder="단답형 응답">
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div id="emptyGuide" class="text-center text-muted py-4">질문을 추가해주세요.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- ===== 3. 버튼 영역 ===== -->
    <div class="d-flex justify-content-end gap-2 mb-4">
        <button type="button" class="btn btn-primary px-4"           onclick="saveSurvey()">저장</button>
        <button type="button" class="btn btn-outline-secondary px-4"  onclick="goPost('survey/surveyManage.do')">목록</button>
        <c:if test="${not empty survey}">
            <button type="button" class="btn btn-outline-danger px-4" onclick="deleteSurvey()">삭제</button>
        </c:if>
    </div>

</div>

<!-- ===== 신규 문항 템플릿 (hidden) ===== -->
<div id="questionTemplate" style="display:none;">
    <div class="question-block mb-3" data-question-no="0" data-sort-ord="0">
        <table class="table table-bordered mb-0" style="font-size: 14px;">
            <colgroup>
                <col style="width: 15%"><col>
            </colgroup>
            <tbody>
                <tr class="table-light">
                    <td class="text-center align-middle fw-bold question-num">?</td>
                    <td>
                        <div class="d-flex align-items-center justify-content-between">
                            <select class="form-select form-select-sm q-type" style="width: 140px;"
                                    onchange="onTypeChange(this)">
                                <c:forEach var="t" items="${questionTypes}">
                                    <option value="${t.codeNo}"><c:out value="${t.codeName}"/></option>
                                </c:forEach>
                            </select>
                            <div class="d-flex gap-1">
                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="moveQuestion(this,-1)">▲</button>
                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="moveQuestion(this, 1)">▼</button>
                                <button type="button" class="btn btn-outline-danger    btn-sm" onclick="removeQuestion(this)">삭제</button>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">질문내용</th>
                    <td>
                        <textarea class="form-control form-control-sm q-content" rows="2"
                                  placeholder="질문 내용을 입력하세요."></textarea>
                    </td>
                </tr>
                <tr class="option-area d-none">
                    <th class="table-light align-middle text-center">응답</th>
                    <td>
                        <div class="option-list mb-2"></div>
                        <button type="button" class="btn btn-outline-secondary btn-sm"
                                onclick="addOption(this)">+ 보기 추가</button>
                    </td>
                </tr>
                <tr class="text-preview">
                    <th class="table-light align-middle text-center">응답</th>
                    <td>
                        <input type="text" class="form-control form-control-sm" disabled placeholder="단답형 응답">
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<script>
    const SURVEY_NO = '${survey.surveyNo}';
    const deletedQuestionNos = [];
    const deletedOptionNos   = [];

    /* ===== 문항 추가 ===== */
    function addQuestion() {
        $('#emptyGuide').remove();
        const tmpl  = $('#questionTemplate .question-block').clone(true);
        const count = $('#questionContainer .question-block').length;
        tmpl.attr('data-sort-ord', count);
        $('#questionContainer').prepend(tmpl);
        refreshQuestionNums();
        onTypeChange(tmpl.find('.q-type')[0]);
    }

    /* ===== 문항 삭제 ===== */
    function removeQuestion(btn) {
        const block = $(btn).closest('.question-block');
        const qNo   = block.data('question-no');
        if (qNo && qNo > 0) {
            deletedQuestionNos.push(qNo);
        }
        block.remove();
        refreshQuestionNums();
        if ($('#questionContainer .question-block').length === 0) {
            $('#questionContainer').append('<div id="emptyGuide" class="text-center text-muted py-4">질문을 추가해주세요.</div>');
        }
    }

    /* ===== 문항 순서 이동 ===== */
    function moveQuestion(btn, dir) {
        const block  = $(btn).closest('.question-block');
        const blocks = $('#questionContainer .question-block');
        const idx    = blocks.index(block);
        const ti     = idx + dir;
        if (ti < 0 || ti >= blocks.length) {
            return;
        }
        if (dir === -1) {
            block.insertBefore(blocks.eq(ti));
        } else {
            block.insertAfter(blocks.eq(ti));
        }
        refreshQuestionNums();
    }

    /* ===== Q번호 갱신 ===== */
    function refreshQuestionNums() {
        $('#questionContainer .question-block').each(function(i) {
            $(this).find('.question-num').text(i + 1);
            $(this).attr('data-sort-ord', i);
        });
    }

    /* ===== 유형 변경 ===== */
    function onTypeChange(select) {
        const type     = $(select).val();
        const block    = $(select).closest('.question-block');
        const optArea  = block.find('.option-area');
        const txtPrev  = block.find('.text-preview');
        const isChoice = (type === 'radio' || type === 'select' || type === 'checkbox');

        if (isChoice) {
            txtPrev.addClass('d-none');
            optArea.removeClass('d-none');
            block.find('.option-row').each(function(i) {
                updateOptionIcon($(this), type, i);
            });
        } else {
            optArea.addClass('d-none');
            txtPrev.removeClass('d-none');
            const inner = type === 'textarea'
                ? '<textarea class="form-control form-control-sm" rows="2" disabled placeholder="장문형 응답"></textarea>'
                : '<input type="text" class="form-control form-control-sm" disabled placeholder="단답형 응답">';
            txtPrev.find('td').html(inner);
        }
    }

    /* ===== 보기 아이콘 갱신 (유형 변경 시) ===== */
    function updateOptionIcon(row, type, idx) {
        row.find('input[type=radio], input[type=checkbox], .opt-num').remove();
        let icon;
        if (type === 'radio') {
            icon = $('<input type="radio" disabled class="flex-shrink-0">');
        } else if (type === 'checkbox') {
            icon = $('<input type="checkbox" disabled class="flex-shrink-0">');
        } else {
            icon = $('<span class="text-muted flex-shrink-0 opt-num" style="width:20px;">' + (idx + 1) + '.</span>');
        }
        row.prepend(icon);
    }

    /* ===== 보기 추가 ===== */
    function addOption(btn) {
        const list    = $(btn).siblings('.option-list');
        const type    = $(btn).closest('.question-block').find('.q-type').val();
        const count   = list.find('.option-row').length;
        let iconHtml;
        if (type === 'radio') {
            iconHtml = '<input type="radio" disabled class="flex-shrink-0">';
        } else if (type === 'checkbox') {
            iconHtml = '<input type="checkbox" disabled class="flex-shrink-0">';
        } else {
            iconHtml = '<span class="text-muted flex-shrink-0 opt-num" style="width:20px;">' + (count + 1) + '.</span>';
        }
        const row = $(
            '<div class="d-flex align-items-center gap-1 mb-1 option-row">'
            + iconHtml
            + '<input type="text" class="form-control form-control-sm opt-content" placeholder="보기 내용" data-option-no="0"/>'
            + '<button type="button" class="btn btn-outline-secondary btn-sm px-1" onclick="moveOption(this,-1)">▲</button>'
            + '<button type="button" class="btn btn-outline-secondary btn-sm px-1" onclick="moveOption(this, 1)">▼</button>'
            + '<button type="button" class="btn btn-outline-danger    btn-sm px-1" onclick="removeOption(this)">✕</button>'
            + '</div>'
        );
        list.append(row);
    }

    /* ===== 보기 삭제 ===== */
    function removeOption(btn) {
        const row      = $(btn).closest('.option-row');
        const optionNo = row.find('.opt-content').data('option-no');
        if (optionNo && optionNo > 0) {
            deletedOptionNos.push(optionNo);
        }
        const list = row.closest('.option-list');
        row.remove();
        refreshOptionNums(list);
    }

    /* ===== 보기 순서 이동 ===== */
    function moveOption(btn, dir) {
        const row  = $(btn).closest('.option-row');
        const list = row.closest('.option-list');
        const rows = list.find('.option-row');
        const idx  = rows.index(row);
        const ti   = idx + dir;
        if (ti < 0 || ti >= rows.length) {
            return;
        }
        if (dir === -1) {
            row.insertBefore(rows.eq(ti));
        } else {
            row.insertAfter(rows.eq(ti));
        }
        refreshOptionNums(list);
    }

    /* ===== 보기 번호 갱신 (셀렉트박스만) ===== */
    function refreshOptionNums(list) {
        const type = list.closest('.question-block').find('.q-type').val();
        if (type === 'select') {
            list.find('.option-row').each(function(i) {
                $(this).find('.opt-num').text((i + 1) + '.');
            });
        }
    }

    /* ===== 저장 ===== */
    function saveSurvey() {
        const title     = $('#title').val().trim();
        const startDate = $('#startDate').val();
        const endDate   = $('#endDate').val();

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

        const questions = [];
        let valid = true;

        $('#questionContainer .question-block').each(function(i) {
            const content  = $(this).find('.q-content').val().trim();
            if (!content) {
                alert((i + 1) + '번 문항 내용을 입력하세요.');
                valid = false;
                return false;
            }

            const type     = $(this).find('.q-type').val();
            const isChoice = (type === 'radio' || type === 'select' || type === 'checkbox');
            const options  = [];

            if (isChoice) {
                $(this).find('.option-row').each(function(j) {
                    const optContent = $(this).find('.opt-content').val().trim();
                    if (!optContent) {
                        alert((i + 1) + '번 문항 ' + (j + 1) + '번 보기를 입력하세요.');
                        valid = false;
                        return false;
                    }
                    options.push({
                        optionNo : $(this).find('.opt-content').data('option-no') || 0,
                        content  : optContent,
                        sortOrd  : j
                    });
                });
                if (!valid) { return false; }
                if (options.length === 0) {
                    alert((i + 1) + '번 문항은 선택형이므로 보기를 1개 이상 추가하세요.');
                    valid = false;
                    return false;
                }
            }

            questions.push({
                boardNo : $(this).data('question-no') || 0,
                content : content,
                type    : type,
                sortOrd : i,
                options : options
            });
        });

        if (!valid) { return; }

        const payload = {
            surveyNo           : SURVEY_NO || null,
            title              : title,
            content            : $('#content').val().trim(),
            startDate          : startDate,
            endDate            : endDate,
            useYn              : $('input[name=useYn]:checked').val(),
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
            error : function() {
                alert('서버 오류가 발생하였습니다.');
            }
        });
    }

    /* ===== 삭제 ===== */
    function deleteSurvey() {
        if (!confirm('설문을 삭제하시겠습니까?\n(사용여부가 N으로 변경됩니다.)')) {
            return;
        }
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
            error : function() {
                alert('서버 오류가 발생하였습니다.');
            }
        });
    }
</script>

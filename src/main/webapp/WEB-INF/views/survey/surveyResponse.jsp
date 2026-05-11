<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">설문 참여</h2>
    </div>

    <!-- ===== 1. 설문 기본정보 ===== -->
    <div class="bg-white border p-3 mb-3">
        <table class="table table-bordered mb-0" style="font-size: 14px;">
            <colgroup>
                <col style="width: 15%"><col style="width: 85%">
            </colgroup>
            <tbody>
                <tr>
                    <th class="table-light align-middle text-center">제목</th>
                    <td><c:out value="${survey.title}"/></td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">개요</th>
                    <td style="white-space: pre-wrap;"><c:out value="${survey.content}"/></td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">설문 기간</th>
                    <td><c:out value="${survey.startDate}"/> ~ <c:out value="${survey.endDate}"/></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ===== 2. 질문 목록 ===== -->
    <c:forEach var="q" items="${questions}" varStatus="vs">
        <div class="question-block bg-white border mb-3"
             data-board-no="${q.boardNo}"
             data-type="<c:out value="${q.type}"/>">
            <table class="table table-bordered mb-0" style="font-size: 14px;">
                <colgroup>
                    <col style="width: 15%"><col>
                </colgroup>
                <tbody>
                    <!-- 질문 내용 -->
                    <tr class="table-light">
                        <td class="text-center align-middle fw-bold">Q${vs.index + 1}</td>
                        <td class="align-middle fw-semibold"><c:out value="${q.content}"/></td>
                    </tr>
                    <!-- 질문 이미지 -->
                    <c:if test="${not empty q.imageFileNo and q.imageFileNo gt 0}">
                    <tr>
                        <td colspan="2" class="text-center py-2">
                            <img src="survey/getImage.do?fileNo=${q.imageFileNo}"
                                 alt="질문 이미지" style="max-width: 500px; max-height: 350px;">
                        </td>
                    </tr>
                    </c:if>
                    <!-- 응답 입력 -->
                    <tr>
                        <th class="table-light align-middle text-center">응답</th>
                        <td>
                            <c:choose>
                                <c:when test="${q.type eq 'radio'}">
                                    <c:forEach var="opt" items="${q.options}">
                                        <div class="form-check">
                                            <input type="radio"
                                                   class="form-check-input ans-radio"
                                                   name="q_${q.boardNo}"
                                                   value="${opt.optionNo}">
                                            <label class="form-check-label">
                                                <c:out value="${opt.content}"/>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:when test="${q.type eq 'checkbox'}">
                                    <c:forEach var="opt" items="${q.options}">
                                        <div class="form-check">
                                            <input type="checkbox"
                                                   class="form-check-input ans-checkbox"
                                                   name="q_${q.boardNo}"
                                                   value="${opt.optionNo}">
                                            <label class="form-check-label">
                                                <c:out value="${opt.content}"/>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:when test="${q.type eq 'select'}">
                                    <select class="form-select form-select-sm" name="q_${q.boardNo}" style="width: auto;">
                                        <c:forEach var="opt" items="${q.options}" varStatus="os">
                                            <option value="${opt.optionNo}" ${os.first ? 'selected' : ''}>
                                                <c:out value="${opt.content}"/>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </c:when>
                                <c:when test="${q.type eq 'text'}">
                                    <input type="text"
                                           class="form-control form-control-sm"
                                           name="q_${q.boardNo}"
                                           maxlength="500">
                                </c:when>
                                <c:when test="${q.type eq 'textarea'}">
                                    <textarea class="form-control form-control-sm"
                                              name="q_${q.boardNo}"
                                              rows="3"
                                              maxlength="2000"></textarea>
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </c:forEach>

    <!-- ===== 3. 버튼 영역 ===== -->
    <div class="d-flex justify-content-between mb-4">
        <button type="button" class="btn btn-outline-secondary px-4"
                onclick="goPost('survey/surveyList.do')">목록</button>
        <button type="button" class="btn btn-primary px-4"
                onclick="submitResponse()">설문 참여</button>
    </div>

</div>

<script>
function submitResponse() {
    const payload = {
        surveyNo: ${survey.surveyNo},
        answers: []
    };

    let valid = true;

    $('.question-block').each(function() {
        const boardNo = $(this).data('board-no');
        const type    = $(this).data('type');

        if (type === 'radio' || type === 'select') {
            const val = type === 'radio'
                ? $('input[name=q_' + boardNo + ']:checked').val()
                : $('select[name=q_' + boardNo + ']').val();
            if (!val) {
                alert('모든 질문에 응답해주세요.');
                valid = false;
                return false;
            }
            payload.answers.push({ boardNo: boardNo, type: type, optionNo: parseInt(val) });
        } else if (type === 'checkbox') {
            const checked = [];
            $('input[name=q_' + boardNo + ']:checked').each(function() {
                checked.push(parseInt($(this).val()));
            });
            if (checked.length === 0) {
                alert('모든 질문에 응답해주세요.');
                valid = false;
                return false;
            }
            payload.answers.push({ boardNo: boardNo, type: type, optionNos: checked });
        } else {
            const content = $('[name=q_' + boardNo + ']').val().trim();
            if (!content) {
                alert('모든 질문에 응답해주세요.');
                valid = false;
                return false;
            }
            payload.answers.push({ boardNo: boardNo, type: type, content: content });
        }
    });

    if (!valid) {
        return;
    }

    $.ajax({
        type    : 'post',
        url     : 'survey/surveyResponseSave.do',
        headers : { 'Content-Type': 'application/json' },
        dataType: 'json',
        data    : JSON.stringify(payload),
        success : function(result) {
            if (result.msg === 'D') {
                alert('이미 참여한 설문입니다.');
            } else if (result.msg === 'S') {
                alert('제출되었습니다.');
                goPost('survey/surveyList.do');
            } else {
                alert('제출 중 오류가 발생하였습니다.');
            }
        },
        error : function() {
            alert('서버 오류가 발생하였습니다.');
        }
    });
}
</script>

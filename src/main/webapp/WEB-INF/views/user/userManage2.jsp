<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">
    <h2 class="h5 fw-bold mb-3">사용자 관리</h2>

    <!-- 1. 검색 영역 -->
    <form id="searchForm" method="post" action="user/userManage2.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1"/>
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <select name="searchType" id="searchType" class="form-select" style="width:auto; min-width:100px;">
                    <option value="userId" ${search.searchType eq 'userId' ? 'selected' : ''}>아이디</option>
                    <option value="userName" ${search.searchType eq 'userName' ? 'selected' : ''}>이름</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control" value="${search.searchKeyword}"
                       placeholder="검색어를 입력하세요." maxlength="100"/>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-danger px-4">검색</button>
            </div>
        </div>
    </form>
	
    <!-- 2. 목록 영역 -->
    <div class="bg-white border mb-2">
        <div class="px-3 pt-2 pb-1">
            <small class="text-muted">전체 : <strong style="color:#c0392b;"><fmt:formatNumber value="${paginationInfo.totalRecordCount}" pattern="#,###"/></strong>건</small>
        </div>
        <table class="table table-bordered table-hover mb-0" style="font-size:14px;">
            <thead class="table-light">
                <tr>
                    <th class="text-center" style="width:15%">순번</th>
                    <th class="text-center" style="width:29%">아이디</th>
                    <th class="text-center" style="width:29%">이름</th>
                    <th class="text-center" style="width:25%">사용여부</th>
                </tr>
            </thead>
            <tbody id="userListBody">
            <c:if test="${empty list }"><tr><td colspan="5">데이터가 없습니다.</td></tr></c:if>
            <c:forEach var="user" items="${list}" varStatus="status">
                <tr class="user-row" style="cursor:pointer;" data-user-no="${user.userNo}">
                  <td class="text-center">${paginationInfo.totalRecordCount
                                - (paginationInfo.currentPageNo - 1) * paginationInfo.recordCountPerPage
                                - status.index}</td>
                  <td class="text-center">${user.userId}</td>
                  <td class="text-center">${user.userName }</td>
							    <td class="text-center">
								    <span class="badge p-2 ${user.status eq 'ACTIVE' ? 'bg-success' : 'bg-danger'}">
								        ${user.status eq 'ACTIVE' ? '사용가능' : '사용불가'}
								    </span>
									</td>
            </c:forEach>
        </table>
    </div>

    <!-- 3. 페이징 영역 (더미) -->
    <%-- 페이지네이션: CustomPaginationRenderer 사용 (<<, <, 페이지번호, >, >>) --%>
    <div class="paging mb-3">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
             	<ui:pagination paginationInfo="${paginationInfo}" type="customRenderer" jsFunction="linkPage"/>
            </ul>
        </nav>
    </div>

    <!-- 4. 상세 / 등록 폼 -->
    <div class="bg-white border p-3 mb-3">
    <form id="detailForm" method="post" action="">
        <%-- userNo: 수정/삭제 시 대상 식별용 hidden 필드 --%>
        <input type="hidden" id="userNo" name="userNo" value=""/>
        <table class="table table-bordered mb-0" style="font-size:14px;">
            <colgroup>
                <col style="width:15%">
                <col style="width:35%">
                <col style="width:15%">
                <col style="width:35%">
            </colgroup>
            <tbody>
                <tr>
                    <th class="table-light align-middle">아이디</th>
                    <td>
                        <input type="text" id="userId" name="userId"
                               class="form-control form-control-sm" maxlength="15"
                               placeholder="영문/숫자 5~15자" required/>
                        <p id="userIdMsg" class="guide-msg"></p>
                    </td>
                    <th class="table-light align-middle">이름</th>
                    <td>
                        <input type="text" id="userName" name="userName"
                               class="form-control form-control-sm" maxlength="30"
                               placeholder="이름 입력" required/>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">비밀번호</th>
                    <td colspan="3">
                        <%-- 등록 모드: 새 비밀번호 입력 (필수) --%>
                        <div id="pwRegistDiv">
                            <input type="password" id="userPw" maxlength="25"
                                   class="form-control form-control-sm"
                                   placeholder="숫자+영문+특수문자 조합 10~25자" required/>
                            <p id="userPwMsg" class="guide-msg"></p>
                        </div>
                        <%-- 수정 모드: 현재 비밀번호(마스킹) + 새 비밀번호 선택 입력 --%>
                        <div id="pwUpdateDiv" style="display:none;" class="row g-2">
                            <div class="col-6">
                                <div class="text-muted mb-1" style="font-size:11px;">현재 비밀번호</div>
                                <input type="password" id="userPwView" disabled
                                       class="form-control form-control-sm bg-light"/>
                            </div>
                            <div class="col-6">
                                <div class="text-muted mb-1" style="font-size:11px;">새 비밀번호 (미입력 시 변경 안함)</div>
                                <input type="password" id="userPwChange" maxlength="25"
                                       class="form-control form-control-sm"
                                       placeholder="변경 시에만 입력하세요"/>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">사용여부</th>
                    <td>
                        <select id="status" name="status" class="form-select form-select-sm">
                            <option value="ACTIVE">Y (사용가능)</option>
                            <option value="DISABLED">N (사용불가)</option>
                        </select>
                    </td>
                    <th class="table-light align-middle">사용자구분</th>
                    <td>
                        <select id="role" name="role" class="form-select form-select-sm">
                            <option value="USER">일반사용자</option>
                            <option value="ADMIN">관리자</option>
                            <option value="SYSTEM">시스템관리자</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">최초등록일시</th>
                    <td>
                        <input type="text" id="regDate" class="form-control form-control-sm bg-light" disabled/>
                    </td>
                    <th class="table-light align-middle">최초등록자</th>
                    <td>
                        <input type="text" id="regUserName" class="form-control form-control-sm bg-light" disabled/>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">수정일시</th>
                    <td>
                        <input type="text" id="modDate" class="form-control form-control-sm bg-light" disabled/>
                    </td>
                    <th class="table-light align-middle">수정자</th>
                    <td>
                        <input type="text" id="modUserName" class="form-control form-control-sm bg-light" disabled/>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
    </div>

    <!-- 5. 버튼 영역 -->
    <div class="d-flex justify-content-center gap-2 mb-4">
        <button type="button" class="btn btn-info px-4"            id="btnReset">초기화</button>
        <button type="button" class="btn btn-primary px-4"         id="btnRegist">등록</button>
        <button type="button" class="btn btn-warning px-4"         id="btnUpdate">수정</button>
        <button type="button" class="btn btn-danger px-4"          id="btnDelete">삭제</button>
        <button type="button" class="btn btn-outline-secondary px-4" onclick="goPost('board/list.do')">닫기</button>
    </div>

</div>

<script>
    /*  로그인 사용자 정보 (세션에서 주입)  */
    const LOGIN_USER_NO   = parseInt('${sessionScope.loginUser.userNo}', 10);
    const LOGIN_USER_ROLE = '${sessionScope.loginUser.role}';
    const IS_ADMIN = (LOGIN_USER_ROLE === 'ADMIN' || LOGIN_USER_ROLE === 'SYSTEM');

    /* ===================== 상태 변수 ===================== */
    let selectedUserNo = 0;   // 현재 선택된 사용자 userNo
    let selectedRow    = null;   // 현재 선택된 목록 행 (jQuery 객체)

    /* ===================== 초기화 ===================== */
    $(function () {
        // 페이지 진입 시 등록 모드로 시작
        setRegistMode();

        // 아이디 실시간 검증 (UserValid.idRegex 사용)
        $('#userId').on('input', function () {
            var val = this.value.replace(/[^a-zA-Z0-9]/g, '');
            this.value = val;
            if (val === '') {
                $('#userIdMsg').text('').css('color', '');
            } else if (UserValid.idRegex.test(val)) {
                $('#userIdMsg').text('사용 가능한 아이디입니다.').css('color', 'green');
            } else {
                $('#userIdMsg').text('영문/숫자 5~15자').css('color', 'red');
            }
        });

        // 비밀번호 실시간 검증 (UserValid.pwRegex 사용)
        $('#userPw').on('input', function () {
            var val = this.value;
            if (val === '') {
                $('#userPwMsg').text('').css('color', '');
            } else if (UserValid.pwRegex.test(val)) {
                $('#userPwMsg').text('사용 가능한 비밀번호입니다.').css('color', 'green');
            } else {
                $('#userPwMsg').text('영문+숫자+특수문자 10~25자').css('color', 'red');
            }
        });

        // 이름 공백 자동 제거
        $('#userName').on('input', function () {
            this.value = this.value.replace(/\s/g, '');
        });

        /* ---- 초기화 버튼 ---- */
        $('#btnReset').on('click', function () {
            setRegistMode();
        });

        /* ---- 목록 행 클릭 → 상세 조회 후 수정 모드 전환 ---- */
        $('#userListBody').on('click', '.user-row', function () {
            $('.user-row').removeClass('table-active');
            $(this).addClass('table-active');

            selectedRow    = $(this);
            selectedUserNo = $(this).data('userNo');

            $.ajax({
                type     : 'post',
                url      : 'user/userSelect2.do',
                headers  : { 'Content-Type': 'application/json' },
                dataType : 'json',
                data     : JSON.stringify({ userNo: selectedUserNo }),
                success  : function (result) {
                    if (result.message === 'success') {
                        setUpdateMode(result.user);
                        // 폼 영역으로 스크롤
                        $('#userId')[0].scrollIntoView({ behavior: 'smooth' });
                    } else {
                        alert('조회에 실패하였습니다.');
                    }
                },
                error    : function () {
                    alert('서버 오류가 발생하였습니다.');
                }
            });
        });

        /* ---- 등록 버튼 ---- */
        $('#btnRegist').on('click', function () {
            var userId   = $('#userId').val().trim();
            var userPw   = $('#userPw').val();
            var userName = $('#userName').val().trim();

            if (!userId)                                { alert('아이디를 입력하세요.');               return; }
            if (!UserValid.idRegex.test(userId))        { alert('아이디 형식이 올바르지 않습니다.');   return; }
            if (!userPw)                                { alert('비밀번호를 입력하세요.');             return; }
            if (!UserValid.pwRegex.test(userPw))        { alert('비밀번호 형식이 올바르지 않습니다.'); return; }
            if (!userName)                              { alert('이름을 입력하세요.');                 return; }
            if (!UserValid.nameRegex.test(userName))    { alert('이름 형식이 올바르지 않습니다.');     return; }

            $.ajax({
                type     : 'post',
                url      : 'user/userRegist2.do',
                dataType : 'json',
                data     : {
                    userId   : userId,
                    userPw   : userPw,
                    userName : userName,
                    role     : $('#role').val(),
                    status   : $('#status').val()
                },
                success  : function (result) {
                    if (result.result === 'duplicate') {
                        alert('이미 사용 중인 아이디입니다.');
                    } else if (result.result === 'success') {
                        alert('등록되었습니다.');
                        // 1페이지로 이동하여 새 사용자 확인
                        $('#currentPageNo').val(1);
                        $('#searchForm').submit();
                    } else {
                        alert('등록 중 오류가 발생하였습니다.');
                    }
                },
                error    : function () {
                    alert('서버 오류가 발생하였습니다.');
                }
            });
        });

        /* ---- 수정 버튼 ---- */
        $('#btnUpdate').on('click', function () {
            if (!selectedUserNo) { alert('수정할 사용자를 선택하세요.'); return; }

            var userName    = $('#userName').val().trim();
            var userPwChange = $('#userPwChange').val();

            if (!userName)                                   { alert('이름을 입력하세요.');               return; }
            if (!UserValid.nameRegex.test(userName))         { alert('이름 형식이 올바르지 않습니다.');   return; }
            // 비밀번호 변경 입력이 있는 경우에만 형식 검사
            if (userPwChange && !UserValid.pwRegex.test(userPwChange)) {
                alert('새 비밀번호 형식이 올바르지 않습니다.'); return;
            }
            if (!confirm('수정하시겠습니까?')) return;

            $.ajax({
                type     : 'post',
                url      : 'user/userUpdate2.do',
                dataType : 'json',
                data     : {
                    userNo   : selectedUserNo,
                    userName : userName,
                    userPw   : userPwChange,   // 빈 값이면 서버에서 비밀번호 변경 안 함
                    role     : $('#role').val(),
                    status   : $('#status').val()
                },
                success  : function (result) {
                    if (result.result === 'success') {
                        alert('수정되었습니다.');
                        updateListRow(selectedRow, result.user);
                        setUpdateMode(result.user);
                    } else if (result.result === 'forbidden') {
                        alert('권한이 없습니다.');
                    } else {
                        alert('수정 중 오류가 발생하였습니다.');
                    }
                },
                error    : function () {
                    alert('서버 오류가 발생하였습니다.');
                }
            });
        });

        /* ---- 삭제 버튼 (사용 불가 처리) ---- */
        $('#btnDelete').on('click', function () {
            if (!selectedUserNo) { alert('처리할 사용자를 선택하세요.'); return; }
            if (!confirm('해당 사용자를 사용 불가 처리하시겠습니까?\n(실제로 삭제되지 않습니다.)')) return;

            $.ajax({
                type     : 'post',
                url      : 'user/userDelete2.do',
                dataType : 'json',
                data     : { userNo: selectedUserNo },
                success  : function (result) {
                    if (result.result === 'success') {
                        alert('사용 불가 처리되었습니다.');
                        updateListRow(selectedRow, result.user);
                        setUpdateMode(result.user);
                    } else if (result.result === 'forbidden') {
                        alert('권한이 없습니다.');
                    } else {
                        alert('처리 중 오류가 발생하였습니다.');
                    }
                },
                error    : function () {
                    alert('서버 오류가 발생하였습니다.');
                }
            });
        });
    }); // $(function) end

    /* ===================== 모드 전환 함수 ===================== */

    /* 등록 모드: 폼 초기화 + 등록 버튼 활성 / 수정·삭제 비활성 */
    function setRegistMode() {
        selectedUserNo = null;
        selectedRow    = null;
        $('.user-row').removeClass('table-active');

        // 폼 초기화
        $('#userNo').val('');
        $('#userId').val('').prop('disabled', false);
        $('#userName').val('');
        $('#status').val('ACTIVE');
        $('#role').val('USER');
        $('#regDate, #regUserName, #modDate, #modUserName').val('');

        // 비밀번호 영역: 등록 모드
        $('#pwRegistDiv').show();
        $('#pwUpdateDiv').hide();
        $('#userPw').val('');
        $('#userPwChange').val('');

        // 가이드 메시지 초기화
        $('#userIdMsg, #userPwMsg').text('').css('color', '');

        // 버튼 상태 (권한에 따라 분기)
        // [롤백] IS_ADMIN 조건 제거하고 아래 3줄만 남기면 원래대로:
        // $('#btnRegist').prop('disabled', false).removeClass('btn-secondary').addClass('btn-primary');
        // $('#btnUpdate').prop('disabled', true).removeClass('btn-warning').addClass('btn-secondary');
        // $('#btnDelete').prop('disabled', true).removeClass('btn-danger').addClass('btn-secondary');
        if (IS_ADMIN) {
            // 관리자: 등록 활성, 수정·삭제 비활성 (등록 모드 기본 상태)
            $('#btnReset').prop('disabled', false).removeClass('btn-secondary').addClass('btn-info');
            $('#btnRegist').prop('disabled', false).removeClass('btn-secondary').addClass('btn-primary');
            $('#btnUpdate').prop('disabled', true).removeClass('btn-warning').addClass('btn-secondary');
            $('#btnDelete').prop('disabled', true).removeClass('btn-danger').addClass('btn-secondary');
        } else {
            // 일반 사용자: 초기화·등록·삭제 비활성 (수정만 가능 - 행 선택 후 활성화)
            $('#btnReset').prop('disabled', true).removeClass('btn-info').addClass('btn-secondary');
            $('#btnRegist').prop('disabled', true).removeClass('btn-primary').addClass('btn-secondary');
            $('#btnUpdate').prop('disabled', true).removeClass('btn-warning').addClass('btn-secondary');
            $('#btnDelete').prop('disabled', true).removeClass('btn-danger').addClass('btn-secondary');
        }
    }

    /* 수정 모드: 조회 데이터 폼에 채우기 + 수정·삭제 버튼 활성 / 등록 비활성 */
    function setUpdateMode(user) {
        $('#userNo').val(user.userNo);
        $('#userId').val(user.userId).prop('disabled', true);  // 아이디 변경 불가
        $('#userName').val(user.userName);
        $('#status').val(user.status);
        $('#role').val(user.role);
        $('#regDate').val(user.regDate       || '');
        $('#regUserName').val(user.regUserName || '');
        $('#modDate').val(user.modDate       || '');
        $('#modUserName').val(user.modUserName || '');

        // 비밀번호 영역: 수정 모드
        $('#pwRegistDiv').hide();
        $('#pwUpdateDiv').show();
        $('#userPwView').val('*'.repeat(user.userPwLen || 0));
        $('#userPwChange').val('');

        // 가이드 메시지 초기화
        $('#userIdMsg, #userPwMsg').text('').css('color', '');

        // 버튼 상태 (권한 + 본인 여부에 따라 분기)
        // [롤백] IS_ADMIN/본인 조건 제거하고 아래 3줄만 남기면 원래대로:
        // $('#btnRegist').prop('disabled', true).removeClass('btn-primary').addClass('btn-secondary');
        // $('#btnUpdate').prop('disabled', false).removeClass('btn-secondary').addClass('btn-warning');
        // $('#btnDelete').prop('disabled', false).removeClass('btn-secondary').addClass('btn-danger');
        var isSelf = (user.userNo == LOGIN_USER_NO);
        $('#btnRegist').prop('disabled', true).removeClass('btn-primary').addClass('btn-secondary');
        if (IS_ADMIN) {
            // 관리자: 수정·삭제 활성. 단, 본인 삭제 불가
            $('#btnUpdate').prop('disabled', false).removeClass('btn-secondary').addClass('btn-warning');
            $('#btnDelete').prop('disabled', isSelf).removeClass('btn-secondary btn-danger').addClass(isSelf ? 'btn-secondary' : 'btn-danger');
        } else {
            // 일반 사용자: 본인만 수정 가능, 삭제 불가
            $('#btnUpdate').prop('disabled', !isSelf).removeClass('btn-secondary btn-warning').addClass(isSelf ? 'btn-warning' : 'btn-secondary');
            $('#btnDelete').prop('disabled', true).removeClass('btn-danger').addClass('btn-secondary');
        }
    }

    /* ===================== 목록 행 in-place 갱신 ===================== */
    function updateListRow($row, user) {
        // 이름 셀 (3번째 td, index 2)
        $row.find('td:eq(2)').text(user.userName);
        // 사용여부 배지 갱신
        var isActive   = user.status === 'ACTIVE';
        var badgeClass = isActive ? 'bg-success' : 'bg-danger';
        var badgeText  = isActive ? '사용가능'   : '사용불가';
        $row.find('.badge')
            .removeClass('bg-success bg-danger')
            .addClass(badgeClass)
            .text(badgeText);
    }

    /* ===================== 페이지네이션 ===================== */
    // linkPage: CustomPaginationRenderer 가 전역 함수로 호출 → $(function) 바깥에 선언
    function linkPage(pageNo) {
        $('#currentPageNo').val(pageNo);
        $('#searchForm').submit();
    }
</script>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!-- 백업 임시용 파일 -->
<div class="px-1">
    <h2 class="h5 fw-bold mb-3">사용자 관리</h2>

    <!-- 1. 검색 영역 -->
    <form id="searchForm" method="post" action="user/userManage.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1"/>
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <select name="searchType" id="searchType" class="form-select" style="width:auto; min-width:100px;">
                    <option value="userId">아이디</option>
                    <option value="userName">이름</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control"
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
            <small class="text-muted">전체 : <strong class="text-danger">3</strong>건</small>
        </div>
        <table class="table table-bordered table-hover mb-0" style="font-size:14px;">
            <thead class="table-light">
                <tr>
                    <th class="text-center" style="width:10%">순번</th>
                    <th class="text-center" style="width:25%">아이디</th>
                    <th class="text-center" style="width:25%">이름</th>
                    <th class="text-center" style="width:20%">사용여부</th>
                    <th class="text-center" style="width:20%">권한</th>
                </tr>
            </thead>
            <tbody id="userListBody">
                <tr class="user-row" style="cursor:pointer;"
                    data-userno="1"
                    data-userid="admin"
                    data-username="관리자"
                    data-role="SYSTEM"
                    data-status="ACTIVE"
                    data-regdate="2026-01-01 09:00"
                    data-moddate="2026-01-01 09:00"
                    data-regusername="관리자"
                    data-modusername="관리자">
                    <td class="text-center">3</td>
                    <td class="text-center">admin</td>
                    <td class="text-center">관리자</td>
                    <td class="text-center"><span class="badge bg-success">사용</span></td>
                    <td class="text-center"><span class="badge bg-danger">시스템관리자</span></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 3. 페이징 영역 (더미) -->
    <div class="paging mb-3">
        <nav>
            <ul class="pagination justify-content-center">
                <li class="page-item disabled"><a class="page-link">&lt;&lt;</a></li>
                <li class="page-item disabled"><a class="page-link">&lt;</a></li>
                <li class="page-item active"><a class="page-link">1</a></li>
                <li class="page-item disabled"><a class="page-link">&gt;</a></li>
                <li class="page-item disabled"><a class="page-link">&gt;&gt;</a></li>
            </ul>
        </nav>
    </div>

    <!-- 4. 상세 / 등록 폼 -->
    <div class="bg-white border p-3 mb-3">
        <table class="table table-bordered mb-0" style="font-size:14px;">
            <colgroup>
                <col style="width:15%">
                <col style="width:35%">
                <col style="width:15%">
                <col style="width:35%">
            </colgroup>
            <tbody>
                <tr>
                    <th class="table-light align-middle">아이디 (영문)</th>
                    <td>
                        <div class="d-flex gap-1">
                            <input type="text" id="dUserId"
                                   class="form-control form-control-sm" maxlength="50" placeholder="영문 입력"/>
                        </div>
                    </td>
                    <th class="table-light align-middle">이름</th>
                    <td>
                        <input type="text" id="dUserName"
                               class="form-control form-control-sm" maxlength="50"/>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">비밀번호</th>
                    <td>
                        <input type="password" id="dUserPw"
                               class="form-control form-control-sm" placeholder="변경 시에만 입력"/>
                    </td>
                    <th class="table-light align-middle">사용자구분</th>
                    <td>
                        <select id="dRole" class="form-select form-select-sm">
                            <option value="USER">일반사용자</option>
                            <option value="ADMIN">관리자</option>
                            <option value="SYSTEM">시스템관리자</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">사용여부</th>
                    <td>
                        <select id="dStatus" class="form-select form-select-sm">
                            <option value="ACTIVE">Y (사용)</option>
                            <option value="DISABLED">N (미사용)</option>
                        </select>
                    </td>
                    <th class="table-light align-middle">최초등록자</th>
                    <td>
                        <input type="text" id="dRegUserName" class="form-control form-control-sm bg-light" readonly/>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">최초등록일시</th>
                    <td>
                        <input type="text" id="dRegDate" class="form-control form-control-sm bg-light" readonly/>
                    </td>
                    <th class="table-light align-middle">수정자</th>
                    <td>
                        <input type="text" id="dModUserName" class="form-control form-control-sm bg-light" readonly/>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">수정일시</th>
                    <td>
                        <input type="text" id="dModDate" class="form-control form-control-sm bg-light" readonly/>
                    </td>
                    <td colspan="2"></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 5. 버튼 영역 -->
    <div class="d-flex justify-content-center gap-2 mb-4">
        <button type="button" class="btn btn-secondary px-4" id="btnReset">초기화</button>
        <button type="button" class="btn btn-primary px-4"    id="btnRegist">등록</button>
        <button type="button" class="btn btn-warning px-4"    id="btnUpdate">수정</button>
        <button type="button" class="btn btn-danger px-4"     id="btnDelete">삭제</button>
        <button type="button" class="btn btn-outline-secondary px-4" id="btnClose">닫기</button>
    </div>

</div>

<script>
var selectedUserNo = null;
var idChecked      = false;

$(function() {

    /* 목록 행 클릭 → 폼에 데이터 채우기 */
    $('#userListBody').on('click', '.user-row', function() {
        $('.user-row').removeClass('table-active');
        $(this).addClass('table-active');

        var $row   = $(this);
        selectedUserNo = $row.data('userno');
        idChecked      = true;

        $('#dUserId').val($row.data('userid')).prop('readonly', true);
        $('#dUserName').val($row.data('username'));
        $('#dUserPw').val('');
        $('#dRole').val($row.data('role'));
        $('#dStatus').val($row.data('status'));
        $('#dRegUserName').val($row.data('regusername') || '');
        $('#dModUserName').val($row.data('modusername') || '');
        $('#dRegDate').val($row.data('regdate')         || '');
        $('#dModDate').val($row.data('moddate')         || '');
        $('#btnIdCheck').prop('disabled', true);

        // 폼 영역으로 스크롤
        $('html, body').animate({ scrollTop: $('#dUserId').closest('.bg-white.border').offset().top - 20 }, 300);
    });

    /* 초기화 */
    $('#btnReset').on('click', function() {
        $('.user-row').removeClass('table-active');
        selectedUserNo = null;
        idChecked      = false;

        $('#dUserId').val('').prop('readonly', false);
        $('#dUserName').val('');
        $('#dUserPw').val('');
        $('#dRole').val('USER');
        $('#dStatus').val('ACTIVE');
        $('#dRegUserName').val('');
        $('#dModUserName').val('');
        $('#dRegDate').val('');
        $('#dModDate').val('');
        $('#btnIdCheck').prop('disabled', false);
    });

    /* 등록 (알림만 - 테스트용) */
    $('#btnRegist').on('click', function() {
        if (!$('#dUserId').val().trim())   { alert('아이디를 입력하세요.');       return; }
        if (!idChecked)                    { alert('아이디 중복확인을 해주세요.'); return; }
        if (!$('#dUserName').val().trim()) { alert('이름을 입력하세요.');         return; }
        if (!$('#dUserPw').val().trim())   { alert('비밀번호를 입력하세요.');     return; }
        alert('[테스트] 등록 버튼 동작 확인');
    });

    /* 수정 (알림만 - 테스트용) */
    $('#btnUpdate').on('click', function() {
        if (!selectedUserNo) { alert('수정할 사용자를 선택하세요.'); return; }
        alert('[테스트] 수정 버튼 동작 확인 (userNo: ' + selectedUserNo + ')');
    });

    /* 삭제 (알림만 - 테스트용) */
    $('#btnDelete').on('click', function() {
        if (!selectedUserNo) { alert('삭제할 사용자를 선택하세요.'); return; }
        if (!confirm('해당 사용자를 사용 불가(N) 처리하시겠습니까?')) return;
        alert('[테스트] 삭제 버튼 동작 확인 (userNo: ' + selectedUserNo + ')');
    });

    /* 닫기 */
    $('#btnClose').on('click', function() {
        goPost('board/list.do');
    });

}); // $(function) end
</script>

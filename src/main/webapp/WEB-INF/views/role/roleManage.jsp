<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">롤 관리</h2>
    </div>

    <!-- 1. 검색 영역 -->
    <form id="searchForm" method="post" action="role/roleManage.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1" />
        <div class="border bg-white p-3 mb-3">
            <div class="row row-cols-1 row-cols-md-5 mb-2 flex-wrap align-items-end">
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">롤 코드</label>
                    <input type="text" name="searchRoleId" id="searchRoleId" class="form-control form-control-sm"
                           value="<c:out value="${search.searchRoleId}"/>" placeholder="롤 코드를 입력하세요" maxlength="200" />
                </div>
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">롤 명</label>
                    <input type="text" name="searchRoleName" id="searchRoleName" class="form-control form-control-sm"
                           value="<c:out value="${search.searchRoleName}"/>" placeholder="롤 명을 입력하세요" maxlength="50" />
                </div>
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">사용자구분코드</label>
                    <select name="searchRoleRank" id="searchRoleRank" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach var="code" items="${userTypeOptions}">
                            <option value="${code.codeNo}" ${search.searchRoleRank eq code.codeNo ? 'selected' : ''}>
                                <c:out value="${code.codeName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">사용 여부</label>
                    <select name="searchUseYn" id="searchUseYn" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach var="code" items="${useYnOptions}">
                          <option value="${code.codeNo}" ${search.searchUseYn eq code.codeNo ? 'selected' : ''}>
                              <c:out value="${code.codeName}"/>
                          </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">관리자 여부</label>
                    <select name="searchAdminYn" id="searchAdminYn" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach var="code" items="${adminYnOptions}">
                            <option value="${code.codeNo}" ${search.searchAdminYn eq code.codeNo ? 'selected' : ''}>
                                <c:out value="${code.codeName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-1">
                    <label class="form-label mb-0 me-1" style="font-size: 13px;">페이지당</label>
                    <select class="form-select form-select-sm" name="recordPerPage" id="recordPerPage" style="width: auto;">
									    <c:forEach var="size" items="3,5,10">
									        <option value="${size}" ${search.recordPerPage eq size ? 'selected' : ''}>
									            ${size}건
									        </option>
									    </c:forEach>
										</select>
                </div>
                <div>
                    <button type="button" class="btn btn-light btn-sm px-3" onclick="resetSearch()">초기화</button>
                    <button type="submit" class="btn btn-danger btn-sm px-3">조회</button>
                </div>
            </div>
        </div>
    </form>

    <!-- 2. 목록 영역 -->
    <div class="bg-white border mb-3">
        <div class="px-3 pt-2 pb-1 d-flex justify-content-between align-items-center">
            <small class="text-muted">전체 :
                <strong style="color: #c0392b;">${paginationInfo.totalRecordCount}</strong>건
            </small>
            <button type="button" class="btn btn-primary btn-sm px-3"
                    onclick="setInsertMode()">신규 추가</button>
        </div>
        <table class="table table-bordered table-hover mb-0" style="font-size: 14px;">
            <colgroup>
                <col style="width: 15%">
                <col style="width: 18%">
                <col>
                <col style="width: 10%">
                <col style="width: 10%">
                <col style="width: 15%">
            </colgroup>
            <thead class="table-light">
                <tr>
                    <th class="text-center">롤 코드</th>
                    <th class="text-center">롤 명</th>
                    <th class="text-center">설명</th>
                    <th class="text-center">관리자여부</th>
                    <th class="text-center">사용여부</th>
                    <th class="text-center">등록일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-3">권한 그룹이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="role" items="${list}">
                            <tr style="cursor: pointer;" onclick="loadDetail(${role.roleNo})">
                                <td class="text-center"><c:out value="${role.roleId}"/></td>
                                <td class="text-start"><c:out value="${role.roleName}"/></td>
                                <td class="text-start"><c:out value="${role.roleDesc}"/></td>
                                <td class="text-center"><c:out value="${role.adminYn}"/></td>
                                <td class="text-center"><c:out value="${role.useYn}"/></td>
                                <td class="text-center"><c:out value="${role.regDate}"/></td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 3. 페이징 영역 -->
    <div class="paging mb-3">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}"
                               type="customRenderer" jsFunction="linkPage"/>
            </ul>
        </nav>
    </div>

    <!-- 4. 상세 / 등록 영역 -->
    <div class="bg-white border p-3 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="fw-bold mb-0" id="detailTitle">롤 상세</h6>
        </div>
        <form id="detailForm" name="dtlFrm">
        <input type="hidden" id="dtlRoleNo" name="roleNo" value="" />
        <table class="table table-bordered mb-3" style="font-size: 14px;">
            <colgroup>
                <col style="width: 15%">
                <col style="width: 35%">
                <col style="width: 15%">
                <col style="width: 35%">
            </colgroup>
            <tbody>
                <tr>
                    <th class="table-light align-middle text-center">롤 코드</th>
                    <td><input type="text" id="dtlRoleId" name="roleId" class="form-control form-control-sm bg-light" maxlength="100" readOnly placeholder="자동 생성입니다." /></td>
                    <th class="table-light align-middle text-center">사용자구분코드</th>
                    <td>
                        <select id="dtlRoleRank" name="roleRank" class="form-select form-select-sm">
                            <c:forEach var="code" items="${userTypeOptions}">
                            	<c:if test="${code.codeNo ne '70030' }">
                                <option value="${code.codeNo}"><c:out value="${code.codeName}"/></option>
                            	</c:if>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">롤 명</th>
                    <td><input type="text" id="dtlRoleName" name="roleName" class="form-control form-control-sm" maxlength="100" /></td>
                    <th class="table-light align-middle text-center">관리자 여부</th>
                    <td>
                        <select id="dtlAdminYn" name="adminYn" class="form-select form-select-sm">
                            <c:forEach var="code" items="${adminYnOptions}">
                                <option value="${code.codeNo}" ${code.codeNo eq 'N' ? 'selected' : ''}><c:out value="${code.codeName}"/></option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center" rowspan="2">롤 설명</th>
                    <td rowspan="2">
                        <textarea id="dtlRoleDesc" name="roleDesc" class="form-control form-control-sm" rows="3" maxlength="500"></textarea>
                    </td>
                    <th class="table-light align-middle text-center">사용 여부</th>
                    <td>
                        <select id="dtlUseYn" name=useYn class="form-select form-select-sm">
                            <c:forEach var="code" items="${useYnOptions}">
                                <option value="${code.codeNo}"><c:out value="${code.codeName}"/></option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">정렬 순서</th>
                    <td><input type="number" id="dtlSortOrd" name="sortOrd" class="form-control form-control-sm" min="0" value="1" /></td>
                </tr>
            </tbody>
        </table>
        <div class="d-flex justify-content-end gap-2">
            <button type="button" id="btnDelete" class="btn btn-danger btn-sm px-3" disabled onclick="deleteRole()">삭제</button>
            <button type="button" id="btnSave" class="btn btn-primary btn-sm px-3" onclick="saveRole()">저장</button>
        </div>
        </form>
    </div>

</div>

<script>

/* 페이지네이션 페이지 이동 */
function linkPage(pageNo) {
    $('#currentPageNo').val(pageNo);
    $('#searchForm').submit();
}

 /* 검색 조건 초기화 */
function resetSearch() {
	$('#searchForm input').val(''); // 페이지 번호는 빈값일시 컨트롤러에서 1로 초기화
	$('#searchForm select').prop("selectedIndex", 0);
}

/* 등록 모드 */
function setInsertMode() {
    const $form = $('#detailForm');

    // 1. 폼 초기화
    $form.find('input, textarea').val('');
    $form.find('select').prop('selectedIndex', 0);

    // 2. 동적으로 추가됐던 임시 옵션(시스템관리자 등) 제거
    $form.find('option[data-temp="true"]').remove();

    // 3. 기본값 세팅
    $('#dtlAdminYn').val('N');
    $('#dtlUseYn').val('Y');
    $('#dtlSortOrd').val('1');

    // 4. UI 제어
    $('#dtlRoleRank').prop('disabled', false);
    $('#btnSave').prop('disabled', false);
    $('#btnDelete').prop('disabled', true);
    $('#dtlRoleName')[0].scrollIntoView({ behavior: 'smooth', block: 'start' });
    $('#dtlRoleName').focus();
}

/* 행 클릭 → AJAX 상세 조회 → 수정 모드 */
function loadDetail(roleNo) {
    $.ajax({
        type    : 'post',
        url     : 'role/roleDetail.do',
        data    : { roleNo: roleNo },
        dataType: 'json',
        success : result => {
            if (result.msg !== 'S') {
                alert(result.desc);
                return;
            }
            const role  = result.role;
            const $form = $('#detailForm');

            // 1. 이전 임시 옵션 제거 후 select 활성화 초기화
            $form.find('option[data-temp="true"]').remove();
            $('#dtlRoleRank').prop('disabled', false);

            // 2. 시스템관리자(70030): 수정·삭제 불가 처리
            if (role.roleRank === '70030') {
                $('#dtlRoleRank').append('<option value="70030" data-temp="true">시스템관리자</option>');
                $('#dtlRoleRank').prop('disabled', true);
                $('#btnSave').prop('disabled', true);
                $('#btnDelete').prop('disabled', true);
            } else {
                $('#btnSave').prop('disabled', false);
                $('#btnDelete').prop('disabled', false);
            }

            // 3. 데이터 바인딩 (name 속성과 key 매칭)
            Object.keys(role).forEach(key => {
                const $el = $form.find('[name=' + key + ']');
                if ($el.length > 0) $el.val(role[key]);
            });

            $('#dtlRoleName')[0].scrollIntoView({ behavior: 'smooth', block: 'start' });
        },
        error : () => { alert('서버 오류가 발생하였습니다.'); }
    });
}

/* 등록 or 수정 */
function saveRole() {
    const roleName = $('#dtlRoleName').val();
    const roleRank = $('#dtlRoleRank').val();
    const adminYn  = $('#dtlAdminYn').val();
    const useYn    = $('#dtlUseYn').val();
    const sortOrd  = $('#dtlSortOrd').val();

    if (!roleName) { alert('롤 명을 입력해 주세요.'); $('#dtlRoleName').focus(); return; }
    if (!roleRank) { alert('사용자 구분코드를 선택해 주세요.'); return; }
    if (!adminYn)  { alert('관리자 여부를 선택해 주세요.'); return; }
    if (!useYn)    { alert('사용 여부를 선택해 주세요.'); return; }
    if (sortOrd === '') { alert('정렬 순서를 입력해 주세요.'); $('#dtlSortOrd').focus(); return; }

    $.ajax({
        type    : 'post',
        url     : 'role/roleSave.do',
        data    : {
            roleNo  : $('#dtlRoleNo').val(),
            roleId  : $('#dtlRoleId').val(),
            roleName: roleName,
            roleRank: roleRank,
            adminYn : adminYn,
            useYn   : useYn,
            roleDesc: $('#dtlRoleDesc').val(),
            sortOrd : sortOrd
        },
        dataType: 'json',
        success : result => {
            alert(result.desc);
            if (result.msg === 'S') $('#searchForm').submit();
        },
        error : () => { alert('서버 오류가 발생하였습니다.'); }
    });
}

/* 롤 삭제 */
function deleteRole() {
    if (!confirm('정말 삭제하시겠습니까?')) return;
    const roleNo = $('#dtlRoleNo').val();
    $.ajax({
        type    : 'post',
        url     : 'role/roleDelete.do',
        data    : { roleNo: roleNo },
        dataType: 'json',
        success : result => {
            alert(result.desc);
            if (result.msg === 'S') $('#searchForm').submit();
        },
        error : () => { alert('서버 오류가 발생하였습니다.'); }
    });
}
</script>

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
        <input type="hidden" name="recordPerPage" id="recordPerPage"
               value="<c:out value="${search.recordPerPage}"/>" />
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2 flex-wrap align-items-end">
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">롤 코드</label>
                    <input type="text" name="searchRoleId" class="form-control form-control-sm"
                           value="<c:out value="${search.searchRoleId}"/>" placeholder="롤 코드" maxlength="90" />
                </div>
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">롤 명</label>
                    <input type="text" name="searchRoleName" class="form-control form-control-sm"
                           value="<c:out value="${search.searchRoleName}"/>" placeholder="롤 명" maxlength="90" />
                </div>
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">사용자구분코드</label>
                    <select name="searchRoleRank" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach var="code" items="${userTypeCodes}">
                            <option value="${code.codeNo}"
                                    ${search.searchRoleRank eq code.codeNo ? 'selected' : ''}>
                                <c:out value="${code.codeName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">사용 여부</label>
                    <select name="searchUseYn" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach var="code" items="${useYnCodes}">
                            <option value="${code.codeNo}"
                                    ${search.searchUseYn eq code.codeNo ? 'selected' : ''}>
                                <c:out value="${code.codeName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="form-label mb-1" style="font-size: 13px;">관리자 여부</label>
                    <select name="searchAdminYn" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach var="code" items="${adminYnCodes}">
                            <option value="${code.codeNo}"
                                    ${search.searchAdminYn eq code.codeNo ? 'selected' : ''}>
                                <c:out value="${code.codeName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-1">
                    <label class="form-label mb-0 me-1" style="font-size: 13px;">페이지당</label>
                    <select class="form-select form-select-sm" style="width: auto;"
                            onchange="changeRecordPerPage(this.value)">
                        <option value="10" ${search.recordPerPage eq '10' or empty search.recordPerPage ? 'selected' : ''}>10건</option>
                        <option value="20" ${search.recordPerPage eq '20' ? 'selected' : ''}>20건</option>
                        <option value="50" ${search.recordPerPage eq '50' ? 'selected' : ''}>50건</option>
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
                    onclick="setInsertMode()">등록</button>
        </div>
        <table class="table table-bordered table-hover mb-0" style="font-size: 14px;">
            <colgroup>
                <col style="width: 15%">
                <col style="width: 18%">
                <col>
                <col style="width: 12%">
                <col style="width: 8%">
                <col style="width: 8%">
                <col style="width: 12%">
            </colgroup>
            <thead class="table-light">
                <tr>
                    <th class="text-center">롤 코드</th>
                    <th class="text-center">롤 명</th>
                    <th class="text-center">설명</th>
                    <th class="text-center">사용자구분코드</th>
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
                                <td class="text-center"><c:out value="${role.roleRank}"/></td>
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
        <input type="hidden" id="dtlRoleNo" value="" />
        <table class="table table-bordered mb-3" style="font-size: 14px;">
            <colgroup>
                <col style="width: 15%"><col style="width: 35%">
                <col style="width: 15%"><col style="width: 35%">
            </colgroup>
            <tbody>
                <tr>
                    <th class="table-light align-middle text-center">롤 코드</th>
                    <td><input type="text" id="dtlRoleId" class="form-control form-control-sm" maxlength="100" readonly /></td>
                    <th class="table-light align-middle text-center">사용자구분코드</th>
                    <td>
                        <select id="dtlRoleRank" class="form-select form-select-sm">
                            <c:forEach var="code" items="${userTypeCodes}">
                                <option value="${code.codeNo}"><c:out value="${code.codeName}"/></option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">롤 명</th>
                    <td><input type="text" id="dtlRoleName" class="form-control form-control-sm" maxlength="100" /></td>
                    <th class="table-light align-middle text-center">관리자 여부</th>
                    <td>
                        <select id="dtlAdminYn" class="form-select form-select-sm">
                            <c:forEach var="code" items="${adminYnCodes}">
                                <option value="${code.codeNo}"><c:out value="${code.codeName}"/></option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center" rowspan="2">롤 설명</th>
                    <td rowspan="2">
                        <textarea id="dtlRoleDesc" class="form-control form-control-sm" rows="3" maxlength="500"></textarea>
                    </td>
                    <th class="table-light align-middle text-center">사용 여부</th>
                    <td>
                        <select id="dtlUseYn" class="form-select form-select-sm">
                            <c:forEach var="code" items="${useYnCodes}">
                                <option value="${code.codeNo}"><c:out value="${code.codeName}"/></option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle text-center">정렬 순서</th>
                    <td><input type="number" id="dtlSortOrd" class="form-control form-control-sm" min="0" /></td>
                </tr>
            </tbody>
        </table>
        <div class="d-flex justify-content-end gap-2">
            <button type="button" id="btnDelete" class="btn btn-outline-danger btn-sm px-3"
                    style="display: none;" onclick="deleteRole()">삭제</button>
            <button type="button" id="btnSave" class="btn btn-primary btn-sm px-3"
                    onclick="saveRole()">저장</button>
        </div>
    </div>

</div>

<script>
function linkPage(pageNo) {
    document.getElementById('currentPageNo').value = pageNo;
    document.getElementById('searchForm').submit();
}

function changeRecordPerPage(val) {
    document.getElementById('recordPerPage').value = val;
    document.getElementById('currentPageNo').value = 1;
    document.getElementById('searchForm').submit();
}

function resetSearch() {
    document.getElementById('currentPageNo').value = 1;
    document.getElementById('searchForm').reset();
    document.getElementById('recordPerPage').value = '10';
    document.getElementById('searchForm').submit();
}

/* 등록 모드 */
function setInsertMode() {
    document.getElementById('detailTitle').innerText = '롤 등록';
    document.getElementById('dtlRoleNo').value   = '';
    document.getElementById('dtlRoleId').value   = '';
    document.getElementById('dtlRoleName').value = '';
    document.getElementById('dtlRoleDesc').value = '';
    document.getElementById('dtlSortOrd').value  = '';
    document.getElementById('dtlRoleRank').value = '';
    document.getElementById('dtlAdminYn').value  = 'N';
    document.getElementById('dtlUseYn').value    = 'Y';
    document.getElementById('dtlRoleId').readOnly = false;
    document.getElementById('btnDelete').style.display = 'none';
    document.getElementById('dtlRoleName').focus();
}

/* 행 클릭 → AJAX 상세 조회 → 수정 모드 */
function loadDetail(roleNo) {
    $.ajax({
        type    : 'post',
        url     : 'role/roleDetail.do',
        data    : { roleNo: roleNo },
        dataType: 'json',
        success : function(result) {
            if (result.msg !== 'S') {
                alert('조회 중 오류가 발생하였습니다.');
                return;
            }
            var d = result.data;
            document.getElementById('detailTitle').innerText  = '롤 수정';
            document.getElementById('dtlRoleNo').value        = d.roleNo   || '';
            document.getElementById('dtlRoleId').value        = d.roleId   || '';
            document.getElementById('dtlRoleName').value      = d.roleName || '';
            document.getElementById('dtlRoleDesc').value      = d.roleDesc || '';
            document.getElementById('dtlSortOrd').value       = d.sortOrd  || '';
            document.getElementById('dtlRoleRank').value      = d.roleRank || '';
            document.getElementById('dtlAdminYn').value       = d.adminYn  || '';
            document.getElementById('dtlUseYn').value         = d.useYn    || '';
            document.getElementById('dtlRoleId').readOnly     = true;
            document.getElementById('btnDelete').style.display = '';
        },
        error : function() {
            alert('서버 오류가 발생하였습니다.');
        }
    });
}

function saveRole() {
    alert('저장 기능은 추후 구현 예정입니다.');
}

function deleteRole() {
    alert('삭제 기능은 추후 구현 예정입니다.');
}
</script>

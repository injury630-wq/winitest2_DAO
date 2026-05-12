<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">권한별 사용자 관리</h2>
    </div>

    <!-- 검색 폼 -->
    <form id="searchForm" method="post" action="role/userRole.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1" />
        <div class="bg-white border mb-3 p-2">
            <div class="d-flex gap-2 align-items-center flex-wrap">
                <label class="form-label mb-0" style="font-size: 13px; white-space: nowrap;">권한유형</label>
                <select name="searchRoleNo" class="form-select form-select-sm" style="width: 160px;">
                    <option value="">전체</option>
                    <c:forEach var="role" items="${roleList}">
                        <option value="${role.roleNo}" ${param.searchRoleNo eq role.roleNo ? 'selected' : ''}>
                            <c:out value="${role.roleName}"/>
                        </option>
                    </c:forEach>
                </select>
                <label class="form-label mb-0 ms-2" style="font-size: 13px; white-space: nowrap;">이름</label>
                <input type="text" name="searchUserName" class="form-control form-control-sm"
                       placeholder="이름 검색" maxlength="50" style="width: 140px;"
                       value="<c:out value='${param.searchUserName}'/>"/>
                <button type="submit" class="btn btn-primary btn-sm px-3">조회</button>
            </div>
        </div>
    </form>

    <!-- 적용 폼: roleNo hidden + userNos 체크박스를 묶어 serialize()로 AJAX 전송 -->
    <form id="applyForm">
        <input type="hidden" name="roleNo" id="selectedRoleNo" value=""/>

        <div class="row g-3">

            <!-- 좌측: 권한 목록 -->
            <div class="col-3">
                <div class="bg-white border">
                    <div class="px-3 pt-2 pb-1 border-bottom">
                        <span class="fw-semibold" style="font-size: 14px;">권한 목록</span>
                    </div>
                    <table class="table table-bordered table-hover mb-0" style="font-size: 13px;">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width: 15%;">NO</th>
                                <th class="text-center">롤 명</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty roleList}">
                                    <tr><td colspan="2" class="text-center text-muted py-3">데이터가 없습니다.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="role" items="${roleList}" varStatus="vs">
                                    <tr class="role-row" style="cursor: pointer;"
                                        onclick="selectTargetRole(this, '${role.roleNo}', '${role.roleRank}')">
                                        <td class="text-center">${vs.count}</td>
                                        <td>
                                            <c:out value="${role.roleName}"/>
                                            <c:if test="${role.roleRank == 70030}">
                                                <span class="badge bg-danger ms-1" style="font-size: 10px;">변경불가</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 우측: 사용자 목록 -->
            <div class="col-9">
                <div class="bg-white border">
                    <div class="px-3 pt-2 pb-1 border-bottom">
                        <span class="fw-semibold" style="font-size: 14px;">사용자 목록</span>
                    </div>
                    <table class="table table-bordered table-hover mb-0" style="font-size: 13px;">
                        <colgroup>
                            <col style="width: 5%">
                            <col style="width: 5%">
                            <col style="width: 20%">
                            <col style="width: 18%">
                            <col style="width: 25%">
                            <col style="width: 15%">
                        </colgroup>
                        <thead class="table-light">
                            <tr>
                                <th class="text-center">
                                    <input type="checkbox" class="form-check-input" onclick="toggleAll(this)">
                                </th>
                                <th class="text-center">NO</th>
                                <th class="text-center">아이디</th>
                                <th class="text-center">이름</th>
                                <th class="text-center">현재 권한</th>
                                <th class="text-center">등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty userList}">
                                    <tr><td colspan="6" class="text-center text-muted py-3">데이터가 없습니다.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${userList}" varStatus="vs">
                                    <tr>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input user-chk"
                                                   name="userNos" value="${user.userNo}"
                                                   ${user.roleRank == 70030 ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">${vs.count}</td>
                                        <td class="text-center"><c:out value="${user.userId}"/></td>
                                        <td class="text-center"><c:out value="${user.userName}"/></td>
                                        <td class="text-center">
                                            <c:out value="${user.roleName}"/>
                                            <c:if test="${user.roleRank == 70030}">
                                                <span class="badge bg-danger ms-1" style="font-size: 10px;">변경불가</span>
                                            </c:if>
                                        </td>
                                        <td class="text-center"><c:out value="${user.regDate}"/></td>
                                    </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <div class="px-3 py-2 border-top d-flex justify-content-between align-items-center">
                        <ui:pagination paginationInfo="${paginationInfo}"
                                       type="customRenderer" jsFunction="linkPage"/>
                        <button type="button" class="btn btn-primary btn-sm px-4 btn-perm-upd" id="applyRoleBtn" onclick="applyRole()" disabled>적용</button>
                    </div>
                </div>
            </div>

        </div><!-- /row -->
    </form>

</div>

<script>
function selectTargetRole(row, roleNo, roleRank) {
    $('.role-row').removeClass('table-primary');
    $(row).addClass('table-primary');

    var isSysAdmin = (String(roleRank) === '70030');
    $('#selectedRoleNo').val(isSysAdmin ? '' : roleNo);
    $('#applyRoleBtn').prop('disabled', isSysAdmin);
    if (!isSysAdmin) {
        applyButtonPerms();
    }
}

function toggleAll(chk) {
    $('.user-chk').prop('checked', $(chk).prop('checked'));
}

function linkPage(pageNo) {
    $('#currentPageNo').val(pageNo);
    $('#searchForm').submit();
}

function applyRole() {
    if (!$('#selectedRoleNo').val()) {
        alert('좌측에서 적용할 권한을 선택해 주세요.');
        return;
    }
    if ($('.user-chk:checked').length === 0) {
        alert('적용할 사용자를 선택해 주세요.');
        return;
    }
    $.ajax({
        url    : 'role/userRoleApply.do',
        type   : 'POST',
        data   : $('#applyForm').serialize(),
        success: function(res) {
            alert(res.desc);
            if (res.msg === 'S') {
                $('#searchForm').submit();
            }
        },
        error  : function() { alert('서버 오류가 발생했습니다.'); }
    });
}
</script>

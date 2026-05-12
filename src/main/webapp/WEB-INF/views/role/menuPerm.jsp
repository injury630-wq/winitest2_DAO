<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 시스템관리자 여부 (role_rank=70030) --%>
<c:set var="isSysAdmin" value="false" />
<c:if test="${not empty selectedRoleNo}">
    <c:forEach var="role" items="${roleList}">
        <c:if test="${role.roleNo == selectedRoleNo and role.roleRank == 70030}">
            <c:set var="isSysAdmin" value="true" />
        </c:if>
    </c:forEach>
</c:if>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">메뉴별 권한 관리</h2>
    </div>

    <%-- 롤 선택 시 이 폼을 POST 제출 (keyword도 함께 전송하여 검색조건 유지) --%>
    <form id="roleSelectForm" method="post"
          action="role/menuPerm.do"
          style="display:none;">
        <input type="hidden" id="selectedRoleNoInput" name="selectedRoleNo" value="" />
        <input type="hidden" id="keywordInput"        name="keyword"        value="" />
    </form>

    <div class="row g-3">

        <!-- 좌측: 롤 목록 -->
        <div class="col-3">
            <div class="bg-white border">
                <div class="px-3 pt-2 pb-1 border-bottom">
                    <span class="fw-semibold" style="font-size: 14px;">롤 목록</span>
                </div>
                <div class="p-2">
                    <div class="input-group input-group-sm mb-1">
                        <input type="text" id="roleKeyword" class="form-control"
                               placeholder="롤명 또는 코드 검색" maxlength="100"
                               value="<c:out value='${keyword}'/>"
                               onkeydown="if(event.key==='Enter') filterRoleList()" />
                        <button class="btn btn-outline-secondary" type="button"
                                onclick="filterRoleList()">검색</button>
                    </div>
                </div>
                <table class="table table-bordered table-hover mb-0" style="font-size: 13px;">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 45%;">롤 코드</th>
                            <th class="text-center">롤 명</th>
                        </tr>
                    </thead>
                    <tbody id="roleListBody">
                        <c:forEach var="role" items="${roleList}">
                        <%-- 선택된 롤 강조 --%>
                        <tr class="role-row ${role.roleNo == selectedRoleNo ? 'table-primary' : ''}"
                            style="cursor: pointer;"
                            onclick="selectRoleSSR('${role.roleNo}')">
                            <td class="text-center"><c:out value="${role.roleId}"/></td>
                            <td><c:out value="${role.roleName}"/></td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 우측: 메뉴 권한 목록 (SSR 렌더링) -->
        <div class="col-9">
            <div class="bg-white border">
                <div class="px-3 pt-2 pb-1 d-flex justify-content-between align-items-center border-bottom">
                    <span class="fw-semibold" style="font-size: 14px;">
                        메뉴 권한 목록
                        <c:if test="${not empty selectedRoleNo}">
                            <c:forEach var="role" items="${roleList}">
                                <c:if test="${role.roleNo == selectedRoleNo}">
                                    <span class="text-muted fw-normal ms-1" style="font-size: 13px;">
                                        — <c:out value="${role.roleName}"/> (<c:out value="${role.roleId}"/>)
                                    </span>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <%-- 시스템관리자 안내 --%>
                        <c:if test="${isSysAdmin}">
                            <span class="badge bg-danger ms-2" style="font-size: 11px;">변경 불가</span>
                        </c:if>
                    </span>
                    <div class="d-flex gap-1">
                        <button type="button" class="btn btn-outline-secondary btn-sm px-2"
                                onclick="checkAll(true)" ${isSysAdmin ? 'disabled' : ''}>전체 선택</button>
                        <button type="button" class="btn btn-outline-secondary btn-sm px-2"
                                onclick="checkAll(false)" ${isSysAdmin ? 'disabled' : ''}>전체 해제</button>
                        <button type="button" class="btn btn-primary btn-sm px-3 btn-perm-upd"
                                onclick="savePerm()" ${isSysAdmin ? 'disabled' : ''}>저장</button>
                    </div>
                </div>

                <%-- 시스템관리자 안내 메시지 --%>
             <%--    <c:if test="${isSysAdmin}">
                    <div class="px-3 py-2 bg-danger bg-opacity-10 border-bottom"
                         style="font-size: 12px; color: #c0392b;">
                        시스템관리자의 메뉴 권한은 변경할 수 없습니다. 권한 수정이 필요하면 DB에서 직접 처리해 주세요.
                    </div>
                </c:if> --%>

                <table class="table table-bordered mb-0" style="font-size: 13px;">
                    <colgroup>
                        <col style="width: 5%">
                        <col>
                        <col style="width: 10%">
                        <col style="width: 10%">
                        <col style="width: 10%">
                        <col style="width: 10%">
                        <col style="width: 10%">
                    </colgroup>
                    <thead class="table-light">
                        <tr>
                            <th class="text-center">순번</th>
                            <th class="text-center">메뉴명</th>
                            <th class="text-center">메뉴표시</th>
                            <th class="text-center">조회</th>
                            <th class="text-center">등록</th>
                            <th class="text-center">수정</th>
                            <th class="text-center">삭제</th>
                        </tr>
                    </thead>
                    <tbody id="menuPermBody">
                        <c:choose>
                            <c:when test="${not empty menuPermList}">
                                <c:forEach var="menu" items="${menuPermList}" varStatus="vs">
                                    <c:set var="pl"     value="${menu.menuLev > 0 ? menu.menuLev * 20 + 8 : 8}" />
                                    <c:set var="rowCls" value="${menu.menuLev == 0 ? 'fw-semibold' : 'table-light'}" />
                                    <tr class="${rowCls}" data-menu-no="${menu.menuNo}">
                                        <td class="text-center">${vs.count}</td>
                                        <td style="padding-left:${pl}px;">
                                            <c:if test="${menu.menuLev > 0}">└ </c:if>
                                            <c:out value="${menu.menuName}"/>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-disp"
                                                   ${menu.dispPerm == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-view"
                                                   ${menu.viewPerm == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-ins"
                                                   ${menu.insPerm == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-upd"
                                                   ${menu.updPerm == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-del"
                                                   ${menu.delPerm == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4">
                                         롤을 선택해 주세요.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<script>
const selectedRoleNo = '${not empty selectedRoleNo ? selectedRoleNo : ""}';
const isSysAdmin     = ${isSysAdmin};

function selectRoleSSR(roleNo) {
    $('#selectedRoleNoInput').val(roleNo);
    $('#keywordInput').val($('#roleKeyword').val());
    $('#roleSelectForm').submit();
}

$(document).ready(function() {
    if ($('#roleKeyword').val()) {
        filterRoleList();
    }
});

function filterRoleList() {
    var keyword = $('#roleKeyword').val().toLowerCase();
    $('.role-row').each(function() {
        $(this).toggle($(this).text().toLowerCase().includes(keyword));
    });
}

function checkAll(checked) {
    $('#menuPermBody input[type="checkbox"]').prop('checked', checked);
}

function savePerm() {
    if (isSysAdmin) {
        alert('시스템관리자의 메뉴 권한은 변경할 수 없습니다.');
        return;
    }
    if (!selectedRoleNo) {
        alert('롤을 선택해 주세요.');
        return;
    }
    var perms = [];
    $('#menuPermBody tr[data-menu-no]').each(function() {
        var $tr = $(this);
        perms.push({
            menuNo  : $tr.data('menu-no'),
            dispPerm: $tr.find('.chk-disp').prop('checked') ? 'Y' : 'N',
            viewPerm: $tr.find('.chk-view').prop('checked') ? 'Y' : 'N',
            insPerm : $tr.find('.chk-ins').prop('checked')  ? 'Y' : 'N',
            updPerm : $tr.find('.chk-upd').prop('checked')  ? 'Y' : 'N',
            delPerm : $tr.find('.chk-del').prop('checked')  ? 'Y' : 'N'
        });
    });
    if (perms.length === 0) {
        alert('저장할 권한 데이터가 없습니다.');
        return;
    }
    $.ajax({
        url    : 'role/menuPermSave.do',
        type   : 'POST',
        data   : { roleNo: selectedRoleNo, permsJson: JSON.stringify(perms) },
        success: function(res) {
            alert(res.desc || (res.msg === 'S' ? '저장됐습니다.' : '저장 중 오류가 발생했습니다.'));
        },
        error  : function() { alert('서버 오류가 발생했습니다.'); }
    });
}

</script>

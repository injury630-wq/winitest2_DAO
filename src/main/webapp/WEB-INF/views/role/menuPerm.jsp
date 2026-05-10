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

    <%-- SSR 방식: 롤 선택 시 이 폼을 POST 제출 (keyword도 함께 전송하여 검색조건 유지) --%>
    <form id="roleSelectForm" method="post"
          action="${pageContext.request.contextPath}/role/menuPerm.do"
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
                        <button type="button" class="btn btn-primary btn-sm px-3"
                                onclick="savePerm()" ${isSysAdmin ? 'disabled' : ''}>저장</button>
                    </div>
                </div>

                <%-- 시스템관리자 안내 메시지 --%>
                <c:if test="${isSysAdmin}">
                    <div class="px-3 py-2 bg-danger bg-opacity-10 border-bottom"
                         style="font-size: 12px; color: #c0392b;">
                        시스템관리자의 메뉴 권한은 변경할 수 없습니다. 권한 수정이 필요하면 DB에서 직접 처리해 주세요.
                    </div>
                </c:if>

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
                                                   ${menu.dispYn == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-view"
                                                   ${menu.viewYn == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-ins"
                                                   ${menu.insYn == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-upd"
                                                   ${menu.updYn == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input chk-del"
                                                   ${menu.delYn == 'Y' ? 'checked' : ''}
                                                   ${isSysAdmin ? 'disabled' : ''}>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">
                                        좌측에서 롤을 선택해 주세요.
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
const ctx          = '${pageContext.request.contextPath}';
const selectedRoleNo = '${not empty selectedRoleNo ? selectedRoleNo : ""}';
const isSysAdmin     = ${isSysAdmin};

function selectRoleSSR(roleNo) {
    document.getElementById('selectedRoleNoInput').value = roleNo;
    document.getElementById('keywordInput').value        = document.getElementById('roleKeyword').value;
    document.getElementById('roleSelectForm').submit();
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('roleKeyword').value) filterRoleList();
});

function filterRoleList() {
    const keyword = document.getElementById('roleKeyword').value.toLowerCase();
    document.querySelectorAll('.role-row').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(keyword) ? '' : 'none';
    });
}

function checkAll(checked) {
    document.querySelectorAll('#menuPermBody input[type="checkbox"]').forEach(chk => {
        chk.checked = checked;
    });
}

function savePerm() {
    if (isSysAdmin) { alert('시스템관리자의 메뉴 권한은 변경할 수 없습니다.'); return; }
    if (!selectedRoleNo) { alert('롤을 선택해 주세요.'); return; }
    const perms = [];
    document.querySelectorAll('#menuPermBody tr[data-menu-no]').forEach(tr => {
        perms.push({
            menuNo: tr.getAttribute('data-menu-no'),
            dispYn: tr.querySelector('.chk-disp').checked ? 'Y' : 'N',
            viewYn: tr.querySelector('.chk-view').checked ? 'Y' : 'N',
            insYn:  tr.querySelector('.chk-ins').checked  ? 'Y' : 'N',
            updYn:  tr.querySelector('.chk-upd').checked  ? 'Y' : 'N',
            delYn:  tr.querySelector('.chk-del').checked  ? 'Y' : 'N'
        });
    });
    if (perms.length === 0) { alert('저장할 권한 데이터가 없습니다.'); return; }
    $.ajax({
        url: ctx + '/role/menuPermSave.do',
        type: 'POST',
        data: { roleNo: selectedRoleNo, permsJson: JSON.stringify(perms) },
        success: res => { alert(res.desc || (res.msg === 'S' ? '저장됐습니다.' : '저장 중 오류가 발생했습니다.')); },
        error: () => { alert('서버 오류가 발생했습니다.'); }
    });
}

/*
 * ════════════════════════════════════════════════════════════════
 *  AJAX 방식 원본 (SSR 전환 전) — 복구 시 아래 주석 해제 후
 *  tr 의 onclick 을 selectRole(this, '${role.roleNo}', ...) 로 변경
 * ════════════════════════════════════════════════════════════════
 *
function selectRole(row, roleNo, roleId, roleName) {
    document.querySelectorAll('.role-row').forEach(function(r) { r.classList.remove('table-primary'); });
    row.classList.add('table-primary');
    selectedRoleNo = roleNo;
    document.getElementById('selectedRoleLabel').innerText = '— ' + roleName + ' (' + roleId + ')';
    loadMenuPermList(roleNo);
}

function loadMenuPermList(roleNo) {
    $.ajax({
        url: ctx + '/role/menuPermList.do',
        type: 'POST',
        data: { roleNo: roleNo },
        success: function(res) {
            if (res.msg !== 'S') { alert('조회 중 오류가 발생했습니다.'); return; }
            renderMenuPermList(res.list);
        },
        error: function() { alert('서버 오류가 발생했습니다.'); }
    });
}

function renderMenuPermList(list) {
    var tbody = document.getElementById('menuPermBody');
    if (!list || list.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted py-4">메뉴 데이터가 없습니다.</td></tr>';
        return;
    }
    var html = '';
    var seq = 1;
    list.forEach(function(m) {
        var pl = m.menuLev > 0 ? (m.menuLev * 20 + 8) : 8;
        var rowCls = m.menuLev === 0 ? 'fw-semibold' : 'table-light';
        var prefix = m.menuLev > 0 ? '└ ' : '';
        html += '<tr class="' + rowCls + '" data-menu-no="' + m.menuNo + '">';
        html += '<td class="text-center">' + (seq++) + '</td>';
        html += '<td style="padding-left:' + pl + 'px;">' + prefix + escHtml(m.menuName) + '</td>';
        html += '<td class="text-center"><input type="checkbox" class="form-check-input chk-disp" ' + (m.dispYn === 'Y' ? 'checked' : '') + '></td>';
        html += '<td class="text-center"><input type="checkbox" class="form-check-input chk-view" ' + (m.viewYn === 'Y' ? 'checked' : '') + '></td>';
        html += '<td class="text-center"><input type="checkbox" class="form-check-input chk-ins"  ' + (m.insYn  === 'Y' ? 'checked' : '') + '></td>';
        html += '<td class="text-center"><input type="checkbox" class="form-check-input chk-upd"  ' + (m.updYn  === 'Y' ? 'checked' : '') + '></td>';
        html += '<td class="text-center"><input type="checkbox" class="form-check-input chk-del"  ' + (m.delYn  === 'Y' ? 'checked' : '') + '></td>';
        html += '</tr>';
    });
    tbody.innerHTML = html;
}

function escHtml(str) {
    var d = document.createElement('div');
    d.appendChild(document.createTextNode(str || ''));
    return d.innerHTML;
}
 */
</script>

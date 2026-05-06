<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container detail-container">
    <h2>이미지 게시글 조회</h2>

    <table class="detail-table">
        <tr>
            <th>제목</th>
            <td colspan="3" class="text-truncate" style="max-width:0;"
                title="<c:out value="${gallery.title}"/>">
                <c:out value="${gallery.title}"/>
            </td>
        </tr>
        <tr>
            <th>작성자</th>
            <td><c:out value="${gallery.regUserName}"/></td>
            <th>등록일</th>
            <td>${gallery.regDate}</td>
        </tr>
        <tr>
            <th>수정자</th>
            <td>${not empty gallery.modUserName ? gallery.modUserName : '--'}</td>
            <th>수정일</th>
            <td>${not empty gallery.modDate ? gallery.modDate : '--'}</td>
        </tr>
        <tr>
            <th>조회수</th>
            <td colspan="3" id="hit"><c:out value="${gallery.hit}"/></td>
        </tr>
        <tr>
            <th>내용</th>
            <td colspan="3">
                <div class="content-area gallery-content">
                    <c:out value="${gallery.content}" escapeXml="false"/>
                </div>
            </td>
        </tr>
    </table>

    <div class="d-flex justify-content-between align-items-start mt-3">
        <div>
            <button class="btn btn-secondary" onclick="goPost('gallery/list.do')">목록</button>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-success"
                    onclick="goPost('gallery/form.do', {boardNo:'${gallery.boardNo}'})">수정</button>
            <button class="btn btn-danger" onclick="confirmDelete()">삭제</button>
            <c:if test="${sessionScope.loginUser.userNo == gallery.regUser
                          or sessionScope.loginUser.adminYn == 'Y'}">
            </c:if>
        </div>
    </div>
</div>

<style>
.gallery-content {
    max-width: 100%;
    overflow-x: hidden;
    word-break: break-all;
}
.gallery-content img {
    width: 300px;
    height: 300px;
    object-fit: contain;
    background-color: #f8f9fa;
    display: inline-block;
    margin: 4px;
    vertical-align: top;
    border-radius: 4px;
}
</style>

<script>
function confirmDelete() {
    if (!confirm('삭제하시겠습니까?')) return;
    $.ajax({
        url: 'gallery/delete.do',
        type: 'POST',
        data: { boardNo: '${gallery.boardNo}' },
        dataType: 'json',
        success: function (res) {
            if (res.msg === 'S') {
                goPost('gallery/list.do');
            } else if (res.msg === 'X') {
                alert('삭제 권한이 없습니다.');
            } else {
                alert('삭제 중 오류가 발생하였습니다.');
            }
        },
        error: function () { alert('서버 오류가 발생하였습니다.'); }
    });
}

function updateHit() {
    $.post('gallery/updateHitAjax.do', { boardNo: '${gallery.boardNo}' }, function (res) {
        $('#hit').text(res.hit);
    });
}

document.addEventListener('DOMContentLoaded', function () {
    if ('${noHit}' !== 'Y') updateHit();
});
</script>

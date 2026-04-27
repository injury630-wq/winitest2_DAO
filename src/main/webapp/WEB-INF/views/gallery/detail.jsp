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
                <%-- [신방식] Ajax 임시업로드: 실제 imgView URL이 저장되므로 c:out으로 바로 렌더링 --%>
                <div class="content-area gallery-content">
                    <c:out value="${gallery.content}" escapeXml="false"/>
                </div>
                <%-- [구방식 롤백용] blob URL → __IMG_N__ 방식 사용 시 아래로 교체
                <div id="savedContent" style="display:none">${gallery.content}</div>
                <div id="contentDisplay" class="content-area gallery-content"></div>
                --%>
            </td>
        </tr>
    </table>

    <div class="d-flex justify-content-between align-items-start mt-3">
        <div>
            <button class="btn btn-secondary" onclick="goPost('gallery/list.do')">목록</button>
        </div>
        <div class="d-flex gap-2">
            <c:if test="${sessionScope.loginUser.userNo == gallery.regUser
                          or sessionScope.loginUser.adminYn == 'Y'}">
                <button class="btn btn-success"
                        onclick="goPost('gallery/form.do', {boardNo:'${gallery.boardNo}'})">수정</button>
                <button class="btn btn-danger" onclick="confirmDelete()">삭제</button>
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

<form id="deleteForm" method="post" action="gallery/delete.do">
    <input type="hidden" name="boardNo" value="${gallery.boardNo}"/>
</form>

<script>
/* [구방식 롤백용] blob URL → __IMG_N__ 방식 사용 시 주석 해제
document.getElementById('contentDisplay').innerHTML =
    document.getElementById('savedContent').innerHTML;
*/

function confirmDelete() {
    if (!confirm('삭제하시겠습니까?')) return;
    document.getElementById('deleteForm').submit();
}

/* async function updateHit() {
    try {
        let res = await fetch('gallery/updateHitAjax.do', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: new URLSearchParams({boardNo: '${gallery.boardNo}'})
        });
        var hit = await res.text();
        document.getElementById('hit').innerText = hit;
    } catch (e) { console.error(e); }
} */
function updateHit() {
  $.post('gallery/updateHitAjax.do', {
      boardNo: '${gallery.boardNo}'
  }, function(res) {
      $('#hit').text(res.hit);
  });
}

document.addEventListener('DOMContentLoaded', function() {
    if ('${noHit}' != 'Y') updateHit();
});
</script>

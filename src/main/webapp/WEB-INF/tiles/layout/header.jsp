<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<header>
    <div class="header-inner">
        <a class="site-title" href="${pageContext.request.contextPath}/">Home</a>
        <div class="header-user">
            <c:if test="${not empty sessionScope.loginUser}">
                <span class="">(${sessionScope.loginUser.role})</span>
                <span class="user-name">${sessionScope.loginUser.userName} 님</span>
                <form action="user/logout.do" method="post" style="margin:0">
                    <button type="submit" class="btn btn-outline-light btn-sm">로그아웃</button>
                </form>
            </c:if>
        </div>
    </div>
</header>

<%--
__navForm: 전체 페이지 공용 POST 이동 전용 숨겨진 폼
data-dyn 속성의 역할 goPost 는 재사용되는 단일 폼(__navForm)에 파라미터를 동적으로 append 한다.
    새로 추가한 input 에 data-dyn 속성을 해두고 다음 호출 시 먼저 제거한다.
--%>
<form id="__navForm" method="post" style="display:none"></form>

<script>
    // 공용 POST 이동 함수
    // url  : 이동할 컨트롤러 URL
    // params: 전송할 파라미터 객체 (없으면 생략)
    // ex) goPost('board/write.do')
    //     goPost('board/detail.do', {boardNo: '5', currentPageNo: '2'})
    function goPost(url, params) {
        var form = document.getElementById('__navForm');
        form.action = url;
        // 이전 호출에서 동적으로 추가된 input 제거 (중복 전송 방지)
        form.querySelectorAll('[data-dyn]').forEach(el => el.remove());
        // 파라미터가 있으면 hidden input 으로 추가
        if (params) {
            Object.keys(params).forEach(function(key) {
                var inp = document.createElement('input');
                inp.type  = 'hidden';
                inp.name  = key;
                inp.value = params[key];
                inp.setAttribute('data-dyn', ''); // 다음 호출 시 제거 대상으로 마킹
                form.appendChild(inp);
            });
        }
        form.submit();
    }
</script>

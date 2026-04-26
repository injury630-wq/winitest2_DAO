<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
    bridge.jsp  : POST → POST 연결 전용 중계 페이지
    goPost      : 클라이언트 JS에서 직접 POST 이동. JSP에서 이동 버튼용으로 사용.
    bridge.jsp  : 서버 처리 완료 후 다음 화면으로 이동할 때 사용.
                    글 등록->목록, 글 수정->상세, 글 삭제->목록 등 서버 처리 결과를 가지고 이동할 때.
--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- base href 로 상대경로가 컨텍스트 루트 기준으로 해석되게 함 --%>
<base href="${pageContext.request.contextPath}/"/>
</head>
<body>
<%-- requestScope.param 맵의 모든 항목을 hidden field 로 전송 (bridgeUrl 제외) --%>
<form id="f" method="post" action="${requestScope.param.bridgeUrl}">
    <c:forEach var="e" items="${requestScope.param}">
        <c:if test="${e.key != 'bridgeUrl'}">
            <input type="hidden" name="${e.key}" value="${e.value}"/>
        </c:if>
    </c:forEach>
</form>
<script>document.getElementById('f').submit();</script>
</body>
</html>
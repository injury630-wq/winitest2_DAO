<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
    bridge.jsp : POST → POST 연결 전용 중계 페이지

    [왜 bridge.jsp 가 필요한가?]
    이 프로젝트의 컨트롤러는 모두 POST 전용이다.
    Spring MVC 의 redirect: 는 GET 으로 전환되므로 사용 불가.
    따라서 "처리 후 다른 컨트롤러로 이동"이 필요할 때
      컨트롤러가 model 에 {bridgeUrl, 파라미터들} 을 담아 bridge.jsp 로 포워드하면,
      bridge.jsp 가 즉시 form 을 만들어 목적지 URL 로 POST 전송한다.

    [header.jsp 의 goPost 와 차이]
    goPost        : 클라이언트(브라우저) JS 에서 직접 POST 이동. 뷰 JSP 에서 이동 버튼용으로 사용.
    bridge.jsp    : 서버(컨트롤러) 처리 완료 후 다음 화면으로 이동할 때 사용.
                    글 등록→목록, 글 수정→상세, 글 삭제→목록 등 서버 처리 결과를 가지고 이동할 때.

    [param vs requestScope.param]
    JSP EL 에서 ${param} 은 HttpServletRequest 의 파라미터(쿼리스트링)를 의미한다.
    컨트롤러가 model.addAttribute("param", paramMap) 으로 담은 값은
    requestScope 에 들어가므로 ${requestScope.param} 으로 접근해야 충돌이 없다.
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
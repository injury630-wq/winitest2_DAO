<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <base href="${pageContext.request.contextPath}/" />
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>메인화면</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
      crossorigin="anonymous"
    />
  </head>
  <body>
    <h3>게시글은 로그인이 필요합니다.</h3>

    <!-- 로그인 페이지로 POST 이동 -->
    <form id="loginForm" action="user/login.do" method="post">
      <button type="submit" class="btn btn-success">
        로그인 페이지로 이동
      </button>
    </form>
    <br />
    <!-- 게시글 페이지로 POST 이동 -->
    <form id="boardForm" action="board/list.do" method="post">
      <button type="submit" class="btn btn-primary">
        게시글 페이지로 이동
      </button>
    </form>
    <br />
    서버정보: <%=application.getServerInfo()%>
    <hr />
    서블릿정보:
    <%=application.getMajorVersion()%>.<%=application.getMinorVersion()%>
    <hr />
    JSP정보:
    <%=JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion()%>
  </body>
  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
    crossorigin="anonymous"
  ></script>
</html>

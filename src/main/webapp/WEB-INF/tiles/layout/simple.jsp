<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base href="${pageContext.request.contextPath}/"/>
    <title><tiles:getAsString name="title" defaultValue="winiTest"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous"/>
    <style>
        body { font-family: '맑은 고딕', sans-serif; background: #f5f5f5; }
        /* 회원가입 안내 메시지 */
        .guide-msg { font-size: 12px; margin-top: 5px; color: #aaa; }
        .guide-msg.ok   { color: green; }
        .guide-msg.fail { color: red; }
    </style>
</head>
<body>
    <tiles:insertAttribute name="content"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"
            integrity="sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y"
            crossorigin="anonymous"></script>
</body>
</html>

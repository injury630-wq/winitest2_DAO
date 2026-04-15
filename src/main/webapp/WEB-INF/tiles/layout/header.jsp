<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

        /* 헤더 */
        header { background: #2c3e50; }
        .header-inner { max-width: 1060px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center; height: 50px; }
        .site-title { color: white; font-size: 18px; font-weight: bold; text-decoration: none; }
        .site-title:hover { color: white; opacity: 0.85; text-decoration: none; }
        .header-user { display: flex; align-items: center; gap: 12px; color: #ccc; font-size: 14px; }
        .header-user .user-name { color: white; }

        /* 컨테이너 */
        .container { max-width: 1000px; margin: 30px auto; background: white; padding: 30px; border: 1px solid #ddd; border-radius: 0; }
        h2 { font-size: 22px; margin-bottom: 20px; border-left: 4px solid #dc3545; padding-left: 10px; }

        /* 테이블 */
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        thead tr { background: #f0f0f0; border-top: 2px solid #333; }
        th { padding: 10px; background: #f0f0f0; border: 1px solid #ddd; text-align: center; font-weight: normal; }
        td { padding: 10px; border: 1px solid #ddd; word-break: break-all; }
        tr:hover { background: #fafafa; }

        /* 공통 */
        .required { color: #dc3545; margin-right: 3px; }
        .error-msg { color: #dc3545; font-size: 13px; margin-top: 8px; }

        /* 게시판 목록 제목 셀. */
        td.title { text-align: left; max-width: 280px; overflow: hidden; }
        /* 목록 행 hover: board-list 클래스를 가진 테이블에만 적용 */
        .board-list tbody tr:hover td { color: #dc3545; }
        .re-lev1 { padding-left: 20px; }
        .re-lev2 { padding-left: 40px; }
        .paging { text-align: center; margin: 20px 0; }

        /* 첨부파일 */
        .file-item { display: flex; align-items: center; gap: 10px; padding: 5px 0; border-bottom: 1px solid #eee; font-size: 13px; }

        /* 상세 */
        .detail-table th { width: 10%; min-width: 80px; white-space: nowrap; }
        .content-area { min-height: 180px; max-height: 500px; overflow-y: auto; white-space: pre-wrap; }
        .detail-container { min-height: 480px; }
    </style>
</head>
<body>

    <header>
        <div class="header-inner">
            <a class="site-title" href="${pageContext.request.contextPath}/">Home</a>
            <div class="header-user">
                <c:if test="${not empty sessionScope.loginUser}">
                    <span class="user-name">${sessionScope.loginUser.userName} 님</span>
                    <form action="user/logout.do" method="post" style="margin:0">
                        <button type="submit" class="btn btn-outline-light btn-sm">로그아웃</button>
                    </form>
                </c:if>
            </div>
        </div>
    </header>

    <tiles:insertAttribute name="content"/>

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
        // 사용 예) goPost('board/write.do')
        //         goPost('board/detail.do', {boardNo: '5', currentPageNo: '2'})
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"
            integrity="sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y"
            crossorigin="anonymous"></script>
</body>
</html>

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

        /* 게시판 목록 제목 셀
           overflow:hidden: td 안의 flex 컨테이너가 셀 밖으로 넘치지 않도록 차단.
           내부 span 에 text-truncate + min-width:0 을 적용해야 flex 에서 말줄임표가 동작한다. */
        td.title { text-align: left; max-width: 280px; overflow: hidden; }
        /* 목록 행 hover: board-list 클래스를 가진 테이블에만 적용 */
        .board-list tbody tr:hover td { color: #dc3545; }
        .re-lev1 { padding-left: 20px; }
        .re-lev2 { padding-left: 40px; }
        .paging { text-align: center; margin: 20px 0; }

        /* 첨부파일 */
        .file-item { display: flex; align-items: center; gap: 10px; padding: 5px 0; border-bottom: 1px solid #eee; font-size: 13px; }

        /* 상세 */
        /* detail-table th: 너비를 고정하여 내용 길이와 무관하게 th 가 압축·줄바꿈되지 않게 함.
           white-space:nowrap 으로 "첨부파일" 같은 긴 텍스트도 한 줄 유지. */
        .detail-table th { width: 10%; min-width: 80px; white-space: nowrap; }
        /* content-area: <td> 에 직접 min-height 를 주면 브라우저가 무시하므로 내부 div 에 적용.
           min-height: 내용이 짧아도 일정 높이 유지. max-height + overflow-y: 내용이 길어도 레이아웃 고정. */
        .content-area { min-height: 180px; max-height: 500px; overflow-y: auto; white-space: pre-wrap; }
        /* 상세 페이지 전체 컨테이너: 내용물이 짧아도 최소 높이 보장 */
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

        [왜 header.jsp 에 있는가?]
        Tiles 레이아웃 구조상 header.jsp 가 모든 페이지에 공통으로 포함된다.
        여기에 빈 form 하나를 두면 어떤 JSP 조각(fragment)에서도
        goPost() 함수를 통해 POST 방식으로 이동할 수 있다.

        [goPost(url, params) 역할]
        href 기반 GET 이동 대신 POST 이동이 필요할 때 사용한다.
        이 프로젝트의 모든 컨트롤러가 POST 전용(@RequestMapping method=POST)이기 때문에
        단순 <a href="..."> 로는 이동 자체가 불가능하다.
        따라서 goPost 로 임의의 URL 과 파라미터를 동적으로 주입해서 POST 폼 전송을 흉내낸다.

        [data-dyn 속성의 역할]
        goPost 는 재사용되는 단일 폼(__navForm)에 파라미터를 동적으로 append 한다.
        연속 호출 시 이전 호출의 input 이 남아있으면 안 되므로,
        새로 추가한 input 에 data-dyn 마킹을 해두고, 다음 호출 시 먼저 제거한다.

        [goPost vs 각 JSP 자체 form]
        goPost : 파일 업로드가 없는 단순 이동 전용. enctype 이 기본(urlencoded)이다.
        자체 form : 파일 업로드(enctype="multipart/form-data")가 필요한 페이지(write/edit/reply)는
                    goPost 의 __navForm 을 사용할 수 없으므로 페이지마다 전용 form 을 직접 보유한다.
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
            [].forEach.call(form.querySelectorAll('[data-dyn]'), function(el) {
                el.parentNode.removeChild(el);
            });
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

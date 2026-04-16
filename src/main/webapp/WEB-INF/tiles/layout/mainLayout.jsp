<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <base href="${pageContext.request.contextPath}/"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
	<meta http-equiv="content-language" content="ko">
    <title>
	   <tiles:getAsString name="title" defaultValue="winiTest"/>
	</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>          
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

    <!-- HEADER -->
    <tiles:insertAttribute name="header"/>

    <div class="container-fluid">
        <div class="row">

            <!-- SIDEBAR -->
            <div class="col-2 bg-light vh-100 position-fixed">
                <tiles:insertAttribute name="sidebar"/>
            </div>

            <!-- CONTENT -->
            <div class="col-10 offset-2 p-4">
                <tiles:insertAttribute name="content"/>
            </div>

        </div>
    </div>

</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"
        integrity="sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y"
        crossorigin="anonymous"></script>
</html>
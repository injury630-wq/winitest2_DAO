<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사용자관리 테스트</title>
</head>
<body>
<h2><a href="javascript:void(0);" onclick="">사용자 관리</a></h2>
    <form id="searchForm" action="board/list.do" method="post">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1"/>
        <div class="border p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <select name="searchType" class="form-select" style="width:auto; min-width:90px;">
                    <option value="">전체</option>
                    <option value="user_id">아이디</option>
                    <option value="user_name" selected>이름</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control"
                       value="${param.searchKeyword}" placeholder="검색어를 입력하세요." maxlength="100"/>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-danger px-4">검색</button>
            </div>
        </div>
    </form>
    <div class="container" style="max-width: 600px">
    <div class="py-5 text-center">
        <h2>회원 목록</h2> </div>
    <div class="row">
        <div class="col">
            <button class="btn btn-primary float-end" type="button">회원 등록</button>
        </div>
    </div>
    <hr class="my-4">
    <div>
        <table class="table">
            <thead>
            <tr>
                <th>순번</th>
                <th>아이디</th>
                <th>이름</th>
                <th>사용여부</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <c:forEach var="board" items="${list}" varStatus="status">
                <tr onclick="goDetail('${board.boardNo}')" style="cursor:pointer;">
                    <td>1</td>
                    <td class="title"></td>
                    <td>${board.writerName}</td>
                    <td>${board.regDate}</td>
                </tr>
               </c:forEach>
            </tr>
            </tbody>
        </table>
    </div>
	</div> <!-- /container -->
</body>
</html>
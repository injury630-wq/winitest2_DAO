<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>
<h2><a href="javascript:void(0);" onclick="">사용자 관리</a></h2>
<form id="searchForm" action="board/list.do" method="post">
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
<!-- ========검색영역 END======== -->
<div class="container">
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
          	<c:forEach var="user" items="${userList}" varStatus="status">
	        <tr style="cursor:pointer;" data-user-no="${user.userNo}" onclick="goDetail(this)">
	          <td>${status.index + 1}</td>
	          <td>${user.userId}</td>
	          <td>${user.userName}</td>
	          <td><c:out value="${user.status eq 'ACTIVE' ? '사용가능' : '사용불가'}"></c:out></td>
	         </tr>
           </c:forEach>
           </tbody>
       </table>
   	</div>
   		        <button id="jtest" class="btn btn-primary" type="button">제이쿼리 테스트</button>
</div> <!-- /container -->
<!-- ========회원 목록 END======== -->
<script>
function goDetail(el) {
    const userNo = el.getAttribute("data-user-no");
    goPost('user/detail.do', { userNo: userNo });
}

</script>

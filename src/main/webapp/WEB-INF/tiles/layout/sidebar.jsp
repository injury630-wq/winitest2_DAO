<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<ul class="nav flex-column">

    <li class="nav-item">
    	<button type="button" onclick="goPost('board/list.do')" class="btn btn-secondary px-4 w-100">게시판</button>
    </li>
    
    <li class="nav-item">
    	<button type="button" onclick="goPost('user/userList.do')" class="btn btn-secondary px-4 my-1 w-100">사용자 관리</button>
    </li>

    <li class="nav-item">
        <a href="#" onclick="goPost('board/list.do')">사용자 관리</a>
    </li>

</ul>
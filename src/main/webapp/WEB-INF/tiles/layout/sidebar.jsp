<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<ul class="nav flex-column pt-3">
  <li class="nav-item mb-1">
    <button
      type="button"
      onclick="goPost('board/list.do')"
      class="btn btn-secondary px-4 w-100"
    >
      게시판
    </button>
  </li>

  <li class="nav-item mb-1">
    <button
      type="button"
      onclick="goPost('user/userManage1.do')"
      class="btn btn-secondary px-4 w-100"
    >
      사용자 관리
    </button>
  </li>
  
  <li class="nav-item mb-1">
    <button
      type="button"
      onclick="goPost('user/userManage2.do')"
      class="btn btn-secondary px-4 w-100"
    >
      사용자 관리
    </button>
  </li>
</ul>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<ul class="nav flex-column pt-3">

  <li class="nav-item mb-1">
    <button type="button" class="btn px-4 w-100 text-start"
            data-bs-toggle="collapse" data-bs-target="#menuBoard">
      게시판
    </button>
    <div class="collapse show" id="menuBoard">
      <ul class="nav flex-column ps-3">
        <li><button type="button" class="btn px-4 w-100 text-start" onclick="goPost('board/list.do')">일반 게시판</button></li>
        <li><button type="button" class="btn px-4 w-100 text-start" onclick="goPost('gallery/list.do')">이미지 게시판</button></li>
      </ul>
    </div>
  </li>

  <li class="nav-item mb-1">
    <button type="button" class="btn px-4 w-100 text-start"
            data-bs-toggle="collapse" data-bs-target="#menuUser">
      사용자 관리
    </button>
    <div class="collapse show" id="menuUser">
      <ul class="nav flex-column ps-3">
        <li><button type="button" class="btn px-4 w-100 text-start" onclick="goPost('user/userManage.do')">사용자 목록</button></li>
      </ul>
    </div>
  </li>

</ul>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%-- DB 연동 동적 메뉴 (MenuInterceptor 방식) - 비활성화
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<ul class="nav flex-column pt-3">
  <c:forEach var="parent" items="${menuList}">
    <li class="nav-item mb-1">
      <button type="button" class="btn px-4 w-100 text-start"
              data-bs-toggle="collapse" data-bs-target="#menu${parent.menuNo}">
        ${parent.menuName}
      </button>
      <div class="collapse show" id="menu${parent.menuNo}">
        <ul class="nav flex-column ps-3">
          <c:forEach var="child" items="${parent.children}">
            <li>
              <button type="button" class="btn px-4 w-100 text-start"
                      onclick="goPost('${child.proPath}')">
                ${child.menuName}
              </button>
            </li>
          </c:forEach>
        </ul>
      </div>
    </li>
  </c:forEach>
</ul>
--%>

<!--======================== 기본 디자이 ===================================================-->
<!-- <ul class="nav flex-column pt-3">

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

</ul> -->
<!-- ============================ 기본디자인 END ======================================= -->
<ul class="nav flex-column pt-3">

<c:forEach var="menu" items="${menuList}">

    <li class="nav-item">

        <button type="button"
                class="btn w-100 text-start"
                style="padding-left: ${menu.menuLev * 20}px"
                onclick="goPost('${menu.proPath}')">
            ${menu.menuName}
        </button>

    </li>

</c:forEach>

</ul>
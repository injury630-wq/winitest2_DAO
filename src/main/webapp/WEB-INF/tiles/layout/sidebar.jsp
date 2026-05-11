<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<ul class="nav flex-column pt-3">
<c:forEach var="menu" items="${menuList}">
    <c:set var="menuPerm" value="${sessionScope.sessionMenuPerms[menu.menuNo]}"/>
    <c:if test="${sessionScope.loginUser.adminYn eq 'Y' or empty menuPerm or menuPerm.dispPerm ne 'N'}">
    <li class="nav-item">
        <c:choose>
            <c:when test="${not empty menu.proPath}"> <!-- 하위메뉴 + 연결된 프로그램 있음 -->
                <button type="button" class="btn w-100 text-start"
                        style="padding-left: ${menu.menuLev * 20}px"
                        onclick="goPost('<c:out value="${menu.proPath}"/>')">
                    <c:out value="${menu.menuName}"/>
                </button>
            </c:when>
            <c:when test="${empty menu.parentNo}"> <!-- 최상위 메뉴 -->
                <div class="fw-bold px-2 py-1" style="padding-left: ${menu.menuLev * 20}px">
                    <c:out value="${menu.menuName}"/>
                </div>
            </c:when>
            <c:otherwise>	<!-- 하위메뉴 + 연결된 프로그램 없음 -->
            	<div class="" style="padding-left: ${menu.menuLev * 20}px">
                    <c:out value="${menu.menuName}"/>
                </div>
            </c:otherwise>
        </c:choose>
    </li>
    </c:if>
</c:forEach>
</ul>

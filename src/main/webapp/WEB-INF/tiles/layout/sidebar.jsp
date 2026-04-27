<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%--
    사이드바 렌더링 방식 선택 - 아래 두 블록 중 하나만 활성화.

    방식 A (현재 활성)  : CTE 플랫 목록 + padding-left 들여쓰기
      - ${menuList} 사용, menuLev * 20px로 계층 자동 표현
      - 3단, 4단도 JSP 수정 없이 자동 지원

    방식 B (현재 비활성): Java 트리 변환 + Bootstrap Collapse
      - ${menuTree} 사용, parent.children 중첩 forEach
      - 1단 헤더 클릭 시 하위 메뉴 접기/펼치기
      - 현재 2단 구조 지원 (3단 추가 시 child 루프 안에 grandchild 루프 추가)

    스위칭 방법:
      A -> B : 방식 A 블록 전체를  로 감싸고, 방식 B 블록의 제거 
--%>

<%-- ========== 방식 A : CTE 플랫 목록 (현재 활성) ========== --%>
<ul class="nav flex-column pt-3">
<c:forEach var="menu" items="${menuList}">
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
</c:forEach>
</ul>

<%--
========== 방식 B : Java 트리 변환 + Bootstrap Collapse (현재 비활성) ==========
방식 A 블록을 주석으로 감싸고, 아래 블록의 시작/끝 주석 태그를 제거해 활성화.

<ul class="nav flex-column pt-3">
  <c:forEach var="parent" items="${menuTree}">
    <li class="nav-item mb-1">
      <c:choose>
        <c:when test="${not empty parent.children}">
          <button type="button" class="btn px-3 w-100 text-start fw-bold"
                  data-bs-toggle="collapse"
                  data-bs-target="#menu${parent.menuNo}">
            <c:out value="${parent.menuName}"/>
          </button>
          <div class="collapse show" id="menu${parent.menuNo}">
            <ul class="nav flex-column ps-3">
              <c:forEach var="child" items="${parent.children}">
                <li class="nav-item">
                  <c:choose>
                    <c:when test="${not empty child.proPath}">
                      <button type="button" class="btn px-3 w-100 text-start"
                              onclick="goPost('<c:out value="${child.proPath}"/>')">
                        <c:out value="${child.menuName}"/>
                      </button>
                    </c:when>
                    <c:otherwise>
                      <div class="fw-bold px-2 py-1"><c:out value="${child.menuName}"/></div>
                    </c:otherwise>
                  </c:choose>
                </li>
              </c:forEach>
            </ul>
          </div>
        </c:when>
        <c:when test="${not empty parent.proPath}">
          <button type="button" class="btn px-3 w-100 text-start fw-bold"
                  onclick="goPost('<c:out value="${parent.proPath}"/>')">
            <c:out value="${parent.menuName}"/>
          </button>
        </c:when>
        <c:otherwise>
          <div class="fw-bold px-2 py-1"><c:out value="${parent.menuName}"/></div>
        </c:otherwise>
      </c:choose>
    </li>
  </c:forEach>
</ul>
--%>

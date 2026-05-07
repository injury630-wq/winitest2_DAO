<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-bold mb-0">롤 관리</h2>
    </div>

    <!-- 1. 검색 영역 -->
    <form id="searchForm" method="post" action="survey/roleManage.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1" />
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
            		<div>
            		롤코드
                <input type="text" name="searchRoleId" class="form-control"
                       value="<c:out value="${search.searchRoleId}"/>"
                       placeholder="롤 코드를 입력하세요" maxlength="90" />
            		</div>
            		<div>
            		롤 명
                <input type="text" name="searchRoleName" class="form-control"
                       value="<c:out value="${search.searchRoleName}"/>"
                       placeholder="롤 명을 입력하세요" maxlength="90" />
            		</div>
            		<div>
            		사용자구분코드
                <select name="searchRoleRank" class="form-select">
							    <option value="">전체</option>
							    <option value="korean">한국어</option>
							    <option value="english">영어</option>
							    <option value="chinese">중국어</option>
							    <option value="spanish">스페인어</option>
							  </select>
            		</div>
            		<div>
            		사용 여부
                <select name="searchUseYn" class="form-select">
							    <option value="">전체</option>
							    <option value="korean">한국어</option>
							  </select>
            		</div>
            		<div>
            		관리자 여부
                <select name="searchAdminYn" class="form-select">
							    <option value="">전체</option>
							    <option value="korean">한국어</option>
							  </select>
            		</div>
            </div>
            <div class="text-end">
                <button type="submit" class="btn btn-danger px-4">조회</button>
                <button type="button" class="btn btn-light px-4">초기화</button>
            </div>
        </div>
    </form>

    <!-- 2. 목록 영역 -->
    <div class="bg-white border mb-2">
        <div class="px-3 pt-2 pb-1">
            <small class="text-muted">전체 :
                <strong style="color: #c0392b;">
                </strong>건
            </small>
        </div>
        <table class="table table-bordered table-hover mb-0" style="font-size: 14px;">
        <colgroup>
            <col style="width: 15%">
            <col style="width: 20%">
            <col style="width: 20%">
            <col style="width: 10%">
            <col style="width: 10%">
            <col style="width: 23%">
        </colgroup>
            <thead class="table-light">
                <tr>
                    <th class="text-center">롤 코드</th>
                    <th class="text-center">롤 명</th>
                    <th class="text-center">설명</th>
                    <th class="text-center">관리자 여부</th>
                    <th class="text-center">사용 여부</th>
                    <th class="text-center">등록일</th>
                </tr>
            </thead>
            <tbody>
            		<tr>
	                  <td class="text-start">
	                  코드 
	                  </td>
	                  <td class="text-start">
	                  롤 명
	                  </td>
	                  <td class="text-start">
	                  설명	
	                  </td>
	                  <td class="text-start">
	                  ㄱ헌라저 요뷰
	                  </td>
	                  <td class="text-center">
	                  사용여부
	                  </td>
	                  <td class="text-center">
	                  등록일
	                  </td>
	              </tr>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-3">권한 그룹이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="role" items="${list}" varStatus="vs">
                            <tr>
                                <td class="text-start">
                                	롤 코드
                                </td>
                                <td class="text-start">
                                	롤 명
                                </td>
                                <td class="text-start">
                               	 설명
                                </td>
                                <td class="text-center">
                              		관리자여부
                                </td>
                                <td class="text-center">
                                	사용여부
                                </td>
                                <td class="text-center">
                                	등록일
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 3. 페이징 영역 -->
    <div class="paging mb-3">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
            		<li>페이징</li>
                <%-- <ui:pagination paginationInfo="${paginationInfo}"
                               type="customRenderer" jsFunction="linkPage"/> --%>
            </ul>
        </nav>
    </div>
</div>
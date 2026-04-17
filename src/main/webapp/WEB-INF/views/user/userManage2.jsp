<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui"  uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">
    <h2 class="h5 fw-bold mb-3">사용자 관리</h2>

    <!-- 1. 검색 영역 -->
    <form id="searchForm" method="post" action="user/userManage2.do">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1"/>
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <select name="searchType" id="searchType" class="form-select" style="width:auto; min-width:100px;">
                    <option value="userId" ${search.searchType eq 'userId' ? 'selected' : ''}>아이디</option>
                    <option value="userName" ${search.searchType eq 'userName' ? 'selected' : ''}>이름</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control" value="${search.searchKeyword}"
                       placeholder="검색어를 입력하세요." maxlength="100"/>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-danger px-4">검색</button>
            </div>
        </div>
    </form>

    <!-- 2. 목록 영역 -->
    <div class="bg-white border mb-2">
        <div class="px-3 pt-2 pb-1">
            <small class="text-muted">전체 : <strong style="color:#c0392b;"><fmt:formatNumber value="${paginationInfo.totalRecordCount}" pattern="#,###"/></strong>건</small>
        </div>
        <table class="table table-bordered table-hover mb-0" style="font-size:14px;">
            <thead class="table-light">
                <tr>
                    <th class="text-center" style="width:15%">순번</th>
                    <th class="text-center" style="width:29%">아이디</th>
                    <th class="text-center" style="width:29%">이름</th>
                    <th class="text-center" style="width:25%">사용여부</th>
                </tr>
            </thead>
            <tbody id="userListBody">
            <c:if test="${empty list }"><tr><td colspan="5">데이터가 없습니다.</td></tr></c:if>
            <c:forEach var="user" items="${list}" varStatus="status">
                <tr class="user-row" style="cursor:pointer;" data-user-no="${user.userNo}">
                  <td class="text-center">${paginationInfo.totalRecordCount
                                - (paginationInfo.currentPageNo - 1) * paginationInfo.recordCountPerPage
                                - status.index}</td>
                  <td class="text-center">${user.userId}</td>
                  <td class="text-center">${user.userName }</td>
							    <td class="text-center">
								    <span class="badge p-2 ${user.status eq 'ACTIVE' ? 'bg-success' : 'bg-danger'}">
								        ${user.status eq 'ACTIVE' ? '사용가능' : '사용불가'}
								    </span>
									</td>
            </c:forEach>
        </table>
    </div>

    <!-- 3. 페이징 영역 (더미) -->
    <%-- 페이지네이션: CustomPaginationRenderer 사용 (<<, <, 페이지번호, >, >>) --%>
    <div class="paging mb-3">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="customRenderer" jsFunction="linkPage"/>
            </ul>
        </nav>
    </div>

    <!-- 4. 상세 / 등록 폼 -->
    <div class="bg-white border p-3 mb-3">
    <form id="detailForm" method="post" action="">
        <table class="table table-bordered mb-0" style="font-size:14px;">
            <colgroup>
                <col style="width:15%">
                <col style="width:35%">
                <col style="width:15%">
                <col style="width:35%">
            </colgroup>
            <tbody>
                <tr>
                    <th class="table-light align-middle">아이디</th>
                    <td>
                      <input type="text" id="dUserId" disabled
                               class="form-control form-control-sm bg-light" maxlength="15" placeholder="영문 입력"/>
                    </td>
                    <th class="table-light align-middle">이름</th>
                    <td>
                        <input type="text" id="dUserName"
                               class="form-control form-control-sm" maxlength="30"/>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">비밀번호</th>
                    <td>
                        <input type="password" id="dUserPwView" maxlength="25" disabled
                               class="form-control form-control-sm bg-light"/>
                    </td>
                    <th class="table-light align-middle">비밀번호 변경</th>
                    <td>
                        <input type="password" id="dUserPw" maxlength="25" placeholder="비밀번호 변경시에만 입력하세요"
                               class="form-control form-control-sm"/>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">사용여부</th>
                    <td>
                        <select id="dStatus" class="form-select form-select-sm">
                            <option value="ACTIVE">Y (사용가능)</option>
                            <option value="DISABLED">N (사용불가)</option>
                        </select>
                    </td>
                    <th class="table-light align-middle">사용자구분</th>
                    <td>
                        <select id="dRole" class="form-select form-select-sm">
                            <option value="USER">일반사용자</option>
                            <option value="ADMIN">관리자</option>
                            <option value="SYSTEM">시스템관리자</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">최초등록일시</th>
                    <td>
                        <input type="text" id="dRegDate" class="form-control form-control-sm bg-light" disabled/>
                    </td>
                    <th class="table-light align-middle">최초등록자</th>
                    <td>
                        <input type="text" id="dRegUserName" class="form-control form-control-sm bg-light" disabled/>
                    </td>
                </tr>
                <tr>
                    <th class="table-light align-middle">수정일시</th>
                    <td>
                        <input type="text" id="dModDate" class="form-control form-control-sm bg-light" disabled/>
                    </td>
                    <th class="table-light align-middle">수정자</th>
                    <td>
                        <input type="text" id="dModUserName" class="form-control form-control-sm bg-light" disabled/>
                    </td>
                </tr>
            </tbody>
        </table>
      </form>
    </div>

    <!-- 5. 버튼 영역 -->
    <div class="d-flex justify-content-center gap-2 mb-4">
        <button type="button" class="btn btn-secondary px-4" id="btnReset">초기화</button>
        <button type="button" class="btn btn-primary px-4"    id="btnRegist">등록</button>
        <button type="button" class="btn btn-warning px-4"    id="btnUpdate">수정</button>
        <button type="button" class="btn btn-danger px-4"     id="btnDelete">삭제</button>
        <button type="button" class="btn btn-outline-secondary px-4" id="btnClose">닫기</button>
    </div>

</div>

<script>
	/* =====유저 상세 조회 클릭 이벤트======*/
/* 	$("tr.user-row").on("click", (e) =>{ // => 함수 this window객체 주의
		let userNo = $(e.currentTarget).data("userNo");
		$.ajax({
	    type : 'post',           // 타입 (get, post, put 등등)
	    url : '/user/ajaxTest',           // 요청할 서버url
	    async : true,            // 비동기화 여부 (default : true)
	    headers : {              // Http header
	      "Content-Type" : "application/json",
	      "X-HTTP-Method-Override" : "POST"
	    },
	    dataType : 'json',       // 받을 데이터 타입 (html, xml, json, text 등등)
	    data : JSON.stringify({  // 보낼 데이터 (Object , String, Array)
	      "userNo" : userNo
	    }),
	    success : function(result) { // 결과 성공 콜백함수
	        console.log(result);
	    },
	    error : function(request, status, error) { // 결과 에러 콜백함수
	        console.log(error)
	    }
		})
	}); */
	/* =====유저 상세 조회 클릭 이벤트 END======*/
	
	/* 목록 행 클릭 → 폼에 데이터 채우기 */
    $('#userListBody').on('click', '.user-row', function() {
        $('.user-row').removeClass('table-active');
        $(this).addClass('table-active'); //선택행 배경 포커싱
		//선택행 userNo
        let $row   = $(this); 
        let selectedUserNo = $row.data('userNo');
        let idChecked      = true;
        
        $.ajax({
    	    type : 'post',           // 타입 (get, post, put 등등)
    	    url : 'user/ajaxTest.do',           // 요청할 서버url
    	    async : true,            // 비동기화 여부 (default : true)
    	    headers : {              // Http header
    	      "Content-Type" : "application/json",
    	    },
    	    dataType : 'json',       // 받을 데이터 타입 (html, xml, json, text 등등)
    	    data : JSON.stringify({  // 보낼 데이터 (Object , String, Array)
    	      "userNo" : selectedUserNo
    	    }),
    	    success : function(result) { // 결과 성공 콜백함수
    	    	if(result.message == "success"){
    	    	// 조회한 user 정보 화면 로드
  	    		let user = result.user;
	  	    	$('#dUserId').val(user.userId);
	          $('#dUserName').val(user.userName);
	          $('#dUserPwView').val("*".repeat(user.userPwLen));
	          $('#dRole').val(user.role);
	          $('#dStatus').val(user.status);
	          $('#dRegUserName').val(user.regUserName);
	          $('#dModUserName').val(user.modUserName);
	          $('#dRegDate').val(user.regDate);
	          $('#dModDate').val(user.modDate);
    	    	}
    	    	else{
    	    		alert("조회 실패했습니다.");
    	    	}
  	    	},
    	    error : function(request, status, error) { // 결과 에러 콜백함수
    	    	alert("서버 오류가 발생하였습니다.");
    	    	console.log(request.responseText)	;
  	        console.log(error);
    	    }
        })


        // 폼 영역으로 스크롤
        $('#dUserId')[0].scrollIntoView({ behavior: 'smooth' });
    });
	
	//linkPage(pageNo): 페이지네이션 버튼 클릭 시 CustomPaginationRenderer 가 호출한다.
  // searchForm 의 currentPageNo 를 바꿔서 submit -> 검색 조건을 유지하면서 해당 페이지로 이동
  function linkPage(pageNo) {
      $('#currentPageNo').val(pageNo);
      $('#searchForm').submit();
  }
</script>

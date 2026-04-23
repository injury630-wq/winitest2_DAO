<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<div class="px-1">
		<h2 class="h5 fw-bold mb-3">사용자 관리</h2>

		<!-- 1. 검색 영역 -->
		<form id="searchForm" method="post" action="user/userManage.do">
				<input type="hidden" name="currentPageNo" id="currentPageNo" value="1" />
				<div class="border bg-white p-3 mb-3">
						<div class="d-flex gap-2 mb-2">
								<select name="searchType" id="searchType" class="form-select"
										style="width: auto; min-width: 100px;">
										<option value="userId"
												${search.searchType eq 'userId' ? 'selected' : ''}>아이디</option>
										<option value="userName"
												${search.searchType eq 'userName' ? 'selected' : ''}>이름</option>
								</select>
								<input type="text" name="searchKeyword" class="form-control"
										value="${search.searchKeyword}" placeholder="검색어를 입력하세요."
										maxlength="100" />
						</div>
						<div class="text-center">
								<button type="submit" class="btn btn-danger px-4">검색</button>
						</div>
				</div>
		</form>

		<!-- 2. 목록 영역 -->
		<div class="bg-white border mb-2">
				<div class="px-3 pt-2 pb-1">
						<small class="text-muted">전체 : <strong
								style="color: #c0392b;"><fmt:formatNumber
												value="${paginationInfo.totalRecordCount}" pattern="#,###" /></strong>건
						</small>
				</div>
				<table class="table table-bordered table-hover mb-0" style="font-size: 14px;">
						<thead class="table-light">
								<tr>
										<th class="text-center" style="width: 15%">순번</th>
										<th class="text-center" style="width: 29%">아이디</th>
										<th class="text-center" style="width: 29%">이름</th>
										<th class="text-center" style="width: 25%">사용여부</th>
								</tr>
						</thead>
						<tbody id="userListBody">
								<c:if test="${empty list}">
										<tr>
												<td colspan="5">데이터가 없습니다.</td>
										</tr>
								</c:if>
								<c:forEach var="user" items="${list}" varStatus="status">
										<tr class="user-row" style="cursor: pointer;"
												data-user-no="${user.userNo}">
												<td class="text-center">${paginationInfo.totalRecordCount
                                - (paginationInfo.currentPageNo - 1) * paginationInfo.recordCountPerPage
                                - status.index}</td>
												<td class="text-center">${user.userId}</td>
												<td class="text-center">${user.userName}</td>
												<td class="text-center">
														<span class="badge p-2 ${user.useYn eq 'Y' ? 'bg-success' : 'bg-danger'}">
																${user.useYn eq 'Y' ? '사용가능' : '사용불가'}
														</span>
												</td>
										</tr>
								</c:forEach>
						</tbody>
				</table>
		</div>

		<!-- 3. 페이징 영역 -->
		<div class="paging mb-3">
				<nav aria-label="페이지 이동">
						<ul class="pagination justify-content-center">
								<ui:pagination paginationInfo="${paginationInfo}"
										type="customRenderer" jsFunction="linkPage" />
						</ul>
				</nav>
		</div>

		<!-- 4. 상세 / 등록 폼 -->
		<div class="bg-white border p-3 mb-3">
				<form id="detailForm" method="post" action="">
						<input type="hidden" id="userNo" name="userNo" value="" />
						<table class="table table-bordered mb-0" style="font-size: 14px;">
								<colgroup>
										<col style="width: 15%">
										<col style="width: 35%">
										<col style="width: 15%">
										<col style="width: 35%">
								</colgroup>
								<tbody>
										<tr>
												<th class="table-light align-middle">아이디</th>
												<td><input type="text" id="userId" name="userId"
														class="form-control form-control-sm" maxlength="15"
														placeholder="영문/숫자 5~15자" required />
														<p id="userIdMsg" class="guide-msg"></p></td>
												<th class="table-light align-middle">이름</th>
												<td><input type="text" id="userName" name="userName"
														class="form-control form-control-sm" maxlength="30"
														placeholder="이름 입력" required /></td>
										</tr>
										<tr>
												<th class="table-light align-middle">비밀번호</th>
												<td>
														<%-- 등록 모드 --%>
														<div id="pwRegistDiv">
																<input type="password" id="userPw" maxlength="25"
																		class="form-control form-control-sm"
																		placeholder="숫자+영문+특수문자 조합 10~25자" required />
																<p id="userPwMsg" class="guide-msg"></p>
														</div>
														<%-- 수정 모드: 미입력 시 비밀번호 변경 안 함 --%>
														<div id="pwUpdateDiv" style="display:none;" class="row g-2">
																<div class="text-muted mb-1">비밀번호 (미입력 시 변경 안함)</div>
																<input type="password" id="userPwView" onfocus="this.select()" class="form-control form-control-sm" maxlength="25"/>
																<p id="userPwMsg2" class="guide-msg"></p>
																<input type="password" id="userPwChange" maxlength="25"
																		class="form-control form-control-sm visually-hidden"/>
														</div>
												</td>
										</tr>
										<tr>
												<th class="table-light align-middle">사용여부</th>
												<td><select id="useYn" name="useYn"
														class="form-select form-select-sm">
																<option value="Y">Y (사용가능)</option>
																<option value="N">N (사용불가)</option>
												</select></td>
												<th class="table-light align-middle">사용자구분</th>
												<td><select id="role" name="role"
														class="form-select form-select-sm">
																<c:forEach var="r" items="${roleList}">
																		<option value="${r.role}">${r.roleName}</option>
																</c:forEach>
												</select></td>
										</tr>
										<tr>
												<th class="table-light align-middle">최초등록일시</th>
												<td><input type="text" id="regDate"
														class="form-control form-control-sm" disabled /></td>
												<th class="table-light align-middle">최초등록자</th>
												<td><input type="text" id="regUserName"
														class="form-control form-control-sm" disabled /></td>
										</tr>
										<tr>
												<th class="table-light align-middle">수정일시</th>
												<td><input type="text" id="modDate"
														class="form-control form-control-sm" disabled /></td>
												<th class="table-light align-middle">수정자</th>
												<td><input type="text" id="modUserName"
														class="form-control form-control-sm" disabled /></td>
										</tr>
								</tbody>
						</table>
				</form>
		</div>

		<!-- 5. 버튼 영역 -->
		<div class="d-flex justify-content-center gap-2 mb-4">
				<button type="button" class="btn btn-info px-4" id="btnReset">초기화</button>
				<button type="button" class="btn btn-primary px-4" id="btnRegist">등록</button>
				<button type="button" class="btn btn-warning px-4" id="btnUpdate">수정</button>
				<button type="button" class="btn btn-danger px-4" id="btnDelete">삭제</button>
				<button type="button" class="btn btn-outline-secondary px-4"
						onclick="goPost('board/list.do')">닫기</button>
		</div>

</div>

<script>
	/* ===== 정규식 ===== */
	let idRegex = /^[a-zA-Z0-9]{5,15}$/;
	let pwRegex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\-=\[\]{}|;':",.<>?])[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|;':",.<>?]{10,25}$/;
	let nameRegex = /^[가-힣a-zA-Z0-9]+$/;

	/* 로그인 사용자 정보 */
	let loginUserNo = ${sessionScope.loginUser.userNo};
	let loginUserRole = '${sessionScope.loginUser.role}';
	let isAdmin = (loginUserRole === 'ADMIN' || loginUserRole === 'SYSTEM');

	/* 상태 변수 */
	let selectedUserNo = 0;
	let selectedRow = null;

	/* 초기화 */
	$(function() {
		setRegistMode();

		/* 아이디 실시간 검증 */
		$('#userId').on('input', function() {
			let val = this.value.replace(/[^a-zA-Z0-9]/g, '');
			this.value = val;
			if (val === '') {
				$('#userIdMsg').text('').css('color', '');
			} else if (idRegex.test(val)) {
				$('#userIdMsg').text('사용 가능한 아이디입니다.').css('color', 'green');
			} else {
				$('#userIdMsg').text('영문/숫자 5~15자').css('color', 'red');
			}
		});

		/* 비밀번호 실시간 검증 (등록 모드) */
		$('#userPw').on('input', function() {
			let val = this.value;
			if (val === '') {
				$('#userPwMsg').text('').css('color', '');
			} else if (pwRegex.test(val)) {
				$('#userPwMsg').text('사용 가능한 비밀번호입니다.').css('color', 'green');
			} else {
				$('#userPwMsg').text('영문+숫자+특수문자 10~25자').css('color', 'red');
			}
		});

		/* 비밀번호 실시간 검증 (수정 모드) */
		$('#userPwView').on('input', function() {
			let val = this.value;
			if (val === '') {
				$('#userPwMsg2').text('').css('color', '');
			} else if (pwRegex.test(val)) {
				$('#userPwMsg2').text('사용 가능한 비밀번호입니다.').css('color', 'green');
			} else {
				$('#userPwMsg2').text('영문+숫자+특수문자 10~25자').css('color', 'red');
			}
		});

		/* 이름 공백 자동 제거 */
		$('#userName').on('input', function() {
			this.value = this.value.replace(/\s/g, '');
		});

		/* 초기화 버튼 */
		$('#btnReset').on('click', function() {
			setRegistMode();
		});

		/* 목록 행 클릭 → 상세 조회 후 수정 모드 */
		$('#userListBody').on('click', '.user-row', function() {
			$('.user-row').removeClass('table-active');
			$(this).addClass('table-active');

			selectedRow = $(this);
			selectedUserNo = $(this).data('userNo');

			$.ajax({
				type : 'post',
				url : 'user/userSelect.do',
				headers : { 'Content-Type' : 'application/json' },
				dataType : 'json',
				data : JSON.stringify({ userNo : selectedUserNo }),
				success : function(result) {
					if (result.message === 'success') {
						setUpdateMode(result.user);
						$('#userId')[0].scrollIntoView({ behavior : 'smooth' });
					} else {
						alert('조회에 실패하였습니다.');
					}
				},
				error : function() {
					alert('서버 오류가 발생하였습니다.');
				}
			});
		});

		/* 등록 버튼 */
		$('#btnRegist').on('click', function() {
			let userId = $('#userId').val().trim();
			let userPw = $('#userPw').val();
			let userName = $('#userName').val().trim();

			if (!userId)                   { alert('아이디를 입력하세요.');           return; }
			if (!idRegex.test(userId))     { alert('아이디 형식이 올바르지 않습니다.'); return; }
			if (!userPw)                   { alert('비밀번호를 입력하세요.');           return; }
			if (!pwRegex.test(userPw))     { alert('비밀번호 형식이 올바르지 않습니다.'); return; }
			if (!userName)                 { alert('이름을 입력하세요.');              return; }
			if (!nameRegex.test(userName)) { alert('이름 형식이 올바르지 않습니다.');    return; }

			$.ajax({
				type : 'post',
				url : 'user/userRegist.do',
				dataType : 'json',
				data : {
					userId   : userId,
					userPw   : userPw,
					userName : userName,
					role     : $('#role').val(),
					useYn    : $('#useYn').val()
				},
				success : function(result) {
					if (result.result === 'duplicate') {
						alert('이미 사용 중인 아이디입니다.');
					} else if (result.result === 'forbidden') {
						alert('권한이 없습니다.');
					} else if (result.result === 'success') {
						alert('등록되었습니다.');
						$('#currentPageNo').val(1);
						$('#searchForm').submit();
					} else {
						alert('등록 중 오류가 발생하였습니다.');
					}
				},
				error : function() {
					alert('서버 오류가 발생하였습니다.');
				}
			});
		});

		/* 수정 버튼 */
		$('#btnUpdate').on('click', function() {
			if (!selectedUserNo) { alert('수정할 사용자를 선택하세요.'); return; }

			let userName      = $('#userName').val().trim();
			let userPwChange  = $('#userPwChange').val();

			if (!userName)                 { alert('이름을 입력하세요.');              return; }
			if (!nameRegex.test(userName)) { alert('이름 형식이 올바르지 않습니다.');    return; }
			if (userPwChange && !pwRegex.test(userPwChange)) {
				alert('새 비밀번호 형식이 올바르지 않습니다.'); return;
			}
			if (!confirm('수정하시겠습니까?')) return;

			$.ajax({
				type : 'post',
				url : 'user/userUpdate.do',
				dataType : 'json',
				data : {
					userNo   : selectedUserNo,
					userName : userName,
					userPw   : userPwChange,
					role     : $('#role').val(),
					useYn    : $('#useYn').val()
				},
				success : function(result) {
					if (result.result === 'success') {
						alert('수정되었습니다.');
						updateListRow(selectedRow, result.user);
						setUpdateMode(result.user);
					} else if (result.result === 'forbidden') {
						alert('권한이 없습니다.');
					} else if (result.result === 'relogin') {
						alert('권한이 변경되어 다시 로그인해야 합니다.');
						location.href = 'user/login.do';
					} else {
						alert('수정 중 오류가 발생하였습니다.');
					}
				},
				error : function() {
					alert('서버 오류가 발생하였습니다.');
				}
			});
		});

		/* 삭제(비활성화) 버튼 */
		$('#btnDelete').on('click', function() {
			if (!selectedUserNo) { alert('처리할 사용자를 선택하세요.'); return; }
			if (!confirm('해당 사용자를 사용 불가 처리하시겠습니까?\n(실제로 삭제되지 않습니다.)')) return;

			$.ajax({
				type : 'post',
				url : 'user/userDelete.do',
				dataType : 'json',
				data : { userNo : selectedUserNo },
				success : function(result) {
					if (result.result === 'success') {
						alert('사용 불가 처리되었습니다.');
						updateListRow(selectedRow, result.user);
						setUpdateMode(result.user);
					} else if (result.result === 'forbidden') {
						alert('권한이 없습니다.');
					} else {
						alert('처리 중 오류가 발생하였습니다.');
					}
				},
				error : function() {
					alert('서버 오류가 발생하였습니다.');
				}
			});
		});
	}); // $(function) end

	/* ==== 모드 전환 함수 ==== */

	/* 등록 모드 */
	function setRegistMode() {
		selectedUserNo = null;
		selectedRow = null;
		$('.user-row').removeClass('table-active');

		$('#userNo').val('');
		$('#userId').val('').prop('disabled', false);
		$('#userName').val('');
		$('#useYn').val('Y');
		$('#role').val('USER');
		$('#regDate, #regUserName, #modDate, #modUserName').val('');

		$('#pwRegistDiv').show();
		$('#pwUpdateDiv').hide();
		$('#userPw').val('');
		$('#userPwChange').val('');
		$('#userIdMsg, #userPwMsg').text('').css('color', '');

		if (isAdmin) {
			$('#btnReset').prop('disabled', false).removeClass('btn-secondary').addClass('btn-info');
			$('#btnRegist').prop('disabled', false).removeClass('btn-secondary').addClass('btn-primary');
			$('#btnUpdate').prop('disabled', true).removeClass('btn-warning').addClass('btn-secondary');
			$('#btnDelete').prop('disabled', true).removeClass('btn-danger').addClass('btn-secondary');
		} else {
			$('#btnReset').prop('disabled', true).removeClass('btn-info').addClass('btn-secondary');
			$('#btnRegist').prop('disabled', true).removeClass('btn-primary').addClass('btn-secondary');
			$('#btnUpdate').prop('disabled', true).removeClass('btn-warning').addClass('btn-secondary');
			$('#btnDelete').prop('disabled', true).removeClass('btn-danger').addClass('btn-secondary');
		}
	}

	/* 수정 모드 */
	function setUpdateMode(user) {
		$('#userNo').val(user.userNo);
		$('#userId').val(user.userId).prop('disabled', true);
		$('#userName').val(user.userName);
		$('#useYn').val(user.useYn);
		$('#role').val(user.role);
		$('#regDate').val(user.regDate || '');
		$('#regUserName').val(user.regUserName || '');
		$('#modDate').val(user.modDate || '');
		$('#modUserName').val(user.modUserName || '');

		$('#pwRegistDiv').hide();
		$('#pwUpdateDiv').show();
		$('#userPwView').val('*'.repeat(user.userPwLen || 0));
		$('#userPwChange').val('');
		$('#userIdMsg, #userPwMsg').text('').css('color', '');

		let isSelf = (user.userNo == loginUserNo);
		$('#btnRegist').prop('disabled', true).removeClass('btn-primary').addClass('btn-secondary');
		if (isAdmin) {
			$('#btnUpdate').prop('disabled', false).removeClass('btn-secondary').addClass('btn-warning');
			$('#btnDelete').prop('disabled', isSelf).removeClass('btn-secondary btn-danger')
					.addClass(isSelf ? 'btn-secondary' : 'btn-danger');
		} else {
			$('#btnUpdate').prop('disabled', !isSelf).removeClass('btn-secondary btn-warning')
					.addClass(isSelf ? 'btn-warning' : 'btn-secondary');
			$('#btnDelete').prop('disabled', true).removeClass('btn-danger').addClass('btn-secondary');
		}
	}

	/* 목록 행 현장 갱신 */
	function updateListRow($row, user) {
		$row.find('td:eq(2)').text(user.userName);
		let isActive = user.useYn === 'Y';
		$row.find('.badge').removeClass('bg-success bg-danger')
				.addClass(isActive ? 'bg-success' : 'bg-danger')
				.text(isActive ? '사용가능' : '사용불가');
	}

	/* 페이지네이션 */
	function linkPage(pageNo) {
		$('#currentPageNo').val(pageNo);
		$('#searchForm').submit();
	}

	/* 비밀번호 표시/숨김 */
	function togglePw(id, btn) {
		let input = document.querySelector('#' + id);
		if (input.type === 'password') {
			input.type = 'text';
			btn.innerText = '숨김';
		} else {
			input.type = 'password';
			btn.innerText = '표시';
		}
	}
</script>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!-- 백업 임시용 파일 -->
<div class="px-1">
    <h2 class="h5 fw-bold mb-3">이미지 게시판</h2>

    <!-- 1. 검색 영역 -->
    <form id="searchForm" method="post" action="">
        <input type="hidden" name="currentPageNo" id="currentPageNo" value="1"/>
        <div class="border bg-white p-3 mb-3">
            <div class="d-flex gap-2 mb-2">
                <select name="searchType" id="searchType" class="form-select" style="width:auto; min-width:100px;">
                    <option value="userId">아이디</option>
                    <option value="userName">이름</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control"
                       placeholder="검색어를 입력하세요." maxlength="100"/>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-danger px-4">검색</button>
            </div>
        </div>
    </form>

		<!-- 2. 목록 영역 -->
		<div class="bg-white border mb-2">
		
		    <!-- 상단 개수 -->
		    <div class="px-3 pt-2 pb-1">
		        <small class="text-muted">
		            전체 : <strong class="text-danger">8</strong>건
		        </small>
		    </div>
		
		    <!-- 갤러리 영역 -->
		    <div class="p-3">
		        <div class="row g-3">
		
		            <!-- 카드 1 -->
		            <div class="col-md-3">
		                <div class="card h-100" style="cursor:pointer;">
		                    <img src="https://dummyimage.com/600x400/d68bd6/ffffff.png"
		                         class="card-img-top"
		                         style="height:180px; object-fit:cover;">
		
		                    <div class="card-body p-2">
		                        <h6 class="card-title mb-1 text-truncate">
		                            샘플 이미지 제목 1
		                        </h6>
		                        <div class="text-muted small">홍길동</div>
		                        <div class="d-flex justify-content-between small text-muted">
		                            <span>2026-04-20</span>
		                            <span>조회 12</span>
		                        </div>
		                    </div>
		                </div>
		            </div>
		
		            <!-- 카드 2 -->
		            <div class="col-md-3">
		                <div class="card h-100" style="cursor:pointer;">
		                    <img src="https://dummyimage.com/600x400/d68bd6/ffffff.png&text=test"
		                         class="card-img-top"
		                         style="height:180px; object-fit:cover;">
		
		                    <div class="card-body p-2">
		                        <h6 class="card-title mb-1 text-truncate">
		                            여행 사진 갤러리
		                        </h6>
		                        <div class="text-muted small">김철수</div>
		                        <div class="d-flex justify-content-between small text-muted">
		                            <span>2026-04-19</span>
		                            <span>조회 33</span>
		                        </div>
		                    </div>
		                </div>
		            </div>
		
		            <!-- 카드 3 -->
		            <div class="col-md-3">
		                <div class="card h-100" style="cursor:pointer;">
		                    <img src="https://dummyimage.com/600x400/d68bd6/ffffff.png&text=test"
		                         class="card-img-top"
		                         style="height:180px; object-fit:cover;">
		
		                    <div class="card-body p-2">
		                        <h6 class="card-title mb-1 text-truncate">
		                            테스트 게시글 제목입니다
		                        </h6>
		                        <div class="text-muted small">이영희</div>
		                        <div class="d-flex justify-content-between small text-muted">
		                            <span>2026-04-18</span>
		                            <span>조회 5</span>
		                        </div>
		                    </div>
		                </div>
		            </div>
		
		            <!-- 카드 4 -->
		            <div class="col-md-3">
		                <div class="card h-100" style="cursor:pointer;">
		                    <img src="https://dummyimage.com/600x400/d68bd6/ffffff.png&text=test"
		                         class="card-img-top"
		                         style="height:180px; object-fit:cover;">
		
		                    <div class="card-body p-2">
		                        <h6 class="card-title mb-1 text-truncate">
		                            이미지 게시판 예시
		                        </h6>
		                        <div class="text-muted small">관리자</div>
		                        <div class="d-flex justify-content-between small text-muted">
		                            <span>2026-04-17</span>
		                            <span>조회 99</span>
		                        </div>
		                    </div>
		                </div>
		            </div>
		
		            <!-- 카드 5 -->
		            <div class="col-md-3">
		                <div class="card h-100" style="cursor:pointer;">
		                    <img src="https://dummyimage.com/600x400/d68bd6/ffffff.png&text=test"
		                         class="card-img-top"
		                         style="height:180px; object-fit:cover;">
		
		                    <div class="card-body p-2">
		                        <h6 class="card-title mb-1 text-truncate">
		                            새로운 갤러리 UI 테스트
		                        </h6>
		                        <div class="text-muted small">박민수</div>
		                        <div class="d-flex justify-content-between small text-muted">
		                            <span>2026-04-16</span>
		                            <span>조회 21</span>
		                        </div>
		                    </div>
		                </div>
		            </div>
		
		            <!-- 카드 6 -->
		            <div class="col-md-3">
		                <div class="card h-100" style="cursor:pointer;">
		                    <img src="https://dummyimage.com/600x400/d68bd6/ffffff.png&text=test"
		                         class="card-img-top"
		                         style="height:180px; object-fit:cover;">
		
		                    <div class="card-body p-2">
		                        <h6 class="card-title mb-1 text-truncate">
		                            썸네일 표시 테스트
		                        </h6>
		                        <div class="text-muted small">최지훈</div>
		                        <div class="d-flex justify-content-between small text-muted">
		                            <span>2026-04-15</span>
		                            <span>조회 7</span>
		                        </div>
		                    </div>
		                </div>
		            </div>
		
		            <!-- 카드 7 -->
		            <div class="col-md-3">
		                <div class="card h-100" style="cursor:pointer;">
		                    <img src="https://dummyimage.com/600x400/d68bd6/ffffff.png&text=test"
		                         class="card-img-top"
		                         style="height:180px; object-fit:cover;">
		
		                    <div class="card-body p-2">
		                        <h6 class="card-title mb-1 text-truncate">
		                            UI 샘플 데이터
		                        </h6>
		                        <div class="text-muted small">홍길동</div>
		                        <div class="d-flex justify-content-between small text-muted">
		                            <span>2026-04-14</span>
		                            <span>조회 18</span>
		                        </div>
		                    </div>
		                </div>
		            </div>
		
		            <!-- 카드 8 -->
		            <div class="col-md-3">
		                <div class="card h-100" style="cursor:pointer;">
		                    <img src="https://dummyimage.com/600x400/d68bd6/ffffff.png&text=test"
		                         class="card-img-top"
		                         style="height:180px; object-fit:cover;">
		
		                    <div class="card-body p-2">
		                        <h6 class="card-title mb-1 text-truncate">
		                            마지막 더미 데이터
		                        </h6>
		                        <div class="text-muted small">관리자</div>
		                        <div class="d-flex justify-content-between small text-muted">
		                            <span>2026-04-13</span>
		                            <span>조회 2</span>
		                        </div>
		                    </div>
		                </div>
		            </div>
		
		        </div>
		    </div>
		</div>
		<%-- 4. 페이지네이션: CustomPaginationRenderer 사용 (<<, <, 페이지번호, >, >>) --%>
    <div class="paging">
        <nav aria-label="페이지 이동">
            <ul class="pagination justify-content-center">
                <%-- <ui:pagination paginationInfo="${paginationInfo}" type="customRenderer" jsFunction="linkPage"/> --%>
                	<li>페ㅣ징</li>	
            </ul>
        </nav>
    </div>
			
    <!-- 5. 버튼 영역 -->
    <div class="text-end mt-2">
        <button type="button" class="btn btn-danger">글쓰기</button>
    </div>

</div>

<script>

</script>

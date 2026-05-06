<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<div class="container mt-4">
    <h3>설문지 등록</h3>

    <!-- 설문 기본 정보 -->
    <div class="card mb-3">
        <div class="card-body">
            <div class="form-group">
                <label>설문 제목</label>
                <input type="text" class="form-control" name="title">
            </div>

            <div class="form-group">
                <label>설명</label>
                <textarea class="form-control" name="description"></textarea>
            </div>

            <div class="form-row">
                <div class="col">
                    <label>시작일</label>
                    <input type="date" class="form-control" name="startDate">
                </div>
                <div class="col">
                    <label>종료일</label>
                    <input type="date" class="form-control" name="endDate">
                </div>
            </div>
        </div>
    </div>

    <!-- 문항 영역 -->
    <div class="mb-3">
        <h5>문항 목록</h5>
        <button type="button" class="btn btn-primary mb-2" onclick="addQuestion()">+ 문항 추가</button>
        
        <div id="questionContainer"></div>
    </div>

    <button class="btn btn-success">저장</button>
</div>
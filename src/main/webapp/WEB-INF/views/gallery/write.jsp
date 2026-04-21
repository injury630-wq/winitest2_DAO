<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container">
    <h2>이미지 게시글 등록</h2>
    <form action="" method="post" enctype="multipart/form-data">
        <input type="hidden" name="searchType"    value="${param.searchType}"/>
        <input type="hidden" name="searchKeyword" value="${param.searchKeyword}"/>
        <table>
            <tr>
                <th><span class="required">*</span>작성자</th>
                <td>
                    <input type="text" name="writerId" class="form-control" value="${sessionScope.loginUser.userName}" readonly/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>제목</th>
                <td colspan="3">
                    <input type="text" name="title" class="form-control" placeholder="제목 입력" maxlength="160" required/>
                </td>
            </tr>
            <tr>
                <th><span class="required">*</span>내용</th>
                <td colspan="3">
                    <textarea name="content" class="form-control" rows="8" placeholder="내용 입력" maxlength="2800" required></textarea>
                </td>
            </tr>
            <tr>
                <th>첨부</th>
                <td colspan="3">
                    <input type="file" multiple name="uploadFile" class="form-control" id="fileInput"/>
                    <span class="text-muted" style="font-size:12px;">shift 혹은 ctrl을 눌러 여러 파일 등록가능합니다.</span>
					<div class="file-item file-item-temp" style="display:none;">
					    <span class="file-name">파일이름[byte]</span>
					</div>
					<div id="fileList">
					</div>
                </td>
            </tr>
        </table>
        <div class="d-flex justify-content-center gap-2 mt-3">
            <button type="button" class="btn btn-outline-secondary" onclick="goPost('board/list.do', {searchType:'${param.searchType}', searchKeyword:'${param.searchKeyword}'})">취소</button>
            <button type="submit" class="btn btn-danger" onclick="return validate()">저장</button>
        </div>
    </form>
</div>

<script>

</script>

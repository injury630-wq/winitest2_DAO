<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-center align-items-center" style="min-height:100vh;">
    <div class="bg-white border p-4" style="width:400px;">
        <h2 class="text-center mb-4" style="font-size:24px;">로그인</h2>

        <c:if test="${error == '1'}">
            <p class="text-danger text-center small mb-3">아이디 또는 비밀번호가 틀렸습니다.</p>
        </c:if>
        <c:if test="${join == '1'}">
            <p class="text-success text-center small mb-3">회원가입이 완료됐습니다. 로그인해주세요.</p>
        </c:if>

        <form action="user/loginProc.do" method="post">
            <div class="mb-3">
                <label class="form-label">아이디</label>
                <input type="text" name="userId" class="form-control" placeholder="아이디"/>
            </div>
            <div class="mb-3">
                <label class="form-label">비밀번호</label>
                <input type="password" name="userPw" class="form-control" placeholder="비밀번호"/>
            </div>
            <button type="submit" class="btn btn-danger w-100 mt-1">로그인</button>
        </form>

        <div class="text-center mt-3">
            <form action="user/register.do" method="post" style="margin:0">
                <button type="submit" class="btn btn-link p-0 text-secondary text-decoration-none" style="font-size:14px;">회원가입</button>
            </form>
        </div>
    </div>
</div>

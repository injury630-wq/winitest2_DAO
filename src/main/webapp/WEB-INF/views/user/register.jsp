<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-center align-items-center py-5" style="min-height:100vh;">
    <div class="bg-white border p-4" style="width:520px;">
        <h2 class="mb-1" style="font-size:20px;">회원정보 입력</h2>
        <p class="text-end text-danger mb-3" style="font-size:12px;">* 표시는 반드시 입력하셔야 합니다.</p>

        <form action="user/registerProc.do" method="post">
            <table style="width:100%; border-collapse:collapse;">
                <tr>
                    <td style="width:120px; padding:8px 5px; font-size:14px; vertical-align:top; padding-top:12px;">
                        <span class="text-danger me-1">*</span>아이디
                    </td>
                    <td style="padding:8px 5px;">
                        <div class="input-group">
                            <input type="text" id="userId" name="userId" class="form-control"/>
                            <button type="button" class="btn btn-outline-danger" onclick="idCheck()">중복확인</button>
                        </div>
                        <p id="idMsg" class="guide-msg">한글, 특수문자를 제외한 5~15자 영문, 숫자로 입력해주세요.</p>
                    </td>
                </tr>
                <tr>
                    <td style="width:120px; padding:8px 5px; font-size:14px; vertical-align:top; padding-top:12px;">
                        <span class="text-danger me-1">*</span>비밀번호
                    </td>
                    <td style="padding:8px 5px;">
                        <div class="input-group">
                            <input type="password" id="userPw" name="userPw" class="form-control"/>
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePw('userPw', this)">표시</button>
                        </div>
                        <p id="pwMsg" class="guide-msg">숫자+영문자+특수문자 조합으로 10~25자리로 입력해주세요.</p>
                    </td>
                </tr>
                <tr>
                    <td style="width:120px; padding:8px 5px; font-size:14px; vertical-align:top; padding-top:12px;">
                        <span class="text-danger me-1">*</span>비밀번호 확인
                    </td>
                    <td style="padding:8px 5px;">
                        <div class="input-group">
                            <input type="password" id="userPwCheck" class="form-control"/>
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePw('userPwCheck', this)">표시</button>
                        </div>
                        <p id="pwCheckMsg" class="guide-msg"></p>
                    </td>
                </tr>
                <tr>
                    <td style="width:120px; padding:8px 5px; font-size:14px; vertical-align:top; padding-top:12px;">
                        <span class="text-danger me-1">*</span>이름
                    </td>
                    <td style="padding:8px 5px;">
                        <input type="text" name="userName" id="userName" class="form-control"/>
                        <p id="nameMsg" class="guide-msg">이름은 공백 없이 들어갑니다.</p>
                    </td>
                </tr>
            </table>

            <div class="d-flex justify-content-center gap-2 mt-3">
                <button type="button" class="btn btn-outline-secondary px-4" onclick="history.back()">취소</button>
                <button type="submit" class="btn btn-danger px-4" onclick="return validate()">가입</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.querySelector("#userId").addEventListener("input", function() {
        var userId = this.value.trim();
        var msg = document.querySelector("#idMsg");
        var idRegex = /^[a-zA-Z0-9]{5,15}$/;
        if (userId === "") {
            msg.className = "guide-msg";
            msg.innerText = "한글, 특수문자를 제외한 5~15자 영문, 숫자로 입력해주세요.";
        } else if (idRegex.test(userId)) {
            msg.className = "guide-msg ok";
            msg.innerText = "올바른 형식입니다.";
        } else {
            msg.className = "guide-msg fail";
            msg.innerText = "한글, 특수문자를 제외한 5~15자 영문, 숫자로 입력해주세요.";
        }
    });

    document.querySelector("#userPw").addEventListener("input", function() {
        var pw = this.value.trim();
        var msg = document.querySelector("#pwMsg");
        var pwRegex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\-=\[\]{}|;':",.<>?])[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|;':",.<>?]{10,25}$/;
        if (pw === "") {
            msg.className = "guide-msg";
            msg.innerText = "숫자+영문자+특수문자 조합으로 10~25자리로 입력해주세요.";
        } else if (pwRegex.test(pw)) {
            msg.className = "guide-msg ok";
            msg.innerText = "사용 가능한 비밀번호입니다.";
        } else {
            msg.className = "guide-msg fail";
            msg.innerText = "숫자+영문자+특수문자 조합으로 10~25자리로 입력해주세요.";
        }
        checkPwMatch();
    });

    document.querySelector("#userPwCheck").addEventListener("input", checkPwMatch);

    function checkPwMatch() {
        var pw      = document.querySelector("#userPw").value.trim();
        var pwCheck = document.querySelector("#userPwCheck").value.trim();
        var msg     = document.querySelector("#pwCheckMsg");
        if (pwCheck === "") {
            msg.className = "guide-msg";
            msg.innerText = "";
        } else if (pw === pwCheck) {
            msg.className = "guide-msg ok";
            msg.innerText = "비밀번호가 일치합니다.";
        } else {
            msg.className = "guide-msg fail";
            msg.innerText = "비밀번호가 일치하지 않습니다.";
        }
    }

    function togglePw(id, btn) {
        var input = document.querySelector("#" + id);
        if (input.type === "password") {
            input.type = "text";
            btn.innerText = "숨김";
        } else {
            input.type = "password";
            btn.innerText = "표시";
        }
    }

    async function idCheck() {
        var userId = document.querySelector("#userId").value.trim();
        var msg = document.querySelector("#idMsg");
        var idRegex = /^[a-zA-Z0-9]{5,15}$/;
        if (!userId) { alert("아이디를 입력하세요."); return; }
        if (!idRegex.test(userId)) {
            msg.className = "guide-msg fail";
            msg.innerText = "한글, 특수문자를 제외한 5~15자 영문, 숫자로 입력해주세요.";
            return;
        }
        try {
            var response = await fetch("user/idCheck.do", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "userId=" + encodeURIComponent(userId)
            });
            var result = await response.text();
            if (result == "0") {
                msg.className = "guide-msg ok";
                msg.innerText = "사용 가능한 아이디입니다.";
            } else {
                msg.className = "guide-msg fail";
                msg.innerText = "이미 사용 중인 아이디입니다.";
            }
        } catch (e) {
            alert("오류가 발생했습니다.");
        }
    }

    function validate() {
        var userId   = document.querySelector("#userId").value.trim();
        var userPw   = document.querySelector("#userPw").value.trim();
        var pwCheck  = document.querySelector("#userPwCheck").value.trim();
        var userName = document.querySelector("#userName").value.replace(/\s/g, "");
        var idMsg    = document.querySelector("#idMsg").innerText;
        var idRegex  = /^[a-zA-Z0-9]{5,15}$/;
        var pwRegex  = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\-=\[\]{}|;':",.<>?])[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|;':",.<>?]{10,25}$/;

        if (!userId)                              { alert("아이디를 입력하세요."); return false; }
        if (!idRegex.test(userId))                { alert("아이디 형식이 올바르지 않습니다."); return false; }
        if (idMsg !== "사용 가능한 아이디입니다.") { alert("아이디 중복확인을 해주세요."); return false; }
        if (!userPw)                              { alert("비밀번호를 입력하세요."); return false; }
        if (!pwRegex.test(userPw))                { alert("비밀번호 형식이 올바르지 않습니다."); return false; }
        if (userPw !== pwCheck)                   { alert("비밀번호가 일치하지 않습니다."); return false; }
        if (!userName)                            { alert("이름을 입력해주세요."); return false; }

        document.querySelector("#userName").value = userName;
        return true;
    }
</script>

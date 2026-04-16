<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* placeholder 색상 연하게 */
    ::placeholder { color: #bbb; opacity: 1; }

    /* 언어 힌트 뱃지 */
    .lang-badge {
        display: inline-block;
        font-size: 10px;
        padding: 1px 5px;
        border-radius: 3px;
        margin-left: 4px;
        vertical-align: middle;
        font-weight: bold;
        letter-spacing: 0.5px;
    }
    .lang-badge.en { background: #e8f0fe; color: #1a73e8; }
    .lang-badge.ko { background: #fce8e6; color: #d93025; }
</style>

<div class="d-flex justify-content-center align-items-center py-5" style="min-height:100vh;">
    <div class="bg-white border p-4" style="width:520px;">
        <h2 class="mb-1" style="font-size:20px;">회원정보 입력</h2>
        <p class="text-end text-danger mb-3" style="font-size:12px;">* 표시는 반드시 입력하셔야 합니다.</p>

        <form action="user/registerProc.do" method="post">
            <table style="width:100%; border-collapse:collapse;">
                <tr>
                    <td style="width:120px; padding:8px 5px; font-size:14px; vertical-align:top; padding-top:12px;">
                        <span class="text-danger me-1">*</span>아이디
                        <span class="lang-badge en">EN</span>
                    </td>
                    <td style="padding:8px 5px;">
                        <div class="input-group">
                            <input type="text" id="userId" name="userId" class="form-control"
                                   maxlength="15" autocomplete="off"
                                   placeholder="영문/숫자 5~15자"/>
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
                            <input type="password" id="userPw" name="userPw" class="form-control"
                                   maxlength="25"/>
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
                            <input type="password" id="userPwCheck" class="form-control"
                                   maxlength="25"/>
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePw('userPwCheck', this)">표시</button>
                        </div>
                        <p id="pwCheckMsg" class="guide-msg"></p>
                    </td>
                </tr>
                <tr>
                    <td style="width:120px; padding:8px 5px; font-size:14px; vertical-align:top; padding-top:12px;">
                        <span class="text-danger me-1">*</span>이름
                        <span class="lang-badge ko">한글</span>
                    </td>
                    <td style="padding:8px 5px;">
                        <input type="text" name="userName" id="userName" class="form-control"
                               placeholder="이름을 입력하세요"/>
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
    var idRegex = /^[a-zA-Z0-9]{5,15}$/;
    var pwRegex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\-=\[\]{}|;':",.<>?])[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|;':",.<>?]{10,25}$/;

    /* ---- 아이디: 포커스 시 영문 모드 유도, 한글 즉시 제거 ---- */
    var userIdInput = document.querySelector("#userId");

    userIdInput.addEventListener("focus", function() {
        // 영문 전용 임시 input 에 포커스를 줬다가 다시 원래 input 으로 돌아오면
        // 브라우저/OS 가 영문 상태로 돌아오는 경우가 있음
        var dummy = document.getElementById("_dummyEn");
        dummy.focus();
        dummy.blur();
        this.focus();
    });

    userIdInput.addEventListener("input", function() {
        // 한글·특수문자 즉시 제거 (IME 조합 중인 문자 포함)
        var cleaned = this.value.replace(/[^a-zA-Z0-9]/g, "");
        if (this.value !== cleaned) this.value = cleaned;

        var msg = document.querySelector("#idMsg");
        if (cleaned === "") {
            msg.className = "guide-msg";
            msg.innerText = "한글, 특수문자를 제외한 5~15자 영문, 숫자로 입력해주세요.";
        } else if (idRegex.test(cleaned)) {
            msg.className = "guide-msg ok";
            msg.innerText = "올바른 형식입니다.";
        } else {
            msg.className = "guide-msg fail";
            msg.innerText = "한글, 특수문자를 제외한 5~15자 영문, 숫자로 입력해주세요.";
        }
    });

    // IME 조합 완료 시점에도 한 번 더 제거 (compositionend: 한글 확정 순간)
    userIdInput.addEventListener("compositionend", function() {
        this.value = this.value.replace(/[^a-zA-Z0-9]/g, "");
    });

    /* ---- 이름: 포커스 시 한글 유도 ---- */
    document.querySelector("#userName").addEventListener("focus", function() {
        // 한글 전용 임시 input 에 포커스를 줬다가 돌아오면
        // 브라우저/OS 가 한글 상태로 돌아오는 경우가 있음
        var dummy = document.getElementById("_dummyKo");
        dummy.focus();
        dummy.blur();
        this.focus();
    });

    /* ---- 비밀번호 ---- */
    document.querySelector("#userPw").addEventListener("input", function() {
        var pw  = this.value.trim();
        var msg = document.querySelector("#pwMsg");
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
        var msg    = document.querySelector("#idMsg");
        if (!userId) { alert("아이디를 입력하세요."); return; }
        if (!idRegex.test(userId)) {
            msg.className = "guide-msg fail";
            msg.innerText = "한글, 특수문자를 제외한 5~15자 영문, 숫자로 입력해주세요.";
            return;
        }
        try {
            var res    = await fetch("user/idCheck.do", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "userId=" + encodeURIComponent(userId)
            });
            var result = await res.text();
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

        if (!userId)                              { alert("아이디를 입력하세요.");           return false; }
        if (!idRegex.test(userId))                { alert("아이디 형식이 올바르지 않습니다."); return false; }
        if (idMsg !== "사용 가능한 아이디입니다.") { alert("아이디 중복확인을 해주세요.");     return false; }
        if (!userPw)                              { alert("비밀번호를 입력하세요.");          return false; }
        if (!pwRegex.test(userPw))                { alert("비밀번호 형식이 올바르지 않습니다."); return false; }
        if (userPw !== pwCheck)                   { alert("비밀번호가 일치하지 않습니다.");   return false; }
        if (!userName)                            { alert("이름을 입력해주세요.");            return false; }

        document.querySelector("#userName").value = userName;
        return true;
    }
</script>

<%-- 언어 유도용 더미 input (화면에 보이지 않음) --%>
<%-- _dummyEn: lang="en" → 포커스 시 영문 IME 유도 --%>
<%-- _dummyKo: lang="ko" → 포커스 시 한글 IME 유도 --%>
<input id="_dummyEn" type="text" lang="en"
       style="position:fixed; top:-999px; left:-999px; width:1px; height:1px; opacity:0;"
       tabindex="-1" aria-hidden="true"/>
<input id="_dummyKo" type="text" lang="ko"
       style="position:fixed; top:-999px; left:-999px; width:1px; height:1px; opacity:0;"
       tabindex="-1" aria-hidden="true"/>

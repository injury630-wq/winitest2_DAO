const UserValid = {

    /* ===== 정규식 ===== */
    idRegex: /^[a-zA-Z0-9]{5,15}$/,
    // 영문 + 숫자 + 특수문자 포함, 10~25자
    pwRegex: /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\-=\[\]{}|;':",.<>?]).{10,25}$/,
    nameRegex: /^[가-힣a-zA-Z0-9]+$/,

    /* ===== 초기화 ===== */
    init: function () {

        /* 아이디 */
        $('#userId').on('input', function () {
            let val = $(this).val();

            // 공백 제거 + 영문/숫자만 허용
            val = val.replace(/\s/g, '').replace(/[^a-zA-Z0-9]/g, '');
            $(this).val(val);

            if (val === '') {
                $('#idMsg').text('');
            } else if (UserValid.idRegex.test(val)) {
                $('#idMsg').text('사용 가능한 아이디입니다.').css('color', 'green');
            } else {
                $('#idMsg').text('영문/숫자 5~15자').css('color', 'red');
            }
        });

        /* 비밀번호 */
        $('#userPw').on('input', function () {
            let val = $(this).val();

            // 공백 제거
            val = val.replace(/\s/g, '');
            $(this).val(val);

            if (val === '') {
                $('#pwMsg').text('');
            } else if (UserValid.pwRegex.test(val)) {
                $('#pwMsg').text('사용 가능한 비밀번호입니다.').css('color', 'green');
            } else {
                $('#pwMsg').text('영문+숫자+특수문자 10~25자').css('color', 'red');
            }

            UserValid.checkPwMatch();
        });

        /* 비밀번호 확인 */
        $('#userPw2').on('input', function () {
            let val = $(this).val().replace(/\s/g, '');
            $(this).val(val);

            UserValid.checkPwMatch();
        });

        /* 이름 */
        $('#userName').on('input', function () {
            let val = $(this).val();

            // 공백 제거
            val = val.replace(/\s/g, '');
            $(this).val(val);

            if (val === '') {
                $('#nameMsg').text('');
            } else if (UserValid.nameRegex.test(val)) {
                $('#nameMsg').text('사용 가능합니다.').css('color', 'green');
            } else {
                $('#nameMsg').text('한글/영문/숫자만 입력').css('color', 'red');
            }
        });
    },

    /* ===== 비밀번호 일치 체크 ===== */
    checkPwMatch: function () {
        const pw = $('#userPw').val();
        const pw2 = $('#userPw2').val();

        if (pw2 === '') {
            $('#pwCheckMsg').text('');
        } else if (pw === pw2) {
            $('#pwCheckMsg').text('비밀번호가 일치합니다.').css('color', 'green');
        } else {
            $('#pwCheckMsg').text('비밀번호가 일치하지 않습니다.').css('color', 'red');
        }
    },

    /* ===== 최종 제출 검사 ===== */
     checkAll = function () {
        const id = $('#userId').val();
        const pw = $('#userPw').val();
        const name = $('#userName').val();

        if (!this.idRegex.test(id)) {
            alert('아이디를 확인해주세요.');
            return false;
        }

        if (!this.pwRegex.test(pw)) {
            alert('비밀번호를 확인해주세요.');
            return false;
        }

        if (!this.nameRegex.test(name)) {
            alert('이름을 확인해주세요.');
            return false;
        }

        return true;
    }
};
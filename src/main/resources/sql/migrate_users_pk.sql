-- ============================================================
-- users 테이블 PK 변경 마이그레이션
-- 목적: user_id PK → user_no AUTO_INCREMENT PK
--       user_id는 UNIQUE 제약으로 유지 (로그인/표시용)
--
-- 실행 순서: 1 → 2 → 3 (순서 엄수)
-- ============================================================

-- [1] 기존 users 테이블이 있는 경우: PK를 user_id→user_no로 전환
--     (데이터 보존)

ALTER TABLE users
    DROP PRIMARY KEY,
    ADD COLUMN user_no INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST,
    ADD UNIQUE KEY uk_user_id (user_id);

-- ============================================================
-- [2] 신규 생성의 경우 (테이블 자체가 없을 때 사용)
-- ============================================================
/*
CREATE TABLE users (
    user_no   INT          NOT NULL AUTO_INCREMENT COMMENT '사용자 번호(PK)',
    user_id   VARCHAR(15)  NOT NULL                COMMENT '사용자 아이디(로그인/표시용, 관리자 변경 가능)',
    user_pw   VARCHAR(100) NOT NULL                COMMENT '비밀번호',
    user_name VARCHAR(50)  NOT NULL                COMMENT '이름',
    reg_date  DATETIME     DEFAULT NOW()           COMMENT '가입일시',
    PRIMARY KEY (user_no),
    UNIQUE KEY uk_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자';
*/

-- ============================================================
-- [3] 마이그레이션 결과 확인
-- ============================================================
-- SHOW CREATE TABLE users;
-- SELECT user_no, user_id, user_name, reg_date FROM users;

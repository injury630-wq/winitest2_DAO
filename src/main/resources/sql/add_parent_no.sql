-- board 테이블에 parent_no 컬럼 추가
-- parent_no: 직접적인 부모글의 board_no (원글은 NULL)
ALTER TABLE board
    ADD COLUMN parent_no INT DEFAULT NULL
        COMMENT '부모글 board_no (원글은 NULL)';

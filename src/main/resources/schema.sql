-- ================================================================
-- 전자 제안서 접수 및 심사 포털 — 스키마 DDL
-- DB: book_ex (기존 MariaDB/MySQL)
-- ================================================================

-- 1. tbl_user 컬럼 추가 (Spring Security 역할·활성화 지원)
ALTER TABLE tbl_user
    ADD COLUMN IF NOT EXISTS role    VARCHAR(20)  NOT NULL DEFAULT 'ROLE_USER'  COMMENT '권한: ROLE_USER, ROLE_REVIEWER, ROLE_ADMIN',
    ADD COLUMN IF NOT EXISTS enabled TINYINT(1)   NOT NULL DEFAULT 1             COMMENT '계정 활성화 여부';

-- 기존 사용자 역할 초기화 (최초 1회)
UPDATE tbl_user SET role = 'ROLE_USER' WHERE role IS NULL OR role = '';

-- 2. 제안서 테이블
CREATE TABLE IF NOT EXISTS tbl_proposal (
    pno         INT          NOT NULL AUTO_INCREMENT        COMMENT '제안서 번호',
    title       VARCHAR(200) NOT NULL                       COMMENT '제목',
    content     TEXT         NOT NULL                       COMMENT '내용',
    category    VARCHAR(20)  NOT NULL DEFAULT 'OTHER'       COMMENT '분야: IT, ENV, MGT, OTHER',
    submitter   VARCHAR(100) NOT NULL                       COMMENT '제안자 uid',
    status      VARCHAR(20)  NOT NULL DEFAULT 'SUBMITTED'   COMMENT '상태: SUBMITTED, REVIEWING, COMPLETED, REJECTED',
    total_score DECIMAL(5,2)          DEFAULT NULL          COMMENT '심사 평균 점수',
    deadline    DATE                  DEFAULT NULL          COMMENT '심사 마감일',
    regdate     DATETIME     NOT NULL DEFAULT NOW()         COMMENT '등록일',
    updatedate  DATETIME     NOT NULL DEFAULT NOW()         COMMENT '수정일',
    PRIMARY KEY (pno),
    INDEX idx_proposal_submitter (submitter),
    INDEX idx_proposal_status    (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='제안서';

-- 3. 제안서 첨부파일
CREATE TABLE IF NOT EXISTS tbl_proposal_attach (
    ano           INT          NOT NULL AUTO_INCREMENT  COMMENT '파일 번호',
    pno           INT          NOT NULL                 COMMENT '제안서 번호 (FK)',
    saved_name    VARCHAR(500) NOT NULL                 COMMENT '저장 파일명 (UUID_원본명)',
    original_name VARCHAR(500) NOT NULL                 COMMENT '원본 파일명',
    filesize      BIGINT       NOT NULL DEFAULT 0       COMMENT '파일 크기(bytes)',
    regdate       DATETIME     NOT NULL DEFAULT NOW()   COMMENT '등록일',
    PRIMARY KEY (ano),
    CONSTRAINT fk_attach_proposal FOREIGN KEY (pno) REFERENCES tbl_proposal(pno) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='제안서 첨부파일';

-- 4. 심사 배정
CREATE TABLE IF NOT EXISTS tbl_review_assign (
    assign_no     INT          NOT NULL AUTO_INCREMENT  COMMENT '배정 번호',
    pno           INT          NOT NULL                 COMMENT '제안서 번호 (FK)',
    reviewer_id   VARCHAR(100) NOT NULL                 COMMENT '심사자 uid',
    assigned_date DATETIME     NOT NULL DEFAULT NOW()   COMMENT '배정일',
    PRIMARY KEY (assign_no),
    UNIQUE KEY uk_assign (pno, reviewer_id),
    CONSTRAINT fk_assign_proposal FOREIGN KEY (pno)         REFERENCES tbl_proposal(pno),
    CONSTRAINT fk_assign_reviewer FOREIGN KEY (reviewer_id) REFERENCES tbl_user(uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='심사 배정';

-- 5. 심사 결과
CREATE TABLE IF NOT EXISTS tbl_review (
    rno               INT  NOT NULL AUTO_INCREMENT  COMMENT '심사 번호',
    pno               INT  NOT NULL                 COMMENT '제안서 번호 (FK)',
    reviewer_id       VARCHAR(100) NOT NULL         COMMENT '심사자 uid',
    score_originality INT  NOT NULL DEFAULT 0       COMMENT '독창성    (0-25)',
    score_feasibility INT  NOT NULL DEFAULT 0       COMMENT '실현가능성 (0-25)',
    score_economy     INT  NOT NULL DEFAULT 0       COMMENT '경제성    (0-25)',
    score_impact      INT  NOT NULL DEFAULT 0       COMMENT '파급효과  (0-25)',
    total_score       INT  NOT NULL DEFAULT 0       COMMENT '총점      (0-100)',
    opinion           TEXT                          COMMENT '심사 의견',
    review_date       DATETIME NOT NULL DEFAULT NOW() COMMENT '심사일',
    PRIMARY KEY (rno),
    UNIQUE KEY uk_review (pno, reviewer_id),
    CONSTRAINT fk_review_proposal FOREIGN KEY (pno)         REFERENCES tbl_proposal(pno),
    CONSTRAINT fk_review_reviewer FOREIGN KEY (reviewer_id) REFERENCES tbl_user(uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='심사 결과';

-- 6. 관리자 계정 (비밀번호 변경 시 이 줄만 수정)
-- ★ 관리자 ID / PW 변경 지점 ★
INSERT INTO tbl_user (uid, upw, uname, role, enabled)
VALUES ('whlsls3377', 'a23895524!!', '관리자', 'ROLE_ADMIN', 1)
ON DUPLICATE KEY UPDATE
    upw  = 'a23895524!!',
    role = 'ROLE_ADMIN',
    enabled = 1;

-- 테스트용 일반 사용자 (운영 시 삭제 가능)
INSERT IGNORE INTO tbl_user (uid, upw, uname, role, enabled)
VALUES ('user1', 'user1234', '홍길동', 'ROLE_USER', 1);

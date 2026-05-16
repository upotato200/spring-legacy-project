# 전자 제안서 접수 및 심사 포털

Spring Legacy MVC 기반의 전자 제안서 접수·심사·관리 시스템입니다.

## 개발 환경

| 항목 | 버전 |
|------|------|
| Java | 1.8 |
| Framework | Spring MVC 4.1.7 |
| ORM | MyBatis 3.2.8 |
| Security | Spring Security 4.2.20 |
| DB | MySQL (`book_ex` 스키마) |
| Server | Tomcat 8.5 |
| Build | Maven |
| IDE | IntelliJ IDEA |

## 주요 기능

### 제안서 관리
- 제안서 등록 / 수정 / 삭제
- 파일 첨부 업로드
- 페이징 및 검색 (제목·작성자·상태)
- 상태 표시: 접수 / 심사중 / 완료 / 반려

### 심사 시스템
- 관리자가 제안서별 심사자 배정
- 심사자 심사 의견 및 점수 입력
- 심사 결과 조회

### 관리자
- 대시보드 (최근 제안서 목록, 심사자 현황)
- 제안서 전체 목록 관리
- 심사자 계정 생성 / 편집 (아이디·이름·비밀번호) / 활성화 토글 / 삭제
- 전체 데이터 Excel 다운로드

### 사용자 인증
- Spring Security 기반 로그인 / 로그아웃
- 역할 구분: 일반 사용자 / 심사자 / 관리자
- 로그인 유지 (Remember-me, 7일)
- 회원가입 (아이디 중복 확인)

## 폐쇄망 지원

외부 CDN 의존성을 완전히 제거하여 인터넷 없이도 동작합니다.

- Bootstrap CSS → 로컬 `resources/bootstrap/css/bootstrap.min.css`
- Font Awesome → `portal.css` 내 Unicode 아이콘으로 대체
- jQuery + Bootstrap.js → `portal.js` (바닐라 JS로 직접 구현)

## 프로젝트 구조

```
src/main/
├── java/com/jh/
│   ├── controller/
│   │   ├── admin/          # 관리자 컨트롤러
│   │   ├── proposal/       # 제안서 컨트롤러
│   │   └── review/         # 심사 컨트롤러
│   ├── dao/
│   │   ├── proposal/       # 제안서·심사 DAO
│   │   └── UserDAO         # 사용자 DAO
│   ├── service/
│   │   ├── proposal/       # 제안서·심사 서비스
│   │   └── UserService     # 사용자 서비스
│   ├── security/           # Spring Security 설정
│   └── vo/                 # ProposalVO, ReviewVO, UserVO ...
├── resources/
│   └── mappers/            # MyBatis XML (proposal, review, user)
└── webapp/
    ├── resources/
    │   ├── bootstrap/      # 로컬 Bootstrap 3
    │   ├── css/portal.css  # 커스텀 디자인 + 아이콘
    │   └── js/portal.js    # 바닐라 JS 컴포넌트
    └── WEB-INF/views/
        ├── admin/          # 관리자 화면
        ├── proposal/       # 제안서 화면
        ├── review/         # 심사 화면
        └── user/           # 로그인·회원가입
```

## 계정 역할

| 역할 | 권한 |
|------|------|
| `ROLE_USER` | 제안서 등록·수정·삭제, 내 제안서 조회 |
| `ROLE_REVIEWER` | 배정된 제안서 심사 의견 입력 |
| `ROLE_ADMIN` | 전체 관리 (제안서·심사자·배정·Excel) |

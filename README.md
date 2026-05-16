# 전자 제안서 접수 및 심사 포털

Spring Legacy MVC 기반의 전자 제안서 접수·심사·관리 시스템입니다.

## 개발 환경

| 항목 | 버전 |
|------|------|
| Java | 1.8 |
| Framework | Spring MVC 4.1.7 |
| ORM | MyBatis 3.2.8 |
| Security | Spring Security 4.2.20 |
| DB | MySQL|
| Server | Tomcat 8.5 |
| Build | Maven |
| IDE | IntelliJ IDEA |

## 주요 기능

**제안서 관리** — 등록/수정/삭제, 파일 첨부, 페이징·검색, 상태 표시(접수/심사중/완료/반려)

**심사 시스템** — 심사자 배정, 의견·점수 입력, 결과 조회

**관리자** — 대시보드, 제안서 전체 관리, 심사자 계정 CRUD, Excel 다운로드

**사용자 인증** — Spring Security, 역할 구분(일반/심사자/관리자), Remember-me, 회원가입

**폐쇄망 지원** — CDN 없이 동작 (Bootstrap·jQuery·Font Awesome 전부 로컬)

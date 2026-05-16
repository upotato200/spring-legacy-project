<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인 - 전자 제안서 포털</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/portal.css">
</head>
<body class="auth-page-body">

<div class="auth-box">

  <div class="auth-logo">
    <a href="${pageContext.request.contextPath}/proposal/list">
      <i class="fa fa-file-text-o"></i> 전자 제안서 포털
    </a>
    <small>전자 제안서 접수 및 심사 시스템</small>
  </div>

  <div class="auth-card">

    <c:if test="${param.error != null}">
      <div class="alert alert-danger">
        <i class="fa fa-exclamation-triangle"></i> 아이디 또는 비밀번호가 올바르지 않습니다.
      </div>
    </c:if>
    <c:if test="${param.logout != null}">
      <div class="alert alert-info">
        <i class="fa fa-info-circle"></i> 로그아웃 되었습니다.
      </div>
    </c:if>
    <c:if test="${param.expired != null}">
      <div class="alert alert-warning">
        <i class="fa fa-warning"></i> 다른 기기에서 로그인되어 세션이 만료되었습니다.
      </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/user/loginPost" method="post">
      <div class="form-group">
        <label for="uid"><i class="fa fa-user"></i> 아이디</label>
        <input type="text" id="uid" name="uid" class="form-control"
               placeholder="아이디를 입력하세요" required autofocus>
      </div>
      <div class="form-group">
        <label for="upw"><i class="fa fa-lock"></i> 비밀번호</label>
        <input type="password" id="upw" name="upw" class="form-control"
               placeholder="비밀번호를 입력하세요" required>
      </div>

      <div class="form-group" style="margin-bottom: 20px;">
        <label style="font-weight:400; cursor:pointer;">
          <input type="checkbox" name="remember-me"> 로그인 유지 (7일)
        </label>
      </div>

      <button type="submit" class="btn btn-primary btn-block">
        <i class="fa fa-sign-in"></i> 로그인
      </button>
    </form>

    <div class="auth-divider">
      <hr>
      계정이 없으신가요?
      <a href="${pageContext.request.contextPath}/user/joinPage">
        <i class="fa fa-user-plus"></i> 회원가입
      </a>
    </div>
  </div>

</div>

<script src="${pageContext.request.contextPath}/resources/js/portal.js"></script>
</body>
</html>

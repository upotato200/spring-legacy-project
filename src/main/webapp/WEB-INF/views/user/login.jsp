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
<body>
<div class="login-box">
  <div class="login-logo">
    <a href="${pageContext.request.contextPath}/proposal/list">
      <i class="fa fa-file-text-o"></i> 전자 제안서 포털
    </a>
  </div>

  <div class="login-box-body">
    <p class="login-box-msg" style="text-align:center; color:#666; margin-bottom:20px;">로그인 후 이용하세요</p>

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

    <%-- Spring Security form-login: action=/user/loginPost, name=uid, name=upw --%>
    <form action="${pageContext.request.contextPath}/user/loginPost" method="post">
      <div class="form-group has-feedback">
        <input type="text" name="uid" class="form-control" placeholder="아이디" required autofocus>
        <span class="glyphicon glyphicon-user form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" name="upw" class="form-control" placeholder="비밀번호" required>
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="row">
        <div class="col-xs-8">
          <div class="checkbox">
            <label><input type="checkbox" name="remember-me"> 로그인 유지 (7일)</label>
          </div>
        </div>
        <div class="col-xs-4">
          <button type="submit" class="btn btn-primary btn-block">로그인</button>
        </div>
      </div>
    </form>

    <hr>
    <div style="text-align:center;">
      <a href="${pageContext.request.contextPath}/user/joinPage">
        <i class="fa fa-user-plus"></i> 회원가입
      </a>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/portal.js"></script>
</body>
</html>

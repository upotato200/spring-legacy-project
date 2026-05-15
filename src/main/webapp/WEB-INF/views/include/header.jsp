<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"        uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt"      uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>전자 제안서 접수 및 심사 포털</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
  body { padding-top: 50px; background-color: #f5f5f5; }
  .navbar-brand { font-weight: bold; letter-spacing: 1px; }
  .content-area { margin-top: 20px; }
  .label-SUBMITTED { background-color: #5bc0de; }
  .label-REVIEWING { background-color: #f0ad4e; }
  .label-COMPLETED { background-color: #5cb85c; }
  .label-REJECTED  { background-color: #d9534f; }
  .panel { border-radius: 4px; }
  .flash-msg { margin: 10px 0; }
</style>
</head>
<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#mainNav">
        <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="${pageContext.request.contextPath}/proposal/list">
        <i class="fa fa-file-text-o"></i> 제안서 포털
      </a>
    </div>
    <div class="collapse navbar-collapse" id="mainNav">
      <ul class="nav navbar-nav">
        <li><a href="${pageContext.request.contextPath}/proposal/list"><i class="fa fa-list"></i> 제안서 목록</a></li>

        <security:authorize access="isAuthenticated()">
          <li><a href="${pageContext.request.contextPath}/proposal/myList"><i class="fa fa-user"></i> 내 제안서</a></li>
          <li><a href="${pageContext.request.contextPath}/proposal/register"><i class="fa fa-plus"></i> 등록</a></li>
        </security:authorize>

        <security:authorize access="hasAnyRole('ROLE_REVIEWER','ROLE_ADMIN')">
          <li><a href="${pageContext.request.contextPath}/review/myList"><i class="fa fa-check-square-o"></i> 내 심사</a></li>
        </security:authorize>

        <security:authorize access="hasRole('ROLE_ADMIN')">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-cogs"></i> 관리자 <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
              <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> 대시보드</a></li>
              <li><a href="${pageContext.request.contextPath}/admin/proposal/list"><i class="fa fa-list-alt"></i> 제안서 관리</a></li>
              <li><a href="${pageContext.request.contextPath}/admin/reviewers"><i class="fa fa-users"></i> 심사자 관리</a></li>
              <li role="separator" class="divider"></li>
              <li><a href="${pageContext.request.contextPath}/admin/excel"><i class="fa fa-file-excel-o"></i> Excel 다운로드</a></li>
            </ul>
          </li>
        </security:authorize>
      </ul>

      <ul class="nav navbar-nav navbar-right">
        <security:authorize access="isAnonymous()">
          <li><a href="${pageContext.request.contextPath}/user/login"><i class="fa fa-sign-in"></i> 로그인</a></li>
        </security:authorize>
        <security:authorize access="isAuthenticated()">
          <li>
            <a href="#">
              <i class="fa fa-user-circle"></i>
              <security:authentication property="principal.username"/>
              <security:authorize access="hasRole('ROLE_ADMIN')"> <span class="label label-danger">관리자</span></security:authorize>
              <security:authorize access="hasRole('ROLE_REVIEWER')"> <span class="label label-warning">심사자</span></security:authorize>
            </a>
          </li>
          <li>
            <form action="${pageContext.request.contextPath}/user/logout" method="post" style="margin:0;">
              <button type="submit" class="btn btn-link navbar-btn" style="padding:15px 15px;">
                <i class="fa fa-sign-out"></i> 로그아웃
              </button>
            </form>
          </li>
        </security:authorize>
      </ul>
    </div>
  </div>
</nav>

<div class="container content-area">
  <c:if test="${not empty msg}">
    <div class="alert alert-success alert-dismissible flash-msg" role="alert">
      <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
      <i class="fa fa-check-circle"></i> ${msg}
    </div>
  </c:if>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="row">
  <div class="col-md-6 col-md-offset-3 text-center" style="padding: 60px 0;">
    <div class="panel panel-danger">
      <div class="panel-heading">
        <h2 class="panel-title"><i class="fa fa-ban"></i> 접근 거부 (403)</h2>
      </div>
      <div class="panel-body">
        <p style="font-size:16px; color:#555; margin: 20px 0;">
          해당 페이지에 접근할 권한이 없습니다.
        </p>
        <p class="text-muted">관리자에게 권한 요청이 필요하거나 잘못된 경로입니다.</p>
        <hr>
        <a href="${pageContext.request.contextPath}/proposal/list" class="btn btn-primary">
          <i class="fa fa-home"></i> 메인으로
        </a>
        <a href="javascript:history.back();" class="btn btn-default">
          <i class="fa fa-arrow-left"></i> 이전으로
        </a>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="row">
  <div class="col-md-12">
    <h2><i class="fa fa-dashboard"></i> 관리자 대시보드</h2>
    <hr>
  </div>
</div>

<div class="row">
  <!-- 최근 제안서 -->
  <div class="col-md-8">
    <div class="panel panel-default">
      <div class="panel-heading clearfix">
        <h3 class="panel-title pull-left"><i class="fa fa-list"></i> 최근 접수 제안서</h3>
        <div class="pull-right">
          <a href="${pageContext.request.contextPath}/admin/proposal/list" class="btn btn-default btn-xs">전체보기</a>
          <a href="${pageContext.request.contextPath}/admin/excel" class="btn btn-success btn-xs">
            <i class="fa fa-file-excel-o"></i> Excel
          </a>
        </div>
      </div>
      <div class="panel-body" style="padding:0;">
        <table class="table table-hover" style="margin-bottom:0;">
          <thead><tr class="info"><th>번호</th><th>제목</th><th>제안자</th><th>상태</th><th>등록일</th><th>관리</th></tr></thead>
          <tbody>
            <c:forEach var="p" items="${recentList}">
              <tr>
                <td>${p.pno}</td>
                <td><a href="${pageContext.request.contextPath}/proposal/read/${p.pno}">${p.title}</a></td>
                <td>${p.submitter}</td>
                <td><span class="label label-${p.status}">${p.statusLabel}</span></td>
                <td><fmt:formatDate value="${p.regdate}" pattern="MM-dd HH:mm"/></td>
                <td>
                  <a href="${pageContext.request.contextPath}/admin/assign/${p.pno}"
                     class="btn btn-warning btn-xs">
                    <i class="fa fa-user-plus"></i> 배정
                  </a>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty recentList}">
              <tr><td colspan="6" class="text-center text-muted">접수된 제안서가 없습니다.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- 심사자 목록 -->
  <div class="col-md-4">
    <div class="panel panel-warning">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-users"></i> 심사자 목록</h3>
      </div>
      <ul class="list-group">
        <c:forEach var="r" items="${reviewerList}">
          <li class="list-group-item">
            <i class="fa fa-user-circle-o text-warning"></i>
            ${r.uname}
            <small class="text-muted">(${r.uid})</small>
          </li>
        </c:forEach>
        <c:if test="${empty reviewerList}">
          <li class="list-group-item text-muted">등록된 심사자가 없습니다.</li>
        </c:if>
      </ul>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

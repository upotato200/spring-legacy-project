<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-info">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-bar-chart"></i> 심사 결과 — ${proposal.title}</h3>
  </div>
  <div class="panel-body">

    <div class="row" style="margin-bottom:20px;">
      <div class="col-md-3 text-center">
        <div class="panel panel-default">
          <div class="panel-body">
            <p class="text-muted">분야</p>
            <h4>${proposal.categoryLabel}</h4>
          </div>
        </div>
      </div>
      <div class="col-md-3 text-center">
        <div class="panel panel-default">
          <div class="panel-body">
            <p class="text-muted">제안자</p>
            <h4>${proposal.submitter}</h4>
          </div>
        </div>
      </div>
      <div class="col-md-3 text-center">
        <div class="panel panel-default">
          <div class="panel-body">
            <p class="text-muted">상태</p>
            <h4><span class="label label-${proposal.status}">${proposal.statusLabel}</span></h4>
          </div>
        </div>
      </div>
      <div class="col-md-3 text-center">
        <div class="panel panel-success">
          <div class="panel-body">
            <p class="text-muted">심사 평균 총점</p>
            <h2 class="text-success">
              <c:choose>
                <c:when test="${not empty proposal.totalScore}">
                  <fmt:formatNumber value="${proposal.totalScore}" maxFractionDigits="1"/>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </h2>
          </div>
        </div>
      </div>
    </div>

    <c:choose>
      <c:when test="${not empty reviews}">
        <table class="table table-bordered table-hover">
          <thead class="info">
            <tr>
              <th>심사자</th>
              <th style="width:80px;">독창성</th>
              <th style="width:90px;">실현가능성</th>
              <th style="width:80px;">경제성</th>
              <th style="width:80px;">파급효과</th>
              <th style="width:70px;">총점</th>
              <th>심사 의견</th>
              <th style="width:100px;">심사일</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="r" items="${reviews}">
              <tr>
                <td>${r.reviewerId}</td>
                <td class="text-center">${r.scoreOriginality}</td>
                <td class="text-center">${r.scoreFeasibility}</td>
                <td class="text-center">${r.scoreEconomy}</td>
                <td class="text-center">${r.scoreImpact}</td>
                <td class="text-center"><strong>${r.totalScore}</strong></td>
                <td style="white-space:pre-wrap;">${r.opinion}</td>
                <td><fmt:formatDate value="${r.reviewDate}" pattern="MM-dd HH:mm"/></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:when>
      <c:otherwise>
        <div class="alert alert-warning">
          <i class="fa fa-info-circle"></i> 아직 제출된 심사 결과가 없습니다.
        </div>
      </c:otherwise>
    </c:choose>

    <hr>
    <a href="${pageContext.request.contextPath}/proposal/list" class="btn btn-default">
      <i class="fa fa-list"></i> 목록으로
    </a>
    <a href="${pageContext.request.contextPath}/proposal/read/${proposal.pno}" class="btn btn-default">
      <i class="fa fa-file-text-o"></i> 제안서 보기
    </a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

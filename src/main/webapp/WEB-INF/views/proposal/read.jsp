<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"        uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt"      uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="pull-right">
      <span class="label label-${proposal.status} label-lg">${proposal.statusLabel}</span>
    </div>
    <h3 class="panel-title"><i class="fa fa-file-text-o"></i> 제안서 상세</h3>
  </div>
  <div class="panel-body">

    <table class="table table-bordered">
      <tr>
        <th style="width:120px;background:#f9f9f9;">제목</th>
        <td colspan="3"><strong>${proposal.title}</strong></td>
      </tr>
      <tr>
        <th style="background:#f9f9f9;">분야</th>
        <td>${proposal.categoryLabel}</td>
        <th style="background:#f9f9f9;">제안자</th>
        <td>${proposal.submitter}</td>
      </tr>
      <tr>
        <th style="background:#f9f9f9;">마감일</th>
        <td>
          <c:choose>
            <c:when test="${not empty proposal.deadline}">
              <fmt:formatDate value="${proposal.deadline}" pattern="yyyy-MM-dd"/>
            </c:when>
            <c:otherwise><span class="text-muted">미지정</span></c:otherwise>
          </c:choose>
        </td>
        <th style="background:#f9f9f9;">등록일</th>
        <td><fmt:formatDate value="${proposal.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
      </tr>
      <c:if test="${proposal.status == 'COMPLETED' and not empty proposal.totalScore}">
        <tr>
          <th style="background:#f9f9f9;">심사 평균 점수</th>
          <td colspan="3">
            <strong class="text-success" style="font-size:18px;">
              <fmt:formatNumber value="${proposal.totalScore}" maxFractionDigits="1"/>점
            </strong>
            <span class="text-muted">/ 100점</span>
          </td>
        </tr>
      </c:if>
      <tr>
        <th style="background:#f9f9f9; vertical-align:top;">내용</th>
        <td colspan="3" style="white-space:pre-wrap; line-height:1.7;">${proposal.content}</td>
      </tr>
    </table>

    <!-- 첨부파일 -->
    <c:if test="${not empty proposal.attachList}">
      <div class="panel panel-default" style="margin-top:10px;">
        <div class="panel-heading"><i class="fa fa-paperclip"></i> 첨부파일</div>
        <ul class="list-group">
          <c:forEach var="attach" items="${proposal.attachList}">
            <li class="list-group-item">
              <i class="fa fa-file-o"></i>
              <a href="${pageContext.request.contextPath}/resources/uploads/${attach.savedName}"
                 download="${attach.originalName}">
                ${attach.originalName}
              </a>
              <span class="text-muted pull-right">${attach.filesizeKb}</span>
            </li>
          </c:forEach>
        </ul>
      </div>
    </c:if>

    <!-- 심사 결과 요약 (완료 상태) -->
    <c:if test="${not empty reviews}">
      <div class="panel panel-info" style="margin-top:20px;">
        <div class="panel-heading"><i class="fa fa-star"></i> 심사 결과</div>
        <div class="panel-body">
          <table class="table table-sm table-bordered">
            <thead>
              <tr class="info">
                <th>심사자</th><th>독창성</th><th>실현가능성</th><th>경제성</th><th>파급효과</th><th>총점</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="r" items="${reviews}">
                <tr>
                  <td>${r.reviewerId}</td>
                  <td>${r.scoreOriginality}</td>
                  <td>${r.scoreFeasibility}</td>
                  <td>${r.scoreEconomy}</td>
                  <td>${r.scoreImpact}</td>
                  <td><strong>${r.totalScore}</strong></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
          <a href="${pageContext.request.contextPath}/review/result/${proposal.pno}" class="btn btn-info btn-sm">
            <i class="fa fa-bar-chart"></i> 심사 결과 상세
          </a>
        </div>
      </div>
    </c:if>

    <hr>
    <div>
      <a href="${pageContext.request.contextPath}/proposal/list" class="btn btn-default">
        <i class="fa fa-list"></i> 목록
      </a>
      <c:if test="${isOwner and (proposal.status == 'SUBMITTED')}">
        <a href="${pageContext.request.contextPath}/proposal/modify/${proposal.pno}" class="btn btn-warning">
          <i class="fa fa-edit"></i> 수정
        </a>
        <form action="${pageContext.request.contextPath}/proposal/remove/${proposal.pno}"
              method="post" style="display:inline;"
              onsubmit="return confirm('삭제하시겠습니까?');">
          <button type="submit" class="btn btn-danger">
            <i class="fa fa-trash"></i> 삭제
          </button>
        </form>
      </c:if>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

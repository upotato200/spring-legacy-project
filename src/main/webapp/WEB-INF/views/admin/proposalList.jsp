<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-default">
  <div class="panel-heading clearfix">
    <h3 class="panel-title pull-left"><i class="fa fa-list-alt"></i> 제안서 전체 관리</h3>
    <div class="pull-right">
      <a href="${pageContext.request.contextPath}/admin/excel" class="btn btn-success btn-sm">
        <i class="fa fa-file-excel-o"></i> Excel 다운로드
      </a>
    </div>
  </div>
  <div class="panel-body">

    <!-- 검색 -->
    <form method="get" class="form-inline" style="margin-bottom:15px;">
      <select name="status" class="form-control input-sm">
        <option value="" ${empty cri.status ? 'selected' : ''}>전체 상태</option>
        <option value="SUBMITTED"  ${cri.status == 'SUBMITTED'  ? 'selected' : ''}>접수</option>
        <option value="REVIEWING"  ${cri.status == 'REVIEWING'  ? 'selected' : ''}>심사중</option>
        <option value="COMPLETED"  ${cri.status == 'COMPLETED'  ? 'selected' : ''}>완료</option>
        <option value="REJECTED"   ${cri.status == 'REJECTED'   ? 'selected' : ''}>반려</option>
      </select>
      <select name="searchType" class="form-control input-sm">
        <option value="TS">제목+제안자</option>
        <option value="T">제목</option>
        <option value="S">제안자</option>
      </select>
      <input type="text" name="keyword" value="${cri.keyword}" class="form-control input-sm" placeholder="검색어">
      <button type="submit" class="btn btn-default btn-sm"><i class="fa fa-search"></i></button>
    </form>

    <table class="table table-hover table-bordered">
      <thead class="info">
        <tr>
          <th>번호</th><th>제목</th><th>분야</th><th>제안자</th>
          <th>상태</th><th>총점</th><th>마감일</th><th>등록일</th><th>관리</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="p" items="${list}">
          <tr>
            <td>${p.pno}</td>
            <td><a href="${pageContext.request.contextPath}/proposal/read/${p.pno}">${p.title}</a></td>
            <td>${p.categoryLabel}</td>
            <td>${p.submitter}</td>
            <td><span class="label label-${p.status}">${p.statusLabel}</span></td>
            <td>
              <c:choose>
                <c:when test="${not empty p.totalScore}">
                  <fmt:formatNumber value="${p.totalScore}" maxFractionDigits="1"/>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:if test="${not empty p.deadline}">
                <fmt:formatDate value="${p.deadline}" pattern="MM-dd"/>
              </c:if>
            </td>
            <td><fmt:formatDate value="${p.regdate}" pattern="MM-dd"/></td>
            <td>
              <a href="${pageContext.request.contextPath}/admin/assign/${p.pno}"
                 class="btn btn-warning btn-xs"><i class="fa fa-user-plus"></i> 배정</a>
              <a href="${pageContext.request.contextPath}/review/result/${p.pno}"
                 class="btn btn-info btn-xs"><i class="fa fa-bar-chart"></i></a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty list}">
          <tr><td colspan="9" class="text-center text-muted">제안서가 없습니다.</td></tr>
        </c:if>
      </tbody>
    </table>

    <div class="text-center">
      <ul class="pagination pagination-sm">
        <c:if test="${pageMaker.prev}">
          <li><a href="?${cri.makeQuery(pageMaker.startPage-1)}">&laquo;</a></li>
        </c:if>
        <c:forEach var="i" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
          <li class="${pageMaker.cri.page == i ? 'active' : ''}">
            <a href="?${cri.makeQuery(i)}">${i}</a>
          </li>
        </c:forEach>
        <c:if test="${pageMaker.next}">
          <li><a href="?${cri.makeQuery(pageMaker.endPage+1)}">&raquo;</a></li>
        </c:if>
      </ul>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

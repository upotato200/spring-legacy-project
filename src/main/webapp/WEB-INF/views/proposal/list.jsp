<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-list"></i> 제안서 목록</h3>
  </div>
  <div class="panel-body">

    <!-- 검색 폼 -->
    <form method="get" action="${pageContext.request.contextPath}/proposal/list" class="form-inline" style="margin-bottom:15px;">
      <div class="form-group">
        <select name="category" class="form-control input-sm">
          <option value="" ${empty cri.category ? 'selected' : ''}>전체 분야</option>
          <option value="IT"    ${cri.category == 'IT'    ? 'selected' : ''}>IT/기술</option>
          <option value="ENV"   ${cri.category == 'ENV'   ? 'selected' : ''}>환경</option>
          <option value="MGT"   ${cri.category == 'MGT'   ? 'selected' : ''}>경영/관리</option>
          <option value="OTHER" ${cri.category == 'OTHER' ? 'selected' : ''}>기타</option>
        </select>
      </div>
      <div class="form-group">
        <select name="status" class="form-control input-sm">
          <option value="" ${empty cri.status ? 'selected' : ''}>전체 상태</option>
          <option value="SUBMITTED"  ${cri.status == 'SUBMITTED'  ? 'selected' : ''}>접수</option>
          <option value="REVIEWING"  ${cri.status == 'REVIEWING'  ? 'selected' : ''}>심사중</option>
          <option value="COMPLETED"  ${cri.status == 'COMPLETED'  ? 'selected' : ''}>완료</option>
          <option value="REJECTED"   ${cri.status == 'REJECTED'   ? 'selected' : ''}>반려</option>
        </select>
      </div>
      <div class="form-group">
        <select name="searchType" class="form-control input-sm">
          <option value="TS" ${cri.searchType == 'TS' ? 'selected' : ''}>제목+제안자</option>
          <option value="T"  ${cri.searchType == 'T'  ? 'selected' : ''}>제목</option>
          <option value="S"  ${cri.searchType == 'S'  ? 'selected' : ''}>제안자</option>
        </select>
      </div>
      <div class="form-group">
        <input type="text" name="keyword" value="${cri.keyword}" class="form-control input-sm" placeholder="검색어">
      </div>
      <button type="submit" class="btn btn-default btn-sm"><i class="fa fa-search"></i> 검색</button>
      <a href="${pageContext.request.contextPath}/proposal/list" class="btn btn-default btn-sm">초기화</a>
    </form>

    <table class="table table-hover table-bordered">
      <thead class="info">
        <tr>
          <th style="width:60px;">번호</th>
          <th>제목</th>
          <th style="width:80px;">분야</th>
          <th style="width:100px;">제안자</th>
          <th style="width:80px;">상태</th>
          <th style="width:70px;">총점</th>
          <th style="width:110px;">등록일</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="p" items="${list}">
          <tr>
            <td>${p.pno}</td>
            <td>
              <a href="${pageContext.request.contextPath}/proposal/read/${p.pno}">${p.title}</a>
            </td>
            <td><span class="label label-default">${p.categoryLabel}</span></td>
            <td>${p.submitter}</td>
            <td>
              <span class="label label-${p.status}">${p.statusLabel}</span>
            </td>
            <td>
              <c:choose>
                <c:when test="${not empty p.totalScore}">
                  <strong><fmt:formatNumber value="${p.totalScore}" maxFractionDigits="1"/></strong>
                </c:when>
                <c:otherwise><span class="text-muted">-</span></c:otherwise>
              </c:choose>
            </td>
            <td><fmt:formatDate value="${p.regdate}" pattern="yyyy-MM-dd"/></td>
          </tr>
        </c:forEach>
        <c:if test="${empty list}">
          <tr><td colspan="7" class="text-center text-muted">등록된 제안서가 없습니다.</td></tr>
        </c:if>
      </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div class="text-center">
      <ul class="pagination pagination-sm">
        <c:if test="${pageMaker.prev}">
          <li><a href="${pageContext.request.contextPath}/proposal/list?${cri.makeQuery(pageMaker.startPage-1)}">&laquo;</a></li>
        </c:if>
        <c:forEach var="i" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
          <li class="${pageMaker.cri.page == i ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/proposal/list?${cri.makeQuery(i)}">${i}</a>
          </li>
        </c:forEach>
        <c:if test="${pageMaker.next}">
          <li><a href="${pageContext.request.contextPath}/proposal/list?${cri.makeQuery(pageMaker.endPage+1)}">&raquo;</a></li>
        </c:if>
      </ul>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

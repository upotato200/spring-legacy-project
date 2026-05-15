<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-default">
  <div class="panel-heading clearfix">
    <h3 class="panel-title pull-left"><i class="fa fa-user"></i> 내 제안서</h3>
    <div class="pull-right">
      <a href="${pageContext.request.contextPath}/proposal/register" class="btn btn-primary btn-sm">
        <i class="fa fa-plus"></i> 새 제안서
      </a>
    </div>
  </div>
  <div class="panel-body">
    <table class="table table-hover table-bordered">
      <thead class="info">
        <tr>
          <th style="width:60px;">번호</th>
          <th>제목</th>
          <th style="width:80px;">분야</th>
          <th style="width:80px;">상태</th>
          <th style="width:70px;">총점</th>
          <th style="width:110px;">등록일</th>
          <th style="width:100px;">관리</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="p" items="${list}">
          <tr>
            <td>${p.pno}</td>
            <td><a href="${pageContext.request.contextPath}/proposal/read/${p.pno}">${p.title}</a></td>
            <td><span class="label label-default">${p.categoryLabel}</span></td>
            <td><span class="label label-${p.status}">${p.statusLabel}</span></td>
            <td>
              <c:choose>
                <c:when test="${not empty p.totalScore}">
                  <fmt:formatNumber value="${p.totalScore}" maxFractionDigits="1"/>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td><fmt:formatDate value="${p.regdate}" pattern="yyyy-MM-dd"/></td>
            <td>
              <c:if test="${p.status == 'SUBMITTED'}">
                <a href="${pageContext.request.contextPath}/proposal/modify/${p.pno}"
                   class="btn btn-warning btn-xs"><i class="fa fa-edit"></i></a>
                <form action="${pageContext.request.contextPath}/proposal/remove/${p.pno}"
                      method="post" style="display:inline;"
                      onsubmit="return confirm('삭제하시겠습니까?');">
                  <button type="submit" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i></button>
                </form>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty list}">
          <tr><td colspan="7" class="text-center text-muted">등록된 제안서가 없습니다.</td></tr>
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

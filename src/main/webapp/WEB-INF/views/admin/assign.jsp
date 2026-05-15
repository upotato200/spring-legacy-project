<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-warning">
  <div class="panel-heading">
    <h3 class="panel-title">
      <i class="fa fa-user-plus"></i> 심사자 배정
      — <em>${proposal.title}</em>
    </h3>
  </div>
  <div class="panel-body">

    <div class="well well-sm">
      <strong>분야:</strong> ${proposal.categoryLabel} &nbsp;|&nbsp;
      <strong>제안자:</strong> ${proposal.submitter} &nbsp;|&nbsp;
      <strong>상태:</strong> <span class="label label-${proposal.status}">${proposal.statusLabel}</span>
    </div>

    <div class="row">
      <!-- 배정 폼 -->
      <div class="col-md-6">
        <div class="panel panel-default">
          <div class="panel-heading"><h4 class="panel-title">심사자 추가</h4></div>
          <div class="panel-body">
            <form action="${pageContext.request.contextPath}/admin/assign/${proposal.pno}" method="post">
              <div class="input-group">
                <select name="reviewerId" class="form-control" required>
                  <option value="">-- 심사자 선택 --</option>
                  <c:forEach var="r" items="${reviewerList}">
                    <option value="${r.uid}">${r.uname} (${r.uid})</option>
                  </c:forEach>
                </select>
                <span class="input-group-btn">
                  <button type="submit" class="btn btn-warning">
                    <i class="fa fa-plus"></i> 배정
                  </button>
                </span>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- 배정된 심사자 목록 -->
      <div class="col-md-6">
        <div class="panel panel-default">
          <div class="panel-heading"><h4 class="panel-title">배정된 심사자</h4></div>
          <ul class="list-group" style="margin-bottom:0;">
            <c:forEach var="a" items="${assignList}">
              <li class="list-group-item">
                <i class="fa fa-user text-warning"></i> ${a.reviewerId}
                <small class="text-muted">
                  (<fmt:formatDate value="${a.assignedDate}" pattern="MM-dd HH:mm"/>)
                </small>
                <form action="${pageContext.request.contextPath}/admin/assign/${proposal.pno}/remove"
                      method="post" style="display:inline;" class="pull-right"
                      onsubmit="return confirm('배정을 취소하시겠습니까?');">
                  <input type="hidden" name="reviewerId" value="${a.reviewerId}">
                  <button type="submit" class="btn btn-danger btn-xs">
                    <i class="fa fa-times"></i>
                  </button>
                </form>
              </li>
            </c:forEach>
            <c:if test="${empty assignList}">
              <li class="list-group-item text-muted">배정된 심사자가 없습니다.</li>
            </c:if>
          </ul>
        </div>
      </div>
    </div>

    <hr>
    <a href="${pageContext.request.contextPath}/admin/proposal/list" class="btn btn-default">
      <i class="fa fa-arrow-left"></i> 목록으로
    </a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"        uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt"      uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="row">

  <!-- 배정된 제안서 -->
  <div class="col-md-6">
    <div class="panel panel-warning">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-inbox"></i> 배정된 제안서</h3>
      </div>
      <div class="panel-body">
        <c:choose>
          <c:when test="${not empty assignedList}">
            <ul class="list-group">
              <c:forEach var="pno" items="${assignedList}">
                <li class="list-group-item">
                  <a href="${pageContext.request.contextPath}/review/form/${pno}">
                    <i class="fa fa-file-text-o"></i> 제안서 #${pno}
                  </a>
                  <span class="pull-right">
                    <a href="${pageContext.request.contextPath}/review/form/${pno}"
                       class="btn btn-primary btn-xs">
                      <i class="fa fa-star"></i> 심사하기
                    </a>
                  </span>
                </li>
              </c:forEach>
            </ul>
          </c:when>
          <c:otherwise>
            <p class="text-muted text-center">배정된 제안서가 없습니다.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- 제출한 심사 목록 -->
  <div class="col-md-6">
    <div class="panel panel-success">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-check-circle"></i> 제출한 심사</h3>
      </div>
      <div class="panel-body">
        <c:choose>
          <c:when test="${not empty reviewList}">
            <table class="table table-sm table-bordered">
              <thead><tr class="success"><th>제안서</th><th>총점</th><th>심사일</th></tr></thead>
              <tbody>
                <c:forEach var="r" items="${reviewList}">
                  <tr>
                    <td>
                      <a href="${pageContext.request.contextPath}/review/result/${r.pno}">
                        ${not empty r.proposalTitle ? r.proposalTitle : '#'.concat(r.pno)}
                      </a>
                    </td>
                    <td><strong>${r.totalScore}</strong></td>
                    <td><fmt:formatDate value="${r.reviewDate}" pattern="MM-dd"/></td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:when>
          <c:otherwise>
            <p class="text-muted text-center">제출한 심사가 없습니다.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-primary">
  <div class="panel-heading">
    <h3 class="panel-title">
      <i class="fa fa-star"></i>
      ${empty review ? '심사 입력' : '심사 수정'}
      — <em>${proposal.title}</em>
    </h3>
  </div>
  <div class="panel-body">

    <!-- 제안서 요약 -->
    <div class="well well-sm">
      <strong>분야:</strong> ${proposal.categoryLabel} &nbsp;|&nbsp;
      <strong>제안자:</strong> ${proposal.submitter} &nbsp;|&nbsp;
      <strong>마감일:</strong>
      <c:choose>
        <c:when test="${not empty proposal.deadline}">
          <fmt:formatDate value="${proposal.deadline}" pattern="yyyy-MM-dd"/>
        </c:when>
        <c:otherwise>미지정</c:otherwise>
      </c:choose>
    </div>

    <form action="${pageContext.request.contextPath}/review/submit" method="post">
      <input type="hidden" name="pno" value="${proposal.pno}">

      <p class="text-muted"><small>각 항목은 0~25점 범위에서 입력하세요. 총점은 최대 100점입니다.</small></p>

      <div class="row">
        <div class="col-sm-3">
          <div class="form-group">
            <label>독창성 <span class="text-danger">*</span> <small class="text-muted">(0-25)</small></label>
            <input type="number" name="scoreOriginality" class="form-control score-input"
                   min="0" max="25" value="${empty review ? 0 : review.scoreOriginality}" required>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="form-group">
            <label>실현가능성 <span class="text-danger">*</span> <small class="text-muted">(0-25)</small></label>
            <input type="number" name="scoreFeasibility" class="form-control score-input"
                   min="0" max="25" value="${empty review ? 0 : review.scoreFeasibility}" required>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="form-group">
            <label>경제성 <span class="text-danger">*</span> <small class="text-muted">(0-25)</small></label>
            <input type="number" name="scoreEconomy" class="form-control score-input"
                   min="0" max="25" value="${empty review ? 0 : review.scoreEconomy}" required>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="form-group">
            <label>파급효과 <span class="text-danger">*</span> <small class="text-muted">(0-25)</small></label>
            <input type="number" name="scoreImpact" class="form-control score-input"
                   min="0" max="25" value="${empty review ? 0 : review.scoreImpact}" required>
          </div>
        </div>
      </div>

      <div class="alert alert-info" style="margin-top:5px;">
        <strong>총점: <span id="totalScore">0</span>점</strong> / 100점
      </div>

      <div class="form-group">
        <label>심사 의견</label>
        <textarea name="opinion" class="form-control" rows="6"
                  placeholder="심사 의견을 상세히 작성해 주세요.">${empty review ? '' : review.opinion}</textarea>
      </div>

      <hr>
      <button type="submit" class="btn btn-primary">
        <i class="fa fa-check"></i> 심사 제출
      </button>
      <a href="${pageContext.request.contextPath}/review/myList" class="btn btn-default">취소</a>
    </form>

  </div>
</div>

<script>
(function() {
  var inputs = document.querySelectorAll('.score-input');
  var totalEl = document.getElementById('totalScore');

  function calcTotal() {
    var sum = 0;
    inputs.forEach(function(el) { sum += parseInt(el.value) || 0; });
    totalEl.textContent = sum;
    totalEl.parentElement.parentElement.className =
      sum >= 80 ? 'alert alert-success' : sum >= 50 ? 'alert alert-info' : 'alert alert-warning';
  }

  inputs.forEach(function(el) { el.addEventListener('input', calcTotal); });
  calcTotal();
})();
</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

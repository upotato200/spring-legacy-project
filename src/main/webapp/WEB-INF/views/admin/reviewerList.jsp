<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<div class="row">
  <div class="col-md-12">
    <h2><i class="fa fa-users"></i> 심사자 계정 관리</h2>
    <hr>
  </div>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
    <i class="fa fa-exclamation-circle"></i> ${error}
  </div>
</c:if>

<!-- 심사자 등록 폼 -->
<div class="row">
  <div class="col-md-5">
    <div class="panel panel-primary">
      <div class="panel-heading"><i class="fa fa-user-plus"></i> 심사자 계정 생성</div>
      <div class="panel-body">
        <form action="${pageContext.request.contextPath}/admin/reviewers/create" method="post">
          <div class="form-group">
            <label>아이디</label>
            <input type="text" name="uid" class="form-control" placeholder="로그인 ID" required maxlength="50">
          </div>
          <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="upw" class="form-control" placeholder="초기 비밀번호" required maxlength="100">
          </div>
          <div class="form-group">
            <label>이름</label>
            <input type="text" name="uname" class="form-control" placeholder="표시 이름" required maxlength="100">
          </div>
          <button type="submit" class="btn btn-primary btn-block">
            <i class="fa fa-plus"></i> 계정 생성
          </button>
        </form>
      </div>
    </div>
  </div>

  <!-- 심사자 목록 -->
  <div class="col-md-7">
    <div class="panel panel-default">
      <div class="panel-heading">
        <i class="fa fa-list"></i> 심사자 목록
        <span class="badge">${reviewerList.size()}</span>
      </div>
      <div class="panel-body" style="padding:0;">
        <table class="table table-bordered table-hover" style="margin-bottom:0;">
          <thead>
            <tr class="active">
              <th>아이디</th>
              <th>이름</th>
              <th>상태</th>
              <th style="width:220px;">관리</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty reviewerList}">
                <tr><td colspan="4" class="text-center text-muted">등록된 심사자가 없습니다.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="r" items="${reviewerList}">
                  <tr>
                    <td><strong>${r.uid}</strong></td>
                    <td>${r.uname}</td>
                    <td>
                      <c:choose>
                        <c:when test="${r.enabled == 1}">
                          <span class="label label-success">활성</span>
                        </c:when>
                        <c:otherwise>
                          <span class="label label-default">비활성</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <!-- 비밀번호 변경 버튼 -->
                      <button type="button" class="btn btn-xs btn-info"
                              data-toggle="modal" data-target="#pwModal"
                              data-uid="${r.uid}">
                        <i class="fa fa-key"></i> PW
                      </button>

                      <!-- 활성/비활성 토글 -->
                      <c:choose>
                        <c:when test="${r.enabled == 1}">
                          <form action="${pageContext.request.contextPath}/admin/reviewers/${r.uid}/toggle"
                                method="post" style="display:inline;">
                            <input type="hidden" name="enabled" value="0">
                            <button type="submit" class="btn btn-xs btn-warning"
                                    onclick="return confirm('${r.uid} 계정을 비활성화하시겠습니까?')">
                              <i class="fa fa-ban"></i> 비활성
                            </button>
                          </form>
                        </c:when>
                        <c:otherwise>
                          <form action="${pageContext.request.contextPath}/admin/reviewers/${r.uid}/toggle"
                                method="post" style="display:inline;">
                            <input type="hidden" name="enabled" value="1">
                            <button type="submit" class="btn btn-xs btn-success"
                                    onclick="return confirm('${r.uid} 계정을 활성화하시겠습니까?')">
                              <i class="fa fa-check"></i> 활성화
                            </button>
                          </form>
                        </c:otherwise>
                      </c:choose>

                      <!-- 삭제 -->
                      <form action="${pageContext.request.contextPath}/admin/reviewers/${r.uid}/delete"
                            method="post" style="display:inline;">
                        <button type="submit" class="btn btn-xs btn-danger"
                                onclick="return confirm('${r.uid} 계정을 삭제하시겠습니까?\n배정된 심사도 함께 삭제될 수 있습니다.')">
                          <i class="fa fa-trash"></i> 삭제
                        </button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- 비밀번호 변경 모달 -->
<div class="modal fade" id="pwModal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <form id="pwForm" action="" method="post">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
          <h4 class="modal-title"><i class="fa fa-key"></i> 비밀번호 변경</h4>
        </div>
        <div class="modal-body">
          <p id="pwModalUid" class="text-muted"></p>
          <div class="form-group">
            <label>새 비밀번호</label>
            <input type="password" name="newPw" class="form-control" placeholder="새 비밀번호 입력" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> 변경</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<script>
$('#pwModal').on('show.bs.modal', function(e) {
  var uid = $(e.relatedTarget).data('uid');
  $('#pwModalUid').text('대상: ' + uid);
  $('#pwForm').attr('action',
    '${pageContext.request.contextPath}/admin/reviewers/' + uid + '/password');
});
</script>

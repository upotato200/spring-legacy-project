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
              <th style="width:200px;">관리</th>
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
                      <!-- 정보 편집 버튼 -->
                      <button type="button" class="btn btn-xs btn-primary"
                              data-toggle="modal" data-target="#editModal"
                              data-uid="${r.uid}" data-uname="${r.uname}">
                        <i class="fa fa-pencil"></i> 편집
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

<!-- 심사자 정보 편집 모달 (아이디·이름·비밀번호) -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form id="editForm" action="" method="post">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
          <h4 class="modal-title"><i class="fa fa-pencil"></i> 심사자 정보 편집</h4>
        </div>
        <div class="modal-body">
          <div class="alert alert-warning" style="font-size:13px; padding:8px 12px;">
            <i class="fa fa-exclamation-triangle"></i>
            아이디를 변경하면 해당 심사자의 배정 및 심사 기록도 함께 변경됩니다.
          </div>

          <div class="form-group">
            <label>아이디 <span class="text-danger">*</span></label>
            <input type="text" id="editNewUid" name="newUid" class="form-control"
                   placeholder="변경할 아이디" required maxlength="50">
            <span class="help-block text-muted" style="font-size:12px;">
              현재 아이디와 다르게 입력하면 변경됩니다.
            </span>
          </div>

          <div class="form-group">
            <label>이름 <span class="text-danger">*</span></label>
            <input type="text" id="editUname" name="uname" class="form-control"
                   placeholder="이름" required maxlength="100">
          </div>

          <div class="form-group">
            <label>새 비밀번호</label>
            <input type="password" name="newPw" class="form-control"
                   placeholder="변경할 경우만 입력 (빈칸이면 유지)">
            <span class="help-block text-muted" style="font-size:12px;">
              입력하지 않으면 기존 비밀번호가 유지됩니다.
            </span>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-primary">
            <i class="fa fa-save"></i> 저장
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<script>
portal.onModalShow('#editModal', function (e) {
  var btn   = e.detail.relatedTarget;
  var uid   = btn ? btn.getAttribute('data-uid')   : '';
  var uname = btn ? btn.getAttribute('data-uname') : '';

  document.getElementById('editNewUid').value = uid;
  document.getElementById('editUname').value  = uname;
  document.getElementById('editForm').action  =
    '${pageContext.request.contextPath}/admin/reviewers/' + uid + '/update';

  // 비밀번호 필드 초기화
  var pwField = document.querySelector('#editModal input[name="newPw"]');
  if (pwField) pwField.value = '';
});
</script>

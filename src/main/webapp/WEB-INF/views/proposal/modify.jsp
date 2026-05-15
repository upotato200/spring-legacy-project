<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-warning">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-edit"></i> 제안서 수정</h3>
  </div>
  <div class="panel-body">
    <form action="${pageContext.request.contextPath}/proposal/modify/${proposal.pno}"
          method="post" enctype="multipart/form-data">

      <div class="form-group">
        <label>제목 <span class="text-danger">*</span></label>
        <input type="text" name="title" class="form-control" value="${proposal.title}" required maxlength="200">
      </div>

      <div class="form-group">
        <label>분야 <span class="text-danger">*</span></label>
        <select name="category" class="form-control" required>
          <option value="IT"    ${proposal.category == 'IT'    ? 'selected' : ''}>IT/기술</option>
          <option value="ENV"   ${proposal.category == 'ENV'   ? 'selected' : ''}>환경</option>
          <option value="MGT"   ${proposal.category == 'MGT'   ? 'selected' : ''}>경영/관리</option>
          <option value="OTHER" ${proposal.category == 'OTHER' ? 'selected' : ''}>기타</option>
        </select>
      </div>

      <div class="form-group">
        <label>마감일</label>
        <input type="date" name="deadline" class="form-control" style="max-width:200px;"
               value="<fmt:formatDate value='${proposal.deadline}' pattern='yyyy-MM-dd'/>">
      </div>

      <div class="form-group">
        <label>내용 <span class="text-danger">*</span></label>
        <textarea name="content" class="form-control" rows="10" required>${proposal.content}</textarea>
      </div>

      <!-- 기존 첨부파일 -->
      <c:if test="${not empty proposal.attachList}">
        <div class="form-group">
          <label>기존 첨부파일</label>
          <ul class="list-group">
            <c:forEach var="attach" items="${proposal.attachList}">
              <li class="list-group-item">
                <i class="fa fa-file-o"></i> ${attach.originalName}
                <span class="text-muted">(${attach.filesizeKb})</span>
                <form action="${pageContext.request.contextPath}/proposal/attach/remove/${attach.ano}"
                      method="post" style="display:inline;"
                      onsubmit="return confirm('첨부파일을 삭제하시겠습니까?');">
                  <input type="hidden" name="pno" value="${proposal.pno}">
                  <button type="submit" class="btn btn-danger btn-xs pull-right">
                    <i class="fa fa-times"></i> 삭제
                  </button>
                </form>
              </li>
            </c:forEach>
          </ul>
        </div>
      </c:if>

      <div class="form-group">
        <label>파일 추가</label>
        <div id="fileArea">
          <input type="file" name="files" class="form-control">
        </div>
        <button type="button" class="btn btn-default btn-xs" id="addFileBtn">
          <i class="fa fa-plus"></i> 파일 추가
        </button>
      </div>

      <hr>
      <button type="submit" class="btn btn-warning">
        <i class="fa fa-save"></i> 저장
      </button>
      <a href="${pageContext.request.contextPath}/proposal/read/${proposal.pno}" class="btn btn-default">취소</a>
    </form>
  </div>
</div>

<script>
document.getElementById('addFileBtn').addEventListener('click', function() {
  var input = document.createElement('input');
  input.type = 'file';
  input.name = 'files';
  input.className = 'form-control';
  input.style.marginTop = '5px';
  document.getElementById('fileArea').appendChild(input);
});
</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

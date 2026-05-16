<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>

<div class="panel panel-primary">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-plus"></i> 제안서 등록</h3>
  </div>
  <div class="panel-body">
    <form action="${pageContext.request.contextPath}/proposal/register" method="post" enctype="multipart/form-data">

      <div class="form-group">
        <label>제목 <span class="text-danger">*</span></label>
        <input type="text" name="title" class="form-control" placeholder="제안서 제목을 입력하세요" required maxlength="200">
      </div>

      <div class="form-group">
        <label>분야 <span class="text-danger">*</span></label>
        <select name="category" class="form-control" required>
          <option value="">-- 선택 --</option>
          <option value="IT">IT/기술</option>
          <option value="ENV">환경</option>
          <option value="MGT">경영/관리</option>
          <option value="OTHER">기타</option>
        </select>
      </div>

      <div class="form-group">
        <label>마감일</label>
        <input type="date" name="deadline" class="form-control" style="max-width:200px;">
      </div>

      <div class="form-group">
        <label>내용 <span class="text-danger">*</span></label>
        <textarea name="content" class="form-control" rows="10"
                  placeholder="제안서 내용을 상세히 작성해 주세요." required></textarea>
      </div>

      <div class="form-group">
        <label>첨부파일</label>
        <div id="fileArea"></div>
        <button type="button" class="btn btn-default btn-xs" id="addFileBtn">
          <i class="fa fa-plus"></i> 파일 추가
        </button>
        <small class="text-muted"> PDF, DOC, HWP, XLS, PPT, ZIP 허용 (최대 30MB)</small>
      </div>

      <hr>
      <button type="submit" class="btn btn-primary">
        <i class="fa fa-paper-plane"></i> 제출
      </button>
      <a href="${pageContext.request.contextPath}/proposal/list" class="btn btn-default">취소</a>
    </form>
  </div>
</div>

<script>
var ACCEPT = '.pdf,.doc,.docx,.hwp,.xls,.xlsx,.ppt,.pptx,.zip';

function addFileRow() {
  var row = document.createElement('div');
  row.className = 'input-group';
  row.style.marginBottom = '6px';

  var input = document.createElement('input');
  input.type = 'file';
  input.name = 'files';
  input.className = 'form-control';
  input.accept = ACCEPT;

  var span = document.createElement('span');
  span.className = 'input-group-btn';

  var btn = document.createElement('button');
  btn.type = 'button';
  btn.className = 'btn btn-danger btn-sm';
  btn.innerHTML = '<i class="fa fa-times"></i>';
  btn.title = '제거';
  btn.addEventListener('click', function() {
    row.parentNode.removeChild(row);
  });

  span.appendChild(btn);
  row.appendChild(input);
  row.appendChild(span);
  document.getElementById('fileArea').appendChild(row);
}

document.getElementById('addFileBtn').addEventListener('click', addFileRow);

/* 처음 한 줄 기본 표시 */
addFileRow();
</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

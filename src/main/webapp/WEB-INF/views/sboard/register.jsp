<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>등록 페이지</title>
<%-- sboard 레거시 페이지: Handlebars 로컬 파일이 없으면 폐쇄망에서 동작하지 않습니다. --%>
<script type="text/javascript" src="/resources/js/upload.js"></script>
<style>
	.fileDrop {
		width:80%;
		height:100px;
		border:1px dotted gray;
		background-color:lightslategrey;
		margin:auto;
	}
</style>
</head>
<body>
<%@ include file="../include/header.jsp" %>
	<!-- Main content -->
	<section class="content">
		<div class="row">
			<!--  left column -->
			<div class="col-md-12">
			<!-- general form elements -->
				<div class="box">
					<div class="box-header with-border">
						<h3 class="box-title">게시물 등록</h3>
					</div>
					<form id="registerForm" role="form" method="post">
					<div class="box-body">
						<div class="form-group">
							<label for="exampleInputEmail1">제목</label> <input type="text"
								name='title' class="form-control" placeholder="Enter Title">
						</div>
						<div class="form-group">
							<label for="exampleInputPassword1">내용</label>
							<textarea class="form-control" name='content' rows="3"
								placeholder="Enter..."></textarea>
						</div>
						<div class="form-group">
							<label for="exampleInputEmail1">작성자</label> <input type="text"
								name='writer' class="form-control" value='${login.uid}' readonly>
						</div>
						<div class="form-group">
								<label for="exampleInputEmail1">파일 첨부 창</label>
								<div class="fileDrop"></div>
						</div>
					</div>
					
					<div class="box-footer">
							<div>
								<hr>
							</div>
							
							<ul class="mailbox-attachments clearfix uploadedList">
							</ul>
							
						<button type="submit" class="btn btn-primary">등록</button>
					</div>
				</form>
				
				</div>
			</div>
			<!-- /.col(left) -->
		</div>
		<!-- /.row -->
	</section>
	<!-- /.content -->


	<script id="template" type="text/x-handlebars-template">
	<li>
		<span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
		<div class="mailbox-attachment-info">
			<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
			<a href="{{fullName}}" class="btn btn-default btn-xs pull-right delbtn"><i class="fa fa-fw fa-remove"></i></a>
		</div>
	</li>
	</script>
	
	<script>
		var template = Handlebars.compile($("#template").html());
		
		$(".fileDrop").on("dragenter dragover", function(event) {
			event.preventDefault();
		});
		
		$(".fileDrop").on("drop", function(event) {
			event.preventDefault();
			
			var files = event.originalEvent.dataTransfer.files;
			
			var file = files[0];
			
			var formData = new FormData();
			formData.append("file", file);
			
			$.ajax({
				url:'/uploadAjax',
				data:formData,
				dataType:'text',
				processData:false,
				contentType:false,
				type:'POST',
				success:function(data) {
					var fileInfo = getFileInfo(data);
					
					var html = template(fileInfo);
					
					$(".uploadedList").append(html);
				}
			});
		});
		
		$("#registerForm").submit(function(event) {
			event.preventDefault();
			
			var that = $(this);
			var str="";
			$(".uploadedList .delbtn").each(function(index) {
				str += "<input type='hidden' name='files[" + index + "]' value='" + $(this).attr("href") + "'>";
			});
			
			that.append(str);
			that.get(0).submit();
		});

	</script>
	

	
	<%@include file="../include/footer.jsp"%>


</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세 페이지</title>
<%-- sboard 레거시 페이지: jQuery/Handlebars 로컬 파일이 없으면 이 기능은 폐쇄망에서 동작하지 않습니다.
     필요 시 resources/js/jquery.min.js, resources/js/handlebars.min.js 를 직접 추가하세요. --%>
<script type="text/javascript" src="/resources/js/upload.js"></script>
<style type="text/css">
		.popup {position:absolute;}
		.back {background-color:gray; opacity:0.5; width:100%; height:300%; overflow:hidden; z-index:1101;}
		.front {z-index:1110; opacity:1; boarder:1px; margin:auto;}
		.show {position:relative; maxWidth:1200px; max-height:800px; overlow:auto;}
</style>
</head>
<body>
	<%@ include file="../include/header.jsp" %>
	
	<div class="popup back" style="display:none;"></div>
	<div id="popup_front" class="popup front" style="display:none;">
		<img id="popup_img">
	</div>

		<section class="content">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!--  general form elements -->
				
				<div class="box">
					<div class="box-header with-border">
						<h3 class="box-title">게시글 상세보기</h3>
					</div>

					<form role="form" action="modifyPage" method="post">
						<input type="hidden" name="bno" value="${boardVO.bno}">
						<input type="hidden" name="page" value="${cri.page}">
						<input type="hidden" name="perPageNum" value="${cri.perPageNum}">
						<input type="hidden" name="searchType" value="${cri.searchType}">
						<input type="hidden" name="keyword" value="${cri.keyword}">
					</form>

					<div class="box-body">
						<div class="form-group">
							<label for="exampleInputEmail1">제목</label>
							<input type="text" name="title" class="form-control" value="${boardVO.title}" readonly="readonly">
						</div>
						<div class="form-group">
							<label for="exampleInputPassword1">내용</label>
							<textarea class="form-control" name="content" rows="3" readonly="readonly">${boardVO.content}</textarea>
						</div>
						<div class="form-group">
							<label for="exampleInputEmail1">작성자</label>
							<input type="text" name="writer" class="form-control" value="${boardVO.writer}" readonly="readonly">
						</div>
						
						<ul class="mailbox-attachments clearfix uploadedList"></ul>

					</div>
					<!-- /.box-body -->
					<div class="box-footer">
						<c:if test="${login.uid == boardVO.writer}">
							<button type="submit" class="btn btn-warning" id="modifyBtn">수정</button>
							<button type="submit" class="btn btn-danger" id="removeBtn">삭제</button>
						</c:if>
							<button type="submit" class="btn btn-primary" id="listPageBtn">목록</button>
					</div>
				</div>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-12">
				
				<div class="box box-success">
					<div class="box-header">
						<h3 class="box-title-">댓글 등록</h3>
					</div>
					<c:if test="${not empty login}">
						<div class="box-body">
							<label for="newReplyWriter">작성자</label>
							<input class="form-control" type="text" value="${login.uid}" 
								id="newReplyWriter" readonly>
							<label for="newReplyText">댓글 내용</label>
							<input class="form-control" type="text" placeholder="댓글 내용을 입력하세요" id="newReplyText">
						</div>
						<!-- /.box-body -->
						<div class="box-footer">
							<button type="submit" class="btn btn-primary" id="replyAddBtn">입력</button><!-- ADD REPLY 버튼과 LIST PAGE 버튼이 같은 클래스 속성을 이용하므로 이벤트 처리시 수정 필요할 듯 -->
						</div>
					</c:if>
					<c:if test="${empty login}">
						<div class="box-body">
							<div><a href="javascript:goLogin();">로그인을 해주세요</a></div>
						</div>
					</c:if>

				</div>
			</div>
		</div>
		
		<!-- The time line -->
		<ul class="timeline">
			<!-- timeline time label -->
			<li class="time-label" id="repliesDiv">
				<span class="bg-green">
					댓글 보기 <small id='replycntSmall'> [ ${boardVO.replycnt} ]</small>
				</span>
			</li>
		</ul>
				
		<div class="text-center">
			<ul id="pagination" class="pagination pagination-sm no-margin">
			</ul>
		</div> 
	</section>
	
	
	
	<!-- Modal -->
	<div id="modifyModal" class="modal modal-primary fade" role="dialog">
		<div class="modal-dialog">
			<!-- Modal Content -->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title"></h4>
				</div>
				<div class="modal-body" data-rno>
					<p><input type="text" id="replytext" class="form-control"></p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info" id="replyModBtn" data-dismiss="modal">수정</button>
					<button type="button" class="btn btn-danger" id="replyDelBtn" data-dismiss="modal">삭제</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<%@include file="../include/footer.jsp" %>
	

	
<script>
	$(document).ready(function() {
		
		var formObj = $("form[role='form']");
		
		console.log(formObj);
		
		$("#modifyBtn").on("click", function() {
			formObj.attr("action", "/sboard/modifyPage");
			formObj.attr("method", "get");
			formObj.submit();
		});
		
		$("#removeBtn").on("click", function() {
	/* 		var replyCnt = $("#replycntSmall").html().replace(/[^0-9]/g, "");
			if(replyCnt > 0) {
				alert("댓글이 달린 게시물을 삭제할 수 없습니다.");
				return;
			} */
			
			var arr = [];
			$(".uploadedList li").each(function(index) {
				arr.push($(this).attr("data-src"));
			});
			if(arr.length > 0) {
				$.post("deleteAllFiles", {files:arr}, function() {
				});
			}
			
			formObj.attr("action", "/sboard/removePage");
			formObj.submit();
		});
		
		$("#listPageBtn").on("click", function() {
			formObj.attr("method", "get");
			formObj.attr("action", "/sboard/list");
			formObj.submit();
		});
	});
</script>

<script id="template" type="text/x-handlebars-template">
	{{#each .}}
	<li class="replyLi" data-rno={{rno}}>
	<i class="fa fa-comments bg-blue"></i>
		<div class="timeline-item">
			<span class="time">
				<i class="fa fa-clock-o"></i>{{prettifyDate regdate}}
			</span>
			<h3 class="timeline-header"><strong>{{rno}}</strong> -{{replyer}}</h3>
			<div class="timeline-body">{{replytext}}</div>
			{{#eqReplyer replyer}}
			<div class="timeline-footer">
				<a class="btn btn-primary btn-xs" data-toggle="modal" data-target="#modifyModal">Modify</a>
				{{/eqReplyer}}
			</div>
		</div>
	</li>
	{{/each}}
</script>

<script>
	Handlebars.registerHelper("prettifyDate", function(timeValue) {
		var dateObj = new Date(timeValue);
		var year = dateObj.getFullYear();
		var month = dateObj.getMonth() +1;
		var date = dateObj.getDate();
		var hours = dateObj.getHours();
		var minutes = dateObj.getMinutes();
		return year + "/" + month + "/" + date + " " + hours + ":" + minutes;
	});
	
	Handlebars.registerHelper("eqReplyer", function(replyer, block) {
		var accum = "";
		if(replyer == "${login.uid}") {
			accum += block.fn();
		}
		
		return accum;
	});
	
	function printData(replyArr, target, templateObject) {
		var template = Handlebars.compile(templateObject.html());
		var html = template(replyArr);
		$(".replyLi").remove();
		target.after(html);
	}
	
	var bno = ${boardVO.bno};
	var replyPage = 1;
	
	function getPage(pageInfo) {
		
		//RestController의 경우 객체를 JSON 방식으로 전달하기 때문에
		//jQuery를 이용할 때는 getJSON을 이용한다.
		$.getJSON(pageInfo, function(data) {
			printData(data.list, $("#repliesDiv"), $("#template"));
			printPaging(data.pageMaker, $(".pagination"));
			
			$("#modifyModal").modal('hide');
			$("#replycntSmall").html("[ "+data.pageMaker.totalCount +" ]");
		});
	}
	
	function printPaging(pageMaker, target) {
		var str = "";
		
		if(pageMaker.prev) {
			str += "<li><a href='" + (pageMaker.startPage - 1) + "'> << </a></li>";
		}
		
		for(var i=pageMaker.startPage, len=pageMaker.endPage; i<=len; i++) {
			var strClass = pageMaker.cri.page == i? 'class=active' : '';
			str += "<li " + strClass + "><a href='" + i + "'>" + i + "</a></li>";
		}
		
		if(pageMaker.next) {
			str += "<li><a href='" + (pageMaker.endPage + 1) + "'> << </a></li>";
		}
		
		target.html(str);
	}
	
	$("#repliesDiv").on("click", function() {
		if($(".timeline li").size() > 1) {
			return;
		}
		getPage("/replies/" + bno + "/1");
	});
	
	$(".pagination").on("click", "li a", function(event) {
		event.preventDefault();
		
		replyPage = $(this).attr("href");
		
		getPage("/replies/" + bno + "/" + replyPage);
	});
	
	$("#replyAddBtn").on("click", function() {
		var replyerObj = $("#newReplyWriter");
		var replytextObj = $("#newReplyText");
		var replyer = replyerObj.val();
		var replytext = replytextObj.val();
		
		$.ajax({
			type:'post',
			url:'/replies/',
			headers:{
				"Content-Type":"application/json",
				"X-HTTP-Method-Override":"POST"
			},
			dataType:'text',
			data:JSON.stringify({bno:bno, replyer:replyer, replytext:replytext}),
			success:function(result) {
				console.log("result : " + result);
				if(result == "SUCCESS") {
					alert("등록 되었습니다.");
					replyPage = 1;
					getPage("/replies/" + bno + "/" + replyPage);
					replyerObj.val("");
					replytextObj.val("");
				}
			}
		});
	});
	
	$(".timeline").on("click", ".replyLi", function(event) {
		var reply = $(this);
		$("#replytext").val(reply.find('.timeline-body').text());
		$(".modal-title").html(reply.attr("data-rno"));
	});
	
	$("#replyModBtn").on("click", function() {
		var rno = $(".modal-title").html();
		var replytext = $("#replytext").val();
		
		$.ajax({
			type:'put',
			url:'/replies/' + rno,
			headers:{
				"Content-Type":"application/json",
				"X-HTTP-Method-Override":"POST"
			},
			data:JSON.stringify({replytext:replytext}),
			dataType:'text',
			success:function(result) {
				console.log("result : " + result);
				if(result == "SUCCESS") {
					alert("수정 되었습니다.");
					getPage("/replies/" + bno + "/" + replyPage);
				}
			}
		});
	});
	
	$("#replyDelBtn").on("click", function() {
		var rno = $(".modal-title").html();
		
		$.ajax({
			type:'delete',
			url:'/replies/' + rno,
			headers:{
				"Content-Type":"application/json",
				"X-HTTP-Method-Override":"DELETE"
			},
			dataType:'text',
			success:function(result) {
				console.log("result : " + result);
				if(result == "SUCCESS") {
					alert("삭제 되었습니다.");
					getPage("/replies/" + bno + "/" + replyPage);
				}
			}
		});
	});
</script>

<script id="templateAttach" type="text/x-handlebars-template">
	<li data-src="{{fullName}}">
		<span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="AttachMent"></span>
		<div class="mailbox-attachment-info">
			<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
		</div>
	</li>
</script>

<script>
	var bno = ${boardVO.bno};
	var template = Handlebars.compile($("#templateAttach").html());
	
	$.getJSON("/sboard/getAttach/" + bno, function(list) {
		$(list).each(function() {
			var fileInfo = getFileInfo(this);
			var html = template(fileInfo);
			$(".uploadedList").append(html);
		});
	});
	
	$(".uploadedList").on("click", ".mailbox-attachment-info a", function(event) {
		var fileLink = $(this).attr("href");
		if(checkImageType(fileLink)) {
			event.preventDefault();
			
			var imgTag = $("#popup_img");
			imgTag.attr("src", fileLink);
			$(".popup").show('slow');
			imgTag.addClass("show");
		}
	});
	
	$("#popup_img").on("click", function() {
		$(".popup").hide('slow');
	})
</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입 - 전자 제안서 포털</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
  body { background-color: #ecf0f1; }
  .join-box { width: 420px; margin: 6% auto; }
  .join-box-body {
    background: #fff;
    padding: 35px 40px;
    border-radius: 4px;
    box-shadow: 0 2px 6px rgba(0,0,0,.15);
  }
  .join-logo { text-align: center; margin-bottom: 24px; }
  .join-logo a { color: #333; font-size: 26px; font-weight: bold; text-decoration: none; }
  .join-logo small { display: block; font-size: 14px; color: #888; margin-top: 4px; }
  #idCheckMsg {
    font-size: 13px;
    margin-top: 5px;
    min-height: 18px;
    font-weight: bold;
  }
  .btn-check { white-space: nowrap; }
</style>
</head>
<body>

<div class="join-box">
  <div class="join-logo">
    <a href="${pageContext.request.contextPath}/proposal/list">
      <i class="fa fa-file-text-o"></i> 전자 제안서 포털
    </a>
    <small>새 계정 만들기</small>
  </div>

  <div class="join-box-body">
    <form id="joinForm" action="${pageContext.request.contextPath}/user/joinUs" method="post">

      <%-- 아이디 + 중복확인 --%>
      <div class="form-group">
        <label for="uid"><i class="fa fa-user"></i> 아이디</label>
        <div class="input-group">
          <input type="text" id="uid" name="uid" class="form-control"
                 placeholder="아이디를 입력하세요" maxlength="50" autocomplete="off" required>
          <span class="input-group-btn">
            <button type="button" id="btn_duplicate" class="btn btn-default btn-check"
                    onclick="fnIdCheck();">
              <i class="fa fa-search"></i> 중복확인
            </button>
          </span>
        </div>
        <div id="idCheckMsg"></div>
      </div>

      <%-- 비밀번호 --%>
      <div class="form-group">
        <label for="upw"><i class="fa fa-lock"></i> 비밀번호</label>
        <input type="password" id="upw" name="upw" class="form-control"
               placeholder="비밀번호를 입력하세요" maxlength="100" required>
      </div>

      <%-- 비밀번호 확인 --%>
      <div class="form-group">
        <label for="upwConfirm"><i class="fa fa-lock"></i> 비밀번호 확인</label>
        <input type="password" id="upwConfirm" class="form-control"
               placeholder="비밀번호를 다시 입력하세요" maxlength="100" required>
        <div id="pwMatchMsg" style="font-size:13px; margin-top:5px; min-height:18px;"></div>
      </div>

      <%-- 이름 --%>
      <div class="form-group">
        <label for="uname"><i class="fa fa-id-card"></i> 이름</label>
        <input type="text" id="uname" name="uname" class="form-control"
               placeholder="이름을 입력하세요" maxlength="100" required>
      </div>

      <button type="button" class="btn btn-primary btn-block" onclick="fnSubmit();">
        <i class="fa fa-user-plus"></i> 가입하기
      </button>
    </form>

    <hr>
    <div style="text-align:center;">
      이미 계정이 있으신가요?
      <a href="${pageContext.request.contextPath}/user/login">
        <i class="fa fa-sign-in"></i> 로그인
      </a>
    </div>
  </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
var idck = 0; // 0=미확인, 1=사용가능

/* 아이디 변경 시 중복확인 초기화 */
$('#uid').on('input', function() {
  idck = 0;
  $('#btn_duplicate').prop('disabled', false);
  $('#idCheckMsg').text('').removeClass('text-success text-danger');
});

/* 중복확인 AJAX */
function fnIdCheck() {
  var uid = $.trim($('#uid').val());
  if (uid === '') {
    showIdMsg('아이디를 먼저 입력해 주세요.', false);
    return;
  }

  $.ajax({
    type    : 'POST',
    url     : '${pageContext.request.contextPath}/user/idCheck',
    data    : { uid: uid },
    success : function(data) {
      /* 컨트롤러: userVO != null → 1(이미 존재/사용불가), null → 0(사용가능) */
      if (data == 0) {
        showIdMsg('<i class="fa fa-check-circle"></i> 사용할 수 있는 아이디입니다.', true);
        idck = 1;
        $('#btn_duplicate').prop('disabled', true);
      } else {
        showIdMsg('<i class="fa fa-times-circle"></i> 이미 사용 중인 아이디입니다.', false);
        idck = 0;
      }
    },
    error: function() {
      showIdMsg('서버 오류가 발생했습니다. 다시 시도해 주세요.', false);
    }
  });
}

function showIdMsg(msg, ok) {
  var el = $('#idCheckMsg');
  el.html(msg);
  el.removeClass('text-success text-danger');
  el.addClass(ok ? 'text-success' : 'text-danger');
}

/* 비밀번호 확인 실시간 검증 */
$('#upwConfirm').on('input', function() {
  var pw  = $('#upw').val();
  var cpw = $(this).val();
  if (cpw === '') {
    $('#pwMatchMsg').text('').removeClass('text-success text-danger');
  } else if (pw === cpw) {
    $('#pwMatchMsg').html('<i class="fa fa-check-circle"></i> 비밀번호가 일치합니다.')
                   .removeClass('text-danger').addClass('text-success');
  } else {
    $('#pwMatchMsg').html('<i class="fa fa-times-circle"></i> 비밀번호가 일치하지 않습니다.')
                   .removeClass('text-success').addClass('text-danger');
  }
});

/* 최종 제출 유효성 검사 */
function fnSubmit() {
  if (idck === 0) {
    alert('아이디 중복 확인을 완료해 주세요.');
    $('#uid').focus();
    return;
  }
  var pw  = $('#upw').val();
  var cpw = $('#upwConfirm').val();
  if (pw !== cpw) {
    alert('비밀번호가 일치하지 않습니다.');
    $('#upwConfirm').focus();
    return;
  }
  $('#joinForm').submit();
}
</script>
</body>
</html>

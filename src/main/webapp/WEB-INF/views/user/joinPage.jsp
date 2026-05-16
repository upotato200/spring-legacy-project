<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입 - 전자 제안서 포털</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/portal.css">
<style>
  #idCheckMsg { font-size: 13px; margin-top: 5px; min-height: 18px; font-weight: bold; }
  .btn-check  { white-space: nowrap; }
</style>
</head>
<body class="auth-page-body">

<div class="auth-box" style="max-width:460px;">
  <div class="auth-logo">
    <a href="${pageContext.request.contextPath}/proposal/list">
      <i class="fa fa-file-text-o"></i> 전자 제안서 포털
    </a>
    <small>새 계정 만들기</small>
  </div>

  <div class="auth-card">
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

    <div class="auth-divider">
      <hr>
      이미 계정이 있으신가요?
      <a href="${pageContext.request.contextPath}/user/login">
        <i class="fa fa-sign-in"></i> 로그인
      </a>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/portal.js"></script>
<script>
(function () {
  'use strict';

  var idck = 0; // 0=미확인, 1=사용가능

  var elUid       = document.getElementById('uid');
  var elBtn       = document.getElementById('btn_duplicate');
  var elMsg       = document.getElementById('idCheckMsg');
  var elUpw       = document.getElementById('upw');
  var elUpwCfm    = document.getElementById('upwConfirm');
  var elPwMsg     = document.getElementById('pwMatchMsg');
  var elJoinForm  = document.getElementById('joinForm');

  /* 아이디 변경 시 중복확인 초기화 */
  elUid.addEventListener('input', function () {
    idck = 0;
    elBtn.disabled = false;
    elMsg.textContent = '';
    elMsg.className = '';
  });

  /* 중복확인 — Fetch API */
  window.fnIdCheck = function () {
    var uid = elUid.value.trim();
    if (!uid) {
      showIdMsg('아이디를 먼저 입력해 주세요.', false);
      return;
    }

    var formData = new FormData();
    formData.append('uid', uid);

    fetch('${pageContext.request.contextPath}/user/idCheck', {
      method : 'POST',
      body   : formData
    })
    .then(function (res) { return res.text(); })
    .then(function (data) {
      /* 컨트롤러: userVO != null → 1(이미 존재/사용불가), null → 0(사용가능) */
      if (data.trim() == '0') {
        showIdMsg('✔ 사용할 수 있는 아이디입니다.', true);
        idck = 1;
        elBtn.disabled = true;
      } else {
        showIdMsg('✖ 이미 사용 중인 아이디입니다.', false);
        idck = 0;
      }
    })
    .catch(function () {
      showIdMsg('서버 오류가 발생했습니다. 다시 시도해 주세요.', false);
    });
  };

  function showIdMsg(msg, ok) {
    elMsg.textContent = msg;
    elMsg.className   = ok ? 'text-success' : 'text-danger';
  }

  /* 비밀번호 확인 실시간 검증 */
  elUpwCfm.addEventListener('input', function () {
    var pw  = elUpw.value;
    var cpw = elUpwCfm.value;
    if (!cpw) {
      elPwMsg.textContent = '';
      elPwMsg.className   = '';
    } else if (pw === cpw) {
      elPwMsg.textContent = '✔ 비밀번호가 일치합니다.';
      elPwMsg.className   = 'text-success';
    } else {
      elPwMsg.textContent = '✖ 비밀번호가 일치하지 않습니다.';
      elPwMsg.className   = 'text-danger';
    }
  });

  /* 최종 제출 유효성 검사 */
  window.fnSubmit = function () {
    if (idck === 0) {
      alert('아이디 중복 확인을 완료해 주세요.');
      elUid.focus();
      return;
    }
    if (elUpw.value !== elUpwCfm.value) {
      alert('비밀번호가 일치하지 않습니다.');
      elUpwCfm.focus();
      return;
    }
    elJoinForm.submit();
  };
}());
</script>
</body>
</html>

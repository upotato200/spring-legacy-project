/**
 * portal.js — 폐쇄망 환경용 바닐라 JS 유틸리티
 * jQuery / Bootstrap.js CDN 대체
 * Bootstrap 3 CSS 클래스 규약과 완전 호환
 */
(function () {
  'use strict';

  /* ================================================================
   * 유틸리티
   * ================================================================ */

  /** querySelectorAll 단축 */
  function $$(sel, ctx) {
    return Array.prototype.slice.call((ctx || document).querySelectorAll(sel));
  }

  /** querySelector 단축 */
  function $(sel, ctx) {
    return (ctx || document).querySelector(sel);
  }

  /** 클래스 토글 헬퍼 */
  function toggleClass(el, cls) {
    if (!el) return;
    el.classList.toggle(cls);
  }
  function addClass(el, cls) {
    if (el) el.classList.add(cls);
  }
  function removeClass(el, cls) {
    if (el) el.classList.remove(cls);
  }
  function hasClass(el, cls) {
    return el ? el.classList.contains(cls) : false;
  }

  /* ================================================================
   * MODAL
   * Bootstrap 3 호환:
   *   열기: data-toggle="modal" data-target="#id"
   *         또는 portal.modal.show('#id')
   *   닫기: data-dismiss="modal"
   *         또는 portal.modal.hide()
   *   이벤트: show.bs.modal / hide.bs.modal (CustomEvent)
   * ================================================================ */

  var _activeModal = null;
  var _backdropEl  = null;

  function createBackdrop() {
    var bd = document.createElement('div');
    bd.className = 'modal-backdrop fade in';
    document.body.appendChild(bd);
    _backdropEl = bd;
    bd.addEventListener('click', function () { modalHide(_activeModal); });
  }

  function removeBackdrop() {
    if (_backdropEl) {
      _backdropEl.parentNode.removeChild(_backdropEl);
      _backdropEl = null;
    }
  }

  /**
   * 모달 표시
   * @param {string|Element} target  CSS 선택자 또는 DOM 요소
   * @param {Element}        relatedTarget  트리거 버튼 (show.bs.modal 이벤트에 포함)
   */
  function modalShow(target, relatedTarget) {
    var el = (typeof target === 'string') ? $(target) : target;
    if (!el) return;

    // 이미 열린 모달 닫기
    if (_activeModal && _activeModal !== el) {
      modalHide(_activeModal);
    }

    _activeModal = el;
    createBackdrop();

    el.style.display = 'block';
    el.removeAttribute('aria-hidden');
    document.body.classList.add('modal-open');

    // Bootstrap 3 애니메이션: fade 클래스가 있으면 in 추가
    setTimeout(function () {
      addClass(el, 'in');
    }, 10);

    // show.bs.modal 커스텀 이벤트 (relatedTarget 전달)
    var evt = document.createEvent('CustomEvent');
    evt.initCustomEvent('show.bs.modal', true, true, { relatedTarget: relatedTarget || null });
    el.dispatchEvent(evt);

    // shown.bs.modal
    var evtShown = document.createEvent('CustomEvent');
    evtShown.initCustomEvent('shown.bs.modal', true, true, {});
    setTimeout(function () { el.dispatchEvent(evtShown); }, 300);
  }

  function modalHide(el) {
    if (!el) el = _activeModal;
    if (!el) return;

    removeClass(el, 'in');
    setTimeout(function () {
      el.style.display = 'none';
      el.setAttribute('aria-hidden', 'true');
      document.body.classList.remove('modal-open');
      removeBackdrop();
      _activeModal = null;

      var evt = document.createEvent('CustomEvent');
      evt.initCustomEvent('hide.bs.modal', true, true, {});
      el.dispatchEvent(evt);
    }, 200);
  }

  /* ================================================================
   * DROPDOWN
   * Bootstrap 3 호환:
   *   .dropdown > .dropdown-toggle[data-toggle="dropdown"]
   *   클릭하면 부모 .dropdown 에 .open 토글
   * ================================================================ */

  function initDropdowns() {
    document.addEventListener('click', function (e) {
      var toggle = e.target.closest('[data-toggle="dropdown"]');

      // 다른 열린 드롭다운 닫기
      $$('.dropdown.open').forEach(function (dd) {
        if (!toggle || dd !== toggle.closest('.dropdown')) {
          removeClass(dd, 'open');
        }
      });

      if (toggle) {
        e.preventDefault();
        var parent = toggle.closest('.dropdown');
        if (parent) toggleClass(parent, 'open');
      }
    });
  }

  /* ================================================================
   * COLLAPSE (navbar-toggle)
   * data-toggle="collapse" data-target="#id"
   * ================================================================ */

  function initCollapse() {
    document.addEventListener('click', function (e) {
      var btn = e.target.closest('[data-toggle="collapse"]');
      if (!btn) return;
      var targetSel = btn.getAttribute('data-target') || btn.getAttribute('href');
      var target = targetSel ? $(targetSel) : null;
      if (!target) return;
      e.preventDefault();
      toggleClass(target, 'in');
      btn.setAttribute('aria-expanded', hasClass(target, 'in'));
    });
  }

  /* ================================================================
   * ALERT DISMISS
   * data-dismiss="alert"
   * ================================================================ */

  function initAlertDismiss() {
    document.addEventListener('click', function (e) {
      var btn = e.target.closest('[data-dismiss="alert"]');
      if (!btn) return;
      var alert = btn.closest('.alert');
      if (alert) {
        addClass(alert, 'fade');
        // Bootstrap fade out
        setTimeout(function () { alert.parentNode && alert.parentNode.removeChild(alert); }, 150);
      }
    });
  }

  /* ================================================================
   * MODAL TRIGGER (data-toggle="modal")
   * ================================================================ */

  function initModalTriggers() {
    document.addEventListener('click', function (e) {
      // dismiss
      var dismiss = e.target.closest('[data-dismiss="modal"]');
      if (dismiss) {
        modalHide(_activeModal);
        return;
      }

      // show
      var trigger = e.target.closest('[data-toggle="modal"]');
      if (trigger) {
        var targetSel = trigger.getAttribute('data-target');
        if (targetSel) modalShow(targetSel, trigger);
      }
    });

    // ESC 키로 닫기
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' || e.keyCode === 27) {
        if (_activeModal) modalHide(_activeModal);
      }
    });
  }

  /* ================================================================
   * show.bs.modal 이벤트 리스너 등록 헬퍼
   * reviewerList.jsp 등에서 $().on('show.bs.modal', ...) 대신 사용
   *
   * 사용법:
   *   portal.onModalShow('#editModal', function(e) {
   *     var btn = e.detail.relatedTarget;
   *     ...
   *   });
   * ================================================================ */

  function onModalShow(selector, handler) {
    var el = $(selector);
    if (el) el.addEventListener('show.bs.modal', handler);
  }

  /* ================================================================
   * TOOLTIP (단순 title 기반 — 필요 시 확장)
   * ================================================================ */

  /* ================================================================
   * PUBLIC API
   * ================================================================ */

  window.portal = {
    modal: {
      show: modalShow,
      hide: function () { modalHide(_activeModal); }
    },
    onModalShow: onModalShow
  };

  /* ================================================================
   * 초기화
   * ================================================================ */
  document.addEventListener('DOMContentLoaded', function () {
    initDropdowns();
    initCollapse();
    initAlertDismiss();
    initModalTriggers();
  });

})();

package com.jh.service;

import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jh.dao.UserDAO;
import com.jh.dao.proposal.ReviewDAO;
import com.jh.dto.LoginDTO;
import com.jh.vo.UserVO;

@Service
public class UserServiceImpl implements UserService {

    @Inject
    private UserDAO dao;

    @Inject
    private ReviewDAO reviewDAO;

    @Override
    public UserVO login(LoginDTO dto) throws Exception {
        return dao.login(dto);
    }

    @Override
    public void keepLogin(String uid, String sessionId, Date next) throws Exception {
        dao.keepLogin(uid, sessionId, next);
    }

    @Override
    public UserVO checkLoginBefore(String value) {
        return dao.checkUserWithSessionKey(value);
    }

    @Override
    public void joinUs(String uid, String upw, String uname) throws Exception {
        dao.joinUs(uid, upw, uname);
    }

    @Override
    public UserVO idCheck(String uid) throws Exception {
        return dao.idCheck(uid);
    }

    // ---------------------------------------------------------------
    // 심사자 관리
    // ---------------------------------------------------------------

    @Override
    public List<UserVO> listReviewers() throws Exception {
        return dao.listReviewers();
    }

    @Override
    public void createReviewer(UserVO vo) throws Exception {
        dao.createReviewer(vo);
    }

    @Override
    public void updatePassword(String uid, String newPw) throws Exception {
        dao.updatePassword(uid, newPw);
    }

    @Override
    public void updateEnabled(String uid, int enabled) throws Exception {
        dao.updateEnabled(uid, enabled);
    }

    @Override
    public void deleteReviewer(String uid) throws Exception {
        dao.deleteReviewer(uid);
    }

    @Override
    public List<UserVO> listAllUsers() throws Exception {
        return dao.listAllUsers();
    }

    @Transactional
    @Override
    public void updateReviewerProfile(String oldUid, String newUid, String uname, String newPw) throws Exception {
        // UID가 변경되는 경우 FK 연쇄 업데이트 먼저 처리
        if (newUid != null && !newUid.equals(oldUid)) {
            reviewDAO.updateReviewerIdInAssign(oldUid, newUid);
            reviewDAO.updateReviewerIdInReview(oldUid, newUid);
        }
        dao.updateReviewerProfile(oldUid, newUid, uname, newPw);
    }
}

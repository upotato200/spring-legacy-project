package com.jh.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jh.dto.LoginDTO;
import com.jh.vo.UserVO;

@Repository
public class UserDAOImpl implements UserDAO {

    @Inject
    private SqlSession session;

    private static final String NS = "com.jh.mapper.UserMapper.";

    @Override
    public UserVO login(LoginDTO dto) throws Exception {
        return session.selectOne(NS + "login", dto);
    }

    @Override
    public void keepLogin(String uid, String sessionId, Date next) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("uid",       uid);
        paramMap.put("sessionId", sessionId);
        paramMap.put("next",      next);
        session.update(NS + "keepLogin", paramMap);
    }

    @Override
    public UserVO checkUserWithSessionKey(String value) {
        return session.selectOne(NS + "checkUserWithSessionKey", value);
    }

    @Override
    public void joinUs(String uid, String upw, String uname) throws Exception {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("uid",   uid);
        paramMap.put("upw",   upw);
        paramMap.put("uname", uname);
        session.insert(NS + "joinUs", paramMap);
    }

    @Override
    public UserVO idCheck(String uid) throws Exception {
        return session.selectOne(NS + "idCheck", uid);
    }

    // ---------------------------------------------------------------
    // 심사자 관리
    // ---------------------------------------------------------------

    @Override
    public List<UserVO> listReviewers() throws Exception {
        return session.selectList(NS + "listReviewers");
    }

    @Override
    public void createReviewer(UserVO vo) throws Exception {
        session.insert(NS + "createReviewer", vo);
    }

    @Override
    public void updatePassword(String uid, String newPw) throws Exception {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("uid", uid);
        params.put("upw", newPw);
        session.update(NS + "updatePassword", params);
    }

    @Override
    public void updateEnabled(String uid, int enabled) throws Exception {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("uid",     uid);
        params.put("enabled", enabled);
        session.update(NS + "updateEnabled", params);
    }

    @Override
    public void deleteReviewer(String uid) throws Exception {
        session.delete(NS + "deleteReviewer", uid);
    }

    @Override
    public List<UserVO> listAllUsers() throws Exception {
        return session.selectList(NS + "listAllUsers");
    }

    @Override
    public void updateReviewerProfile(String oldUid, String newUid, String uname, String newPw) throws Exception {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("oldUid", oldUid);
        params.put("newUid", newUid);
        params.put("uname",  uname);
        params.put("newPw",  newPw);
        session.update(NS + "updateReviewerProfile", params);
    }
}

package com.jh.dao;

import java.util.Date;
import java.util.List;

import com.jh.dto.LoginDTO;
import com.jh.vo.UserVO;

public interface UserDAO {

	public UserVO login(LoginDTO dto) throws Exception;
	public void keepLogin(String uid, String sessionId, Date next);
	public UserVO checkUserWithSessionKey(String value);
	public void joinUs(String uid, String upw, String uname) throws Exception;
	public UserVO idCheck(String uid) throws Exception;

	// 심사자 관리 (관리자 전용)
	public List<UserVO> listReviewers() throws Exception;
	public void createReviewer(UserVO vo) throws Exception;
	public void updatePassword(String uid, String newPw) throws Exception;
	public void updateEnabled(String uid, int enabled) throws Exception;
	public void deleteReviewer(String uid) throws Exception;
	public List<UserVO> listAllUsers() throws Exception;
	public void updateReviewerProfile(String oldUid, String newUid, String uname, String newPw) throws Exception;
}

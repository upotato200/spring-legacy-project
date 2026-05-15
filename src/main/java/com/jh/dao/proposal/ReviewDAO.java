package com.jh.dao.proposal;

import java.util.List;

import com.jh.vo.ReviewAssignVO;
import com.jh.vo.ReviewVO;
import com.jh.vo.UserVO;

public interface ReviewDAO {

    // 배정
    void assign(ReviewAssignVO vo) throws Exception;
    void removeAssign(int pno, String reviewerId) throws Exception;
    List<ReviewAssignVO> getAssignList(int pno) throws Exception;
    List<Integer> getAssignedPnoList(String reviewerId) throws Exception;

    // 심사
    void submitReview(ReviewVO vo) throws Exception;
    ReviewVO getReview(int pno, String reviewerId) throws Exception;
    List<ReviewVO> getReviewListByPno(int pno) throws Exception;
    List<ReviewVO> getReviewListByReviewer(String reviewerId) throws Exception;

    double getAverageScore(int pno) throws Exception;
    int getReviewCount(int pno) throws Exception;
    int getAssignCount(int pno) throws Exception;

    // 관리자 유틸
    List<UserVO> getReviewerList() throws Exception;
    List<ReviewVO> listAllReviews() throws Exception;
}

package com.jh.dao.proposal;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jh.vo.ReviewAssignVO;
import com.jh.vo.ReviewVO;
import com.jh.vo.UserVO;

@Repository
public class ReviewDAOImpl implements ReviewDAO {

    @Inject
    private SqlSession session;

    private static final String NS = "com.jh.mapper.ReviewMapper.";

    @Override
    public void assign(ReviewAssignVO vo) throws Exception {
        session.insert(NS + "assign", vo);
    }

    @Override
    public void removeAssign(int pno, String reviewerId) throws Exception {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("pno",        pno);
        params.put("reviewerId", reviewerId);
        session.delete(NS + "removeAssign", params);
    }

    @Override
    public List<ReviewAssignVO> getAssignList(int pno) throws Exception {
        return session.selectList(NS + "getAssignList", pno);
    }

    @Override
    public List<Integer> getAssignedPnoList(String reviewerId) throws Exception {
        return session.selectList(NS + "getAssignedPnoList", reviewerId);
    }

    @Override
    public void submitReview(ReviewVO vo) throws Exception {
        session.insert(NS + "submitReview", vo);
    }

    @Override
    public ReviewVO getReview(int pno, String reviewerId) throws Exception {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("pno",        pno);
        params.put("reviewerId", reviewerId);
        return session.selectOne(NS + "getReview", params);
    }

    @Override
    public List<ReviewVO> getReviewListByPno(int pno) throws Exception {
        return session.selectList(NS + "getReviewListByPno", pno);
    }

    @Override
    public List<ReviewVO> getReviewListByReviewer(String reviewerId) throws Exception {
        return session.selectList(NS + "getReviewListByReviewer", reviewerId);
    }

    @Override
    public double getAverageScore(int pno) throws Exception {
        Double avg = session.selectOne(NS + "getAverageScore", pno);
        return (avg == null) ? 0.0 : avg;
    }

    @Override
    public int getReviewCount(int pno) throws Exception {
        return session.selectOne(NS + "getReviewCount", pno);
    }

    @Override
    public int getAssignCount(int pno) throws Exception {
        return session.selectOne(NS + "getAssignCount", pno);
    }

    @Override
    public List<UserVO> getReviewerList() throws Exception {
        return session.selectList(NS + "getReviewerList");
    }

    @Override
    public List<ReviewVO> listAllReviews() throws Exception {
        return session.selectList(NS + "listAllReviews");
    }
}

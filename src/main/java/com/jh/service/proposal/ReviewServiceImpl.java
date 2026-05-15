package com.jh.service.proposal;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jh.dao.proposal.ProposalDAO;
import com.jh.dao.proposal.ReviewDAO;
import com.jh.vo.ReviewAssignVO;
import com.jh.vo.ReviewVO;
import com.jh.vo.UserVO;

@Service
public class ReviewServiceImpl implements ReviewService {

    @Inject
    private ReviewDAO   reviewDAO;

    @Inject
    private ProposalDAO proposalDAO;

    @Transactional
    @Override
    public void assign(int pno, String reviewerId) throws Exception {
        ReviewAssignVO vo = new ReviewAssignVO();
        vo.setPno(pno);
        vo.setReviewerId(reviewerId);
        reviewDAO.assign(vo);

        // 배정 시 제안서 상태를 '심사중'으로 변경
        proposalDAO.updateStatus(pno, "REVIEWING");
    }

    @Transactional
    @Override
    public void removeAssign(int pno, String reviewerId) throws Exception {
        reviewDAO.removeAssign(pno, reviewerId);

        // 배정된 심사자가 없으면 상태를 '접수'로 복원
        if (reviewDAO.getAssignCount(pno) == 0) {
            proposalDAO.updateStatus(pno, "SUBMITTED");
        }
    }

    @Override
    public List<ReviewAssignVO> getAssignList(int pno) throws Exception {
        return reviewDAO.getAssignList(pno);
    }

    @Transactional
    @Override
    public void submitReview(ReviewVO vo) throws Exception {
        vo.calcTotal();
        reviewDAO.submitReview(vo);

        // 모든 배정된 심사자가 제출했으면 평균 점수 계산 후 '완료' 처리
        int assignCount = reviewDAO.getAssignCount(vo.getPno());
        int reviewCount = reviewDAO.getReviewCount(vo.getPno());

        if (assignCount > 0 && assignCount == reviewCount) {
            double avg = reviewDAO.getAverageScore(vo.getPno());
            proposalDAO.updateTotalScore(vo.getPno(), avg);
        }
    }

    @Override
    public ReviewVO getMyReview(int pno, String reviewerId) throws Exception {
        return reviewDAO.getReview(pno, reviewerId);
    }

    @Override
    public List<ReviewVO> getReviewsByPno(int pno) throws Exception {
        return reviewDAO.getReviewListByPno(pno);
    }

    @Override
    public List<ReviewVO> getMyReviews(String reviewerId) throws Exception {
        return reviewDAO.getReviewListByReviewer(reviewerId);
    }

    @Override
    public List<Integer> getAssignedPnoList(String reviewerId) throws Exception {
        return reviewDAO.getAssignedPnoList(reviewerId);
    }

    @Override
    public List<UserVO> getReviewerList() throws Exception {
        return reviewDAO.getReviewerList();
    }

    @Override
    public List<ReviewVO> getAllReviews() throws Exception {
        return reviewDAO.listAllReviews();
    }
}

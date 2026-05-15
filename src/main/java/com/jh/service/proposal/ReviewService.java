package com.jh.service.proposal;

import java.util.List;

import com.jh.vo.ReviewAssignVO;
import com.jh.vo.ReviewVO;
import com.jh.vo.UserVO;

public interface ReviewService {

    /** 심사자 배정 */
    void assign(int pno, String reviewerId) throws Exception;

    /** 배정 취소 */
    void removeAssign(int pno, String reviewerId) throws Exception;

    /** 제안서에 배정된 심사자 목록 */
    List<ReviewAssignVO> getAssignList(int pno) throws Exception;

    /** 심사 결과 제출 (등록 또는 수정) */
    void submitReview(ReviewVO vo) throws Exception;

    /** 내 심사 결과 조회 */
    ReviewVO getMyReview(int pno, String reviewerId) throws Exception;

    /** 제안서의 전체 심사 결과 */
    List<ReviewVO> getReviewsByPno(int pno) throws Exception;

    /** 심사자별 제출 목록 */
    List<ReviewVO> getMyReviews(String reviewerId) throws Exception;

    /** 배정된 제안서 번호 목록 */
    List<Integer> getAssignedPnoList(String reviewerId) throws Exception;

    /** 심사자 목록 (관리자용) */
    List<UserVO> getReviewerList() throws Exception;

    /** 전체 심사 결과 목록 (Excel 출력용) */
    List<ReviewVO> getAllReviews() throws Exception;
}

package com.jh.controller.proposal;

import javax.inject.Inject;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jh.service.proposal.ProposalService;
import com.jh.service.proposal.ReviewService;
import com.jh.vo.ProposalVO;
import com.jh.vo.ReviewVO;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Inject
    private ReviewService  reviewService;

    @Inject
    private ProposalService proposalService;

    // ----------------------------------------------------------------
    // 심사자 — 배정된 제안서 목록
    // ----------------------------------------------------------------

    @RequestMapping(value = "/myList", method = RequestMethod.GET)
    public String myList(Model model, Authentication auth) throws Exception {
        String uid = auth.getName();

        model.addAttribute("assignedList", reviewService.getAssignedPnoList(uid));
        model.addAttribute("reviewList",   reviewService.getMyReviews(uid));
        return "review/myList";
    }

    // ----------------------------------------------------------------
    // 심사 폼
    // ----------------------------------------------------------------

    @RequestMapping(value = "/form/{pno}", method = RequestMethod.GET)
    public String form(@PathVariable int pno,
                       Model model,
                       Authentication auth) throws Exception {

        String     uid      = auth.getName();
        ProposalVO proposal = proposalService.get(pno);

        if (proposal == null) {
            return "redirect:/review/myList";
        }

        ReviewVO existing = reviewService.getMyReview(pno, uid);

        model.addAttribute("proposal", proposal);
        model.addAttribute("review",   existing);   // null 이면 신규 입력
        return "review/form";
    }

    // ----------------------------------------------------------------
    // 심사 제출
    // ----------------------------------------------------------------

    @RequestMapping(value = "/submit", method = RequestMethod.POST)
    public String submit(ReviewVO vo,
                         Authentication auth,
                         RedirectAttributes rttr) throws Exception {

        vo.setReviewerId(auth.getName());
        reviewService.submitReview(vo);

        rttr.addFlashAttribute("msg", "심사가 제출되었습니다.");
        return "redirect:/review/myList";
    }

    // ----------------------------------------------------------------
    // 제안서 심사 결과 상세 (제안자 + 심사자 공통)
    // ----------------------------------------------------------------

    @RequestMapping(value = "/result/{pno}", method = RequestMethod.GET)
    public String result(@PathVariable int pno,
                         Model model) throws Exception {

        ProposalVO proposal = proposalService.get(pno);
        if (proposal == null) {
            return "redirect:/proposal/list";
        }

        model.addAttribute("proposal", proposal);
        model.addAttribute("reviews",  reviewService.getReviewsByPno(pno));
        return "review/result";
    }
}

package com.jh.controller.admin;

import java.net.URLEncoder;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jh.service.UserService;
import com.jh.service.proposal.ProposalService;
import com.jh.service.proposal.ReviewService;
import com.jh.util.ExcelExportUtil;
import com.jh.vo.PageMaker;
import com.jh.vo.ProposalSearchCriteria;
import com.jh.vo.ProposalVO;
import com.jh.vo.ReviewVO;
import com.jh.vo.UserVO;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Inject
    private ProposalService proposalService;

    @Inject
    private ReviewService reviewService;

    @Inject
    private UserService userService;

    // ================================================================
    // 대시보드
    // ================================================================

    @RequestMapping(value = {"/", "/dashboard"}, method = RequestMethod.GET)
    public String dashboard(Model model) throws Exception {
        ProposalSearchCriteria cri = new ProposalSearchCriteria();
        cri.setPerPageNum(10);
        model.addAttribute("recentList",   proposalService.getList(cri));
        model.addAttribute("reviewerList", userService.listReviewers());
        return "admin/dashboard";
    }

    // ================================================================
    // 제안서 전체 목록
    // ================================================================

    @RequestMapping(value = "/proposal/list", method = RequestMethod.GET)
    public String proposalList(@ModelAttribute("cri") ProposalSearchCriteria cri,
                               Model model) throws Exception {
        List<ProposalVO> list  = proposalService.getList(cri);
        int              total = proposalService.getTotalCount(cri);

        PageMaker pageMaker = new PageMaker();
        pageMaker.setCri(cri);
        pageMaker.setTotalCount(total);

        model.addAttribute("list",      list);
        model.addAttribute("pageMaker", pageMaker);
        return "admin/proposalList";
    }

    // ================================================================
    // 심사 배정
    // ================================================================

    @RequestMapping(value = "/assign/{pno}", method = RequestMethod.GET)
    public String assignForm(@PathVariable int pno, Model model) throws Exception {
        model.addAttribute("proposal",     proposalService.get(pno));
        model.addAttribute("assignList",   reviewService.getAssignList(pno));
        model.addAttribute("reviewerList", userService.listReviewers());
        return "admin/assign";
    }

    @RequestMapping(value = "/assign/{pno}", method = RequestMethod.POST)
    public String assign(@PathVariable int pno,
                         @RequestParam String reviewerId,
                         RedirectAttributes rttr) throws Exception {
        reviewService.assign(pno, reviewerId);
        rttr.addFlashAttribute("msg", reviewerId + " 심사자가 배정되었습니다.");
        return "redirect:/admin/assign/" + pno;
    }

    @RequestMapping(value = "/assign/{pno}/remove", method = RequestMethod.POST)
    public String removeAssign(@PathVariable int pno,
                               @RequestParam String reviewerId,
                               RedirectAttributes rttr) throws Exception {
        reviewService.removeAssign(pno, reviewerId);
        rttr.addFlashAttribute("msg", reviewerId + " 배정이 취소되었습니다.");
        return "redirect:/admin/assign/" + pno;
    }

    // ================================================================
    // Excel 다운로드
    // ================================================================

    @RequestMapping(value = "/excel", method = RequestMethod.GET)
    public void downloadExcel(HttpServletResponse response) throws Exception {
        List<ProposalVO> proposals = proposalService.getAll();
        List<ReviewVO>   reviews   = reviewService.getAllReviews();

        String filename = URLEncoder.encode("제안서_심사결과.xlsx", "UTF-8")
                                    .replaceAll("\\+", "%20");

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        ExcelExportUtil.exportPortal(proposals, reviews, response.getOutputStream());
    }

    // ================================================================
    // 심사자 계정 관리
    // ================================================================

    /** 심사자 목록 */
    @RequestMapping(value = "/reviewers", method = RequestMethod.GET)
    public String reviewerList(Model model) throws Exception {
        model.addAttribute("reviewerList", userService.listReviewers());
        return "admin/reviewerList";
    }

    /** 심사자 등록 처리 */
    @RequestMapping(value = "/reviewers/create", method = RequestMethod.POST)
    public String createReviewer(@RequestParam String uid,
                                 @RequestParam String upw,
                                 @RequestParam String uname,
                                 RedirectAttributes rttr) throws Exception {
        // 중복 체크
        if (userService.idCheck(uid) != null) {
            rttr.addFlashAttribute("error", "이미 사용 중인 아이디입니다: " + uid);
            return "redirect:/admin/reviewers";
        }

        UserVO vo = new UserVO();
        vo.setUid(uid);
        vo.setUpw(upw);
        vo.setUname(uname);
        userService.createReviewer(vo);

        rttr.addFlashAttribute("msg", "심사자 계정이 생성되었습니다. (ID: " + uid + ")");
        return "redirect:/admin/reviewers";
    }

    /** 비밀번호 초기화 */
    @RequestMapping(value = "/reviewers/{uid}/password", method = RequestMethod.POST)
    public String resetPassword(@PathVariable String uid,
                                @RequestParam String newPw,
                                RedirectAttributes rttr) throws Exception {
        userService.updatePassword(uid, newPw);
        rttr.addFlashAttribute("msg", uid + " 비밀번호가 변경되었습니다.");
        return "redirect:/admin/reviewers";
    }

    /** 계정 활성화 / 비활성화 토글 */
    @RequestMapping(value = "/reviewers/{uid}/toggle", method = RequestMethod.POST)
    public String toggleEnabled(@PathVariable String uid,
                                @RequestParam int enabled,
                                RedirectAttributes rttr) throws Exception {
        userService.updateEnabled(uid, enabled);
        String label = enabled == 1 ? "활성화" : "비활성화";
        rttr.addFlashAttribute("msg", uid + " 계정이 " + label + "되었습니다.");
        return "redirect:/admin/reviewers";
    }

    /** 심사자 계정 삭제 */
    @RequestMapping(value = "/reviewers/{uid}/delete", method = RequestMethod.POST)
    public String deleteReviewer(@PathVariable String uid,
                                 RedirectAttributes rttr) throws Exception {
        userService.deleteReviewer(uid);
        rttr.addFlashAttribute("msg", uid + " 계정이 삭제되었습니다.");
        return "redirect:/admin/reviewers";
    }

    /** 심사자 프로필 수정 (아이디·이름·비밀번호) */
    @RequestMapping(value = "/reviewers/{uid}/update", method = RequestMethod.POST)
    public String updateReviewer(@PathVariable String uid,
                                 @RequestParam String newUid,
                                 @RequestParam String uname,
                                 @RequestParam(required = false, defaultValue = "") String newPw,
                                 RedirectAttributes rttr) throws Exception {

        // 아이디 변경 시 중복 체크
        if (!newUid.equals(uid) && userService.idCheck(newUid) != null) {
            rttr.addFlashAttribute("error", "이미 사용 중인 아이디입니다: " + newUid);
            return "redirect:/admin/reviewers";
        }

        userService.updateReviewerProfile(uid, newUid, uname, newPw);
        rttr.addFlashAttribute("msg", uid + " 심사자 정보가 수정되었습니다."
                + (newUid.equals(uid) ? "" : " (아이디: " + uid + " → " + newUid + ")"));
        return "redirect:/admin/reviewers";
    }
}

package com.jh.controller.proposal;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jh.service.proposal.ProposalService;
import com.jh.service.proposal.ReviewService;
import com.jh.vo.PageMaker;
import com.jh.vo.ProposalSearchCriteria;
import com.jh.vo.ProposalVO;
import com.jh.vo.ReviewVO;

@Controller
@RequestMapping("/proposal")
public class ProposalController {

    @Inject
    private ProposalService proposalService;

    @Inject
    private ReviewService reviewService;

    @Inject
    @org.springframework.beans.factory.annotation.Qualifier("uploadPath")
    private String uploadPath;

    // ----------------------------------------------------------------
    // 목록
    // ----------------------------------------------------------------

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(@ModelAttribute("cri") ProposalSearchCriteria cri,
                       Model model) throws Exception {

        List<ProposalVO> list  = proposalService.getList(cri);
        int              total = proposalService.getTotalCount(cri);

        PageMaker pageMaker = new PageMaker();
        pageMaker.setCri(cri);
        pageMaker.setTotalCount(total);

        model.addAttribute("list",      list);
        model.addAttribute("pageMaker", pageMaker);
        return "proposal/list";
    }

    // ----------------------------------------------------------------
    // 내 제안서 목록
    // ----------------------------------------------------------------

    @RequestMapping(value = "/myList", method = RequestMethod.GET)
    public String myList(@ModelAttribute("cri") ProposalSearchCriteria cri,
                         Model model,
                         Authentication auth) throws Exception {

        String uid = auth.getName();

        List<ProposalVO> list  = proposalService.getMyList(uid, cri);
        int              total = proposalService.getMyCount(uid);

        PageMaker pageMaker = new PageMaker();
        pageMaker.setCri(cri);
        pageMaker.setTotalCount(total);

        model.addAttribute("list",      list);
        model.addAttribute("pageMaker", pageMaker);
        return "proposal/myList";
    }

    // ----------------------------------------------------------------
    // 등록
    // ----------------------------------------------------------------

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String registerForm() {
        return "proposal/register";
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String register(ProposalVO vo,
                           @RequestParam(value = "files", required = false) List<MultipartFile> files,
                           Authentication auth,
                           RedirectAttributes rttr) throws Exception {

        vo.setSubmitter(auth.getName());
        proposalService.register(vo, files, uploadPath);

        rttr.addFlashAttribute("msg", "제안서가 접수되었습니다.");
        return "redirect:/proposal/myList";
    }

    // ----------------------------------------------------------------
    // 상세보기
    // ----------------------------------------------------------------

    @RequestMapping(value = "/read/{pno}", method = RequestMethod.GET)
    public String read(@PathVariable int pno,
                       @ModelAttribute("cri") ProposalSearchCriteria cri,
                       Model model,
                       Authentication auth) throws Exception {

        ProposalVO proposal = proposalService.get(pno);
        if (proposal == null) {
            return "redirect:/proposal/list";
        }

        List<ReviewVO> reviews = reviewService.getReviewsByPno(pno);

        model.addAttribute("proposal", proposal);
        model.addAttribute("reviews",  reviews);
        model.addAttribute("isOwner",  auth != null && auth.getName().equals(proposal.getSubmitter()));
        return "proposal/read";
    }

    // ----------------------------------------------------------------
    // 수정
    // ----------------------------------------------------------------

    @RequestMapping(value = "/modify/{pno}", method = RequestMethod.GET)
    public String modifyForm(@PathVariable int pno,
                             Model model,
                             Authentication auth) throws Exception {

        ProposalVO proposal = proposalService.get(pno);
        if (proposal == null || !auth.getName().equals(proposal.getSubmitter())) {
            return "redirect:/proposal/list";
        }
        model.addAttribute("proposal", proposal);
        return "proposal/modify";
    }

    @RequestMapping(value = "/modify/{pno}", method = RequestMethod.POST)
    public String modify(@PathVariable int pno,
                         ProposalVO vo,
                         @RequestParam(value = "files", required = false) List<MultipartFile> files,
                         Authentication auth,
                         RedirectAttributes rttr) throws Exception {

        ProposalVO existing = proposalService.get(pno);
        if (existing == null || !auth.getName().equals(existing.getSubmitter())) {
            return "redirect:/proposal/list";
        }

        vo.setPno(pno);
        proposalService.modify(vo, files, uploadPath);

        rttr.addFlashAttribute("msg", "제안서가 수정되었습니다.");
        return "redirect:/proposal/read/" + pno;
    }

    // ----------------------------------------------------------------
    // 삭제
    // ----------------------------------------------------------------

    @RequestMapping(value = "/remove/{pno}", method = RequestMethod.POST)
    public String remove(@PathVariable int pno,
                         Authentication auth,
                         RedirectAttributes rttr) throws Exception {

        ProposalVO existing = proposalService.get(pno);
        if (existing != null && auth.getName().equals(existing.getSubmitter())) {
            proposalService.remove(pno, uploadPath);
            rttr.addFlashAttribute("msg", "제안서가 삭제되었습니다.");
        }
        return "redirect:/proposal/myList";
    }

    // ----------------------------------------------------------------
    // 첨부파일 단건 삭제 (Ajax)
    // ----------------------------------------------------------------

    @RequestMapping(value = "/attach/remove/{ano}", method = RequestMethod.POST)
    public String removeAttach(@PathVariable int ano,
                               @RequestParam int pno,
                               Authentication auth) throws Exception {

        ProposalVO existing = proposalService.get(pno);
        if (existing != null && auth.getName().equals(existing.getSubmitter())) {
            proposalService.removeAttach(ano, uploadPath);
        }
        return "redirect:/proposal/modify/" + pno;
    }
}

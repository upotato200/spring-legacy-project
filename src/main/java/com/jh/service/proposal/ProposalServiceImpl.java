package com.jh.service.proposal;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.jh.dao.proposal.ProposalDAO;
import com.jh.vo.ProposalAttachVO;
import com.jh.vo.ProposalSearchCriteria;
import com.jh.vo.ProposalVO;

@Service
public class ProposalServiceImpl implements ProposalService {

    @Inject
    private ProposalDAO proposalDAO;

    @Transactional
    @Override
    public void register(ProposalVO vo, List<MultipartFile> files, String uploadPath) throws Exception {
        proposalDAO.create(vo);

        if (files != null) {
            for (MultipartFile mf : files) {
                if (mf.isEmpty()) continue;
                ProposalAttachVO attach = saveFile(mf, uploadPath);
                attach.setPno(vo.getPno());
                proposalDAO.addAttach(attach);
            }
        }
    }

    @Override
    public ProposalVO get(int pno) throws Exception {
        ProposalVO vo = proposalDAO.read(pno);
        if (vo != null) {
            vo.setAttachList(proposalDAO.getAttachList(pno));
        }
        return vo;
    }

    @Transactional
    @Override
    public void modify(ProposalVO vo, List<MultipartFile> files, String uploadPath) throws Exception {
        proposalDAO.update(vo);

        if (files != null) {
            for (MultipartFile mf : files) {
                if (mf.isEmpty()) continue;
                ProposalAttachVO attach = saveFile(mf, uploadPath);
                attach.setPno(vo.getPno());
                proposalDAO.addAttach(attach);
            }
        }
    }

    @Transactional
    @Override
    public void remove(int pno, String uploadPath) throws Exception {
        List<ProposalAttachVO> attachList = proposalDAO.getAttachList(pno);
        for (ProposalAttachVO attach : attachList) {
            deletePhysicalFile(attach.getSavedName(), uploadPath);
        }
        proposalDAO.delete(pno);
    }

    @Override
    public List<ProposalVO> getList(ProposalSearchCriteria cri) throws Exception {
        return proposalDAO.list(cri);
    }

    @Override
    public List<ProposalVO> getMyList(String submitter, ProposalSearchCriteria cri) throws Exception {
        return proposalDAO.listBySubmitter(submitter, cri);
    }

    @Override
    public int getTotalCount(ProposalSearchCriteria cri) throws Exception {
        return proposalDAO.getTotalCount(cri);
    }

    @Override
    public int getMyCount(String submitter) throws Exception {
        return proposalDAO.getCountBySubmitter(submitter);
    }

    @Override
    public void removeAttach(int ano, String uploadPath) throws Exception {
        proposalDAO.deleteAttach(ano);
    }

    @Override
    public List<ProposalVO> getAll() throws Exception {
        return proposalDAO.listAll();
    }

    // ----------------------------------------------------------------
    // 내부 유틸
    // ----------------------------------------------------------------

    private ProposalAttachVO saveFile(MultipartFile mf, String uploadPath) throws Exception {
        String originalName = mf.getOriginalFilename();
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf("."));
        }
        String savedName = UUID.randomUUID().toString() + ext;

        File dest = new File(uploadPath, savedName);
        dest.getParentFile().mkdirs();
        mf.transferTo(dest);

        ProposalAttachVO attach = new ProposalAttachVO();
        attach.setSavedName(savedName);
        attach.setOriginalName(originalName);
        attach.setFilesize(mf.getSize());
        return attach;
    }

    private void deletePhysicalFile(String savedName, String uploadPath) {
        File file = new File(uploadPath, savedName);
        if (file.exists()) {
            file.delete();
        }
    }
}

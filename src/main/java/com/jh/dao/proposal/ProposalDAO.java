package com.jh.dao.proposal;

import java.util.List;

import com.jh.vo.ProposalAttachVO;
import com.jh.vo.ProposalSearchCriteria;
import com.jh.vo.ProposalVO;

public interface ProposalDAO {

    void create(ProposalVO vo) throws Exception;
    ProposalVO read(int pno) throws Exception;
    void update(ProposalVO vo) throws Exception;
    void delete(int pno) throws Exception;

    List<ProposalVO> list(ProposalSearchCriteria cri) throws Exception;
    List<ProposalVO> listBySubmitter(String submitter, ProposalSearchCriteria cri) throws Exception;
    int getTotalCount(ProposalSearchCriteria cri) throws Exception;
    int getCountBySubmitter(String submitter) throws Exception;

    void updateStatus(int pno, String status) throws Exception;
    void updateTotalScore(int pno, double totalScore) throws Exception;

    void addAttach(ProposalAttachVO attach) throws Exception;
    List<ProposalAttachVO> getAttachList(int pno) throws Exception;
    void deleteAttach(int ano) throws Exception;
    void deleteAttachByPno(int pno) throws Exception;

    List<ProposalVO> listAll() throws Exception;
}

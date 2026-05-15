package com.jh.dao.proposal;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jh.vo.ProposalAttachVO;
import com.jh.vo.ProposalSearchCriteria;
import com.jh.vo.ProposalVO;

@Repository
public class ProposalDAOImpl implements ProposalDAO {

    @Inject
    private SqlSession session;

    private static final String NS = "com.jh.mapper.ProposalMapper.";

    @Override
    public void create(ProposalVO vo) throws Exception {
        session.insert(NS + "create", vo);
    }

    @Override
    public ProposalVO read(int pno) throws Exception {
        return session.selectOne(NS + "read", pno);
    }

    @Override
    public void update(ProposalVO vo) throws Exception {
        session.update(NS + "update", vo);
    }

    @Override
    public void delete(int pno) throws Exception {
        session.delete(NS + "delete", pno);
    }

    @Override
    public List<ProposalVO> list(ProposalSearchCriteria cri) throws Exception {
        return session.selectList(NS + "list", cri);
    }

    @Override
    public List<ProposalVO> listBySubmitter(String submitter, ProposalSearchCriteria cri) throws Exception {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("submitter",  submitter);
        params.put("pageStart",  cri.getPageStart());
        params.put("perPageNum", cri.getPerPageNum());
        return session.selectList(NS + "listBySubmitter", params);
    }

    @Override
    public int getTotalCount(ProposalSearchCriteria cri) throws Exception {
        return session.selectOne(NS + "getTotalCount", cri);
    }

    @Override
    public int getCountBySubmitter(String submitter) throws Exception {
        return session.selectOne(NS + "getCountBySubmitter", submitter);
    }

    @Override
    public void updateStatus(int pno, String status) throws Exception {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("pno",    pno);
        params.put("status", status);
        session.update(NS + "updateStatus", params);
    }

    @Override
    public void updateTotalScore(int pno, double totalScore) throws Exception {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("pno",        pno);
        params.put("totalScore", totalScore);
        session.update(NS + "updateTotalScore", params);
    }

    @Override
    public void addAttach(ProposalAttachVO attach) throws Exception {
        session.insert(NS + "addAttach", attach);
    }

    @Override
    public List<ProposalAttachVO> getAttachList(int pno) throws Exception {
        return session.selectList(NS + "getAttachList", pno);
    }

    @Override
    public void deleteAttach(int ano) throws Exception {
        session.delete(NS + "deleteAttach", ano);
    }

    @Override
    public void deleteAttachByPno(int pno) throws Exception {
        session.delete(NS + "deleteAttachByPno", pno);
    }

    @Override
    public List<ProposalVO> listAll() throws Exception {
        return session.selectList(NS + "listAll");
    }
}

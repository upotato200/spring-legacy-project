package com.jh.service.proposal;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.jh.vo.ProposalAttachVO;
import com.jh.vo.ProposalSearchCriteria;
import com.jh.vo.ProposalVO;

public interface ProposalService {

    /** 제안서 등록 (첨부파일 포함) */
    void register(ProposalVO vo, List<MultipartFile> files, String uploadPath) throws Exception;

    /** 제안서 상세 조회 (첨부파일 포함) */
    ProposalVO get(int pno) throws Exception;

    /** 제안서 수정 */
    void modify(ProposalVO vo, List<MultipartFile> files, String uploadPath) throws Exception;

    /** 제안서 삭제 (첨부파일 물리적 삭제 포함) */
    void remove(int pno, String uploadPath) throws Exception;

    /** 목록 (검색·페이징) */
    List<ProposalVO> getList(ProposalSearchCriteria cri) throws Exception;

    /** 내 제안서 목록 */
    List<ProposalVO> getMyList(String submitter, ProposalSearchCriteria cri) throws Exception;

    /** 전체 건수 */
    int getTotalCount(ProposalSearchCriteria cri) throws Exception;

    /** 내 제안서 전체 건수 */
    int getMyCount(String submitter) throws Exception;

    /** 첨부파일 단건 삭제 */
    void removeAttach(int ano, String uploadPath) throws Exception;

    /** 관리자용 전체 목록 (Excel 출력) */
    List<ProposalVO> getAll() throws Exception;
}

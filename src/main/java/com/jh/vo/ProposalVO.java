package com.jh.vo;

import java.util.Date;
import java.util.List;

public class ProposalVO {

    private int     pno;
    private String  title;
    private String  content;
    private String  category;   // IT, ENV, MGT, OTHER
    private String  submitter;  // tbl_user.uid
    private String  status;     // SUBMITTED, REVIEWING, COMPLETED, REJECTED
    private Double  totalScore;
    private Date    deadline;
    private Date    regdate;
    private Date    updatedate;

    /** 첨부파일 목록 (JOIN 없이 별도 조회 후 바인딩) */
    private List<ProposalAttachVO> attachList;

    public int getPno()                        { return pno; }
    public void setPno(int pno)                { this.pno = pno; }

    public String getTitle()                   { return title; }
    public void setTitle(String title)         { this.title = title; }

    public String getContent()                 { return content; }
    public void setContent(String content)     { this.content = content; }

    public String getCategory()                { return category; }
    public void setCategory(String category)   { this.category = category; }

    public String getSubmitter()               { return submitter; }
    public void setSubmitter(String submitter) { this.submitter = submitter; }

    public String getStatus()                  { return status; }
    public void setStatus(String status)       { this.status = status; }

    public Double getTotalScore()              { return totalScore; }
    public void setTotalScore(Double s)        { this.totalScore = s; }

    public Date getDeadline()                  { return deadline; }
    public void setDeadline(Date deadline)     { this.deadline = deadline; }

    public Date getRegdate()                   { return regdate; }
    public void setRegdate(Date regdate)       { this.regdate = regdate; }

    public Date getUpdatedate()                { return updatedate; }
    public void setUpdatedate(Date updatedate) { this.updatedate = updatedate; }

    public List<ProposalAttachVO> getAttachList()            { return attachList; }
    public void setAttachList(List<ProposalAttachVO> list)   { this.attachList = list; }

    /** 분야명 한글 변환 */
    public String getCategoryLabel() {
        if (category == null) return "";
        switch (category) {
            case "IT":    return "IT/기술";
            case "ENV":   return "환경";
            case "MGT":   return "경영/관리";
            default:      return "기타";
        }
    }

    /** 상태명 한글 변환 */
    public String getStatusLabel() {
        if (status == null) return "";
        switch (status) {
            case "SUBMITTED":  return "접수";
            case "REVIEWING":  return "심사중";
            case "COMPLETED":  return "완료";
            case "REJECTED":   return "반려";
            default:           return status;
        }
    }

    @Override
    public String toString() {
        return "ProposalVO[pno=" + pno + ", title=" + title + ", submitter=" + submitter + ", status=" + status + "]";
    }
}

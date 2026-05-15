package com.jh.vo;

import java.util.Date;

public class ReviewAssignVO {

    private int    assignNo;
    private int    pno;
    private String reviewerId;
    private Date   assignedDate;

    public int getAssignNo()                     { return assignNo; }
    public void setAssignNo(int assignNo)        { this.assignNo = assignNo; }

    public int getPno()                          { return pno; }
    public void setPno(int pno)                  { this.pno = pno; }

    public String getReviewerId()                { return reviewerId; }
    public void setReviewerId(String reviewerId) { this.reviewerId = reviewerId; }

    public Date getAssignedDate()                { return assignedDate; }
    public void setAssignedDate(Date d)          { this.assignedDate = d; }
}

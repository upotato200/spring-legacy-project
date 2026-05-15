package com.jh.vo;

import java.util.Date;

public class ReviewVO {

    private int    rno;
    private int    pno;
    private String reviewerId;
    private int    scoreOriginality;  // 독창성    (0-25)
    private int    scoreFeasibility;  // 실현가능성 (0-25)
    private int    scoreEconomy;      // 경제성    (0-25)
    private int    scoreImpact;       // 파급효과  (0-25)
    private int    totalScore;        // 총점      (0-100)
    private String opinion;
    private Date   reviewDate;

    /** JOIN 시 함께 가져오는 제안서 제목 */
    private String proposalTitle;

    public int getRno()                          { return rno; }
    public void setRno(int rno)                  { this.rno = rno; }

    public int getPno()                          { return pno; }
    public void setPno(int pno)                  { this.pno = pno; }

    public String getReviewerId()                { return reviewerId; }
    public void setReviewerId(String reviewerId) { this.reviewerId = reviewerId; }

    public int getScoreOriginality()             { return scoreOriginality; }
    public void setScoreOriginality(int s)       { this.scoreOriginality = s; }

    public int getScoreFeasibility()             { return scoreFeasibility; }
    public void setScoreFeasibility(int s)       { this.scoreFeasibility = s; }

    public int getScoreEconomy()                 { return scoreEconomy; }
    public void setScoreEconomy(int s)           { this.scoreEconomy = s; }

    public int getScoreImpact()                  { return scoreImpact; }
    public void setScoreImpact(int s)            { this.scoreImpact = s; }

    public int getTotalScore()                   { return totalScore; }
    public void setTotalScore(int totalScore)    { this.totalScore = totalScore; }

    public String getOpinion()                   { return opinion; }
    public void setOpinion(String opinion)       { this.opinion = opinion; }

    public Date getReviewDate()                  { return reviewDate; }
    public void setReviewDate(Date reviewDate)   { this.reviewDate = reviewDate; }

    public String getProposalTitle()             { return proposalTitle; }
    public void setProposalTitle(String t)       { this.proposalTitle = t; }

    /** 총점을 내부에서 계산 (저장 전 호출) */
    public void calcTotal() {
        this.totalScore = scoreOriginality + scoreFeasibility + scoreEconomy + scoreImpact;
    }
}

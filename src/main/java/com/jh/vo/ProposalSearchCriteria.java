package com.jh.vo;

public class ProposalSearchCriteria extends Criteria {

    /** 검색 타입: T=제목, S=제안자, TS=제목+제안자 */
    private String searchType;
    private String keyword;

    /** 상태 필터 (SUBMITTED/REVIEWING/COMPLETED/REJECTED, 빈 문자열이면 전체) */
    private String status;

    /** 분야 필터 (IT/ENV/MGT/OTHER, 빈 문자열이면 전체) */
    private String category;

    public String getSearchType()              { return searchType; }
    public void setSearchType(String t)        { this.searchType = t; }

    public String getKeyword()                 { return keyword; }
    public void setKeyword(String keyword)     { this.keyword = keyword; }

    public String getStatus()                  { return status; }
    public void setStatus(String status)       { this.status = status; }

    public String getCategory()                { return category; }
    public void setCategory(String category)   { this.category = category; }

    /** 페이지 쿼리 스트링 생성 (JSP 링크에서 사용) */
    public String makeQuery(int page) {
        StringBuilder sb = new StringBuilder();
        sb.append("page=").append(page);
        sb.append("&perPageNum=").append(getPerPageNum());
        if (searchType != null && !searchType.isEmpty())
            sb.append("&searchType=").append(searchType);
        if (keyword != null && !keyword.isEmpty())
            sb.append("&keyword=").append(keyword);
        if (status != null && !status.isEmpty())
            sb.append("&status=").append(status);
        if (category != null && !category.isEmpty())
            sb.append("&category=").append(category);
        return sb.toString();
    }
}

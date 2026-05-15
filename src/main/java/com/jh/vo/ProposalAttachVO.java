package com.jh.vo;

import java.util.Date;

public class ProposalAttachVO {

    private int    ano;
    private int    pno;
    private String savedName;
    private String originalName;
    private long   filesize;
    private Date   regdate;

    public int getAno()                        { return ano; }
    public void setAno(int ano)                { this.ano = ano; }

    public int getPno()                        { return pno; }
    public void setPno(int pno)                { this.pno = pno; }

    public String getSavedName()               { return savedName; }
    public void setSavedName(String savedName) { this.savedName = savedName; }

    public String getOriginalName()                  { return originalName; }
    public void setOriginalName(String originalName) { this.originalName = originalName; }

    public long getFilesize()                  { return filesize; }
    public void setFilesize(long filesize)     { this.filesize = filesize; }

    public Date getRegdate()                   { return regdate; }
    public void setRegdate(Date regdate)       { this.regdate = regdate; }

    /** KB 단위 표시 */
    public String getFilesizeKb() {
        return String.format("%.1f KB", filesize / 1024.0);
    }
}

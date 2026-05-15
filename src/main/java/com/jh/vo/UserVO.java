package com.jh.vo;

public class UserVO {
	private String uid;
	private String upw;
	private String uname;
	private int    upoint;
	private String role    = "ROLE_USER";
	private int    enabled = 1;
	
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getUpw() {
		return upw;
	}
	public void setUpw(String upw) {
		this.upw = upw;
	}
	public String getUname() {
		return uname;
	}
	public void setUname(String uname) {
		this.uname = uname;
	}
	public int getUpoint() {
		return upoint;
	}
	public void setUpoint(int upoint) {
		this.upoint = upoint;
	}
	
	public String getRole()              { return role; }
	public void setRole(String role)     { this.role = role; }

	public int getEnabled()              { return enabled; }
	public void setEnabled(int enabled)  { this.enabled = enabled; }

	@Override
	public String toString() {
		return "uid: " + uid + " uname: " + uname + " role: " + role;
	}
}

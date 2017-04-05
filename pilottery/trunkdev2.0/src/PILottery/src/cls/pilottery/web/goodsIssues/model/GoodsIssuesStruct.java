package cls.pilottery.web.goodsIssues.model;

import java.util.ArrayList;
import java.util.List;

public class GoodsIssuesStruct {
	private String sgiNo;// 入库单编号

	private String pwarehouse;// 仓库
	private Long popertype;// 操作类型
	private Integer poper;// 操作人
	private String remarks;
	List<GoodsIssuesBatchStruct> issList=new ArrayList<GoodsIssuesBatchStruct>();
	private Integer c_errorcode;                   
	private String  c_errormesg;
	public String getSgiNo() {
		return sgiNo;
	}
	public void setSgiNo(String sgiNo) {
		this.sgiNo = sgiNo;
	}
	public String getPwarehouse() {
		return pwarehouse;
	}
	public void setPwarehouse(String pwarehouse) {
		this.pwarehouse = pwarehouse;
	}
	public Long getPopertype() {
		return popertype;
	}
	public void setPopertype(Long popertype) {
		this.popertype = popertype;
	}
	public Integer getPoper() {
		return poper;
	}
	public void setPoper(Integer poper) {
		this.poper = poper;
	}
	public List<GoodsIssuesBatchStruct> getIssList() {
		return issList;
	}
	public void setIssList(List<GoodsIssuesBatchStruct> issList) {
		this.issList = issList;
	}
	public Integer getC_errorcode() {
		return c_errorcode;
	}
	public void setC_errorcode(Integer c_errorcode) {
		this.c_errorcode = c_errorcode;
	}
	public String getC_errormesg() {
		return c_errormesg;
	}
	public void setC_errormesg(String c_errormesg) {
		this.c_errormesg = c_errormesg;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	@Override
	public String toString() {
		return "GoodsIssuesStruct [sgiNo=" + sgiNo + ", pwarehouse="
				+ pwarehouse + ", popertype=" + popertype + ", poper=" + poper
				+ ", remarks=" + remarks + ", issList=" + issList
				+ ", c_errorcode=" + c_errorcode + ", c_errormesg="
				+ c_errormesg + "]";
	}
	
	
}

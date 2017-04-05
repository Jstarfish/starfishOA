package cls.pilottery.web.inventory.model;

import java.util.ArrayList;
import java.util.List;

public class CheckStruct {
    private String cpNo;//盘点单号
	private List<CheckBatchStruct> batchList = new ArrayList<CheckBatchStruct>();

	private Integer c_errorcode;                   
	private String  c_errormesg;  

	

	@Override
	public String toString() {
		return "CheckStruct [cpNo=" + cpNo + ", batchList=" + batchList
				+ ", c_errorcode=" + c_errorcode + ", c_errormesg="
				+ c_errormesg + "]";
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

	public String getCpNo() {
		return cpNo;
	}

	public void setCpNo(String cpNo) {
		this.cpNo = cpNo;
	}

	public List<CheckBatchStruct> getBatchList() {
		return batchList;
	}

	public void setBatchList(List<CheckBatchStruct> batchList) {
		this.batchList = batchList;
	}

	

}

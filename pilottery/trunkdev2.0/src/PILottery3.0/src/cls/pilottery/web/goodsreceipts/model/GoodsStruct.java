package cls.pilottery.web.goodsreceipts.model;

import java.util.ArrayList;
import java.util.List;

public class GoodsStruct {
	public List<ResultStruct> getResulstList() {
		return resulstList;
	}

	public void setResulstList(List<ResultStruct> resulstList) {
		this.resulstList = resulstList;
	}

	private String p_inbound_no;// 入库单编号
	private String pplan;// 批次编号
	private String pbatch;// 生产批次
	private String pwarehouse;// 仓库
	private Long popertype;// 操作类型
	private Long poper;// 操作人
	private String code;
	private String sgrNo;
	private String remark;
	private List<GoodsBatchStruct> batchList = new ArrayList<GoodsBatchStruct>();
	private List<ResultStruct> resulstList = new ArrayList<ResultStruct>();
	private Integer c_errorcode;                   
	private String  c_errormesg;  

	public String getP_inbound_no() {
		return p_inbound_no;
	}

	public void setP_inbound_no(String p_inbound_no) {
		this.p_inbound_no = p_inbound_no;
	}

	public String getPplan() {
		return pplan;
	}

	public void setPplan(String pplan) {
		this.pplan = pplan;
	}

	public String getPbatch() {
		return pbatch;
	}

	public void setPbatch(String pbatch) {
		this.pbatch = pbatch;
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

	public Long getPoper() {
		return poper;
	}

	public void setPoper(Long poper) {
		this.poper = poper;
	}

	public List<GoodsBatchStruct> getBatchList() {
		return batchList;
	}

	public void setBatchList(List<GoodsBatchStruct> batchList) {
		this.batchList = batchList;
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

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getSgrNo() {
		return sgrNo;
	}

	public void setSgrNo(String sgrNo) {
		this.sgrNo = sgrNo;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	@Override
	public String toString() {
		return "GoodsStruct [p_inbound_no=" + p_inbound_no + ", pplan=" + pplan
				+ ", pbatch=" + pbatch + ", pwarehouse=" + pwarehouse
				+ ", popertype=" + popertype + ", poper=" + poper + ", code="
				+ code + ", sgrNo=" + sgrNo + ", remark=" + remark
				+ ", batchList=" + batchList + ", c_errorcode=" + c_errorcode
				+ ", c_errormesg=" + c_errormesg + "]";
	}
	
	

}

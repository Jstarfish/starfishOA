package cls.pilottery.web.goodsreceipts.model;

public class DamageVo {
   private Long opradmin;
   private int checktype;// 批次入库损毁 2 调拨损毁 3 盘点损毁

   private String refcode;//参考编号 
   private String remark;
   private String extendarg;
   private String registercode;//损毁编号
	private Integer c_errcode;               
	private String c_errmsg;
public Long getOpradmin() {
	return opradmin;
}
public void setOpradmin(Long opradmin) {
	this.opradmin = opradmin;
}
public int getChecktype() {
	return checktype;
}
public void setChecktype(int checktype) {
	this.checktype = checktype;
}
public String getRefcode() {
	return refcode;
}
public void setRefcode(String refcode) {
	this.refcode = refcode;
}
public String getRemark() {
	return remark;
}
public void setRemark(String remark) {
	this.remark = remark;
}
public String getExtendarg() {
	return extendarg;
}
public void setExtendarg(String extendarg) {
	this.extendarg = extendarg;
}
public String getRegistercode() {
	return registercode;
}
public void setRegistercode(String registercode) {
	this.registercode = registercode;
}
public Integer getC_errcode() {
	return c_errcode;
}
public void setC_errcode(Integer c_errcode) {
	this.c_errcode = c_errcode;
}
public String getC_errmsg() {
	return c_errmsg;
}
public void setC_errmsg(String c_errmsg) {
	this.c_errmsg = c_errmsg;
}
   
}

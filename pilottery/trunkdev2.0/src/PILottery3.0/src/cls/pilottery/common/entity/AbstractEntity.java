package cls.pilottery.common.entity;

import org.apache.log4j.Logger;

public abstract class AbstractEntity implements java.io.Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7903270689597265089L;
	
	static Logger logger = Logger.getLogger(AbstractEntity.class);

	//分页参数
	private Integer beginNum;
	private Integer endNum;
	
	// 调用sp返回的错误参数
	private Integer c_errcode;               
    private String c_errmsg;
    
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
	public Integer getBeginNum() {
		return beginNum;
	}
	public void setBeginNum(Integer beginNum) {
		this.beginNum = beginNum;
	}
	public Integer getEndNum() {
		return endNum;
	}
	public void setEndNum(Integer endNum) {
		this.endNum = endNum;
	}
	
	

}


package cls.pilottery.web.capital.model;

import java.util.List;

/*
 * 组织结构账户扩展类
 * 
 * add by dzg
 * 方便组织一些参数
 * 
 */
public class InstitutionAccountExt extends InstitutionAccount {

	/**
	 * 序列化
	 */
	private static final long serialVersionUID = 170193637953252295L;

	/*
	 * 方案授权信息列表
	 */
	private List<InstitutionCommRate> iCommRateList;

	/*
	 * 错误编码 0 成功
	 */
	private int errCode;

	/*
	 * 错误描述
	 */
	private String errMessage;

	public List<InstitutionCommRate> getiCommRateList() {
		return iCommRateList;
	}

	public void setiCommRateList(List<InstitutionCommRate> iCommRateList) {
		this.iCommRateList = iCommRateList;
	}

	public int getErrCode() {
		return errCode;
	}

	public void setErrCode(int errCode) {
		this.errCode = errCode;
	}

	public String getErrMessage() {
		return errMessage;
	}

	public void setErrMessage(String errMessage) {
		this.errMessage = errMessage;
	}

}

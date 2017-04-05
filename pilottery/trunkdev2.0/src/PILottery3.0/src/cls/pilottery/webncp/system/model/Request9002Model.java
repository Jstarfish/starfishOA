package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

/**
 * 
 * @Description: 数据采集完成通知
 * @author: starfish
 * @date: 2016-2-25 上午9:22:15
 * 
 */
public class Request9002Model extends BaseRequest {

	private static final long serialVersionUID = -4832383555245171777L;

	private String reqSeq;
	private String fileName;
	private Integer apply_status;

	public String getReqSeq() {
		return reqSeq;
	}

	public void setReqSeq(String reqSeq) {
		this.reqSeq = reqSeq;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Integer getApply_status() {
		return apply_status;
	}

	public void setApply_status(Integer apply_status) {
		this.apply_status = apply_status;
	}

}

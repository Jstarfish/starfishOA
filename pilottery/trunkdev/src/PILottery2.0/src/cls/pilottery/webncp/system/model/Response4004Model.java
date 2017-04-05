package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response4004Model extends BaseResponse {

	private static final long serialVersionUID = 7787193156400114027L;
	private String notCode;   //通知序号
	private String sendTime;  //通知时间
	private String title;     //通知题目
	private String content;   //通知内容
	
	public String getNotCode() {
		return notCode;
	}
	public void setNotCode(String notCode) {
		this.notCode = notCode;
	}
	
	public String getSendTime() {
		return sendTime;
	}
	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
}

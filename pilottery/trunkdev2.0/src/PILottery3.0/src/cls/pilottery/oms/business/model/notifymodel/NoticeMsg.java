package cls.pilottery.oms.business.model.notifymodel;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

/**
 * 
 *	@Description: 用在即使消息和票面信息发布后发消息	
 *	@author: starfish 
 *  @date: 2016-3-2 上午10:06:57
 *
 */
public class NoticeMsg extends BaseEntity{

	private static final long serialVersionUID = 6689638799992204574L;
		//区域级别
		private int ctrlLevel;
		//区域级别控制码
		private String ctrlCode;
		//通知消息创建时间
		private Date createTime;
		//通知消息发送时间
		private Date sendTime;
		//设备目标（0：终端机 1：TDS）
		private int who;
		//通知消息长度
		private int length;
		//通知消息，长度为通知消息长度
		private String message;
		//票面信息
		private String slogan;
		
		public int getCtrlLevel() {
			return ctrlLevel;
		}
		public void setCtrlLevel(int ctrlLevel) {
			this.ctrlLevel = ctrlLevel;
		}
		public String getCtrlCode() {
			return ctrlCode;
		}
		public void setCtrlCode(String ctrlCode) {
			this.ctrlCode = ctrlCode;
		}
		public Date getCreateTime() {
			return createTime;
		}
		public void setCreateTime(Date createTime) {
			this.createTime = createTime;
		}
		public Date getSendTime() {
			return sendTime;
		}
		public void setSendTime(Date sendTime) {
			this.sendTime = sendTime;
		}
		public int getWho() {
			return who;
		}
		public void setWho(int who) {
			this.who = who;
		}
		public int getLength() {
			return length;
		}
		public void setLength(int length) {
			this.length = length;
		}
		public String getMessage() {
			return message;
		}
		public void setMessage(String message) {
			this.message = message;
		}
		public String getSlogan() {
			return slogan;
		}
		public void setSlogan(String slogan) {
			this.slogan = slogan;
		}
}

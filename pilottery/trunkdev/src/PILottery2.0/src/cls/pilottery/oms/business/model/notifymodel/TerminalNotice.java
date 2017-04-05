package cls.pilottery.oms.business.model.notifymodel;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

/**
 * 
 *	@Description: 终端通知实体	
 *	@author: starfish 
 *  @date: 2016-3-2 上午10:03:54
 *
 */
public class TerminalNotice extends BaseEntity{
	private static final long serialVersionUID = 1L;
	private long noticeId;
	private int objLevel;
	private long objId;
	private String objIds;
	private String objNames;
	private int positionId;
	private int displayTime;
	private String levelIds;
	//发送人
	private long adminId;
	private String adminAccount;
	private String adminRealname;
	private String title;
	private String content;
	private Date createTime;
	private String creatTimeToChar;
	private Date sendTime;
	private String sendTimeToChar;
	private int status;
	
	public long getNoticeId() {
		return noticeId;
	}
	public void setNoticeId(long noticeId) {
		this.noticeId = noticeId;
	}
	public int getObjLevel() {
		return objLevel;
	}
	public void setObjLevel(int objLevel) {
		this.objLevel = objLevel;
	}
	public long getObjId() {
		return objId;
	}
	public void setObjId(long objId) {
		this.objId = objId;
	}
	public long getAdminId() {
		return adminId;
	}
	public void setAdminId(Long id) {
		this.adminId = id;
	}
	public String getAdminAccount() {
		return adminAccount;
	}
	public void setAdminAccount(String adminAccount) {
		this.adminAccount = adminAccount;
	}
	public String getAdminRealname() {
		return adminRealname;
	}
	public void setAdminRealname(String adminRealname) {
		this.adminRealname = adminRealname;
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
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getObjIds() {
		return objIds;
	}
	public void setObjIds(String objIds) {
		this.objIds = objIds;
	}
	public String getObjNames() {
		return objNames;
	}
	public void setObjNames(String objNames) {
		this.objNames = objNames;
	}
	public int getPositionId() {
		return positionId;
	}
	public void setPositionId(int positionId) {
		this.positionId = positionId;
	}
	public int getDisplayTime() {
		return displayTime;
	}
	public void setDisplayTime(int displayTime) {
		this.displayTime = displayTime;
	}
	public String getLevelIds() {
		return levelIds;
	}
	public void setLevelIds(String levelIds) {
		this.levelIds = levelIds;
	}
	public String getSendTimeToChar() {
		return sendTimeToChar;
	}
	public void setSendTimeToChar(String sendTimeToChar) {
		this.sendTimeToChar = sendTimeToChar;
	}
	public String getCreatTimeToChar() {
		return creatTimeToChar;
	}
	public void setCreatTimeToChar(String creatTimeToChar) {
		this.creatTimeToChar = creatTimeToChar;
	}

}

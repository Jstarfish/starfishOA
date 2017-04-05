package cls.pilottery.oms.monitor.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

public class Events extends BaseEntity {

	private static final long serialVersionUID = 8472078335290731983L;

	private long eventId; // EVENT_ID 事件ID
	private String serverAddr; // SERVER_ADDR 服务器IP
	private int eventType; // EVENT_TYPE 事件类型（1=系统；2=交易；3=游戏；4=业务）
	private int eventLevel; // EVENT_LEVEL 事件级别（1=信息；2=警告；3=错误；4=致命）
	private String eventContent; // EVENT_CONTENT 事件内容
	private Date eventTime; // EVENT_TIME 事件发生时间

	public long getEventId() {
		return eventId;
	}

	public void setEventId(long eventId) {
		this.eventId = eventId;
	}

	public String getServerAddr() {
		return serverAddr;
	}

	public void setServerAddr(String serverAddr) {
		this.serverAddr = serverAddr;
	}

	public int getEventType() {
		return eventType;
	}

	public void setEventType(int eventType) {
		this.eventType = eventType;
	}

	public int getEventLevel() {
		return eventLevel;
	}

	public void setEventLevel(int eventLevel) {
		this.eventLevel = eventLevel;
	}

	public String getEventContent() {
		return eventContent;
	}

	public void setEventContent(String eventContent) {
		this.eventContent = eventContent;
	}

	public Date getEventTime() {
		return eventTime;
	}

	public void setEventTime(Date eventTime) {
		this.eventTime = eventTime;
	}

}

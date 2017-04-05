package cls.pilottery.oms.issue.model;

import cls.pilottery.common.model.BaseEntity;
/**
 *  系统设备(INF_DEVICES)
 *  
 *  @author Woo
 */
public class GameDrawDevice extends BaseEntity{

	private static final long serialVersionUID = 570497798237310614L;

	private Long id;		//DEVICE_ID		设备编号
	private String name;	//DEVICE_NAME	设备名称
	private String ipAddr;	//IP_ADDR		IP地址
	private Short type;		//DEVICE_TYPE	设备类型
	private Integer status;	//DEVICE_STATUS	设备状态（0=未知状态，1=已连接，2=正在初始化，3=工作中，4=断开连接）
	private Short gameCode;	//GAME_CODE		游戏编码
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIpAddr() {
		return ipAddr;
	}
	public void setIpAddr(String ipAddr) {
		this.ipAddr = ipAddr;
	}
	public Short getType() {
		return type;
	}
	public void setType(Short type) {
		this.type = type;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	
}

package cls.pilottery.oms.common.msg;

import java.io.Serializable;

public class UpdateGameServiceTime2019Req implements Serializable {

	private static final long serialVersionUID = -1243038914548372953L;
	public Short gameCode;         // u8
	public Long  service_time_1_b; // u32;
	public Long  service_time_1_e; // u32;
	public Long  service_time_2_b; // u32;
	public Long  service_time_2_e; // u32;
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	
	public Long getService_time_1_b() {
		return service_time_1_b;
	}
	public void setService_time_1_b(Long service_time_1_b) {
		this.service_time_1_b = service_time_1_b;
	}
	
	public Long getService_time_1_e() {
		return service_time_1_e;
	}
	public void setService_time_1_e(Long service_time_1_e) {
		this.service_time_1_e = service_time_1_e;
	}
	
	public Long getService_time_2_b() {
		return service_time_2_b;
	}
	public void setService_time_2_b(Long service_time_2_b) {
		this.service_time_2_b = service_time_2_b;
	}
	
	public Long getService_time_2_e() {
		return service_time_2_e;
	}
	public void setService_time_2_e(Long service_time_2_e) {
		this.service_time_2_e = service_time_2_e;
	}
}

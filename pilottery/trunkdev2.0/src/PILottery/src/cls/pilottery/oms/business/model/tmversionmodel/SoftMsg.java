package cls.pilottery.oms.business.model.tmversionmodel;

import java.io.Serializable;

public class SoftMsg implements Serializable {

	/**
     * 
     */
	private static final long serialVersionUID = 1L;
	private int machineType;// uint8机器型号
	private String versionNO;// 软件版本号
	private int enable;// 版本可用状态

	public int getMachineType() {
		return machineType;
	}

	public void setMachineType(int machineType) {
		this.machineType = machineType;
	}

	public String getVersionNO() {
		return versionNO;
	}

	public void setVersionNO(String versionNO) {
		this.versionNO = versionNO;
	}

	public int getEnable() {
		return enable;
	}

	public void setEnable(int enable) {
		this.enable = enable;
	}

}

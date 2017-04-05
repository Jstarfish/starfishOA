package cls.pilottery.web.area.model;

import java.io.Serializable;

public class Areas implements Serializable{
	private static final long serialVersionUID = 1L;

	private String areaCode;

    private String areaName;

    private String superArea;

    private Short status;

    private Short areaType;

    private Integer areaC;
    
	public Integer getAreaC() {
	
		return areaC;
	}

	
	public void setAreaC(Integer areaC) {
	
		this.areaC = areaC;
	}

	public String getAreaCode() {
        return areaCode;
    }

    public void setAreaCode(String areaCode) {
        this.areaCode = areaCode == null ? null : areaCode.trim();
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName == null ? null : areaName.trim();
    }

    public String getSuperArea() {
        return superArea;
    }

    public void setSuperArea(String superArea) {
        this.superArea = superArea == null ? null : superArea.trim();
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public Short getAreaType() {
        return areaType;
    }

    public void setAreaType(Short areaType) {
        this.areaType = areaType;
    }
}
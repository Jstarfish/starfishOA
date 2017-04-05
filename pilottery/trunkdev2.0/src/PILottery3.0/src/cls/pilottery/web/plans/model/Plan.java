package cls.pilottery.web.plans.model;

import java.io.Serializable;

/**
 * @ClassName Plan
 * @Description
 * @author Wang Qingxiang
 * @date 2015-09-15
 */
public class Plan implements Serializable {

	@Override
	public String toString() {

		return "Plan [planCode=" + planCode + ", fullName=" + fullName + ", shortName=" + shortName + ", faceValue="
				+ faceValue + ", publisherCode=" + publisherCode + ", oldCode=" + oldCode + "]";
	}

	private static final long serialVersionUID = 706534585190929414L;

	private String planCode;

	private String fullName;

	private String shortName;

	private Integer faceValue;

	private Integer publisherCode;

	private String oldCode;

	private short printerCode;

	public Plan() {

	}

	public Plan(String pCode , String pName , int amount , short printercode) {

		this.planCode = pCode;
		this.fullName = pName;
		this.faceValue = amount;
		this.printerCode = printercode;
	}

	public short getPrinterCode() {

		return printerCode;
	}

	public void setPrinterCode(short printerCode) {

		this.printerCode = printerCode;
	}

	public String getOldCode() {

		return oldCode;
	}

	public void setOldCode(String oldCode) {

		this.oldCode = oldCode;
	}

	public String getPlanCode() {

		return planCode;
	}

	public void setPlanCode(String planCode) {

		this.planCode = planCode == null ? null : planCode.trim();
	}

	public String getFullName() {

		return fullName;
	}

	public void setFullName(String fullName) {

		this.fullName = fullName == null ? null : fullName.trim();
	}

	public String getShortName() {

		return shortName;
	}

	public void setShortName(String shortName) {

		this.shortName = shortName == null ? null : shortName.trim();
	}

	public Integer getFaceValue() {

		return faceValue;
	}

	public void setFaceValue(Integer faceValue) {

		this.faceValue = faceValue;
	}

	public Integer getPublisherCode() {

		return publisherCode;
	}

	public void setPublisherCode(Integer publisherCode) {

		this.publisherCode = publisherCode;
	}
}

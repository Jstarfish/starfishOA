package cls.pilottery.web.plans.model;

import java.io.Serializable;

/**
 * @ClassName PlanPublisher
 * @Description
 * @author Wang Qingxiang
 * @date 2015-09-10
 */

public class PlanPublisher implements Serializable {
	private static final long serialVersionUID = 706534585190929414L;

	private String planCode;

	private String fullName;

	private String shortName;

	private Integer faceValue;

	private Integer publisherCode;

	private String publisherName;

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

	public String getPublisherName() {

		return publisherName;
	}

	public void setPublisherName(String publisherName) {

		this.publisherName = publisherName == null ? null : publisherName.trim();
	}
}

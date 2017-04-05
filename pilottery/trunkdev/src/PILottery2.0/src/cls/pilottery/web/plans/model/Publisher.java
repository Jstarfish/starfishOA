package cls.pilottery.web.plans.model;

import java.io.Serializable;

/**
 * @ClassName Publisher
 * @Description
 * @author Wang Qingxiang
 * @date 2015-09-15
 */
public class Publisher implements Serializable {

	private static final long serialVersionUID = 7611738688340205559L;


	private Integer publisherCode;

	private String publisherName;

	private Integer isValid;

	private Integer workFlow;

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

	public Integer getIsValid() {

		return isValid;
	}

	public void setIsValid(Integer isValid) {

		this.isValid = isValid;
	}

	public Integer getWorkFlow() {

		return workFlow;
	}

	public void setWorkFlow(Integer workFlow) {

		this.workFlow = workFlow;
	}
}

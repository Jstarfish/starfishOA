package cls.pilottery.web.plans.form;

import cls.pilottery.common.model.BaseEntity;

/**
 * @ClassName PlanForm
 * @Description
 * @author Wang Qingxiang
 * @date 2015-09-10
 */
public class PlanForm extends BaseEntity {

	private static final long serialVersionUID = 2311526433406596410L;

	private String insCode;

	private String planCodeQuery;

	private String planNameQuery;

	private String batchNoQuery;

	private String publisherNameQuery;

	public String getBatchNoQuery() {

		return batchNoQuery;
	}

	public String getInsCode() {

		return insCode;
	}

	public String getPlanCodeQuery() {

		return planCodeQuery;
	}

	public String getPlanNameQuery() {

		return planNameQuery;
	}

	public String getPublisherNameQuery() {

		return publisherNameQuery;
	}

	public void setBatchNoQuery(String batchNoQuery) {

		this.batchNoQuery = batchNoQuery;
	}

	public void setInsCode(String insCode) {

		this.insCode = insCode;
	}

	public void setPlanCodeQuery(String planCodeQuery) {

		this.planCodeQuery = planCodeQuery == null ? null : planCodeQuery.trim();
	}

	public void setPlanNameQuery(String planNameQuery) {

		this.planNameQuery = planNameQuery == null ? null : planNameQuery.trim();
	}

	public void setPublisherNameQuery(String publisherNameQuery) {

		this.publisherNameQuery = publisherNameQuery == null ? null : publisherNameQuery.trim();
	}

	@Override
	public String toString() {

		return "PlanForm [planCodeQuery=" + planCodeQuery + ", planNameQuery=" + planNameQuery
				+ ", publisherNameQuery=" + publisherNameQuery + "]";
	}
}

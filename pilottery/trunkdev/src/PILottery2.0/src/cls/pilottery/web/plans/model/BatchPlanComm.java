package cls.pilottery.web.plans.model;

import cls.pilottery.common.model.BaseEntity;

public class BatchPlanComm extends BaseEntity {
	private static final long serialVersionUID = 5361951717022061805L;

	private String referPlan;
	
	private String planCode;

	public String getReferPlan() {
		return referPlan;
	}

	public void setReferPlan(String referPlan) {
		this.referPlan = referPlan;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	@Override
	public String toString() {
		return "BatchPlanComm [planCode=" + planCode + ", referPlan=" + referPlan + "]";
	}
}

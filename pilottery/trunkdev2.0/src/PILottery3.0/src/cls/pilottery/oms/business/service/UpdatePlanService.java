package cls.pilottery.oms.business.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.business.form.tmversionform.PlanQueryForm;
import cls.pilottery.oms.business.model.tmversionmodel.PlanTermProgress;
import cls.pilottery.oms.business.model.tmversionmodel.UpdatePlan;

public interface UpdatePlanService {

	Integer countPlanList(PlanQueryForm planForm);

	List<UpdatePlan> queryPlanList(PlanQueryForm planForm);

	// void insertPlan(UpdatePlan plan);

	void updatePlan(UpdatePlan plan);

	void updateUpdateTime(UpdatePlan plan);

	void updateUpdateTimeToNow(UpdatePlan plan);

	void updatePlanStatus(UpdatePlan plan);

	List<PlanTermProgress> selectPlanTermProgress(UpdatePlan plan);

	Integer ifExistPlanName(Map<?, ?> map);

	void addUpgradePlan(UpdatePlan updatePlan);

	Integer isCorrectTerminalNo(Map<String, String> map);
}

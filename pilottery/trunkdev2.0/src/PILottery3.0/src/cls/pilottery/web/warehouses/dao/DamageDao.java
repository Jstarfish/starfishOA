package cls.pilottery.web.warehouses.dao;

import java.util.List;

import cls.pilottery.web.plans.form.PlanForm;
import cls.pilottery.web.warehouses.model.DamageInfo;

public interface DamageDao {

	List<DamageInfo> getDamageList(PlanForm planForm);

	Integer getDamageCount(PlanForm planForm);

	List<DamageInfo> getDamageDetails(String record);

}

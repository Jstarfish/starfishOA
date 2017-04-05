package cls.pilottery.web.marketManager.service;

import java.util.List;

import cls.pilottery.web.marketManager.form.DamegeGoodForm;
import cls.pilottery.web.marketManager.model.GamePlanModel;
import cls.pilottery.web.marketManager.model.InventoryTreeModel;

public interface DamegeGoodService {

	List<GamePlanModel> getPlanListByUser(int userId);

	List<GamePlanModel> getBatchListByPlan(DamegeGoodForm form);

	List<InventoryTreeModel> getTreeByBatch(DamegeGoodForm form);

	void saveDamageGoods(DamegeGoodForm form);

}

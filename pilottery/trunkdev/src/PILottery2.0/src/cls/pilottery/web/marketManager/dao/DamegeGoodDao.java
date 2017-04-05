package cls.pilottery.web.marketManager.dao;

import java.util.List;

import cls.pilottery.web.marketManager.form.DamegeGoodForm;
import cls.pilottery.web.marketManager.model.DamageSumModel;
import cls.pilottery.web.marketManager.model.GamePlanModel;
import cls.pilottery.web.marketManager.model.InventoryTreeModel;
import cls.pilottery.web.sales.model.PlanModel;

public interface DamegeGoodDao {

	List<GamePlanModel> getBatchListByPlan(DamegeGoodForm form);

	List<GamePlanModel> getPlanListByUser(int userId);

	List<InventoryTreeModel> getTreeByBatch(DamegeGoodForm form);

	void updateTrunkStatus(DamegeGoodForm form);

	void updateBoxStatus(DamegeGoodForm form);

	void updatePackageStatus(DamegeGoodForm form);

	void updateInventory(DamegeGoodForm form);

	void updateTrunkIsFull(DamegeGoodForm form);

	void updateBoxIsFull(DamegeGoodForm form);

	DamageSumModel getDamageSum(DamegeGoodForm form);

	String getBrokenRecordSeq();

	void insertBrokenDetailTrunk(DamegeGoodForm form);

	void insertBrokenDetailBox(DamegeGoodForm form);

	void insertBrokenDetailPack(DamegeGoodForm form);

	PlanModel getPlanInfo(DamegeGoodForm form);

	void insertBrokenInfo(DamegeGoodForm form);

}

package cls.pilottery.web.marketManager.dao;

import java.util.List;

import cls.pilottery.web.marketManager.form.RepaymentRecordForm;
import cls.pilottery.web.marketManager.model.InventoryModel;
import cls.pilottery.web.marketManager.model.RepaymentRecordModel;

public interface RepaymentRecordDao {

	int getRepaymentRecordCount(RepaymentRecordForm form);

	List<RepaymentRecordModel> getRepaymentRecordList(RepaymentRecordForm form);

	InventoryModel getInventorySum(int userId);

	List<InventoryModel> getInventoryList(int userId);

}

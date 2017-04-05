package cls.pilottery.web.marketManager.service;

import java.util.List;

import cls.pilottery.web.marketManager.form.RepaymentRecordForm;
import cls.pilottery.web.marketManager.model.InventoryModel;
import cls.pilottery.web.marketManager.model.RepaymentRecordModel;

public interface RepaymentRecordService {

	int getRepaymentRecordCount(RepaymentRecordForm form);

	List<RepaymentRecordModel> getRepaymentRecordList(RepaymentRecordForm form);

	List<InventoryModel> getInventoryList(int intValue);

	InventoryModel getInventorySum(int intValue);

}

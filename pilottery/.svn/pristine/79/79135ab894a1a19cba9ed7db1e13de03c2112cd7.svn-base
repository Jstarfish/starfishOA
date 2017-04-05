package cls.pilottery.web.marketManager.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.marketManager.dao.RepaymentRecordDao;
import cls.pilottery.web.marketManager.form.RepaymentRecordForm;
import cls.pilottery.web.marketManager.model.InventoryModel;
import cls.pilottery.web.marketManager.model.RepaymentRecordModel;
import cls.pilottery.web.marketManager.service.RepaymentRecordService;

@Service
public class RepaymentRecordServiceImpl implements RepaymentRecordService {
	
	@Autowired
	private RepaymentRecordDao repaymentRecordDao;

	@Override
	public int getRepaymentRecordCount(RepaymentRecordForm form) {
		return repaymentRecordDao.getRepaymentRecordCount(form);
	}

	@Override
	public List<RepaymentRecordModel> getRepaymentRecordList(RepaymentRecordForm form) {
		return repaymentRecordDao.getRepaymentRecordList(form);
	}

	@Override
	public List<InventoryModel> getInventoryList(int userId) {
		return repaymentRecordDao.getInventoryList(userId);
	}

	@Override
	public InventoryModel getInventorySum(int userId) {
		return repaymentRecordDao.getInventorySum(userId);
	}

}

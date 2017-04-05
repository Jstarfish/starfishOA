package cls.pilottery.web.marketManager.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.marketManager.dao.TransferRecordDao;
import cls.pilottery.web.marketManager.form.MMTransferRecordForm;
import cls.pilottery.web.marketManager.model.MMTransferRecordModel;
import cls.pilottery.web.marketManager.model.PayoutDetailModel;
import cls.pilottery.web.marketManager.model.ReturnDetailModel;
import cls.pilottery.web.marketManager.model.SalesDetailModel;
import cls.pilottery.web.marketManager.service.TransferRecordService;
@Service
public class TransferRecordServiceImpl implements TransferRecordService{

	@Autowired
	private TransferRecordDao transferRecordDao;
	@Override
	public int getTransferRecordCount(MMTransferRecordForm form) {
		return transferRecordDao.getTransferRecordCount(form);
	}

	@Override
	public List<MMTransferRecordModel> getTransferRecordList(
			MMTransferRecordForm form) {
		return transferRecordDao.getTransferRecordList(form);
	}


	@Override
	public SalesDetailModel getSaleDetailOne(String contractNo) {
		return transferRecordDao.getSaleDetailOne(contractNo);
	}

	@Override
	public List<SalesDetailModel> getSaleDetailTwo(String contractNo) {
		return transferRecordDao.getSaleDetailTwo(contractNo);
	}

	@Override
	public List<SalesDetailModel> getSaleDetailThree(String contractNo) {
		return transferRecordDao.getSaleDetailThree(contractNo);
	}

	

	@Override
	public ReturnDetailModel getReturnDetailOne(String contractNo) {
		return transferRecordDao.getReturnDetailOne(contractNo);
	}

	@Override
	public List<ReturnDetailModel> getReturnDetailTwo(String contractNo) {
		return transferRecordDao.getReturnDetailTwo(contractNo);
	}

	@Override
	public List<ReturnDetailModel> getReturnDetailThree(String contractNo) {
		return transferRecordDao.getReturnDetailThree(contractNo);
	}

	@Override
	public PayoutDetailModel getPayoutDetailOne(String contractNo) {
		return transferRecordDao.getPayoutDetailOne(contractNo);
	}

	@Override
	public List<PayoutDetailModel> getPayoutDetailTwo(String contractNo) {
		// TODO Auto-generated method stub
		return transferRecordDao.getPayoutDetailTwo(contractNo);
	}

	@Override
	public List<PayoutDetailModel> getPayoutDetailThree(String contractNo) {
		// TODO Auto-generated method stub
		return transferRecordDao.getPayoutDetailThree(contractNo);
	}

}

package cls.pilottery.web.marketManager.service;

import java.util.List;

import cls.pilottery.web.marketManager.form.MMTransferRecordForm;
import cls.pilottery.web.marketManager.model.MMTransferRecordModel;
import cls.pilottery.web.marketManager.model.PayoutDetailModel;
import cls.pilottery.web.marketManager.model.ReturnDetailModel;
import cls.pilottery.web.marketManager.model.SalesDetailModel;

public interface TransferRecordService {
	int getTransferRecordCount(MMTransferRecordForm form);

	List<MMTransferRecordModel> getTransferRecordList(MMTransferRecordForm form);

	SalesDetailModel getSaleDetailOne(String contractNo);
	
	List<SalesDetailModel> getSaleDetailTwo(String contractNo);

	List<SalesDetailModel> getSaleDetailThree(String contractNo);
	
	
	PayoutDetailModel getPayoutDetailOne(String contractNo);
	
	List<PayoutDetailModel> getPayoutDetailTwo(String contractNo);
	
	List<PayoutDetailModel> getPayoutDetailThree(String contractNo);

	ReturnDetailModel getReturnDetailOne(String contractNo);
	
	List<ReturnDetailModel> getReturnDetailTwo(String contractNo);
	
	List<ReturnDetailModel> getReturnDetailThree(String contractNo);
}

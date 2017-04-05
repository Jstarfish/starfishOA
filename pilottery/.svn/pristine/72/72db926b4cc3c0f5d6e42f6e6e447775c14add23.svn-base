package cls.pilottery.web.sales.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.sales.entity.StockTransfer;
import cls.pilottery.web.sales.entity.StockTransferDetail;
import cls.pilottery.web.sales.form.TransferForm;
import cls.pilottery.web.sales.model.OrgAccountFlowModel;
import cls.pilottery.web.sales.model.OrgAccountModel;


public interface TransferDao {

	int getTransferCount(TransferForm form);

	List<StockTransfer> getTransferList(TransferForm form);

	String getStockTransferSeq();

	void saveTransferDetail(StockTransferDetail detail);

	void saveStockTransfer(StockTransfer order);

	int modifyStockTransfer(Map<String, Object> map);

	StockTransfer getTransferDetail(String stbNo);

	void deleteTransferDetails(String stbNo);

	void updateStockTransfer(StockTransfer order);

	void updateStockTransferAproval(StockTransfer order);

	int getTransferCountForInquery(TransferForm form);

	List<StockTransfer> getTransferListForInquery(TransferForm form);

	OrgAccountModel getOrgAccountInfo(String orgCode);

	void updateOrgAccountBalance(OrgAccountModel rcvAccount);

	void insertOrgAccountFlow(OrgAccountFlowModel accountFlow);
}

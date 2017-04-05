package cls.pilottery.web.sales.service;

import java.util.List;

import cls.pilottery.web.sales.entity.PurchaseOrder;
import cls.pilottery.web.sales.entity.StockTransfer;
import cls.pilottery.web.sales.form.TransferForm;

public interface TransferService {

	int getTransferCount(TransferForm form);

	List<StockTransfer> getTransferList(TransferForm form);

	void saveStockTransfer(StockTransfer order);

	int modifyStockTransferStatus(String stbNo, int status);

	StockTransfer getTransferDetail(String stbNo);

	void updateStockTransfer(StockTransfer order);

	int updateStockTransferAproval(StockTransfer order);

	int getTransferCountForInquery(TransferForm form);

	List<StockTransfer> getTransferListForInquery(TransferForm form);

	int expiredStockTransfer(String stbNo,long userId);

}

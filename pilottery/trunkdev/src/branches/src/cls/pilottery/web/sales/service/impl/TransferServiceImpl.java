package cls.pilottery.web.sales.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.web.sales.dao.TransferDao;
import cls.pilottery.web.sales.entity.StockTransfer;
import cls.pilottery.web.sales.entity.StockTransferDetail;
import cls.pilottery.web.sales.form.TransferForm;
import cls.pilottery.web.sales.model.OrgAccountFlowModel;
import cls.pilottery.web.sales.model.OrgAccountModel;
import cls.pilottery.web.sales.service.TransferService;

@Service
public class TransferServiceImpl implements TransferService {
	
	@Autowired
	private TransferDao transDao;

	@Override
	public int getTransferCount(TransferForm form) {
		return transDao.getTransferCount(form);
	}

	@Override
	public List<StockTransfer> getTransferList(TransferForm form) {
		return transDao.getTransferList(form);
	}

	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public void saveStockTransfer(StockTransfer order) {
		List<StockTransferDetail> transferDetail = order.getTransferDetail();
		String stbNo = transDao.getStockTransferSeq();
		order.setStbNo(stbNo);
		for(int i=0;i<transferDetail.size();i++){
			StockTransferDetail detail = transferDetail.get(i);
			if(detail != null && detail.getDetailAmount() > 0){
				detail.setStbNo(stbNo);
				for(int k=i+1;k<transferDetail.size();k++){
					StockTransferDetail detail2 = transferDetail.get(k);
					if(detail2 != null && detail2.getDetailAmount()>0 && detail.getPlanCode().equals(detail2.getPlanCode())){
						detail.setDetailAmount(detail.getDetailAmount()+detail2.getDetailAmount());
						detail.setPackages(detail.getPackages()+detail2.getPackages());
						detail.setDetailTickets(detail.getDetailTickets()+detail2.getDetailTickets());
						transferDetail.set(k, null);
					}
				}
				transDao.saveTransferDetail(detail);
			}
		}
		transDao.saveStockTransfer(order);
	}

	@Override
	public int modifyStockTransferStatus(String stbNo, int status) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("stbNo", stbNo);
		map.put("status", status);
		return transDao.modifyStockTransfer(map);
	}

	@Override
	public StockTransfer getTransferDetail(String stbNo) {
		return transDao.getTransferDetail(stbNo);
	}
	
	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public void updateStockTransfer(StockTransfer order) {
		List<StockTransferDetail> transferDetail = order.getTransferDetail();
		String stbNo = order.getStbNo();
		transDao.deleteTransferDetails(stbNo);
		for(int i=0;i<transferDetail.size();i++){
			StockTransferDetail detail = transferDetail.get(i);
			if(detail != null && detail.getDetailAmount() > 0){
				detail.setStbNo(stbNo);
				for(int k=i+1;k<transferDetail.size();k++){
					StockTransferDetail detail2 = transferDetail.get(k);
					if(detail2 != null && detail2.getDetailAmount()>0 && detail.getPlanCode().equals(detail2.getPlanCode())){
						detail.setDetailAmount(detail.getDetailAmount()+detail2.getDetailAmount());
						detail.setPackages(detail.getPackages()+detail2.getPackages());
						detail.setDetailTickets(detail.getDetailTickets()+detail2.getDetailTickets());
						transferDetail.set(k, null);
					}
				}
				transDao.saveTransferDetail(detail);
			}
		}
		transDao.updateStockTransfer(order);
	}

	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public int updateStockTransferAproval(StockTransfer order){
		int flag = 0;
		int status = order.getStatus();
		if(status == 7){	//已审批
			StockTransfer  stinfo =  transDao.getTransferDetail(order.getStbNo());
			OrgAccountModel rcvAccount = transDao.getOrgAccountInfo(stinfo.getReceiveOrg());
			if(rcvAccount == null || rcvAccount.getBalance()+rcvAccount.getCredit() < stinfo.getAmount()){
				flag = -1;	//账户余额不足
				order.setStatus(8);
			}else{
				OrgAccountModel sendAccount = transDao.getOrgAccountInfo(stinfo.getSendOrg());
				rcvAccount.setBalance(rcvAccount.getBalance()-stinfo.getAmount());
				sendAccount.setBalance(sendAccount.getBalance()+stinfo.getAmount());
				OrgAccountFlowModel rcvFlow = new OrgAccountFlowModel();
				OrgAccountFlowModel sendFlow = new OrgAccountFlowModel();
				rcvFlow.setAccountNo(rcvAccount.getAccountNo());
				sendFlow.setAccountNo(sendAccount.getAccountNo());
				rcvFlow.setRefNo(stinfo.getStbNo());
				sendFlow.setRefNo(stinfo.getStbNo());
				rcvFlow.setOrgCode(rcvAccount.getOrgCode());
				sendFlow.setOrgCode(sendAccount.getOrgCode());
				rcvFlow.setChangeAmount(-stinfo.getAmount());
				sendFlow.setChangeAmount(stinfo.getAmount());
				rcvFlow.setFrozen(0);
				sendFlow.setFrozen(0);
				rcvFlow.setBeforeFrozen(rcvAccount.getFrozenBalance());
				rcvFlow.setAfterFrozen(rcvAccount.getFrozenBalance());
				sendFlow.setBeforeFrozen(sendAccount.getFrozenBalance());
				sendFlow.setAfterFrozen(sendAccount.getFrozenBalance());
				rcvFlow.setBeforeAmount(rcvAccount.getBalance());
				rcvFlow.setAfterAmount(rcvAccount.getBalance()-stinfo.getAmount());
				sendFlow.setBeforeAmount(sendAccount.getBalance());
				sendFlow.setAfterAmount(sendAccount.getBalance()+stinfo.getAmount());

				transDao.updateOrgAccountBalance(rcvAccount);
				transDao.insertOrgAccountFlow(rcvFlow);
				transDao.updateOrgAccountBalance(sendAccount);
				transDao.insertOrgAccountFlow(sendFlow);
			}
		}
		
		transDao.updateStockTransferAproval(order);
		return flag;
	}

	@Override
	public int getTransferCountForInquery(TransferForm form) {
		return transDao.getTransferCountForInquery(form);
	}

	@Override
	public List<StockTransfer> getTransferListForInquery(TransferForm form) {
		return transDao.getTransferListForInquery(form);
	} 
}

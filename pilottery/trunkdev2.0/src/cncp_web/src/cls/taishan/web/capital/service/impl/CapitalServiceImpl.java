package cls.taishan.web.capital.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.taishan.web.capital.dao.CapitalDao;
import cls.taishan.web.capital.form.CapitalForm;
import cls.taishan.web.capital.form.TransactionForm;
import cls.taishan.web.capital.model.Capital;
import cls.taishan.web.capital.model.Transactions;
import cls.taishan.web.capital.service.CapitalService;
import cls.taishan.web.dealer.model.Dealer;

@Service
public class CapitalServiceImpl implements CapitalService {

	@Autowired
	private CapitalDao capitalDao;

	@Override
	public List<Transactions> getFundTransaction(TransactionForm form) {
		return capitalDao.getFundTransaction(form);
	}

	@Override
	public List<Dealer> getDealerList() {
		return capitalDao.getDealerList();
	}

	@Override
	public List<Capital> getTopUpList(CapitalForm form) {
		return capitalDao.getTopUpList(form);
	}

	@Override
	public String getDealerNameByCode(String dealerCode) {
		return capitalDao.getDealerNameByCode(dealerCode);
	}

	@Override
	public void topUp(CapitalForm form) {
		capitalDao.topUp(form);
	}

	@Override
	public List<Capital> getWithdrawList(CapitalForm form) {
		return capitalDao.getWithdrawList(form);
	}

	@Override
	public List<Capital> getAdjuetmentList(CapitalForm form) {
		return capitalDao.getAdjustmentList(form);
	}

	@Override
	public void withdraw(CapitalForm form) {
		capitalDao.withdraw(form);
	}

	@Override
	public Capital getDealerInfoByCode(String dealerCode) {
		return capitalDao.getDealerInfoByCode(dealerCode);
	}

	@Override
	public void adjustAccount(CapitalForm form) {
		capitalDao.adjustAccount(form);
	}

	@Override
	public Capital getTopUpInfo(String fundNo) {
		return capitalDao.getTopUpInfo(fundNo);
	}

	@Override
	public Capital getWithdrawInfo(String fundNo) {
		return capitalDao.getWithdrawInfo(fundNo);
	}

	@Override
	public Capital getAdjustmentInfo(String fundNo) {
		return capitalDao.getAdjustmentInfo(fundNo);
	}

	@Override
	public int getTransactionsCount(TransactionForm form) {
		return capitalDao.getTransactionsCount(form);
	}

	@Override
	public List<Dealer> getUsableDealerList() {
		return capitalDao.getUsableDealerList();
	}

}

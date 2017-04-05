package cls.taishan.web.capital.service;

import java.util.List;

import cls.taishan.web.capital.form.CapitalForm;
import cls.taishan.web.capital.form.TransactionForm;
import cls.taishan.web.capital.model.Capital;
import cls.taishan.web.capital.model.Transactions;
import cls.taishan.web.dealer.model.Dealer;

public interface CapitalService {

	List<Transactions> getFundTransaction(TransactionForm form);

	List<Dealer> getDealerList();

	List<Capital> getTopUpList(CapitalForm form);

	String getDealerNameByCode(String dealerCode);

	void topUp(CapitalForm form);

	List<Capital> getWithdrawList(CapitalForm form);

	List<Capital> getAdjuetmentList(CapitalForm form);

	void withdraw(CapitalForm form);

	Capital getDealerInfoByCode(String dealerCode);

	void adjustAccount(CapitalForm form);

	Capital getTopUpInfo(String fundNo);

	Capital getWithdrawInfo(String fundNo);

	Capital getAdjustmentInfo(String fundNo);

	int getTransactionsCount(TransactionForm form);

	List<Dealer> getUsableDealerList();

}
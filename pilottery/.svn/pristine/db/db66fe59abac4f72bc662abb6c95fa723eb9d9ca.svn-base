package cls.taishan.web.capital.dao;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import cls.taishan.web.capital.form.CapitalForm;
import cls.taishan.web.capital.form.TransactionForm;
import cls.taishan.web.capital.model.Capital;
import cls.taishan.web.capital.model.Transactions;
import cls.taishan.web.dealer.model.Dealer;

public interface CapitalDao {

	List<Transactions> getFundTransaction(TransactionForm form);

	@Select("select DEALER_CODE dealerCode,DEALER_NAME dealerName from CNCP_INF_DEALERS")
	List<Dealer> getDealerList();

	List<Capital> getTopUpList(CapitalForm form);

	String getDealerNameByCode(String dealerCode);

	void topUp(CapitalForm form);

	List<Capital> getWithdrawList(CapitalForm form);

	List<Capital> getAdjustmentList(CapitalForm form);

	void withdraw(CapitalForm form);

	Capital getDealerInfoByCode(String dealerCode);

	void adjustAccount(CapitalForm form);

	Capital getTopUpInfo(String fundNo);

	Capital getWithdrawInfo(String fundNo);

	Capital getAdjustmentInfo(String fundNo);

	int getTransactionsCount(TransactionForm form);
	
	@Select("select DEALER_CODE dealerCode,DEALER_NAME dealerName from CNCP_INF_DEALERS where DEALER_STATUS=1")
	List<Dealer> getUsableDealerList();

}

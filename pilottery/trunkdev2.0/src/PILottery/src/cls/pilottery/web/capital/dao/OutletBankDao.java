package cls.pilottery.web.capital.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.capital.form.OutletAcctForm;
import cls.pilottery.web.capital.form.OutletAdjustForm;
import cls.pilottery.web.capital.form.OutletBankQueryForm;
import cls.pilottery.web.capital.model.AdjustmentRecord;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.capital.model.OutletAccountExt;
import cls.pilottery.web.capital.model.OutletAccountModel;
import cls.pilottery.web.capital.model.OutletBankAccount;
import cls.pilottery.web.capital.model.OutletBankTranFlow;
import cls.pilottery.web.goodsreceipts.model.GamePlans;

public interface OutletBankDao {

	 public int getTopupFlowCount(OutletBankQueryForm form);
	 public List<OutletBankTranFlow> getTopupFlow(OutletBankQueryForm form);
	 	 
	 public int getWithdrawFlowCount(OutletBankQueryForm form);
	 public List<OutletBankTranFlow> getWithdrawFlow(OutletBankQueryForm form);
	 	 
	 public int  getOutletListCount(OutletBankQueryForm form);
	 public List<OutletBankAccount> getOutletList(OutletBankQueryForm form);
	 
	 public void insertBankAcc(OutletBankAccount acc);
	 public void updateBankAcc(OutletBankAccount acc);
	 public void updateBankAccStatus(OutletBankAccount acc);
	 public OutletBankAccount getAccInfoById(String accSeq);
	 public OutletBankAccount getOutletInfo(String outletCode);

}

package cls.pilottery.web.capital.service;

import java.util.List;
import cls.pilottery.web.capital.form.OutletBankQueryForm;
import cls.pilottery.web.capital.model.OutletBankAccount;
import cls.pilottery.web.capital.model.OutletBankTranFlow;


public interface OutletBankService {
	
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

package cls.pilottery.web.capital.service.impl;

import java.util.List;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import cls.pilottery.web.capital.dao.OutletBankDao;
import cls.pilottery.web.capital.form.OutletBankQueryForm;
import cls.pilottery.web.capital.model.OutletBankAccount;
import cls.pilottery.web.capital.model.OutletBankTranFlow;
import cls.pilottery.web.capital.service.OutletBankService;

@Service
public class OutletBankServiceImpl implements OutletBankService {

	public static Logger logger = Logger.getLogger(OutletBankServiceImpl.class);
	
	@Autowired
	private OutletBankDao outletBankDao;

	@Override
	public int getTopupFlowCount(OutletBankQueryForm form) {
		return outletBankDao.getTopupFlowCount(form);
	}

	@Override
	public List<OutletBankTranFlow> getTopupFlow(OutletBankQueryForm form) {
		return outletBankDao.getTopupFlow(form);
	}

	@Override
	public int getWithdrawFlowCount(OutletBankQueryForm form) {
		return outletBankDao.getWithdrawFlowCount(form);
	}

	@Override
	public List<OutletBankTranFlow> getWithdrawFlow(OutletBankQueryForm form) {
		return outletBankDao.getWithdrawFlow(form);
	}

	@Override
	public int getOutletListCount(OutletBankQueryForm form) {
		return outletBankDao.getOutletListCount(form);
	}

	@Override
	public List<OutletBankAccount> getOutletList(OutletBankQueryForm form) {
		return outletBankDao.getOutletList(form);
	}

	@Override
	public void insertBankAcc(OutletBankAccount acc) {
		outletBankDao.insertBankAcc(acc);
	}

	@Override
	public void updateBankAcc(OutletBankAccount acc) {
		outletBankDao.updateBankAcc(acc);
	}

	@Override
	public void updateBankAccStatus(OutletBankAccount acc) {
		outletBankDao.updateBankAccStatus(acc);
	}

	@Override
	public OutletBankAccount getAccInfoById(String accSeq) {
		return outletBankDao.getAccInfoById(accSeq);
	}

	@Override
	public OutletBankAccount getOutletInfo(String outletCode) {
		return outletBankDao.getOutletInfo(outletCode);
	}	

}

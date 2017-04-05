package cls.pilottery.web.capital.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cls.pilottery.web.capital.dao.CashWithdrawnDao;
import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.withdrawnmodel.CashWithdrawn;
import cls.pilottery.web.capital.service.CashWithdrawnService;

@Service
public class CashWithdrawnServiceImpl implements CashWithdrawnService{

	@Autowired
	private CashWithdrawnDao cashWithdrawnDao;
	@Override
	public Integer getCashWithdrawnCount(CashWithdrawnForm cashWithdrawnForm) {
		return cashWithdrawnDao.getCashWithdrawnCount(cashWithdrawnForm);
	}
	
	@Override
	public Integer getInstitutionCashWithdrawnCount(
			CashWithdrawnForm cashWithdrawnForm) {
		return cashWithdrawnDao.getInstitutionCashWithdrawnCount(cashWithdrawnForm);
	}

	@Override
	public List<CashWithdrawn> getCashWithdrawnList(
			CashWithdrawnForm cashWithdrawnForm) {
		return cashWithdrawnDao.getCashWithdrawnList(cashWithdrawnForm);
	}
	
	@Override
	public List<CashWithdrawn> getInstitutionCashWithdrawnList(
			CashWithdrawnForm cashWithdrawnForm) {
		return cashWithdrawnDao.getInstitutionCashWithdrawnList(cashWithdrawnForm);
	}
	

	@Transactional(rollbackFor={Exception.class})
	@Override
	public int modifyWithdrawnStatus(String fundNo, int applyStatus) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("fundNo", fundNo);
		map.put("applyStatus", applyStatus);
		return cashWithdrawnDao.modifyWithdrawnStatus(map);
	}

	@Transactional(rollbackFor={Exception.class})
	@Override
	public void deleteWithdrawn(String fundNo) {
		cashWithdrawnDao.deleteWithdrawn(fundNo);
	}

	@Override
	public InstitutionAccount getInstitutionAccountList(String orgCode) {
		return cashWithdrawnDao.getInstitutionAccountList(orgCode);
	}

	@Override
	public void forOrgsCashWithdrawn(CashWithdrawnForm cashWithdrawnForm) {
		cashWithdrawnDao.forOrgsCashWithdrawn(cashWithdrawnForm);
	}

	@Override
	public CashWithdrawn getCashWithdrawnInfo(CashWithdrawn cashWithdrawn) {
		return cashWithdrawnDao.getCashWithdrawnInfo(cashWithdrawn);
	}

	@Override
	public void updateWithdrawnAproval(CashWithdrawnForm cashWithdrawnForm) {
		cashWithdrawnDao.updateWithdrawnAproval(cashWithdrawnForm);
	}

	@Override
	public CashWithdrawn getCashWithdrawnInfoById(String fundNo) {
		return cashWithdrawnDao.getCashWithdrawnInfoById(fundNo);
	}

	@Override
	public void approveWithdrawn(CashWithdrawnForm cashWithdrawnForm) {
		cashWithdrawnDao.approveWithdrawn(cashWithdrawnForm);
		
	/*	note: 分层思想
	 * if(cashWithdrawnForm.getCheckResult() == 1){
			cashWithdrawnDao.approveWithdrawn(cashWithdrawnForm);
		}
		else {
			cashWithdrawnDao.refuseWithdrawn(cashWithdrawnForm);
			cashWithdrawnForm.setC_errcode(0);
		}
		*/
	}

	@Override
	public String getAccNoByOrgCode(String orgCode) {
		return cashWithdrawnDao.getAccNoByOrgCode(orgCode);
	}

	@Override
	public void refuseWithdrawn(CashWithdrawnForm cashWithdrawnForm) {
		cashWithdrawnDao.refuseWithdrawn(cashWithdrawnForm);
	}





	
}

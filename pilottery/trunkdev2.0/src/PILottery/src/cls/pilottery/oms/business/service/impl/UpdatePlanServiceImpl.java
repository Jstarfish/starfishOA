package cls.pilottery.oms.business.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.dao.UpdatePlanDao;
import cls.pilottery.oms.business.form.tmversionform.PlanQueryForm;
import cls.pilottery.oms.business.model.tmversionmodel.PlanTermProgress;
import cls.pilottery.oms.business.model.tmversionmodel.UpdatePlan;
import cls.pilottery.oms.business.service.UpdatePlanService;

@Service
public class UpdatePlanServiceImpl implements UpdatePlanService {

	@Autowired
	private UpdatePlanDao updatePlanDao;

	@Override
	public Integer countPlanList(PlanQueryForm planForm) {
		// TODO Auto-generated method stub
		return updatePlanDao.countPlanList(planForm);
	}

	@Override
	public List<UpdatePlan> queryPlanList(PlanQueryForm planForm) {
		// TODO Auto-generated method stub
		return updatePlanDao.queryPlanList(planForm);
	}

	@Override
/*	public void insertPlan(UpdatePlan plan) {
		// TODO Auto-generated method stub
		
		//get terminals
		List<PlanTerminal> terms = getTerminalsForPlan(plan);
		if( (terms != null)&&(!terms.isEmpty()) )
		{
			//get next id
			Integer curMaxId = updatePlanDao.selectMaxPlanId();
			if(curMaxId == null)
				curMaxId = new Integer(1);
			else
				curMaxId += 1;
			plan.setPlanId(curMaxId);
			
			updatePlanDao.intserPlan(plan);
						
			//update terminals
			for(PlanTerminal term: terms)
			{	term.setPlanId(curMaxId);
				term.setPackVer(plan.getPkgVer());
				updatePlanDao.intserPlanTerminal(term);
			}
		}
	}*/
	/*private boolean isTermCodeStrValid(UpdatePlan plan)
	{
		String termCodesStr = plan.getTermCodes();
		if(termCodesStr == null || termCodesStr.isEmpty())
			return false;
		
		String[] termCodes = termCodesStr.split(",");		
		for(int i=0;i<termCodes.length;i++) // 只要包含一个有效终端编码，认为合法
		{
			if(verifyTermCode(termCodes[i]))
			{
				return true;
			}
		}
		return false;
	}*/
	/*private boolean verifyTermCode(String termCode)
	{
		if((termCode!=null)&&(!termCode.isEmpty()))
		{
			int len = termCode.length();
			if(len >=11 && len <= 12)
			{
				boolean flag = true;
				for(int i=0;i<len;i++)
				{
					if(termCode.charAt(i) < '0' || termCode.charAt(i) > '9')
					{
						flag = false;
						break;
					}
				}
				return flag;
			}
		}
		return false;
	}*/
	/*private List<PlanTerminal> getTerminalsForPlan(UpdatePlan plan)
	{
		List<PlanTerminal> list = new ArrayList<PlanTerminal>();
		if(isTermCodeStrValid(plan))
		{
			String termCodesStr = plan.getTermCodes();
			String[] termCodes = termCodesStr.split(",");
			Long termCode = 0L;
			for(int i=0;i<termCodes.length;i++)
			{
				if(verifyTermCode(termCodes[i]))
				{
					termCode = Long.parseLong(termCodes[i]);
					PlanTerminal pt = new PlanTerminal();
					pt.setTerminalCode(termCode);
					list.add(pt);
				}
			}
			return list;
		}
		if(plan.getCity() !=null)  //市区编码后面加  min:8个0  max: 8个9
		{
			long city = plan.getCity();
			if(city > 99) 
			{
				Long minTerm = 100000000L*city;
				Long maxTerm = minTerm + 99999999L;
				
				PlanTerminalRange range = new PlanTerminalRange();
				range.setMinTerminalCode(minTerm);
				range.setMaxTerminalCode(maxTerm);
				
				list = updatePlanDao.selectPlanTerminal(range);
				return list;
			}
		}
		if(plan.getProvince() !=null)
		{
			long prov = plan.getProvince();
			if(prov >0 && prov <100){
				Long minTerm = 10000000000L*prov;
				Long maxTerm = minTerm + 9999999999L;
				
				PlanTerminalRange range = new PlanTerminalRange();
				range.setMinTerminalCode(minTerm);
				range.setMaxTerminalCode(maxTerm);
				
				list = updatePlanDao.selectPlanTerminal(range);
				return list;
			}
		}
		
		return null;
	}*/

	
	public void updatePlan(UpdatePlan plan) {
		// TODO Auto-generated method stub
		updatePlanDao.updatePlan(plan);
	}

	@Override
	public void updateUpdateTime(UpdatePlan plan) {
		// TODO Auto-generated method stub
		updatePlanDao.updateUpdateTime(plan);
	}

	@Override
	public void updateUpdateTimeToNow(UpdatePlan plan) {
		// TODO Auto-generated method stub
		updatePlanDao.updateUpdateTimeToNow(plan);
	}

	@Override
	public void updatePlanStatus(UpdatePlan plan) {
		// TODO Auto-generated method stub
		updatePlanDao.updatePlanStatus(plan);
	}

	@Override
	public List<PlanTermProgress> selectPlanTermProgress(UpdatePlan plan) {
		// TODO Auto-generated method stub
		return updatePlanDao.selectPlanTermProgress(plan);
	}

	@Override
	public Integer ifExistPlanName(Map<?,?> map) {
		return updatePlanDao.ifExistPlanName(map);
	}

	@Override
	public void addUpgradePlan(UpdatePlan updatePlan) {
		updatePlanDao.addUpgradePlan(updatePlan);
		
	}

	@Override
	public Integer isCorrectTerminalNo(Map<String, String> map) {
		return updatePlanDao.isCorrectTerminalNo(map);
	}
	

}

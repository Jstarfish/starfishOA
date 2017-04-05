package cls.pilottery.web.marketManager.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.web.marketManager.dao.DamegeGoodDao;
import cls.pilottery.web.marketManager.form.DamegeGoodForm;
import cls.pilottery.web.marketManager.model.DamageSumModel;
import cls.pilottery.web.marketManager.model.GamePlanModel;
import cls.pilottery.web.marketManager.model.InventoryTreeModel;
import cls.pilottery.web.marketManager.service.DamegeGoodService;
import cls.pilottery.web.sales.model.PlanModel;

@Service
public class DamegeGoodServiceImpl implements DamegeGoodService {

	@Autowired
	private DamegeGoodDao damegeGoodDao;

	@Override
	public List<GamePlanModel> getBatchListByPlan(DamegeGoodForm form) {
		return damegeGoodDao.getBatchListByPlan(form);
	}

	@Override
	public List<GamePlanModel> getPlanListByUser(int userId) {
		return damegeGoodDao.getPlanListByUser(userId);
	}

	@Override
	public List<InventoryTreeModel> getTreeByBatch(DamegeGoodForm form) {
		return damegeGoodDao.getTreeByBatch(form);
	}

	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public void saveDamageGoods(DamegeGoodForm form) {
		//damageArray=|3,00001,00001-01,0000002|3,00001,00001-03,0000046|3,00001,00001-03,0000047
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String nowDate = sdf.format(new Date());
		form.setOperateDate(nowDate);
		if(StringUtils.isNotEmpty(form.getDamageArray().trim())){
			String[] damageArr = form.getDamageArray().split("#");
			
			String brokenNo = damegeGoodDao.getBrokenRecordSeq();	//取损毁单编号
			form.setBrokenNo(brokenNo);
			PlanModel plan = damegeGoodDao.getPlanInfo(form);
			
			for(int i=0;i<damageArr.length;i++){
				if(StringUtils.isNotEmpty(damageArr[i])){
					String[] arr = damageArr[i].split(",");
					form.setTrunkNo(arr[1]);
					
					switch(Integer.parseInt(arr[0])){
						case 1:		//箱
							damegeGoodDao.updateTrunkStatus(form); 		//更新箱状态
							damegeGoodDao.updateBoxStatus(form);		//更新该箱下所有盒的状态
							damegeGoodDao.updatePackageStatus(form);	//更新该箱下所有本的状态
							form.setPackages(plan.getTrunkPacks());
							form.setAmount(plan.getTrunkPacks()*plan.getPackTickets()*plan.getTicketAmount());
							damegeGoodDao.insertBrokenDetailTrunk(form);		//新增损毁单明细
							break;
						case 2:		//盒
							form.setBoxNo(arr[2]);
							damegeGoodDao.updateTrunkIsFull(form); 		//更新对应箱的是否完整字段为0（不完整），不论之前是否完整都更新
							damegeGoodDao.updateBoxStatus(form);
							damegeGoodDao.updatePackageStatus(form);
							form.setPackages(plan.getBoxPacks());
							form.setAmount(plan.getBoxPacks()*plan.getPackTickets()*plan.getTicketAmount());
							damegeGoodDao.insertBrokenDetailBox(form);		//新增损毁单明细
							break;
						case 3:		//本
							form.setBoxNo(arr[2]);
							form.setPackageNo(arr[3]);
							damegeGoodDao.updateTrunkIsFull(form); 	
							damegeGoodDao.updateBoxIsFull(form);
							damegeGoodDao.updatePackageStatus(form);
							form.setPackages(1);
							form.setAmount(plan.getPackTickets()*plan.getTicketAmount());
							damegeGoodDao.insertBrokenDetailPack(form);		//新增损毁单明细
					}
				}
			}
			DamageSumModel damageSum = damegeGoodDao.getDamageSum(form);
			int totalTickets = damageSum.getDamagePackage()*damageSum.getPackTickets();
			form.setTotalPackages(damageSum.getDamagePackage());
			form.setTotalTickets(totalTickets);
			form.setTotalAmount(totalTickets*damageSum.getTicketAmount());
			damegeGoodDao.updateInventory(form);		//更新当前市场管理员的在手库存数量
			form.setRemark("Submitted by market manager.\r\nReason:"+EnumConfigEN.brokenReason.get(form.getStatus()));
			damegeGoodDao.insertBrokenInfo(form);		//插入损毁单信息
		}
	}
	
}

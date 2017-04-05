package cls.pilottery.web.inventory.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.inventory.dao.InventoryDao;
import cls.pilottery.web.inventory.form.InventoryForm;
import cls.pilottery.web.inventory.model.InventoryVo;
import cls.pilottery.web.inventory.model.WhInfoVo;
import cls.pilottery.web.inventory.service.InventoryService;
@Service
public class InventoryServiceImpl implements InventoryService {
	@Autowired
	private InventoryDao inventoryDao;
	/**
	 * 
	    * @Title: getWhListByorgCode
	    * @Description: 根据orgCode查询仓库
	    * @param @param orgCode
	    * @param @return    参数
	    * @return List<WhInfoVo>    返回类型
	    * @throws
	 */
	@Override
	public List<WhInfoVo> getWhListByorgCode(String orgCode) {
		
		return this.inventoryDao.getWhListByorgCode(orgCode);
	}
	/**
	    * 
	       * @Title: getBatchInfo
	       * @Description:获得批次信息
	       * @param @return    参数
	       * @return List<GameBatchImport>    返回类型
	       * @throws
	    */
	   
	@Override
	public List<GameBatchImport> getBatchInfo() {
		
		return this.inventoryDao.getBatchInfo();
	}
	  /**
	    * 
	       * @Title: getInventoryCount
	       * @Description:分页记录总数
	       * @param @param inventoryForm
	       * @param @return    参数
	       * @return Integer    返回类型
	       * @throws
	    */
	@Override
	public Integer getInventoryCount(InventoryForm inventoryForm) {
		
		return this.inventoryDao.getInventoryCount(inventoryForm);
	}
	  
	   /**
	    * 
	       * @Title: getInventoryList
	       * @Description: 分页查询
	       * @param @param inventoryForm
	       * @param @return    参数
	       * @return List<InventoryVo>    返回类型
	       * @throws
	    */
	@Override
	public List<InventoryVo> getInventoryList(InventoryForm inventoryForm) {
		
		return this.inventoryDao.getInventoryList(inventoryForm);
	}
	  /**
	    * 
	       * @Title: getGroupByCode
	       * @Description: 获得奖组信息
	       * @param @param batchNo
	       * @param @return    参数
	       * @return List<InventoryVo>    返回类型
	       * @throws
	    */
	@Override
	public List<InventoryVo> getGroupByCode(InventoryVo vo) {
		
		return this.inventoryDao.getGroupByCode(vo);
	}
	 /**
	    * 
	       * @Title: getSum
	       * @Description: 分页合计
	       * @param @param inventoryForm
	       * @param @return    参数
	       * @return InventoryVo    返回类型
	       * @throws
	    */
	@Override
	public InventoryVo getSum(InventoryForm inventoryForm) {
		InventoryVo vo=new InventoryVo();
		List<InventoryVo> listvo=this.inventoryDao.getSum(inventoryForm);
		if(listvo!=null && listvo.size()>0){
			vo=listvo.get(0);
		}
		return vo;
	}
	@Override
	public List<GameBatchImport> getBatchListByPlanCode(String planCode) {
		
		return this.inventoryDao.getBatchListByPlanCode(planCode);
	}

}

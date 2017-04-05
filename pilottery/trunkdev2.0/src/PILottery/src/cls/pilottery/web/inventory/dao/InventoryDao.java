package cls.pilottery.web.inventory.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.inventory.form.InventoryForm;
import cls.pilottery.web.inventory.model.InventoryVo;
import cls.pilottery.web.inventory.model.WhInfoVo;

public interface InventoryDao {
	
	/**
	 * 
	    * @Title: getWhListByorgCode
	    * @Description: 根据orgCode查询仓库
	    * @param @param orgCode
	    * @param @return    参数
	    * @return List<WhInfoVo>    返回类型
	    * @throws
	 */
   public List<WhInfoVo> getWhListByorgCode(String orgCode);
   /**
    * 
       * @Title: getBatchInfo
       * @Description:获得批次信息
       * @param @return    参数
       * @return List<GameBatchImport>    返回类型
       * @throws
    */
   public List<GameBatchImport>getBatchInfo();
   /**
    * 
       * @Title: getInventoryCount
       * @Description:分页记录总数
       * @param @param inventoryForm
       * @param @return    参数
       * @return Integer    返回类型
       * @throws
    */
   public Integer getInventoryCount(InventoryForm inventoryForm);
   
   /**
    * 
       * @Title: getInventoryList
       * @Description: 分页查询
       * @param @param inventoryForm
       * @param @return    参数
       * @return List<InventoryVo>    返回类型
       * @throws
    */
   public List<InventoryVo>getInventoryList(InventoryForm inventoryForm);
   /**
    * 
       * @Title: getGroupByCode
       * @Description: 获得奖组信息
       * @param @param batchNo
       * @param @return    参数
       * @return List<InventoryVo>    返回类型
       * @throws
    */
   public List<InventoryVo>getGroupByCode(InventoryVo vo);
   /**
    * 
       * @Title: getSum
       * @Description: 分页合计
       * @param @param inventoryForm
       * @param @return    参数
       * @return List<InventoryVo>    返回类型
       * @throws
    */
   public List<InventoryVo>getSum(InventoryForm inventoryForm);
   public List<GameBatchImport>getBatchListByPlanCode(String planCode);
   public List<WhInfoVo> getWhListByorgCodeList(InventoryForm inventoryForm);
}

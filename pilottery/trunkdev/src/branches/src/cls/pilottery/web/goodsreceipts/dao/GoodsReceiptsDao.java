package cls.pilottery.web.goodsreceipts.dao;

import java.util.List;

import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsreceipts.form.GoodsReceiptsForm;
import cls.pilottery.web.goodsreceipts.model.DamageVo;
import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.goodsreceipts.model.GameBatchImportDetail;
import cls.pilottery.web.goodsreceipts.model.GameBatchParamt;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GamePlans;
import cls.pilottery.web.goodsreceipts.model.GoodReceiptParamt;
import cls.pilottery.web.goodsreceipts.model.GoodsReceiptTrans;
import cls.pilottery.web.goodsreceipts.model.ReturnRecoder;
import cls.pilottery.web.goodsreceipts.model.WhGoodsReceipt;
import cls.pilottery.web.goodsreceipts.model.WhGoodsReceiptDetail;
import cls.pilottery.web.sales.entity.StockTransfer;
/**
 * 
    * @ClassName: GoodsReceiptsDao
    * @Description: 入库dao
    * @author yuyuanhua
    * @date 2015年9月12日
    *
 */
public interface GoodsReceiptsDao {
	/**
	 * 
	    * @Title: getGoodsReceiptCount
	    * @Description: 入库查询记录数
	    * @param @param goodsReceiptsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
	public Integer getGoodsReceiptCount(GoodsReceiptsForm goodsReceiptsForm);
	/**
	 * 
	    * @Title: getGoodsReceiptList
	    * @Description: 分页查询
	    * @param @param goodsReceiptsForm
	    * @param @return    参数
	    * @return List<WhGoodsReceipt>    返回类型
	    * @throws
	 */
	public List<WhGoodsReceipt>getGoodsReceiptList(GoodsReceiptsForm goodsReceiptsForm);
	/**
	 * 
	    * @Title: getGoodsReceiptDetailBysgrNo
	    * @Description: 入库单详情
	    * @param @param sgrNo
	    * @param @return    参数
	    * @return List<WhGoodsReceiptDetail>    返回类型
	    * @throws
	 */
	public List<WhGoodsReceiptDetail>getGoodsReceiptDetailBysgrNo(String sgrNo);
	/**
	 * 
	    * @Title: getAllGamePlan
	    * @Description: 获得方案信息
	    * @param @return    参数
	    * @return List<GamePlans>    返回类型
	    * @throws
	 */
	public List<GamePlans>getAllGamePlan();
	/**
	 * 
	    * @Title: getGameBatchInfoBypanCode
	    * @Description: TODO(这里用一句话描述这个方法的作用)
	    * @param @param planCode
	    * @param @return    参数
	    * @return List<GameBatchImport>    返回类型
	    * @throws
	 */
	public List<GameBatchImport>getGameBatchInfoBypanCode(String planCode);

	/**
	 * 
	    * @Title: getGamePlanOrBatchInfo
	    * @Description: 获取方案，和批次信息
	    * @param @param gameBatchImport
	    * @param @return    参数
	    * @return List<GameBatchImportDetail>    返回类型
	    * @throws
	 */
	public List<GameBatchImportDetail> getGamePlanOrBatchInfo(GoodReceiptParamt goodReceiptParamt);
	/**
	 * 
	    * @Title: addGameBath
	    * @Description: 增加箱入库
	    * @param @param gameBatchParamt    参数
	    * @return void    返回类型
	    * @throws
	 */
	public void addGameBath(GameBatchParamt gameBatchParamt);
	/**
	 * 
	    * @Title: getGamePlanByCode
	    * @Description: 获取方案信息
	    * @param @param planCode
	    * @param @return    参数
	    * @return List<GamePlans>    返回类型
	    * @throws
	 */
	public List<GamePlans>getGamePlanInfoByCode(String planCode);
	/**
	 * 
	    * @Title: getGameReceiptActAmount
	    * @Description: 实际入库张数
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return Long    返回类型
	    * @throws
	 */
	public Long getGameReceiptActAmount(GoodReceiptParamt goodReceiptParamt);
	/**
	 * 
	    * @Title: updateGoodReceiptComplete
	    * @Description: 订单完成
	    * @param @param goodReceiptParamt    参数
	    * @return void    返回类型
	    * @throws
	 */
	public void updateGoodReceiptComplete(GoodReceiptParamt goodReceiptParamt);
	/**
	 * 
	    * @Title: getGoodsDamagedByNo
	    * @Description: 查询损毁信息
	    * @param @param sgrNo
	    * @param @return    参数
	    * @return List<WhGoodsReceipt>    返回类型
	    * @throws
	 */
	public List<WhGoodsReceipt>getGoodsDamagedByNo(String sgrNo);
	public List<WhGoodsReceiptDetail> getGoodsReceiptDetailsumBysgrNo(String sgrNo);
	public WhGoodsReceiptDetail getGoodetailPlancodeByreNO(String sgrNo);
	 public List<StockTransfer>getReciveStrockByorgCode(String orgCode);
	 public GameBatchImportDetail getGamePlanOrBatchInfoSum(GoodReceiptParamt goodReceiptParamt);
	 /**
	  * 
	     * @Title: getGoodsReceiptsPrintList
	     * @Description: 打印入库单信息
	     * @param @param refNo
	     * @param @return    参数
	     * @return List<WhGoodsReceiptDetail>    返回类型
	     * @throws
	  */
	 public List<WhGoodsReceiptDetail>getGoodsReceiptsPrintList(String refNo);
	 /**
	  * 
	     * @Title: getGoodsReceiptsPrintByrefNo
	     * @Description: 打印入库时间，入库单位
	     * @param @param refNo
	     * @param @return    参数
	     * @return List<WhGoodsReceipt>    返回类型
	     * @throws
	  */
	 public List<WhGoodsReceipt> getGoodsReceiptsPrintByrefNo(String refNo);
	 /**
	  * 
	     * @Title: getGoodsReceiptsPrintSumByrefNo
	     * @Description: 入库统计
	     * @param @param refNo
	     * @param @return    参数
	     * @return WhGoodsReceiptDetail    返回类型
	     * @throws
	  */
	 public WhGoodsReceiptDetail getGoodsReceiptsPrintSumByrefNo(String refNo);
	 /**
	  * 
	     * @Title: getGoodsReceiptsTranPrintByStbno
	     * @Description:调拨单出库打印
	     * @param @param refNo
	     * @param @return    参数
	     * @return GoodsReceiptTrans    返回类型
	     * @throws
	  */
	 public GoodsReceiptTrans getGoodsReceiptsTranPrintByStbno(String refNo);
	 /**
	  * 
	     * @Title: getGoodsReceiptsReturnPrintByStbno
	     * @Description: 还货入库打印
	     * @param @param refNo
	     * @param @return    参数
	     * @return ReturnRecoder    返回类型
	     * @throws
	  */
	 public ReturnRecoder  getGoodsReceiptsReturnPrintByStbno(String refNo);
	 public Long getGameReceiptAmount(GoodReceiptParamt goodReceiptParamt);
	 public List<WhGoodsReceiptDetail>getGoodsReceiptsDetailInfoByRefNo(String refNo);
     public void addDamage(DamageVo damageVo);
     public Integer getGoodsReceiptsSumTickts(String refNo);
     public List<GamePlanVo>getGameBatchInfoTemp();
     public List<GoodsIssueDetailVo>getPlanListTemp(String houseCode);
     public List<GoodsIssueDetailVo>getPlanListTempDiff(String houseCode);
}

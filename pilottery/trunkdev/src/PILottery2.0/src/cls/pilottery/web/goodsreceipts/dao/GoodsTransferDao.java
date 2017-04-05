package cls.pilottery.web.goodsreceipts.dao;

import java.util.List;

import cls.pilottery.web.goodsIssues.form.GoodsIssuesForm;
import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.sales.entity.StockTransfer;
/**
 * 
    * @ClassName: GoodsTransferDao
    * @Description: 调拨单入库
    * @author dell
    * @date 2015年9月17日
    *
 */
import cls.pilottery.web.sales.entity.StockTransferDetail;
public interface GoodsTransferDao {
	/**
	 * 
	    * @Title: getSaltranserList
	    * @Description: 获得调拨单列表
	    * @param @return    参数
	    * @return List<StockTransfer>    返回类型
	    * @throws
	 */
 public List<StockTransfer>getSaltranserList(GoodsIssuesForm giform);
 /**
  * 
     * @Title: getSaltranserDitalList
     * @Description:根据调拨单号查询调拨单详情list
     * @param @param stbNo
     * @param @return    参数
     * @return List<StockTransferDetail>    返回类型
     * @throws
  */
 public List<StockTransferDetail>getSaltranserDitalList(String stbNo);
 /**
  * 
     * @Title: getGameBathInfoList
     * @Description: 查询方案批次信息
     * @param @return    参数
     * @return List<GamePlanVo>    返回类型
     * @throws
  */
 public List<GamePlanVo>getGameBathInfoList();
 /**
  * 
     * @Title: getGameRfeNo
     * @Description: 查找入库单引用号
     * @param @param sgrNo
     * @param @return    参数
     * @return String    返回类型
     * @throws
  */
 public String getGameRfeNo(String sgrNo);
 public List<GamePlanVo>getSaltranserGame(String stbNo);
 public List<GoodsIssueDetailVo> getSaltranserInfoListbyCode(String stbNo);
 public List<GoodsIssueDetailVo>getSaltranserInfoListDiffbyCode(String stbNo);

}

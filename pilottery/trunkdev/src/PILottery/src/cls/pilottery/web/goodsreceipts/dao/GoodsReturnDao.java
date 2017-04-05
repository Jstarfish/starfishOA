package cls.pilottery.web.goodsreceipts.dao;

import java.util.List;

import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsreceipts.form.GoodsReceiptsForm;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.RetrurnVo;
import cls.pilottery.web.goodsreceipts.model.ReturnRecoder;
/**
 * 
    * @ClassName: GoodsReturnDao
    * @Description:还货入库
    * @author yuyuanhua
    * @date 2015年9月18日
    *
 */
public interface GoodsReturnDao {
	/**
	 * 
	    * @Title: getReturnInfoList
	    * @Description: 查询还货单编码
	    * @param @return    参数
	    * @return List<ReturnRecoder>    返回类型
	    * @throws
	 */
public List<ReturnRecoder>getReturnInfoList(GoodsReceiptsForm goodsReceiptsForm);
public List<GamePlanVo>getReturnPlanInfoBycode(String returnNo);
 public RetrurnVo getReturnSaleReturner(String returnNo);
 public List<RetrurnVo>getReturnSaleReturnerList(String returnNo);
 public List <GoodsIssueDetailVo>getReturnListInfoByCode(String returnNo);
 public List <GoodsIssueDetailVo> getReturnListInfoDiffByCode(String returnNo);
}

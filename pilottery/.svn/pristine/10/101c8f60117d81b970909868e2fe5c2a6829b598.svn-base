package cls.pilottery.web.goodsreceipts.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.goodsIssues.form.GoodsIssuesForm;
import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsreceipts.dao.GoodsTransferDao;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.service.GoodsTransferService;
import cls.pilottery.web.sales.entity.StockTransfer;
import cls.pilottery.web.sales.entity.StockTransferDetail;

@Service
public class GoodsTransferServiceImpl implements GoodsTransferService{
	@Autowired
   private GoodsTransferDao goodsTransferDao;
	/**
	 * 
	    * @Title: getSaltranserList
	    * @Description: 获得调拨单列表
	    * @param @return    参数
	    * @return List<StockTransfer>    返回类型
	    * @throws
	 */
	@Override
	public List<StockTransfer> getSaltranserList(GoodsIssuesForm giform) {
		
		return goodsTransferDao.getSaltranserList(giform);
	}
	 /**
	  * 
	     * @Title: getSaltranserDitalList
	     * @Description:根据调拨单号查询调拨单详情list
	     * @param @param stbNo
	     * @param @return    参数
	     * @return List<StockTransferDetail>    返回类型
	     * @throws
	  */
	@Override
	public List<StockTransferDetail> getSaltranserDitalList(String stbNo) {
		
		return goodsTransferDao.getSaltranserDitalList(stbNo);
	}
	 /**
	  * 
	     * @Title: getGameBathInfoList
	     * @Description: 查询方案批次信息
	     * @param @return    参数
	     * @return List<GamePlanVo>    返回类型
	     * @throws
	  */
	
	@Override
	public List<GamePlanVo> getGameBathInfoList() {
		
		return goodsTransferDao.getGameBathInfoList();
	}
	 /**
	  * 
	     * @Title: getGameRfeNo
	     * @Description: 查找入库单引用号
	     * @param @param sgrNo
	     * @param @return    参数
	     * @return String    返回类型
	     * @throws
	  */
	
	@Override
	public String getGameRfeNo(String sgrNo) {
	
		return goodsTransferDao.getGameRfeNo(sgrNo);
	}
	@Override
	public List<GamePlanVo> getSaltranserGame(String stbNo) {
		// TODO Auto-generated method stub
		return this.goodsTransferDao.getSaltranserGame(stbNo);
	}
	@Override
	public List<GoodsIssueDetailVo> getSaltranserInfoListbyCode(String stbNo) {
		// TODO Auto-generated method stub
		return this.goodsTransferDao.getSaltranserInfoListbyCode(stbNo);
	}
	@Override
	public List<GoodsIssueDetailVo> getSaltranserInfoListDiffbyCode(String stbNo) {
		// TODO Auto-generated method stub
		return this.goodsTransferDao.getSaltranserInfoListDiffbyCode(stbNo);
	}
}

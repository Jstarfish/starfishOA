package cls.pilottery.web.goodsreceipts.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsreceipts.dao.GoodsReturnDao;
import cls.pilottery.web.goodsreceipts.form.GoodsReceiptsForm;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.RetrurnVo;
import cls.pilottery.web.goodsreceipts.model.ReturnRecoder;
import cls.pilottery.web.goodsreceipts.service.GoodsReturnService;

@Service
public class GoodsReturnServiceImpl implements GoodsReturnService{
	@Autowired
	private GoodsReturnDao  goodsReturnDao ;
	/**
	 * 
	    * @Title: getReturnInfoList
	    * @Description: 查询还货单编码
	    * @param @return    参数
	    * @return List<ReturnRecoder>    返回类型
	    * @throws
	 */

	@Override
	public List<ReturnRecoder> getReturnInfoList(GoodsReceiptsForm goodsReceiptsForm) {

		return goodsReturnDao.getReturnInfoList(goodsReceiptsForm);
	}
	@Override
	public List<GamePlanVo> getReturnPlanInfoBycode(String returnNo) {
	
		return this.goodsReturnDao.getReturnPlanInfoBycode(returnNo);
	}
	@Override
	public RetrurnVo getReturnSaleReturner(String returnNo) {
		
		return this.goodsReturnDao.getReturnSaleReturner(returnNo);
	}
	@Override
	public List<RetrurnVo> getReturnSaleReturnerList(String returnNo) {
		
		return this.goodsReturnDao.getReturnSaleReturnerList(returnNo);
	}
	@Override
	public List<GoodsIssueDetailVo> getReturnListInfoByCode(String returnNo) {

		return this.goodsReturnDao.getReturnListInfoByCode(returnNo);
	}
	@Override
	public List<GoodsIssueDetailVo> getReturnListInfoDiffByCode(String returnNo) {

		return this.goodsReturnDao.getReturnListInfoDiffByCode(returnNo);
	}

}

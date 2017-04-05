package cls.pilottery.web.outlet.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.outlet.dao.OutletGoodsDao;
import cls.pilottery.web.outlet.form.OutletGoodsForm;
import cls.pilottery.web.outlet.model.SaleAgencyReceiptVo;
import cls.pilottery.web.outlet.service.OutletGoodsService;
@Service
public class OutletGoodsServiceImpl implements OutletGoodsService {
     @Autowired
	 private OutletGoodsDao outletGoodsDao;
	/**
	 * 
	    * @Title: getOutletGoodsCount
	    * @Description: 分页记录数
	    * @param @param outletGoodsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
	@Override
	public Integer getOutletGoodsCount(OutletGoodsForm outletGoodsForm) {

		return outletGoodsDao.getOutletGoodsCount(outletGoodsForm);
	}
	/**
	 * 
	    * @Title: getOutletGoodsCountList
	    * @Description: 分页查询
	    * @param @param outletGoodsForm
	    * @param @return    参数
	    * @return List<SaleAgencyReceiptVo>    返回类型
	    * @throws
	 */
	@Override
	public List<SaleAgencyReceiptVo> getOutletGoodsCountList(OutletGoodsForm outletGoodsForm) {
		
		return outletGoodsDao.getOutletGoodsCountList(outletGoodsForm);
	}

}

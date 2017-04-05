package cls.pilottery.web.outlet.service;

import java.util.List;

import cls.pilottery.web.outlet.form.OutletGoodsForm;
import cls.pilottery.web.outlet.model.SaleAgencyReceiptVo;

public interface OutletGoodsService {
	/**
	 * 
	    * @Title: getOutletGoodsCount
	    * @Description: 分页记录数
	    * @param @param outletGoodsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
	public Integer getOutletGoodsCount(OutletGoodsForm outletGoodsForm);
	/**
	 * 
	    * @Title: getOutletGoodsCountList
	    * @Description: 分页查询
	    * @param @param outletGoodsForm
	    * @param @return    参数
	    * @return List<SaleAgencyReceiptVo>    返回类型
	    * @throws
	 */
	public List<SaleAgencyReceiptVo>getOutletGoodsCountList(OutletGoodsForm outletGoodsForm);
}

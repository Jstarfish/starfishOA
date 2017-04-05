package cls.pilottery.web.outlet.service;

import java.util.List;

import cls.pilottery.web.outlet.form.ReturnedGoodsForm;
import cls.pilottery.web.outlet.model.SaleAgencyReturnVo;

public interface ReturnedGoodsService {
	/**
	 * 
	    * @Title: geetSaleReturnCount
	    * @Description:记录总数
	    * @param @param returnedGoodsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
  public Integer geetSaleReturnCount(ReturnedGoodsForm returnedGoodsForm);
	 /**
	   * 
	      * @Title: geetSaleReturnList
	      * @Description: 分页
	      * @param @param returnedGoodsForm
	      * @param @return    参数
	      * @return List<SaleAgencyReturnVo>    返回类型
	      * @throws
	   */
	  public List<SaleAgencyReturnVo>geetSaleReturnList(ReturnedGoodsForm returnedGoodsForm);
}

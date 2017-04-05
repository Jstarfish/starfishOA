package cls.pilottery.web.outlet.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.outlet.dao.ReturnedGoodsDao;
import cls.pilottery.web.outlet.form.ReturnedGoodsForm;
import cls.pilottery.web.outlet.model.SaleAgencyReturnVo;
import cls.pilottery.web.outlet.service.ReturnedGoodsService;
@Service
public class ReturnedGoodsServiceImpl implements ReturnedGoodsService {
	@Autowired
    private ReturnedGoodsDao returnedGoodsDao;
	/**
	 * 
	    * @Title: geetSaleReturnCount
	    * @Description:记录总数
	    * @param @param returnedGoodsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
	@Override
	public Integer geetSaleReturnCount(ReturnedGoodsForm returnedGoodsForm) {
		
		return this.returnedGoodsDao.geetSaleReturnCount(returnedGoodsForm);
	}
	  /**
	   * 
	      * @Title: geetSaleReturnList
	      * @Description: 分页
	      * @param @param returnedGoodsForm
	      * @param @return    参数
	      * @return List<SaleAgencyReturnVo>    返回类型
	      * @throws
	   */
	@Override
	public List<SaleAgencyReturnVo> geetSaleReturnList(ReturnedGoodsForm returnedGoodsForm) {
		
		return this.returnedGoodsDao.geetSaleReturnList(returnedGoodsForm);
	}

}

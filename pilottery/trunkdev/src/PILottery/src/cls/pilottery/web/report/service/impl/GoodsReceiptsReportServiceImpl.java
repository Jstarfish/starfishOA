package cls.pilottery.web.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.report.dao.GoodsReceiptsReportDao;
import cls.pilottery.web.report.form.GoodsReceiptsReportForm;
import cls.pilottery.web.report.model.GoodsReceiptsReportVo;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.service.GoodsReceiptsReportService;
import cls.pilottery.web.warehouses.model.WarehouseInfo;

@Service
public class GoodsReceiptsReportServiceImpl implements GoodsReceiptsReportService{
	@Autowired
  private GoodsReceiptsReportDao goodsReceiptsReportDao;

	@Override
	public List<WarehouseInfo> getheadWhouseList() {
		return this.goodsReceiptsReportDao.getheadWhouseList();
	}

	@Override
	public List<GoodsReceiptsReportVo> getReceiptsReportList(GoodsReceiptsReportForm goodsReceiptsReportForm) {
		
		return this.goodsReceiptsReportDao.getReceiptsReportList(goodsReceiptsReportForm);
	}

	@Override
	public GoodsReceiptsReportVo getheadWhouseListSum(GoodsReceiptsReportForm goodsReceiptsReportForm) {
		
		return this.goodsReceiptsReportDao.getheadWhouseListSum(goodsReceiptsReportForm);
	}

	@Override
	public List<GoodsReceiptsReportVo> getOutReportList(GoodsReceiptsReportForm form) {

		return this.goodsReceiptsReportDao.getOutReportList(form);
	}

	@Override
	public GoodsReceiptsReportVo getheadWhouseListOutSum(GoodsReceiptsReportForm form) {

		return this.goodsReceiptsReportDao.getheadWhouseListOutSum(form);
	}


}

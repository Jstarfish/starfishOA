package cls.pilottery.web.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.report.dao.SaleReportDao;
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.InventoryModel;
import cls.pilottery.web.report.model.SalesReportModel;
import cls.pilottery.web.report.model.WarehouseModel;
import cls.pilottery.web.report.service.SaleReportService;
import cls.pilottery.web.sales.model.PlanModel;

@Service
public class SaleReportServiceImpl implements SaleReportService {

	@Autowired
	private SaleReportDao saleReportDao;
	
	@Override
	public List<SalesReportModel> getGameSalesList(SaleReportForm form) {
		return saleReportDao.getGameSalesList(form);
	}

	@Override
	public List<SalesReportModel> getInstitutionSalesList(SaleReportForm form) {
		return saleReportDao.getInstitutionSalesList(form);
	}

	@Override
	public List<InventoryModel> getInventoryList(SaleReportForm form) {
		return saleReportDao.getInventoryList(form);
	}

	@Override
	public List<WarehouseModel> getWarehouseList(String cuserOrg) {
		return saleReportDao.getWarehouseList(cuserOrg);
	}

	@Override
	public List<InstitutionModel> getInstitutionList(String cuserOrg) {
		return saleReportDao.getInstitutionList(cuserOrg);
	}

	@Override
	public SalesReportModel getGameSalesSum(SaleReportForm form) {
		return saleReportDao.getGameSalesSum(form);
	}

	@Override
	public SalesReportModel getInstitutionSalesSum(SaleReportForm form) {
		return saleReportDao.getInstitutionSalesSum(form);
	}

	@Override
	public InventoryModel getInventorySum(SaleReportForm form) {
		return saleReportDao.getInventorySum(form);
	}

	@Override
	public List<PlanModel> getPlanList() {
		return saleReportDao.getPlanList();
	}

}

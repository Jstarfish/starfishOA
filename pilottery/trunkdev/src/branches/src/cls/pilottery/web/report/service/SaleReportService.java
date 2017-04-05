package cls.pilottery.web.report.service;

import java.util.List;

import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.InventoryModel;
import cls.pilottery.web.report.model.SalesReportModel;
import cls.pilottery.web.report.model.WarehouseModel;
import cls.pilottery.web.sales.model.PlanModel;

public interface SaleReportService {

	List<SalesReportModel> getGameSalesList(SaleReportForm form);

	List<SalesReportModel> getInstitutionSalesList(SaleReportForm form);

	List<InventoryModel> getInventoryList(SaleReportForm form);

	List<WarehouseModel> getWarehouseList(String cuserOrg);

	List<InstitutionModel> getInstitutionList(String cuserOrg);

	InventoryModel getInventorySum(SaleReportForm form);

	SalesReportModel getInstitutionSalesSum(SaleReportForm form);

	SalesReportModel getGameSalesSum(SaleReportForm form);

	List<PlanModel> getPlanList();

}

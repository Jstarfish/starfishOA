package cls.pilottery.web.report.dao;

import java.util.List;

import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.InventoryModel;
import cls.pilottery.web.report.model.SalesReportModel;
import cls.pilottery.web.report.model.WarehouseModel;
import cls.pilottery.web.sales.model.PlanModel;

public interface SaleReportDao {

	List<SalesReportModel> getGameSalesList(SaleReportForm form);

	List<SalesReportModel> getInstitutionSalesList(SaleReportForm form);

	List<InventoryModel> getInventoryList(SaleReportForm form);

	List<WarehouseModel> getWarehouseList(String cuserOrg);

	List<InstitutionModel> getInstitutionList(String cuserOrg);

	SalesReportModel getGameSalesSum(SaleReportForm form);

	SalesReportModel getInstitutionSalesSum(SaleReportForm form);

	InventoryModel getInventorySum(SaleReportForm form);

	List<PlanModel> getPlanList();

}

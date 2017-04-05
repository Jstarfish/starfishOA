package cls.pilottery.web.report.service;

import java.util.List;


import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.InstitutionFundVO;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.InventoryDaliyReportVo;
import cls.pilottery.web.report.model.InventoryModel;
import cls.pilottery.web.report.model.ManagerFundReportVO;
import cls.pilottery.web.report.model.OrgInventoryDaliyReportVo;
import cls.pilottery.web.report.model.OutletFundVO;
import cls.pilottery.web.report.model.OutletInventoryDaliyReportVo;
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

	List<InstitutionFundVO> getInstitutionFundList(SaleReportForm form);

	List<OutletFundVO> getOutletFundList(SaleReportForm form);

	InstitutionFundVO getInstitutionFundListSum(SaleReportForm form);
	
	OutletFundVO getOutletFundListSum(SaleReportForm form);
	public List<InventoryDaliyReportVo>getInventoryDaliyReportList(SaleReportForm form);

	List<ManagerFundReportVO> getMnanagerFundList(SaleReportForm form);

	List<InstitutionFundVO> getInstitutionFundUSDList(SaleReportForm form);

	InstitutionFundVO getInstitutionFundUSDListSum(SaleReportForm form);

	List<OutletFundVO> getOutletFundUSDList(SaleReportForm form);

	OutletFundVO getOutletFundUSDListSum(SaleReportForm form);

	List<OutletInventoryDaliyReportVo> getOutletInventoryDaliyReport(SaleReportForm form);

	List<OrgInventoryDaliyReportVo> getOrgInventoryDaliyReport(SaleReportForm form);

	List<InstitutionFundVO> getInstitutionPayableList(SaleReportForm form);

	InstitutionFundVO getInstitutionPayableListSum(SaleReportForm form);

	List<InstitutionFundVO> getInstitutionPayableUSDList(SaleReportForm form);

	InstitutionFundVO getInstitutionPayableUSDListSum(SaleReportForm form);

	List<InstitutionFundVO> getAgentFundReport(SaleReportForm form);

	InstitutionFundVO getAgentFundReportSum(SaleReportForm form);

	List<InstitutionFundVO> getAgentFundReportUSD(SaleReportForm form);

	InstitutionFundVO getAgentFundReportUSDSum(SaleReportForm form);

}

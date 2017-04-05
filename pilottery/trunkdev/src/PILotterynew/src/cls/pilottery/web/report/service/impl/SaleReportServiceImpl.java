package cls.pilottery.web.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.report.dao.SaleReportDao;
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

	@Override
	public List<InstitutionFundVO> getInstitutionFundList(SaleReportForm form) {
		return saleReportDao.getInstitutionFundList(form);
	}

	@Override
	public List<OutletFundVO> getOutletFundList(SaleReportForm form) {
		return saleReportDao.getOutletFundList(form);
	}

	@Override
	public InstitutionFundVO getInstitutionFundListSum(SaleReportForm form) {
		return saleReportDao.getInstitutionFundListSum(form);
	}

	@Override
	public OutletFundVO getOutletFundListSum(SaleReportForm form) {
		return saleReportDao.getOutletFundListSum(form);
	}


	@Override
	public List<ManagerFundReportVO> getMnanagerFundList(SaleReportForm form) {
		return saleReportDao.getMnanagerFundList(form);
	}

	@Override
	public List<InventoryDaliyReportVo> getInventoryDaliyReportList(SaleReportForm form) {
		
		return saleReportDao.getInventoryDaliyReportList(form);
	}

	@Override
	public List<InstitutionFundVO> getInstitutionFundUSDList(SaleReportForm form) {

		return saleReportDao.getInstitutionFundUSDList(form);
	}

	@Override
	public InstitutionFundVO getInstitutionFundUSDListSum(SaleReportForm form) {

		return saleReportDao.getInstitutionFundUSDListSum(form);
	}

	@Override
	public List<OutletFundVO> getOutletFundUSDList(SaleReportForm form) {

		return saleReportDao.getOutletFundUSDList(form);
	}

	@Override
	public OutletFundVO getOutletFundUSDListSum(SaleReportForm form) {

		return saleReportDao.getOutletFundUSDListSum(form);
	}

	@Override
	public List<OrgInventoryDaliyReportVo> getOrgInventoryDaliyReport(SaleReportForm form) {
		
		return saleReportDao.getOrgInventoryDaliyReport(form);
	}

	@Override
	public List<OutletInventoryDaliyReportVo> getOutletInventoryDaliyReport(SaleReportForm form) {
		
		return saleReportDao.getOutletInventoryDaliyReport(form);
	}

	@Override
	public List<InstitutionFundVO> getInstitutionPayableList(SaleReportForm form) {
		return saleReportDao.getInstitutionPayableList(form);
	}

	@Override
	public InstitutionFundVO getInstitutionPayableListSum(SaleReportForm form) {
		return saleReportDao.getInstitutionPayableListSum(form);
	}

	@Override
	public List<InstitutionFundVO> getInstitutionPayableUSDList(SaleReportForm form) {
		return saleReportDao.getInstitutionPayableUSDList(form);
	}

	@Override
	public InstitutionFundVO getInstitutionPayableUSDListSum(SaleReportForm form) {
		return saleReportDao.getInstitutionPayableUSDListSum(form);
	}

	@Override
	public List<InstitutionFundVO> getAgentFundReport(SaleReportForm form) {
		return saleReportDao.getAgentFundReport(form);
	}

	@Override
	public InstitutionFundVO getAgentFundReportSum(SaleReportForm form) {
		return saleReportDao.getAgentFundReportSum(form);
	}

	@Override
	public List<InstitutionFundVO> getAgentFundReportUSD(SaleReportForm form) {
		return saleReportDao.getAgentFundReportUSD(form);
	}

	@Override
	public InstitutionFundVO getAgentFundReportUSDSum(SaleReportForm form) {
		return saleReportDao.getAgentFundReportUSDSum(form);
	}


}

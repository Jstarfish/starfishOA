package cls.pilottery.web.report.dao;

import java.util.List;

import cls.pilottery.web.report.form.AnalysisStatisticsForm;
import cls.pilottery.web.report.form.NetSalesForm;
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.AuthDetailModel;
import cls.pilottery.web.report.model.InstitutionFundVO;
import cls.pilottery.web.report.model.NetSalesModel;
import cls.pilottery.web.report.model.OutletInfoVO;

public interface AnalysisStatisticsDao {

	List<OutletInfoVO> getAgencyInfoList(AnalysisStatisticsForm form);

	List<OutletInfoVO> getNoSaleOutletsList(AnalysisStatisticsForm form);

	List<InstitutionFundVO> getInstFundReportByLotTypeList(SaleReportForm form);

	InstitutionFundVO getInstFundReportByLotTypeSum(SaleReportForm form);

	List<InstitutionFundVO> getAgentFundReportByLotTypeList(SaleReportForm form);

	InstitutionFundVO getAgentFundReportByLotTypeSum(SaleReportForm form);

	List<AuthDetailModel> getCtgAuthDetail(String agencyCode);

	List<AuthDetailModel> getPilAuthDetail(String agencyCode);
	
	
	List<NetSalesModel> getNetSalesList(NetSalesForm form);

	NetSalesModel getNetSalesSum(NetSalesForm form);

}

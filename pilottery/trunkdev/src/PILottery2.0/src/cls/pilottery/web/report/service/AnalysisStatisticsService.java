package cls.pilottery.web.report.service;

import java.util.List;

import cls.pilottery.web.report.form.AnalysisStatisticsForm;
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.InstitutionFundVO;
import cls.pilottery.web.report.model.OutletInfoVO;

public interface AnalysisStatisticsService {

	List<OutletInfoVO> getAgencyInfoList(AnalysisStatisticsForm form);

	List<OutletInfoVO> getNoSaleOutletsList(AnalysisStatisticsForm form);

	List<InstitutionFundVO> getInstFundReportByLotTypeList(SaleReportForm form);

	InstitutionFundVO getInstFundReportByLotTypeSum(SaleReportForm form);

}

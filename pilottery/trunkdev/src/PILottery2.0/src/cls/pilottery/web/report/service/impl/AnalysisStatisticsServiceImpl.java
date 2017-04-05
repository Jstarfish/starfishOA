package cls.pilottery.web.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.report.dao.AnalysisStatisticsDao;
import cls.pilottery.web.report.form.AnalysisStatisticsForm;
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.InstitutionFundVO;
import cls.pilottery.web.report.model.OutletInfoVO;
import cls.pilottery.web.report.service.AnalysisStatisticsService;

@Service
public class AnalysisStatisticsServiceImpl implements AnalysisStatisticsService {
	@Autowired
	private AnalysisStatisticsDao analysisStatisticsDao;
	
	@Override
	public List<OutletInfoVO> getAgencyInfoList(AnalysisStatisticsForm form) {
		return analysisStatisticsDao.getAgencyInfoList(form);
	}

	@Override
	public List<OutletInfoVO> getNoSaleOutletsList(AnalysisStatisticsForm form) {
		return analysisStatisticsDao.getNoSaleOutletsList(form);
	}

	@Override
	public List<InstitutionFundVO> getInstFundReportByLotTypeList(SaleReportForm form) {
		return analysisStatisticsDao.getInstFundReportByLotTypeList(form);
	}

	@Override
	public InstitutionFundVO getInstFundReportByLotTypeSum(SaleReportForm form) {
		return analysisStatisticsDao.getInstFundReportByLotTypeSum(form);
	}

}

package cls.pilottery.web.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.report.dao.MonthlyReportDao;
import cls.pilottery.web.report.form.MonthlyReportForm;
import cls.pilottery.web.report.model.MonthlyReportVo;
import cls.pilottery.web.report.service.MonthlyReportService;

@Service
public class MonthlyReportServiceImpl implements MonthlyReportService {

	@Autowired
	private MonthlyReportDao monthlyReportDao;

	@Override
	public List<MonthlyReportVo> getInstitutionFundList(MonthlyReportForm form) {
		return monthlyReportDao.getInstitutionFundList(form);
	}

	@Override
	public MonthlyReportVo getInstitutionFundSum(MonthlyReportForm form) {
		return monthlyReportDao.getInstitutionFundSum(form);
	}

	@Override
	public List<MonthlyReportVo> getAgencyFundList(MonthlyReportForm form) {
		return monthlyReportDao.getAgencyFundList(form);
	}

	@Override
	public MonthlyReportVo getAgencyFundSum(MonthlyReportForm form) {
		return monthlyReportDao.getAgencyFundSum(form);
	}

	@Override
	public List<MonthlyReportVo> getMarketManagerFundList(MonthlyReportForm form) {
		return monthlyReportDao.getMarketManagerFundList(form);
	}

	@Override
	public MonthlyReportVo getMarketManagerFundSum(MonthlyReportForm form) {
		return monthlyReportDao.getMarketManagerFundSum(form);
	}

}

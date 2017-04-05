package cls.pilottery.web.report.service;

import java.util.List;

import cls.pilottery.web.report.form.MonthlyReportForm;
import cls.pilottery.web.report.model.MonthlyReportVo;

public interface MonthlyReportService {

	List<MonthlyReportVo> getInstitutionFundList(MonthlyReportForm form);

	MonthlyReportVo getInstitutionFundSum(MonthlyReportForm form);

	List<MonthlyReportVo> getAgencyFundList(MonthlyReportForm form);

	MonthlyReportVo getAgencyFundSum(MonthlyReportForm form);

	List<MonthlyReportVo> getMarketManagerFundList(MonthlyReportForm form);

	MonthlyReportVo getMarketManagerFundSum(MonthlyReportForm form);

}

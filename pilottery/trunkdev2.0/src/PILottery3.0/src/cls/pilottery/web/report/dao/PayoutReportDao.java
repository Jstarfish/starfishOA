package cls.pilottery.web.report.dao;

import java.util.List;

import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.PayoutReportModel;

public interface PayoutReportDao {

	List<PayoutReportModel> getPayoutList(SaleReportForm form);

	PayoutReportModel getPayout(SaleReportForm form);

}

package cls.pilottery.web.report.service;

import java.util.List;

import cls.pilottery.web.report.form.HQItemIssueReportForm;
import cls.pilottery.web.report.model.HQItemIssueReportVo;
import cls.pilottery.web.warehouses.model.WarehouseInfo;

public interface HQItemIssueReportService {
	public List<WarehouseInfo> getAllWarehouseUnderHQ();
	public List<HQItemIssueReportVo> getHQItemIssueReportList(HQItemIssueReportForm hqItemIssueReportForm);
}

package cls.pilottery.web.report.dao;

import java.util.List;

import cls.pilottery.web.report.form.HQItemIssueReportForm;
import cls.pilottery.web.report.model.HQItemIssueReportVo;
import cls.pilottery.web.warehouses.model.WarehouseInfo;

public interface HQItemIssueReportDao {
	public List<WarehouseInfo> getAllWarehouseUnderHQ();
	public List<HQItemIssueReportVo> getHQItemIssueReportList(HQItemIssueReportForm hqItemIssueReportForm);
}

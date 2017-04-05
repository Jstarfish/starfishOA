package cls.pilottery.web.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.report.dao.HQItemIssueReportDao;
import cls.pilottery.web.report.form.HQItemIssueReportForm;
import cls.pilottery.web.report.model.HQItemIssueReportVo;
import cls.pilottery.web.report.service.HQItemIssueReportService;
import cls.pilottery.web.warehouses.model.WarehouseInfo;

@Service
public class HQItemIssueReportServiceImpl implements HQItemIssueReportService {

	@Autowired
	private HQItemIssueReportDao hqItemIssueReportDao; 
	
	@Override
	public List<WarehouseInfo> getAllWarehouseUnderHQ() {
		return this.hqItemIssueReportDao.getAllWarehouseUnderHQ();
	}

	@Override
	public List<HQItemIssueReportVo> getHQItemIssueReportList(HQItemIssueReportForm hqItemIssueReportForm) {
		return this.hqItemIssueReportDao.getHQItemIssueReportList(hqItemIssueReportForm);
	}
}

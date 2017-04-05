package test.report;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.report.form.HQItemIssueReportForm;
import cls.pilottery.web.report.model.HQItemIssueReportVo;
import cls.pilottery.web.report.service.HQItemIssueReportService;
import test.BaseTest;

public class TestGetHQItemIssueReportList extends BaseTest {
	@Autowired
	private HQItemIssueReportService service;
	@Test
	public void test()
	{
		HQItemIssueReportForm form = new HQItemIssueReportForm();
		form.setWarehouseCode("0001");
		form.setStartDate("2015-12-31");
		form.setStartDate("2015-12-31");
		List<HQItemIssueReportVo> list = new ArrayList<HQItemIssueReportVo>();
		list = service.getHQItemIssueReportList(form);
		ListIterator<HQItemIssueReportVo> iter = list.listIterator();
		while (iter.hasNext())
		{
			HQItemIssueReportVo v = iter.next();
			System.out.println(
					v.getIssueCode() + " " +
					v.getIssueDate() + " " +
					v.getItemName() + " " +
					v.getOperatorName() + " " +
					v.getReceiveOrgName() + " " +
					v.getSendWhName() + " " +
					v.getQuantity()
					);
		}
	}
}

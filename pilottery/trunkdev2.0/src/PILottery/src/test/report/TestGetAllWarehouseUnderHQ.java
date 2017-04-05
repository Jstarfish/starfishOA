package test.report;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.report.service.HQItemIssueReportService;
import cls.pilottery.web.warehouses.model.WarehouseInfo;
import test.BaseTest;

public class TestGetAllWarehouseUnderHQ extends BaseTest {
	@Autowired
	private HQItemIssueReportService service;
	@Test
	public void test()
	{
		List<WarehouseInfo> list = new ArrayList<WarehouseInfo>();
		list = service.getAllWarehouseUnderHQ();
		ListIterator<WarehouseInfo> iter = list.listIterator();
		while (iter.hasNext())
		{
			WarehouseInfo w = iter.next();
			System.out.println(w.getWarehouseCode()+","+w.getWarehouseName());
		}
	}
}

package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.form.ItemIssueQueryForm;
import cls.pilottery.web.items.model.ItemIssue;
import cls.pilottery.web.items.service.ItemIssueService;
import test.BaseTest;

public class TestGetItemIssue extends BaseTest {
	@Autowired
	private ItemIssueService service;
	@Test
	public void test()
	{
		ItemIssueQueryForm form = new ItemIssueQueryForm();
		form.setBeginNum(0);
		form.setEndNum(50);
		form.setIssueCode("");
		form.setIssueDate("");
		form.setWarehouseCode("");
		Integer count = service.getItemIssueCount(form);
		System.out.println("count:"+count.intValue());
		List<ItemIssue> list = new ArrayList<ItemIssue>();
		list = service.getItemIssueList(form);
		ListIterator<ItemIssue> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemIssue i = iter.next();
			System.out.println(
					i.getIiNo()+","+
					i.getOperAdmin()+","+
					i.getOperAdminName()+","+
					i.getIssueDate()+","+
					i.getReceiveOrg()+","+
					i.getReceiveOrgName()+","+
					i.getSendOrg()+","+
					i.getSendOrgName()+","+
					i.getSendWh()+","+
					i.getSendWhName()
			);
		}
	}
}

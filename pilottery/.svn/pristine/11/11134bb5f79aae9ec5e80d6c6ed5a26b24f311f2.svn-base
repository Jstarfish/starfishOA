package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.model.ItemIssueDetail;
import cls.pilottery.web.items.service.ItemIssueService;
import test.BaseTest;

public class TestGetIssueDetailList extends BaseTest {
	@Autowired
	private ItemIssueService service;
	
	@Test
	public void test()
	{
		List<ItemIssueDetail> list = new ArrayList<ItemIssueDetail>();
		list = service.getItemIssueDetails("II10000003");
		ListIterator<ItemIssueDetail> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemIssueDetail d = iter.next();
			System.out.println(
					d.getIiNo()+","+
					d.getItemCode()+","+
					d.getItemName()+","+
					d.getBaseUnit()+","+
					d.getQuantity()
					);
		}
	}
}

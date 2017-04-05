package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.items.service.ItemIssueService;
import test.BaseTest;

public class TestGetReceivingUnitForSelect extends BaseTest {
	@Autowired
	private ItemIssueService service;
	@Test
	public void test()
	{
		List<InfOrgs> list = new ArrayList<InfOrgs>();
		list = service.getReceivingUnitForSelect();
		ListIterator<InfOrgs> iter = list.listIterator();
		while (iter.hasNext())
		{
			InfOrgs o = iter.next();
			System.out.println(o.getOrgCode()+","+o.getOrgName());
		}
	}
}

package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.model.ItemQuantity;
import cls.pilottery.web.items.service.ItemCheckService;
import test.BaseTest;

public class TestGetAvailableItemForCheck extends BaseTest {
	@Autowired
	private ItemCheckService service;
	@Test
	public void test()
	{
		List<ItemQuantity> list = new ArrayList<ItemQuantity>();
		list = service.getAvailableItemForCheck("9902");
		ListIterator<ItemQuantity> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemQuantity q = iter.next();
			System.out.println(q.getItemCode()+","+q.getItemName()+","+q.getQuantity());
		}
	}
}

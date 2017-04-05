package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.form.ItemQuantityQueryForm;
import cls.pilottery.web.items.model.ItemQuantity;
import cls.pilottery.web.items.service.ItemQuantityService;
import test.BaseTest;

public class TestGetItemQuantity extends BaseTest {
	@Autowired
	private ItemQuantityService service;
	
	@Test
	public void test()
	{
		ItemQuantityQueryForm form = new ItemQuantityQueryForm();
		form.setItemCode("");
		form.setWarehouseCode("");
		form.setBeginNum(0);
		form.setEndNum(50);
		Integer count = service.getItemQuantityCount(form);
		System.out.println("count:"+count.intValue());
		List<ItemQuantity> list = new ArrayList<ItemQuantity>();
		list = service.getItemQuantityList(form);
		ListIterator<ItemQuantity> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemQuantity q = iter.next();
			System.out.println(q.getItemCode()+","+q.getItemName()+","+q.getWarehouseCode()+","+q.getWarehouseName()+","+q.getQuantity());
		}
	}
}

package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.model.ItemType;
import cls.pilottery.web.items.service.ItemQuantityService;
import test.BaseTest;

public class TestGetStorageItemForSelect extends BaseTest {
	@Autowired
	private ItemQuantityService service;
	
	@Test
	public void test()
	{
		List<ItemType> list = new ArrayList<ItemType>();
		list = service.getStorageItemForSelect();
		ListIterator<ItemType> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemType i = iter.next();
			System.out.println(i.getItemCode()+","+i.getItemName());
		}
	}
}

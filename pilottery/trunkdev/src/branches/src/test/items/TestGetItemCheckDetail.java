package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.model.ItemCheckDetail;
import cls.pilottery.web.items.service.ItemCheckService;
import test.BaseTest;

public class TestGetItemCheckDetail extends BaseTest {
	@Autowired
	private ItemCheckService service;
	@Test
	public void test()
	{
		List<ItemCheckDetail> list = new ArrayList<ItemCheckDetail>();
		list = service.getItemCheckListDetails("IC00000016");
		ListIterator<ItemCheckDetail> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemCheckDetail d = iter.next();
			System.out.println(
					d.getCheckNo()+","+
					d.getItemCode()+","+
					d.getItemName()+","+
					d.getBeforeQuantity()+","+
					d.getCheckQuantity()
					);
		}
	}
}

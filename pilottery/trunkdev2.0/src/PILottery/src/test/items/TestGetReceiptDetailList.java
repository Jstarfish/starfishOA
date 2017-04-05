package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.model.ItemReceiptDetail;
import cls.pilottery.web.items.service.ItemReceiptService;
import test.BaseTest;

public class TestGetReceiptDetailList extends BaseTest {
	@Autowired
	private ItemReceiptService itemReceiptService;
	
	@Test
	public void test()
	{
		List<ItemReceiptDetail> list = new ArrayList<ItemReceiptDetail>();
		list = itemReceiptService.getItemReceiptDetails("IR10000002");
		ListIterator<ItemReceiptDetail> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemReceiptDetail d = iter.next();
			System.out.println(d.getIrNo()+","+d.getItemName()+","+d.getItemCode()+","+d.getQuantity()+","+d.getBaseUnit());
		}
	}
}

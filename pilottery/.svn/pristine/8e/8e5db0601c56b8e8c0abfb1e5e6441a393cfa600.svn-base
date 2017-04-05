package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.form.ItemReceiptQueryForm;
import cls.pilottery.web.items.model.ItemReceipt;
import cls.pilottery.web.items.service.ItemReceiptService;
import test.BaseTest;

public class TestGetReceiptList extends BaseTest {
	@Autowired
	private ItemReceiptService itemReceiptService;
	
	@Test
	public void test()
	{
		List<ItemReceipt> list = new ArrayList<ItemReceipt>();
		ItemReceiptQueryForm form = new ItemReceiptQueryForm();
		form.setReceiptCode("");
		form.setReceiptDate("");
		form.setWarehouseCode("");
		form.setBeginNum(0);
		form.setEndNum(50);
		form.setSessionOrgCode("99");
		list = itemReceiptService.getItemReceiptList(form);
		ListIterator<ItemReceipt> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemReceipt i = iter.next();
			System.out.println(
					i.getIrNo()+","+
					i.getCreateAdmin()+","+
					i.getCreateAdminName()+","+
					i.getReceiveOrg()+","+
					i.getReceiveOrgName()+","+
			        i.getReceiveDate()+","+
					i.getReceiveWh()+","+
			        i.getReceiveWhName()
					);
		}
	}
}

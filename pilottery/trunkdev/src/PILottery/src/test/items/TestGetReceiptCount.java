package test.items;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.form.ItemReceiptQueryForm;
import cls.pilottery.web.items.service.ItemReceiptService;
import test.BaseTest;

public class TestGetReceiptCount extends BaseTest {
	@Autowired
	private ItemReceiptService itemReceiptService;
	
	@Test
	public void test()
	{
		ItemReceiptQueryForm form = new ItemReceiptQueryForm();
		form.setReceiptCode("");
		form.setReceiptDate("");
		form.setWarehouseCode("");
		Integer count = itemReceiptService.getItemReceiptCount(form);
		System.out.println("count = " + count.intValue());
	}
}

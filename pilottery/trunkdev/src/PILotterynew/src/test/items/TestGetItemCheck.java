package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.form.ItemCheckQueryForm;
import cls.pilottery.web.items.model.ItemCheck;
import cls.pilottery.web.items.service.ItemCheckService;
import test.BaseTest;

public class TestGetItemCheck extends BaseTest {
	@Autowired
	private ItemCheckService service;
	
	@Test
	public void test()
	{
		ItemCheckQueryForm form = new ItemCheckQueryForm();
		/*form.setCheckCode("IC10000003");
		form.setCheckName("9903 Full Check");
		form.setCheckDate("2015-10-15 15:10");*/
		form.setCheckCode("");
		form.setCheckName("");
		form.setCheckDate("");
		form.setBeginNum(0);
		form.setEndNum(50);
		Integer count = service.getItemCheckCount(form);
		System.out.println("count:"+count.intValue());
		List<ItemCheck> list =  new ArrayList<ItemCheck>();
		list = service.getItemCheckList(form);
		ListIterator<ItemCheck> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemCheck i = iter.next();
			System.out.println(
					i.getCheckNo()+","+
					i.getCheckName()+","+
					i.getCheckDate()+","+
					i.getCheckAdmin()+","+
					i.getCheckAdminName()+","+
					i.getCheckWarehouse()+","+
					i.getCheckWarehouseName()+","+
					i.getStatus());
		}
	}
}

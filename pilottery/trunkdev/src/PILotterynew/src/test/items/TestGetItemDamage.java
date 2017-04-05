package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.form.ItemDamageQueryForm;
import cls.pilottery.web.items.model.ItemDamage;
import cls.pilottery.web.items.service.ItemDamageService;
import test.BaseTest;

public class TestGetItemDamage extends BaseTest {
	@Autowired
	private ItemDamageService service;
	
	@Test
	public void test()
	{
		ItemDamageQueryForm form = new ItemDamageQueryForm();
		form.setBeginNum(0);
		form.setEndNum(50);
		form.setItemCode("");
		form.setItemName("");
		form.setDamageDate("");
		Integer count = service.getItemDamageCount(form);
		System.out.println("count:"+count.intValue());
		
		List<ItemDamage> list = new ArrayList<ItemDamage>();
		list = service.getItemDamageList(form);
		ListIterator<ItemDamage> iter = list.listIterator();
		while (iter.hasNext())
		{
			ItemDamage d = iter.next();
			System.out.println(
					d.getIdNo()+","+
					d.getDamageDate()+","+
					d.getItemCode()+","+
					d.getItemName()+","+
					d.getQuantity()+","+
					d.getCheckAdmin()+","+
					d.getCheckAdminName()+","+
					d.getRemark()
					);
		}
	}
}

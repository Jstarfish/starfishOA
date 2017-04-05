package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.service.ItemQuantityService;
import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;
import test.BaseTest;

public class TestGetStorageWarehouseForSelect extends BaseTest {
	@Autowired
	private ItemQuantityService service;
	
	@Test
	public void test()
	{
		UserSessionForm form = new UserSessionForm();
		form.setSessionOrgCode("00");
		
		List<WarehouseInfo> list = new ArrayList<WarehouseInfo>();
		list = service.getStorageWarehouseForSelect(form);
		ListIterator<WarehouseInfo> iter = list.listIterator();
		while (iter.hasNext())
		{
			WarehouseInfo w = iter.next();
			System.out.println(w.getWarehouseCode() + "," + w.getWarehouseName());
		}
	}
}

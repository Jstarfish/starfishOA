package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestGetAvailableWarehouse extends BaseTest {
	@Autowired
	private WarehouseService service;
	
	@Test
	public void test()
	{
		List<WarehouseInfo> list = new ArrayList<WarehouseInfo>();
		UserSessionForm form = new UserSessionForm();
		form.setSessionOrgCode("00");
		list = service.getAvailableWarehouse(form);
		ListIterator<WarehouseInfo> iter = list.listIterator();
		while (iter.hasNext())
		{
			WarehouseInfo w = iter.next();
			System.out.println(w.getWarehouseCode()+","+w.getWarehouseName());
		}
	}
}

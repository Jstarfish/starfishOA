package test.items;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.model.ItemQuantity;
import cls.pilottery.web.items.service.ItemQuantityService;
import test.BaseTest;

public class TestGetItemQuantityByWarehouse extends BaseTest {
	@Autowired
	private ItemQuantityService service;
	
	@Test
	public void test()
	{
		ItemQuantity q = new ItemQuantity();
		q.setItemCode("IT000010");
		q.setWarehouseCode("0002");
		Integer r = service.getItemQuantityByWarehouse(q);
		if (r == null) {
			System.out.println("r is null");
		} else {
			System.out.println(r.intValue());
		}
	}
}

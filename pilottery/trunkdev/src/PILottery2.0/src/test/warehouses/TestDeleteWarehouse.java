package test.warehouses;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.form.WarehouseDeleteForm;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestDeleteWarehouse extends BaseTest {
	@Autowired
	private WarehouseService warehouseService;
	
	@Test
	public void test()
	{
		try {
			WarehouseDeleteForm form = new WarehouseDeleteForm();
			form.setWarehouseCode("9912");
			form.setOperator(0);
			warehouseService.deleteWarehouse(form);
			System.out.println("Warehouse: status changed to 2.");
		} catch (Exception e) {
			System.out.println("Error: " + e.getMessage());
		}
	}
}

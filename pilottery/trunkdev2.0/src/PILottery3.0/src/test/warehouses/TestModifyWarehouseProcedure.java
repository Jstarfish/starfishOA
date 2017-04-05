package test.warehouses;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.form.NewWarehouseForm;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestModifyWarehouseProcedure extends BaseTest {
	@Autowired
	private WarehouseService warehouseService;
	
	@Test
	public void test()
	{
		NewWarehouseForm form = new NewWarehouseForm();
		form.setWarehouseCode("9909");
		form.setWarehouseName("My Modified Warehouse 7");
		form.setInstitutionCode("99");
		form.setWarehouseAddress("76 Address");
		form.setContactPhone("7676");
		form.setContactPerson(76);
		form.setWarehouseManager("76,77,78");
		warehouseService.modifyWarehouse(form);
		if (form.getC_errcode().intValue() == 0)
		{
			System.out.println("Success");
		}
		else
		{
			System.out.println("Error: " + form.getC_errmsg());
		}
	}
}

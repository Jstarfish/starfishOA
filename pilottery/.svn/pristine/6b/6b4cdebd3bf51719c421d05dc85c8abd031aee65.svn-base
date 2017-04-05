package test.warehouses;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.form.NewWarehouseForm;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestAddWarehouseProcedure extends BaseTest {
	@Autowired
	private WarehouseService warehouseService;
	@Test
	public void test()
	{
		try {
			NewWarehouseForm newWarehouseForm = new NewWarehouseForm();
			newWarehouseForm.setWarehouseCode("9902");
			newWarehouseForm.setWarehouseName("Super Spa");
			newWarehouseForm.setInstitutionCode("99");
			newWarehouseForm.setWarehouseAddress("Happy Valley No. 15");
			newWarehouseForm.setContactPhone("123123123456");
			newWarehouseForm.setContactPerson(0);
			newWarehouseForm.setCreateAdmin(0);
			newWarehouseForm.setWarehouseManager("9900,68");
			warehouseService.addWarehouse(newWarehouseForm);
			if (newWarehouseForm.getC_errcode().intValue() == 0)
			{
				System.out.println("Success");
			}
			else
			{
				System.out.println("Error: " + newWarehouseForm.getC_errmsg());
			}
		}
		catch (Exception e) {
			System.out.println("Exception: " + e.getMessage());
		}
	}
}

package test.warehouses;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.model.WarehouseInfo;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestGetWarehouseDetailsByWarehouseCode extends BaseTest {
	@Autowired
	private WarehouseService warehouseService;
	
	@Test
	public void test()
	{
		WarehouseInfo d = warehouseService.getWarehouseDetails("9901");
    	System.out.println(
    			"(" +
    			d.getWarehouseCode() + "," +
    			d.getWarehouseName() + "," +
    			d.getOrgCode() + "," +
    			d.getOrgName() + "," +
    			d.getAddress() + "," +
    			d.getDirectorAdmin() + "," +
    			d.getDirectorName() + "," +
    			d.getPhone() + "," +
    			d.getStatus() + ")"
    	);
	}
}

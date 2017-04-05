package test.warehouses;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestGetWarehouseCode extends BaseTest {
    @Autowired
    private WarehouseService warehouseService;
    
    @Test
    public void test() {
        String orgCode = "01";
        String warehouseCode = warehouseService.getRecommendedWarehouseCode(orgCode);
        System.out.println("warehouse code is " + warehouseCode);
    }
}

package test.warehouses;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.form.WarehouseQueryForm;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestGetWarehouseCount extends BaseTest {
    @Autowired
    private WarehouseService warehouseService;
    
    @Test
    public void test() {
        WarehouseQueryForm form = new WarehouseQueryForm();
        form.setWarehouseCodeQuery("");
        form.setInstitutionQuery("");
        form.setBeginNum(1);
        form.setEndNum(50);
        int count = warehouseService.getWarehouseCount(form);
        System.out.println("count is " + count);
    }
}

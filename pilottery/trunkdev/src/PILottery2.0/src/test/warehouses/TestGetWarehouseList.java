package test.warehouses;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.form.WarehouseQueryForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestGetWarehouseList extends BaseTest {
    @Autowired
    private WarehouseService warehouseService;
    
    @Test
    public void test() {
        List<WarehouseInfo> list = new ArrayList<WarehouseInfo>();
        WarehouseQueryForm form = new WarehouseQueryForm();
        form.setWarehouseCodeQuery("");
        form.setInstitutionQuery("");
        form.setBeginNum(0);
        form.setEndNum(50);
        list = warehouseService.getWarehouseList(form);
        ListIterator<WarehouseInfo> iter = list.listIterator();
        while (iter.hasNext()) {
            WarehouseInfo d = iter.next();
            System.out.println(d.getOrgName() + "," + d.getWarehouseCode() + "," + d.getWarehouseName() + "," + d.getAddress() + "," + d.getDirectorName() + "," + d.getPhone());
        }
    }
}

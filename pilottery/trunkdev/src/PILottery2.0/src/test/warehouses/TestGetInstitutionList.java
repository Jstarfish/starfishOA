package test.warehouses;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestGetInstitutionList extends BaseTest {
    @Autowired
    private WarehouseService warehouseService;
    @Test
    public void testMyGetInsitutionList() {
        List<InfOrgs> list = new ArrayList<InfOrgs>();
        UserSessionForm form = new UserSessionForm();
        form.setSessionOrgCode("00");
        list = warehouseService.getAvailableInstitution(form);
        ListIterator<InfOrgs> iter = list.listIterator();
        while (iter.hasNext()) {
            InfOrgs data = iter.next();
            System.out.println(data.getOrgCode() + ": " + data.getOrgName());
        }
    }
}

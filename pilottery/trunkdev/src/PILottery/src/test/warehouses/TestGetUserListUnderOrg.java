package test.warehouses;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.system.model.User;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestGetUserListUnderOrg extends BaseTest {
	@Autowired
	private WarehouseService warehouseService;
	
	@Test
	public void test() {
		List<User> list = new ArrayList<User>();
		list = warehouseService.getUserUnder("99");
		ListIterator<User> iter = list.listIterator();
		while (iter.hasNext()) {
			User user = iter.next();
			System.out.println(user.getId()+","+user.getRealName()+","+user.getMobilePhone()+","+user.getLoginId()+","+user.getIsWarehouseManger());
		}
	}
}

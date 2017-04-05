package test.warehouses;

import com.alibaba.fastjson.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.model.WarehouseManager;
import cls.pilottery.web.warehouses.service.WarehouseService;
import test.BaseTest;

public class TestGetWarehouseManagerList extends BaseTest {
	@Autowired
	private WarehouseService warehouseService;
	
	@Test
	public void test()
	{
		List<WarehouseManager> list = new ArrayList<WarehouseManager>();
		
		UserSessionForm form = new UserSessionForm();
		form.setWarehouseCode("9901");
		
		list = warehouseService.getWarehouseManagers(form);
		ListIterator<WarehouseManager> iter = list.listIterator();
		while (iter.hasNext()) {
			WarehouseManager m = iter.next();
			System.out.println(
					m.getManagerID() + "," + m.getUserName() + "," + m.getManagerName() + "," + m.getPhone()
					);	
		}
		System.out.println("list: "+JSON.toJSONString(list));
		Map<Object, Object> map = new HashMap<Object, Object>();
		map.put("message", "success");
		map.put("managers", list);
		System.out.println("map: "+JSON.toJSONString(map));
	}
}

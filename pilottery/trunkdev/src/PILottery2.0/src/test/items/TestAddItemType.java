package test.items;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.model.ItemType;
import cls.pilottery.web.items.service.ItemTypeService;
import test.BaseTest;

public class TestAddItemType extends BaseTest {
	@Autowired
	private ItemTypeService service;
	
	@Test
	public void test() {
		ItemType itemType = new ItemType();
		itemType.setItemName("Test 11");
		itemType.setBaseUnitName("Test Unit 11");
		try {
			service.addItemType(itemType);
			System.out.println("success");
		} catch (Exception e) {
			System.out.println("err: " + e.getMessage()	);
		}
	}
}

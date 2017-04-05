package test.items;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.service.ItemCheckService;
import test.BaseTest;

public class TestDeleteItemCheck extends BaseTest {
	@Autowired
	private ItemCheckService service;
	@Test
	public void test()
	{
		String checkNo = new String("IC00000031");
		String warehouseCode = new String("0001");
		try {
			service.procDeleteItemCheck(checkNo, warehouseCode);
			System.out.println("success: checkNo[" + checkNo + "] warehouseCode[" + warehouseCode + "]");
		} catch (Exception e) {
			System.out.println("error: " + e.getMessage());
		}
	}
}

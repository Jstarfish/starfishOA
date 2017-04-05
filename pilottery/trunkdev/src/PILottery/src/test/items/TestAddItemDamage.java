package test.items;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.form.NewItemDamageForm;
import cls.pilottery.web.items.service.ItemDamageService;
import test.BaseTest;

public class TestAddItemDamage extends BaseTest {
	@Autowired
	private ItemDamageService service;
	@Test
	public void test()
	{
		NewItemDamageForm form = new NewItemDamageForm();
		form.setCheckAdmin(0);
		form.setItemCode("IT000001");
		form.setQuantity(1);
		form.setRemark("Test Procedure");
		form.setWarehouseCode("0001");
		try {
			service.addItemDamage(form);
			if (form.getC_errcode().intValue() == 0) {
				System.out.println("success. idNo:" + form.getIdNo());
			}
			else {
				System.out.println("errmsg:" + form.getC_errmsg());
			}
		} catch (Exception e) {
			System.out.println("exception:" + e.getMessage());
		} finally {
			System.out.println("Call procedure ends..");
		}
	}
}

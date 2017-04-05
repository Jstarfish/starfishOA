package test.capital;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.capital.form.NewRepaymentForm;
import cls.pilottery.web.capital.service.RepaymentService;
import test.BaseTest;

public class TestAddRepaymentProcedure extends BaseTest {
	@Autowired
	private RepaymentService repaymentService;
	
	@Test
	public void test() {
		NewRepaymentForm form = new NewRepaymentForm();
		form.setOperatorCode(0);
		form.setMarketManagerCode(145);
		form.setRepaymentAmount(new Long(5555));
		try {
			repaymentService.addRepayment(form);
			System.out.println("success");
		} catch (Exception e) {
			System.out.println("error: " + e.getMessage());
		}
	}
}

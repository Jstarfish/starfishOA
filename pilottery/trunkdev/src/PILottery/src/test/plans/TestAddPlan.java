package test.plans;

import java.text.ParseException;
import java.util.Map;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import test.BaseTest;
import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.packinfo.PackHandleFactory;
import cls.pilottery.packinfo.PackInfo;
import cls.pilottery.web.plans.model.BatchPublisher;
import cls.pilottery.web.plans.model.Plan;
import cls.pilottery.web.plans.service.PlanService;

public class TestAddPlan extends BaseTest {

	@Autowired
	private PlanService planService;

	@Test
	public void testMyAddPlan() {

		Plan plan = new Plan();
		plan.setPlanCode("12346");
		plan.setFullName("lottery");
		plan.setShortName("lottery");
		plan.setPublisherCode(6);
		plan.setFaceValue(1200);
		try {
			planService.addPlan(plan);
			System.out.println("Success");
		} catch (Exception e) {
			System.out.println("msg:" + e.getMessage());
		}
	}

	public static void main(String[] args) throws ParseException {

	}

	@Test
	public void testPackInfo() throws Exception {
			String code="Y2016000010002000000001100100";
			PackInfo payPackInfo = PackHandleFactory.getPayPackInfo(code);
			System.out.println(payPackInfo);
	}
}

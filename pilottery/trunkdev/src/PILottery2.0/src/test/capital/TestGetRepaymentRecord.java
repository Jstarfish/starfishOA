package test.capital;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.capital.form.RepaymentQueryForm;
import cls.pilottery.web.capital.model.RepaymentRecord;
import cls.pilottery.web.capital.service.RepaymentService;
import test.BaseTest;

public class TestGetRepaymentRecord extends BaseTest {
	@Autowired
	private RepaymentService repaymentService;
	
	@Test
	public void test()
	{
		RepaymentQueryForm form = new RepaymentQueryForm();
		form.setBeginNum(0);
		form.setEndNum(50);
		form.setMarketManagerCode("");
		form.setMarketManagerName("");
		form.setRepaymentDate("");
		
		int count = repaymentService.getRepaymentCount(form);
		System.out.println("count = "+count);
		
		List<RepaymentRecord> list = new ArrayList<RepaymentRecord>();
		list = repaymentService.getRepaymentList(form);
		ListIterator<RepaymentRecord> iter = list.listIterator();
		while (iter.hasNext())
		{
			RepaymentRecord r = iter.next();
			System.out.println(
					r.getMcrNo()+","+
					r.getRepaymentDate()+","+
					r.getMarketManagerCode()+","+
					r.getMarketManagerName()+","+
					r.getBalanceBeforeRepayment()+","+
					r.getRepaymentAmount()+","+
					r.getBalanceAfterRepayment());
		}
	}
}

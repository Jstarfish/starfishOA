package test.capital;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.capital.model.MarketManagerAccount;
import cls.pilottery.web.capital.service.RepaymentService;
import test.BaseTest;

public class TestGetMarketManagerAccountList extends BaseTest {
	@Autowired
	private RepaymentService repaymentService;
	
	@Test
	public void test()
	{
		List<MarketManagerAccount> list = new ArrayList<MarketManagerAccount>();
		list = repaymentService.getMarketManagerAccountList("00");
		ListIterator<MarketManagerAccount> iter = list.listIterator();
		while (iter.hasNext())
		{
			MarketManagerAccount a = iter.next();
			System.out.println(a.getMarketAdmin()+","+
			                   a.getAdminRealName()+","+
					           a.getAccountType()+","+
			                   a.getAccountName()+","+
					           a.getAccountStatus()+","+
			                   a.getAccountNo()+","+
					           a.getCreditLimit()+","+
			                   a.getAccountBalance()+","+
					           a.getCheckCode());
		}
	}
}

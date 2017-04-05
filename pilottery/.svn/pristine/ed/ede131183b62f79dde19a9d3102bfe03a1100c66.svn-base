package test.checkTickets;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.checkTickets.model.GameBatchInfo;
import cls.pilottery.web.checkTickets.service.ScanTicketService;
import test.BaseTest;

public class TestGetGameBatchInfo extends BaseTest {
	@Autowired
	private ScanTicketService service;
	@Test
	public void test()
	{
		List<GameBatchInfo> list = new ArrayList<GameBatchInfo>();
		list = service.getGameBatchInfo();
		ListIterator<GameBatchInfo> iter = list.listIterator();
		while (iter.hasNext())
		{
			GameBatchInfo b = iter.next();
			System.out.println(b.getPlanCode()+","+b.getPlanName()+","+b.getBatchNo()+","+b.getAmount()+","+b.getTicketsEveryGroup());
		}
	}
}

package test.oms.issue;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import test.BaseTest;
import cls.pilottery.oms.issue.model.GameIssue;
import cls.pilottery.oms.issue.service.IssueManagementService;

public class IssueTest extends BaseTest {
	
	@Autowired
	private IssueManagementService issueManagementService;
	
	@Test
	public void getGameIssueListCountSingle(){
		//Integer count = issueManagementService.getIssueCount();
		//System.out.println(count);
	}

	@Test
	public void testinsertIssuesP(){
		List<GameIssue> issueList = new ArrayList<GameIssue>();
		GameIssue gi1 = new GameIssue();
		gi1.setGameCode((short)12);
		gi1.setIssueNumber(160311100L);
		gi1.setPlanCloseTime(new Date());
		gi1.setPlanRewardTime(new Date());
		gi1.setPlanStartTime(new Date());
		issueList.add(gi1);
		issueManagementService.insertIssuesP(issueList);
	}
}

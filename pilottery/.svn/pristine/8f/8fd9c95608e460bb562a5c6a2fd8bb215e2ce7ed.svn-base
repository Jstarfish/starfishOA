package cls.taishan;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.junit.Test;

public class IssueTemplet {
	
	
	int oneIssueMin = 10;
	
	@Test
	public void doIssueTemplet() throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
		Date date1 = sdf.parse("08:00:30");
		Date date2 = sdf.parse("08:10:00");
		System.out.println("11x5_planStartTime_1="+sdf.format(date1));
		System.out.println("11x5_planCloseTime_1="+sdf.format(date2));
		for(int i=2;i<300;i++){
			date1.setTime(date1.getTime() + oneIssueMin*60*1000);
			date2.setTime(date2.getTime() + oneIssueMin*60*1000);
			System.out.println("11x5_planStartTime_"+i+"="+sdf.format(date1));
			System.out.println("11x5_planCloseTime_"+i+"="+sdf.format(date2));
		}
	}

}

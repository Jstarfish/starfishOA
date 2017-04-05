package cls.pilottery.packinfo;

import java.util.ArrayList;
import java.util.List;

public class FunctionTestNew {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		
		try {
			
			List<PlanInfo> plans = new ArrayList<PlanInfo>();
			
			//初始化，参数比较稳定，实际使用可以做个单例启动就初始化一次 
			PackHandleFactory.initParameter(plans);
			
			//J2015 箱
			PackInfo pi =PackHandleFactory.getPackInfo("J201500002001281001001001010000101000200150312001270119.6guardz");
			if(pi != null)
				System.out.println(pi.toString());
			
			//J2015 盒
			pi =PackHandleFactory.getPackInfo("J20150000200110010000127210012740");
			if(pi != null)
				System.out.println(pi.toString());
			
			//J2015 本
			pi =PackHandleFactory.getPackInfo("J2015000020002000012791199100");
			if(pi != null)
				System.out.println(pi.toString());
			
			//J2015 保安区码--用于兑奖
			pi =PackHandleFactory.getPackInfo("J2015000020013842184DKTSANFUBVYUNAORAG016");
			if(pi != null)
				System.out.println(pi.toString());
			
			//J2017 本
			pi =PackHandleFactory.getPackInfo("J2017000020002000012791199100");
			if(pi != null)
				System.out.println(pi.toString());
			
			//J2016 没有对应的处理器--会爆出异常无法找到handler
			pi =PackHandleFactory.getPackInfo("J2016000020002000012791199100");
			if(pi != null)
				System.out.println(pi.toString());
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		

	}

}

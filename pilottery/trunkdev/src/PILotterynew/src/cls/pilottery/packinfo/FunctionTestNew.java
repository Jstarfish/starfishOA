package cls.pilottery.packinfo;

import java.util.ArrayList;
import java.util.List;

import cls.pilottery.web.plans.model.Plan;

public class FunctionTestNew {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		
		try {
			
			List<Plan> plans = new ArrayList<Plan>();
			plans.add(new Plan("J2015","天下足球1",2000,(short)1));
			plans.add(new Plan("J2016","J方案",2000,(short)1));
			plans.add(new Plan("J2017","测试游戏3",3000,(short)1));
			
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
			
			pi = PackHandleFactory.getPayPackInfo("J20150000200110010000127210012740");
			if(pi == null)
			{
				System.out.println("Invalid Sign:J20150000200110010000127210012740");
			}else
			{
				System.out.println(pi.toString());
			}
			
			//J2015 本
			pi =PackHandleFactory.getPackInfo("J2015000020002000012791199100");
			if(pi != null)
				System.out.println(pi.toString());
			
			pi = PackHandleFactory.getPayPackInfo("J2015000020002000012791199100");
			if(pi == null)
			{
				System.out.println("Invalid Sign: J2015000020002000012791199100");
			}else
			{
				System.out.println("ticket:"+pi.toString());
			}
			
			//J2015 保安区码--用于兑奖
			pi =PackHandleFactory.getPackInfo("J2015000020013842184DKTSANFUBVYUNAORAG016");
			if(pi != null)
				System.out.println(pi.toString());
			
			pi = PackHandleFactory.getPayPackInfo("J2015000020013842184DKTSANFUBVYUNAORAG016");
			if(pi == null)
			{
				System.out.println("Invalid Barcode:J2015000020013842184DKTSANFUBVYUNAORAG016");
			}else
			{
				System.out.println("safecode:"+pi.toString());
			}
			
			//J2017 本
			pi =PackHandleFactory.getPackInfo("J2017000020002000012791199100");
			if(pi != null)
				System.out.println(pi.toString());
			
			//J2016
			pi =PackHandleFactory.getPackInfo("J2016000010002000000202100100");
			if(pi != null)
				System.out.println(pi.toString());
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		

	}

}

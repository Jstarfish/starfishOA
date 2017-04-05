package cls.pilottery.packinfo;

import java.util.HashMap;
import java.util.List;


public class PackHandleFactory {

	private static HashMap<String, PlanInfo> plans = new HashMap<String, PlanInfo>();
	
	/*
	 * 根据接口消息:获取方案列表（ 990001）初始化参数
	 * 
	 */
	public static void initParameter(List<PlanInfo> plans) throws Exception
	{
		if(plans == null || plans.size() <= 0)
			throw new Exception("Invalid Parameter.");
		
		//其实这里可以根据PackHandleFactory.plans的值是否为空进行初始化，这样就可以只初始化一次
		
		//初始化hash表信息
		for(int i=0;i<plans.size();i++)
		{
			PlanInfo p = plans.get(i);
			if( p == null)
				continue;
			PackHandleFactory.plans.put(p.getPlanCode(),p);
		}
	}
	
	/*
	 * 获取编码信息
	 */
	public static PackInfo getPackInfo(String inputCode) throws Exception
	{
		if(inputCode.isEmpty())
			throw new Exception("Invalid Parameter.");
		
		//其实这里可能会有点问题，如果北京前5位编号不是方案就会有异常
		String pCode =inputCode.substring(0, 5);		
		PlanInfo p = PackHandleFactory.plans.get(pCode);
		
		if(p == null)
			throw new Exception("Invalid Plan Code.");
		
		PackUnitHandle handler =createPackHandle(p);
		if(handler == null)
			throw new Exception("Can't find the decode handler.");
		
		PackInfo pi = handler.getPackInfo(inputCode);
		if(pi != null)
			pi.setPlanName(p.getPlanName());
		
		return pi;
		
		
	}
	
	
	public static PackUnitHandle createPackHandle(PlanInfo p) {

		if(p == null || p.getPrinterCode().isEmpty())
				return null;
		
		int printer=Integer.parseInt(p.getPrinterCode());
		PackUnitHandle hander = null;
		if (printer == 1) {
			hander = new SJZPrinterHandler(p);

		} else if (printer == 2) {

		} else if (printer == 3) {
			hander = null;
		}

		return hander;
	}
	
	/*
	 * 根据打印商和方案编号，创建包装处理器
	 * 
	 * printer = 1 一厂 printer = 2 一厂 printer = 3 一厂 planCode 方案编码
	 * amountPerTicket 单票金额
	 * batchFirstTrunkCode 批次首箱号
	 * totalTicketNumOfGroup 每个奖组总票数
	 */
	public static PackUnitHandle createPackHandle(int printer, String planCode,
			long amountPerTicket, int batchFirstTrunkCode,
			int totalTicketNumOfGroup) {

		PackUnitHandle hander = null;
		if (printer == 1) {
			hander = new SJZPrinterHandler(planCode, amountPerTicket,
					batchFirstTrunkCode, totalTicketNumOfGroup);

		} else if (printer == 2) {

		} else if (printer == 3) {
			hander = null;
		}

		return hander;
	}
}

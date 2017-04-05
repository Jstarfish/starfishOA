package cls.facebook.ncpimpl;

import cls.facebook.config.SysParameter;
import cls.facebook.utils.EncryptUtils;
import cls.pilottery.common.utils.HttpClientUtils;

import com.alibaba.fastjson.JSON;

public final class StartQueryIssue {

	public static void StartIssueHandle() {
		
		String key ="ncp.startissue";
		String currissue = SysParameter.CurrIssueCode;
		
		while (true) {

			Request4001Model req = new Request4001Model();
			req.setCMD(0x4001);
			req.setGameCode(SysParameter.GameCode);
			req.setPerdIssue(SysParameter.CurrIssueCode);

			String json = JSON.toJSONString(req);
			System.out.println("orginal:  req=" + json);
			String deskey = "12345678";
			String enjson = EncryptUtils.encrypt(json, deskey);
			System.out
					.println(SysParameter.NcpServerPre+ enjson);

			try {
				String result = HttpClientUtils
						.get(SysParameter.NcpServerPre+ enjson);
				System.out.println("get the url :" + result);
				result = EncryptUtils.decrypt(result, deskey);
				Response4001Model jn = JSON.parseObject(result,
						Response4001Model.class);
				if (jn != null)
				{
					System.out.println("get the object :" + jn.getDrawCode());
				}else
				{
					System.out.println("curr issue is not end :" + currissue);
					throw new Exception("no issue...");
				}
				
				
				//Publish Issue;
				System.out.println("curr issue is published :" + currissue);
				
				//Save Parameters
				
				//Set New Issue
				currissue =(Integer.parseInt(currissue)+1)+"";
				SysParameter.Save(key, currissue);
				System.out.println("curr issue is saved :" + currissue);			

			} catch (Exception e1) {
				e1.printStackTrace();
			}finally
			{
				try {
					Thread.sleep(60000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
				
		}
	}
	
}

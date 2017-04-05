package cls.facebook.ncpimpl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import cls.facebook.config.SysParameter;
import cls.facebook.impl.FaceBookImplement;
import cls.facebook.impl.FreshTokenThread;
import cls.facebook.utils.DateUtil;
import cls.facebook.utils.EncryptUtils;
import cls.pilottery.common.utils.HttpClientUtils;

import com.alibaba.fastjson.JSON;

public class IssueThread implements Runnable {

	public static Logger log=LogManager.getLogger(IssueThread.class);
	
	/*
	 * current thread status ,by the self control;
	 * 0 non start
	 * 1 runing and alive
	 * 2 dead
	 */
	private int currStatus = 0;
	
	/*
	 * Start ,get the issue every 1 minuter ,until the non issue.
	 * if the suffix max issue num has over the every day max issue num and time over draw time
	 * then report alive 
	 * if time is another day change currissue.
	 * @see java.lang.Runnable#run()
	 */
	@SuppressWarnings("deprecation")
	public void run() {

		String key ="ncp.startissue";
		String currissue = SysParameter.CurrIssueCode;
		int currissuerequestime =0;
		int currsysdaymaxiss = 0;
		
		FaceBookImplement fb = FaceBookImplement.getInstance();
		
		while (true) {
			
			int curr =Integer.parseInt(DateUtil.getDate(new Date(), "yyMMdd"))*1000; 
			currsysdaymaxiss = curr+ SysParameter.EverydayMaxIssueNum;
			
			this.currStatus =1;
			
			currissuerequestime = currissuerequestime +1;
			Request4001Model req = new Request4001Model();
			req.setCMD(0x4001);
			req.setGameCode(SysParameter.GameCode);
			req.setPerdIssue(currissue);

			String json = JSON.toJSONString(req);
			System.out.println("orginal:  req=" + json);
			String deskey = "12345678";
			String enjson = EncryptUtils.encrypt(json, deskey);
			System.out.println(SysParameter.NcpServerPre+ enjson);

			try {
				
				
				
				if(currsysdaymaxiss < Integer.parseInt(currissue))
				{
					Thread.sleep(60000);
					currissuerequestime = 0;
					log.info("todays issue has finished ....next issue .."+ currissue);
					continue;
				}	
				//test if in the server times.
				Date dnow = new Date();
				int hour =dnow.getHours();
				if(hour < SysParameter.EverydayBeginHour || hour > SysParameter.EverydayEndHour)
				{
					Thread.sleep(60000);
					currissuerequestime = 0;
					log.info("over the server time ....next issue .."+ currissue);	
					continue;
				}
				
				
		
				String result = HttpClientUtils.get(SysParameter.NcpServerPre+ enjson);
				System.out.println("get the url :" + result);
				result = EncryptUtils.decrypt(result, deskey);
				Response4001Model jn = JSON.parseObject(result,Response4001Model.class);
				if (jn != null && jn.getErrorCode()==WebncpErrorMessage.SUCCESS)
				{
					System.out.println("get the object :" + jn.getDrawCode());
					log.info("get ncp curr issue info success... curr issue :"+ currissue);					
				}else
				{
					//throw new Exception("get ncp currissue error"+ currissue);
					Thread.sleep(60000);
					currissuerequestime = 0;
					log.info("not get the issue info ......waiting for next time ."+ currissue);	
					continue;
				}				
				
				//Publish Issue;
				boolean bp = fb.PostFeed(currissue, jn.getDrawCode());
				//boolean bp = true;//just for test
				if(bp)
				{
					log.info("post curr issue info success ... curr issue :"+ currissue);
				}else
				{
					throw new Exception("post facebook currissue error"+ currissue);
				}
								
				//Set New Issue
				int curriss =Integer.parseInt(currissue);
				int currissdaymax = curriss/1000*1000 + SysParameter.EverydayMaxIssueNum;
				
				if(curriss >= currissdaymax)
				{
					//curriss= (curriss / 1000 +1)*1000;
					//ÐÞÕýÀÏËã·¨´íÎó
					
					curriss= curriss / 1000;
					
					SimpleDateFormat sm = new SimpleDateFormat("yyMMdd");
					Date newDate = null;
					try {
						newDate = sm.parse(curriss+"");
					} catch (ParseException e) {
						e.printStackTrace();
					}
					
					 System.out.println(sm.format(newDate.getTime()));
					
					 Calendar calendar = Calendar.getInstance();  
			         calendar.setTime(newDate);  
			         calendar.add(calendar.DAY_OF_YEAR,1); 
			         
			         System.out.println(sm.format(calendar.getTime()));
			         
			         Date  myDate = calendar.getTime();
			         String str = sm.format(myDate);
			         int newcrii = Integer.parseInt(str);
			         curriss= newcrii*1000;
			         
			         System.out.println(curriss);
			    }
				
				log.info("System change curr issue to :"+(curriss+1));
				currissue =(curriss+1)+"";
				currissuerequestime = 0;
				
				//Save Parameters
				SysParameter.CurrIssueCode =currissue;
				SysParameter.Save(key, currissue);
				System.out.println("curr issue is saved :" + currissue);			

			} catch (Exception e1) {
				e1.printStackTrace();
				log.error(e1.getMessage());
			}finally
			{
				try {
					Thread.sleep(60000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
							
			}
			if (currissuerequestime > 3)
			{
				this.setCurrStatus(2);
				log.error("post curr issue info error over 3 time.system exit ... curr issue :"+ currissue);
				break;
			}
				
		}
	}

	public int getCurrStatus() {
		return currStatus;
	}

	public void setCurrStatus(int currStatus) {
		this.currStatus = currStatus;
	}

}

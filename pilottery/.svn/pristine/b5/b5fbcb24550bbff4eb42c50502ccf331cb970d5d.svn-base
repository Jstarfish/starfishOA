package cls.facebook.impl;

import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class FreshTokenThread implements Runnable {

	public static Logger logger =LogManager.getLogger(FreshTokenThread.class);
	/*
	 * fresh the token
	 * Start fresh token
	 * then fresh it every a hour 
	 * print the log report status every 5 minutes
	 * @see java.lang.Runnable#run()
	 */
	public void run() {

		FaceBookImplement fb = FaceBookImplement.getInstance();
		
			try {
				if(fb == null)
				throw new Exception("Can't create the facebook instance.");
				boolean b =fb.FreshToken();
				//if can't fresh token first time ,try it again
				if(b ==false)
				{
					b = fb.FreshToken();
					if(b == false)
					throw new Exception("Can't fresh token, please check the status.");
				}
				
				while(true)
				{
					for(int i=0;i < 60;i++)
					{
						logger.info("fresh token alive ...");
						Thread.sleep(60*1000);
					}
					
					b =fb.FreshToken();
					//if can't fresh token first time ,try it again
					if(b ==false)
					{
						b = fb.FreshToken();
						if(b == false)
						throw new Exception("Can't fresh token, please check the status.");
					}else
					{
						logger.info("fresh token success. now is "+ new Date());
					}
					
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				
				logger.error("fresh token exit for:"+e.getMessage());
			}
	}

}

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import cls.facebook.config.SysParameter;
import cls.facebook.impl.FreshTokenThread;
import cls.facebook.ncpimpl.IssueThread;


public class StartService {

	public static Logger log =LogManager.getLogger(FreshTokenThread.class);
	/**
	 * Start Service
	 * @param args
	 */
	public static void main(String[] args) {

		log.info("System Started ......");
		
		FreshTokenThread tokenSevice = new FreshTokenThread();
		IssueThread  issueService = new IssueThread();

		try {
			
			//tokenSevice.run();
			
			issueService.run();
			
			while(true)
			{
				Thread.sleep(60000);
				log.info("main thread alive.");
				
				//check thread status
				if(issueService.getCurrStatus() !=1)
				{				
					issueService.run();
				}
				 
			}
			
		} catch (Exception e) {
			
			log.error("Main thread exited for:"+e.getMessage());
		}
	}

}

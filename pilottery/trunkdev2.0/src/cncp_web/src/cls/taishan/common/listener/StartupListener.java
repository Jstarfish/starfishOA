package cls.taishan.common.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cls.taishan.common.constants.EnumConfig;
import cls.taishan.common.constants.EnumConfigZH;
import cls.taishan.common.utils.Dom4jUtil;
import cls.taishan.common.utils.PropertiesUtil;

/**
 * Web服务启动监听
 * 
 */
public class StartupListener implements ServletContextListener {

	private static Logger log = LoggerFactory.getLogger(StartupListener.class);

	/**
	 * 这个方法在Web应用服务做好接受请求的时候被调用。
	 * 
	 */
	public void contextInitialized(ServletContextEvent event){
		try {
			PropertiesUtil.init("config/config.properties");

		    Dom4jUtil.fillConfig(new EnumConfig(), "config/EnumConfig_en.xml");
		    Dom4jUtil.fillConfig(new EnumConfigZH(), "config/EnumConfig_zh.xml");
		    
		} catch (IllegalStateException e) {
			log.error("Setting application home path error! ");
		} 
	}
	public void contextDestroyed(ServletContextEvent event) {
		
	}
}
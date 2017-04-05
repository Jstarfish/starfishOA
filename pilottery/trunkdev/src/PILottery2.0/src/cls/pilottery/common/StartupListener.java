package cls.pilottery.common;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cls.pilottery.common.utils.Dom4jUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.common.utils.ReflectUtil;
import cls.pilottery.pos.common.constants.PosConstant;
import cls.pilottery.webncp.common.constants.WebncpConstant;

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
		    
			PosConstant.methodMap = ReflectUtil.getPosMethodList("cls.pilottery.pos.system.service");
			WebncpConstant.methodMap = ReflectUtil.getWebncpMethodList("cls.pilottery.webncp.system.service");
			
			PropertiesUtil.init("config/config.properties");

		    //导入枚举定义-add-by-dzg
		    Dom4jUtil.fillConfig(new EnumConfigEN(), "config/EnumConfig_en.xml");
		    Dom4jUtil.fillConfig(new EnumConfigZH(), "config/EnumConfig_zh.xml");
           

		} catch (IllegalStateException e) {
			log.error("Setting application home path error! ");
		} 
	}
	public void contextDestroyed(ServletContextEvent event) {
		
	}
}
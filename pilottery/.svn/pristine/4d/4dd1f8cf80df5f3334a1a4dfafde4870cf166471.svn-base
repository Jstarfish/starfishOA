package cls.facebook.config;

import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.FileBasedConfiguration;
import org.apache.commons.configuration2.PropertiesConfiguration;
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder;
import org.apache.commons.configuration2.builder.fluent.Parameters;
import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;



/*
 * 系统配置参数装载器
 */
public class SysParameter {
	
	public static Logger logger =LogManager.getLogger(SysParameter.class);

	
	//用于facebook认证参数
	public static String AppID = "";
	public static String AppSecret="";
	public static String AccessToken="";
	public static String CallBackURL="";
	public static String PageID ="";
	public static String GameCode="";
	public static String NcpServerPre="";
	public static String CurrIssueCode="";
	public static int EverydayMaxIssueNum=0;
	public static int EverydayBeginHour=0;
	public static int EverydayEndHour=0;
		

		
	static{
		
		Init();
	}
	
	
	/*
	 * System Parameters Init.
	 */
	public static void Init()
	{
		logger.info("System begin to init the parameters.");
		
		Parameters params = new Parameters();
		FileBasedConfigurationBuilder<FileBasedConfiguration> builder =
		    new FileBasedConfigurationBuilder<FileBasedConfiguration>(PropertiesConfiguration.class)
		    .configure(params.properties()
		        .setFileName("sysconfig.properties"));
		try
		{
		    Configuration config = builder.getConfiguration();
		    
		    AppID = config.getString("facebook.appid");
		    AppSecret=config.getString("facebook.secret");
		    AccessToken=config.getString("facebook.accesstoken");
		    CallBackURL=config.getString("facebook.callbackurl");
		    PageID=config.getString("facebook.pageid");
		    GameCode=config.getString("ncp.querygamecode");
		    NcpServerPre=config.getString("ncp.serverrequestpre");
		    CurrIssueCode=config.getString("ncp.startissue");
		    EverydayMaxIssueNum=config.getInt("ncp.everydaymaxissuenum");
		    EverydayBeginHour=config.getInt("ncp.everydaybeginhour");
		    EverydayEndHour=config.getInt("ncp.ererydaygendhour");

		    
		    logger.info("System parameters loaded.");
		    
		}
		catch(ConfigurationException cex)
		{
		    logger.error("System parameters load failure for:"+cex.getMessage());
		}finally{
			builder = null;
			params = null;
		}
	}
	
	public static void Save(String key,String value)
	{
		logger.info("System begin to save key:"+key);
		
		Parameters params = new Parameters();
		FileBasedConfigurationBuilder<FileBasedConfiguration> builder =
		    new FileBasedConfigurationBuilder<FileBasedConfiguration>(PropertiesConfiguration.class)
		    .configure(params.properties()
		        .setFileName("sysconfig.properties"));
		try
		{
		    Configuration config = builder.getConfiguration();
		    
		    config.setProperty(key, value);
		    builder.save();
		    
		    logger.info("Save Issue Successful. value="+value);
		    
		}
		catch(ConfigurationException cex)
		{
		    logger.error("Save params failure for:"+cex.getMessage());
		}finally{
			builder = null;
			params = null;
		}
	}
}

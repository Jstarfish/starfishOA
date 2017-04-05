package cls.facebook.impl;

import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import cls.facebook.config.SysParameter;
import cls.pilottery.common.utils.HttpClientUtils;
import facebook4j.Account;
import facebook4j.Facebook;
import facebook4j.FacebookFactory;
import facebook4j.PagePhotoUpdate;
import facebook4j.PostUpdate;
import facebook4j.PrivacyBuilder;
import facebook4j.PrivacyParameter;
import facebook4j.PrivacyType;
import facebook4j.ResponseList;
import facebook4j.auth.AccessToken;
import facebook4j.internal.http.HttpClientConfiguration;
import facebook4j.internal.http.HttpClientWrapper;
import facebook4j.internal.http.HttpClientWrapperConfiguration;
import facebook4j.internal.http.HttpResponse;
import facebook4j.internal.org.json.JSONObject;

/*
 * facebook implement
 */
public class FaceBookImplement {

	public static Logger logger =LogManager.getLogger(FaceBookImplement.class);
	
	private static FaceBookImplement instance = null;
	private static Facebook fb =null;
	private static Object lock = new Object();
	
	public static FaceBookImplement getInstance()
	{
		logger.info("facebook init ...");
		if(instance == null)
		{
			if(StringUtils.isEmpty(SysParameter.AppID))
				SysParameter.Init();
			
			 if(StringUtils.isEmpty(SysParameter.AppID))
			 {
				 logger.error("facebook init failure, the sysparameter is null.");

			 }else
			 {
			 
				 synchronized(lock)
				 {
					 fb = new FacebookFactory().getInstance();
					 fb.setOAuthAppId(SysParameter.AppID, SysParameter.AppSecret);
					 fb.setOAuthAccessToken(new AccessToken(SysParameter.AccessToken));
					 instance = new FaceBookImplement();
				 }
			 }
		}
			
		return instance;
	}
	
	
	/*
	 * Test Connection
	 */
	public boolean testConn()
	{
		boolean bRet =false;
		try
		{
			logger.info("facebook test begin ... ");
			
			ResponseList<Account> ac =fb.getAccounts();
			String acc = "";
			if(ac != null & ac.size() >0)
			{
				Account a = ac.get(0);
				acc = a.getName();
			}
			logger.info("facebook test end,we get the account of "+ acc);
			bRet =true;
			
		}catch (Exception ex) {
			
			logger.info("facebook test failure, for " + ex.getMessage());
		}
				
		return bRet;		
	}
	

	
	/*
	 * Publish Message Url
	 */
	public boolean PostUrl(String issue,String wincode)
	{
		boolean bRet =false;
		try
		{
			String message = "Test ... Lucky 5, the "+issue+" issue ,winner code is:"+wincode;
			String url = URLEncoder.encode("http://kpwlottery.com/index.php/km?issue="+issue+"&wincode="+wincode, "UTF-8");
			url = "http://kpwlottery.com/index.php/chn/%E5%BC%80%E5%A5%96%E5%8F%B7%E7%A0%81?issue="+issue+"&wincode="+wincode;
			fb.postLink(new URL(url),message);
			logger.info("facebook post user url,message is: "+ message +",url = "+url);
			
			bRet =true;
			
		}catch (Exception ex) {
			
			logger.error("facebook post user url failure, for " + ex.getMessage());
		}
		return bRet;
	}
	
	/*
	 * Post Page Url
	 */
	public boolean PostPageUrl(String issue,String wincode)
	{
		boolean bRet =false;
		try
		{
			String message = "Test ... Lucky 5, the "+issue+" issue ,winner code is:"+wincode;
			String url = "http://kpwlottery.com/index.php/km?issue="+issue+"&wincode="+wincode;
			
			
			PagePhotoUpdate pagePhotoUpdate = new PagePhotoUpdate(new URL(url));
			pagePhotoUpdate.setMessage(message);
			pagePhotoUpdate.setPublished(true);

			fb.postPagePhoto(SysParameter.PageID, pagePhotoUpdate);
			logger.info("facebook post page("+SysParameter.PageID+") url,message is: "+ message +",url = "+url);
			
			bRet =true;
			
		}catch (Exception ex) {
			
			logger.error("facebook post page url failure, for " + ex.getMessage());
		}
		return bRet;
	}
	
	public boolean PostFeed(String issue,String wincode)
	{
		boolean bRet =false;
		try
		{
			logger.info("facebook post feed begin ... ");
			
			String title = "Lucky 5 (No. "+issue+") winning number.";
			String message = "Issue no. "+issue+" ,winning number:"+wincode;
			String url = "http://kpwlottery.com/index.php/km?issue="+issue+"&wincode="+wincode;
			
			PrivacyParameter privacy = new PrivacyBuilder().setValue(PrivacyType.EVERYONE).build();
			PostUpdate postUpdate = new PostUpdate(new URL(url))
			    //.picture(new URL("http://facebook4j.org/images/hero.png"))
			    .name(title)
			    .caption(title)
			    .published(true)
			    .description(message)
			    .privacy(privacy);
			String postId = fb.postFeed(postUpdate);
			
			logger.info("facebook post feed id ("+postId+") ,message is: "+ message +",url = "+url);
			
			bRet =true;
			
		}catch (Exception ex) {
			
			logger.error("facebook post feed failure, for " + ex.getMessage());
			logger.error(ex);
		}
		return bRet;
	}
	
	
	public boolean PostPageFeed(String issue,String wincode)
	{
		boolean bRet =false;
		try
		{
			logger.info("facebook post page feed begin ... ");
			
			String title = "Test Lucky 5 the"+issue+" draw number.";
			String message = "Test ... Lucky 5, the "+issue+" issue ,winner code is:"+wincode;
			String url = "http://kpwlottery.com/index.php/km?issue="+issue+"&wincode="+wincode;
			
			PrivacyParameter privacy = new PrivacyBuilder().setValue(PrivacyType.EVERYONE).build();
			PostUpdate postUpdate = new PostUpdate(new URL(url))
			    //.picture(new URL("http://facebook4j.org/images/hero.png"))
			    .name(title)
			    .caption(title)
			    .published(true)
			    .description(message)
			    .privacy(privacy);
			String postId = fb.postFeed(SysParameter.PageID,postUpdate);
			
			logger.info("facebook post page feed id ("+postId+") ,message is: "+ message +",url = "+url);
			
			bRet =true;
			
		}catch (Exception ex) {
			
			logger.error("facebook post feed failure, for " + ex.getMessage());
		}
		return bRet;
	}
	
	public boolean FreshToken()
	{
		boolean bRet =false;
		try
		{
			
			String url = "https://graph.facebook.com/oauth/access_token";
			Map<String, String> params  = new HashMap<String, String>();
			params.put("grant_type", "fb_exchange_token");
			params.put("client_id", SysParameter.AppID);
			params.put("client_secret", SysParameter.AppSecret);
			params.put("fb_exchange_token", SysParameter.AccessToken);
			
			url = buildUrl(url, params);
			
			logger.info("facebook fresh token post url : "+url);
			
			//String jstr ="Test ....";
			String jstr =HttpClientUtils.get(url);
			
			System.out.println("get fresh token:"+ jstr);
			/*
			HttpClientWrapperConfiguration conf = fb.getConfiguration();
			HttpClientWrapper http = new HttpClientWrapper(conf);
			HttpResponse rep = http.post(url);
			JSONObject json = rep.asJSONObject();*/
			
			String newToken = "";
        	String[] tmpArr = jstr.split("&");
        	for (String str : tmpArr) {
        		int sindex =str.indexOf("access_token=");
				if(sindex >= 0)
				{
					newToken = str.substring(sindex+"access_token=".length());
					System.out.println("we get the token:"+ newToken);
					break;
				}
			}
        	
        	if(StringUtils.isEmpty(newToken))
        		throw new Exception("Get token is null....");
        	
			SysParameter.AccessToken =newToken;		
			SysParameter.Save("facebook.accesstoken", newToken);
			
			bRet =true;
			
		}catch (Exception ex) {
			
			logger.error("facebook fresh token  failure, for " + ex.getMessage());
		}
		return bRet;
	}
	
	
	 public String buildUrl(String path, Map<String, String> parameters) {
	        StringBuilder url = new StringBuilder();
	        url.append(path);
	        if (parameters != null && parameters.size() > 0) {

	            url.append("?");

	            int i = 0;
	            for (final String k : parameters.keySet()) {
	                if (i > 0) {
	                    url.append("&");
	                }

	                try {
	                    url.append(URLEncoder.encode(k, "UTF-8"))
	                       .append("=")
	                       .append(URLEncoder.encode(parameters.get(k), "UTF-8"));
	                } catch (UnsupportedEncodingException ignore) {
	                }
	                i++;
	            }
	        }
	        return url.toString();
	    }
	
}

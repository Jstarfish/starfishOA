import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.omg.CORBA.portable.InputStream;

import cls.facebook.config.SysParameter;
import cls.facebook.impl.FaceBookImplement;

import facebook4j.Account;
import facebook4j.Facebook;
import facebook4j.FacebookException;
import facebook4j.FacebookFactory;
import facebook4j.PagePhotoUpdate;
import facebook4j.PostUpdate;
import facebook4j.auth.AccessToken;


public class TestFaceBook {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
			Facebook fb = new FacebookFactory().getInstance();
	        fb.setOAuthAppId(SysParameter.AppID, SysParameter.AppSecret);
	        fb.setOAuthAccessToken(new AccessToken(SysParameter.AccessToken));
	       
	       	      
	        try {
	        	
	        	String xxx ="access_token=EAAINXsL2GZA8BACc2OFLzHC4g2ZCTHT2IdWfMGFoFoRUMbErwS5oyZCM2rSdadCTlCaV1gtTX6PUvL1ZAFeIhbid5Kry1YnRuhZBu2UL139CILAAf9IXQLQlHade3oHsuCiZBcZAKxCeoeVoTgfTobSQ7j3sksRCzT7wZAEIDBaTbAZDZD&expires=5183319";
	        	String[] xxxArr = xxx.split("&");
	        	for (String str : xxxArr) {
	        		int sindex =str.indexOf("access_token=");
					if(sindex >= 0)
					{
						System.out.println("we get the token:"+ str.substring(sindex+"access_token=".length()));
						break;
					}
				}
	        	
	        	FaceBookImplement imp = FaceBookImplement.getInstance();
	        	String issue = "160612001";
	        	String wincode ="05,02,07,11,10";
	        	
	        	boolean b = imp.testConn();
	        	System.out.println("test freshed finished! result="+b);
	        	
	        	//b = imp.PostUrl(issue, wincode);
	        	System.out.println("post url freshed finished! result="+b);
	        		        
	        	//b = imp.FreshToken();
	        	System.out.println("token freshed finished! result="+b);
	        		  
	        	//b = imp.PostFeed(issue, wincode);
	        	System.out.println("token post feed finished! result="+b);
	        	
	        	//b = imp.PostPageFeed(issue, wincode);
	        	System.out.println("token post page feed finished! result="+b);
	        		        	
	        	b = imp.PostPageUrl(issue, wincode);
	        	System.out.println("post page freshed finished! result="+b);
	        		        	        		        	
	        	AccessToken acctoken =fb.getOAuthAccessToken();
	        	fb.getAccounts();
	        	
	        	
	        	//AccessToken extendedToken = fb.extendTokenExpiration(acctoken.getToken());
	        	fb.setOAuthCallbackURL("https://my.fb.com/Faccess_by_fb4j/");
	        	//AccessToken bb =fb.getOAuthAccessToken(acctoken.getToken());
	        	//String token =acctoken.getToken();
	        	//String token =getLoginToken();
	        	
	        	fb.postStatusMessage(SysParameter.PageID, "This is a post status!");
	        	fb.postFeed(new PostUpdate("This is a post update"));
	        	fb.postLink(new URL("http://www.kpwlottery.com"),"A great lottery company of Combodia.");
	        	//String acctoken = getLoginToken();
	  	        //fb.setOAuthAccessToken(new facebook4j.auth.AccessToken(acctoken, null));
	  	        
	        	 String pageToken = null;
		            for (Account a : fb.getAccounts()) {
		                if (a.getName().toLowerCase().contains("next")) {
		                    pageToken = a.getAccessToken();
		                }
		            }
		        System.out.println("pgtoken="+pageToken);
		        fb.setOAuthAccessToken(new AccessToken(pageToken));
	            fb.postLink( new URL("http://www.kpwlottery.com"),"A great lottery company of Combodia.");
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	   	           
	}

	public static String getLoginToken() throws IOException
	{
		//access_token=...&amp;client_secret=...&amp;redirect_uri=...&amp;client_id=...
		String url = "https://graph.facebook.com/oauth/client_code";
	    String charset = "UTF-8";


	    String query = String.format("client_id=%s&client_secret=%s&access_token=%s&redirect_uri=%s",
	            URLEncoder.encode(SysParameter.AppID, charset),
	            URLEncoder.encode(SysParameter.AppSecret, charset),
	            URLEncoder.encode(SysParameter.AccessToken, charset),
	    		URLEncoder.encode("https://my.fb.com/access_by_fb4j/", charset));
	    HttpsURLConnection con = (HttpsURLConnection) new URL(url + "?" + query).openConnection();
	    InputStream ins = (InputStream) con.getInputStream();
	    InputStreamReader isr = new InputStreamReader(ins);
	    BufferedReader in = new BufferedReader(isr);

	    String inputLine;
	    String result = "";
	    while ((inputLine = in.readLine()) != null) {
	        System.out.println(inputLine);
	        result += inputLine;
	    }
	    in.close();

	    String[] params = result.split("&");
	    Map<String, String> map = new HashMap<String, String>();
	    for (String param : params) {
	        String name = param.split("=")[0];
	        String value = param.split("=")[1];
	        map.put(name, value);
	    }
	    String longToken=map.get("access_token");
	    return longToken;
	}
}

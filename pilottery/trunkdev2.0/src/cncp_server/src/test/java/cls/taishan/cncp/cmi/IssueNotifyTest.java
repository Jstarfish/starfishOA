package cls.taishan.cncp.cmi;

import org.junit.Test;

import cls.taishan.common.utils.HttpClientUtils;

public class IssueNotifyTest {
	
	@Test
	public void getIssueNotify1101() throws Exception{
		String url = "http://localhost:9000/issueNotify.do";
		
		String result = HttpClientUtils.postString(url,"");
		System.out.println(result);
	}
	
	@Test
	public void testPostString(){
		String postStr = "token=123456&transType=1001&digest=T2vUG5UWSXFZAvj7vQ9NPuhcyfZfrfQCd7vVJV_txSyCRV_uIdOIZmEh6NUxOnMfxAVHFX2NjvSd8_wDw7757-lo_5KVRyyzyig8qfbAv8ANkVuD27t4tKfk6dBDy3W0cpQ1Gqbtnkg_sXdI5K5CuSDBCLEQU3GWkDvI1vE--0A&transMessage={\"messengerId\":\"1234562016092600000003\",\"token\":\"123456\",\"timestamp\":\"20160926102236\",\"transType\":\"1001\",\"body\":{\"game\":\"K11X5\",\"issue\":\"0\"}}";
		
		String url = "http://192.168.26.112:9000/cncp.do";
		
		String result = HttpClientUtils.postString(url,postStr);
		System.out.println(result);
	}
	
	@Test
	public void testEncrypt(){
		String postStr = "token=000001&transType=1006&digest=sxl_jpZcG-DCtfZIS-ZUFyHqAniq2I4D7eK-84hOAMym8-kJLXSGZeGwfYUP_2BlPhRZAdr9Z7yOg4HkmPfezdJOwNu4v_g17_PtdNHz29A0xW66tJWWwr1TZMDI6OjIS8R0mrRmPLK6A8bFE_kskwj2NSBUnpFZTJ_TH8LBFwk=&transMessage={\"body\": {}, \"timestamp\": \"20161130224050\", \"token\": \"000001\", \"messengerId\": \"000000012016113000000007\", \"transType\": 1006}";
		
		String url = "http://192.168.26.74:9000/cncp.do";
		
		String result = HttpClientUtils.postString(url,postStr);
		System.out.println(result);
	}
}

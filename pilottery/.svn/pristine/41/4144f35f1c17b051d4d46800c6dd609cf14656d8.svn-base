package cls.taishan.system;

import org.junit.Test;

import cls.taishan.common.utils.HttpClientUtils;

public class BankTest {
	
	@Test
	public void testWithdraw(){
		//String url = "http://192.168.8.96:8080/bank_gate/API/wing_withdraw.do";
		String url = "http://192.168.26.112:8000/bank_gate/API/wing_withdraw.do";

		String json = "{\"account\":\"1234567890123456\",\"amount\":10000,\"euser\":\"12345678901234\",\"reqFlow\":\"KPW000000000000000000088\",\"userAcc\":\"00614777\"}";

		String result = HttpClientUtils.postString(url, json);
		System.out.println(result);
	}
	
	@Test
	public void testCharge(){
		//String url = "http://192.168.8.96:8080/bank_gate/API/wing_charge.do";
		String url = "http://192.168.26.112:8000/bank_gate/API/wing_withdraw.do";
		
		String json = "{\"account\":\"1234567890123456\",\"amount\":10000,\"euser\":\"12345678901234\",\"otp\":\"413885\",\"reqFlow\":\"KPW000000000000000000097\",\"userAcc\":\"00383661\"}";

		String result = HttpClientUtils.postString(url, json);
		System.out.println(result);
	}

}

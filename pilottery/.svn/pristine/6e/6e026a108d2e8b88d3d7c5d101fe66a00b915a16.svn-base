package cls.taishan.cncp.cmi;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import cls.taishan.cncp.cmi.model.Req1001Msg;
import cls.taishan.common.encrypt.RSASignature;
import cls.taishan.common.exception.ConnectTimeoutException;
import cls.taishan.common.helper.FastJsonHelper;
import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.utils.HttpClientUtils;
import cls.taishan.common.utils.VertxConfiguration;

public class DataQueryTest {

	@Test
	public void getSystemTimeTest() throws Exception {
		// String url = "http://localhost:8088/cncp.do";
		String url = "http://124.42.96.166:9000/cncp.do";

		String token = "1001";
		int transType = 1006;

		BaseMessage req = new BaseMessage<>();
		req.setMessengerId("12-_34");
		req.setToken(token);
		req.setTimestamp(System.currentTimeMillis()+"");
		req.setTransType(1006);

		String transMessage = FastJsonHelper.converter(req);
		System.out.println(transMessage);
		String digest = RSASignature.sign(FastJsonHelper.converter(req),
				VertxConfiguration.configStr("agency_privateKey"));
		// digest = EncryptUtils.encrypt(digest, "12345678");

		String resultJson = "token=" + token + "&transType=" + transType + "&digest=" + digest + "&transMessage="
				+ transMessage;
		System.out.println(resultJson);

		String result = HttpClientUtils.postString(url, resultJson);
		System.out.println(result);
	}

	@Test
	public void testEncrypt() {
		String token = "123456";
		int transType = 1006;

		BaseMessage req = new BaseMessage<>();
		req.setMessengerId("1234");
		req.setToken(token);
		req.setTimestamp(System.currentTimeMillis()+"");
		req.setTransType(1006);

		String content = FastJsonHelper.converter(req);

		System.out.println("--------------- use private key to generate the signation ------------------");
		// String
		// content="{"messengerId":"1234","timestamp":1473756866060,"token":"123456","transType":1006}";

		String signstr = RSASignature.sign(content, VertxConfiguration.configStr("agency_privateKey"));

		System.out.println("Source Content : " + content);
		System.out.println("Sign Result : " + signstr);
		System.out.println();

		System.out.println("--------------- use public key to check the signation ------------------");
		System.out.println("Source Content : " + content);
		System.out.println("Signation : " + signstr);
		System.out.println("Check result : "
				+ RSASignature.doCheck(content, signstr, VertxConfiguration.configStr("agency_publicKey")));
	}

	// 奖期查询Test
	@Test
	public void getAwardPeriodInfoTest() throws ConnectTimeoutException {
		String url = "http://localhost:9000/cncp.do";
		String messengetId = "1234567890ABCDEF";
		String token = "11010012";
		int transType = 1001;
		// String digest ="AJDAJFLJDFLAJFDASJ";
		BaseMessage<Req1001Msg> req = new BaseMessage<Req1001Msg>();
		// Req1001Msg req = new Req1001Msg();
		// String game = "".toLowerCase();
		// req.setGame("K11X5");
		// req.setIssue("0");
		// req.setBody(req);
		Req1001Msg msg = new Req1001Msg();
		msg.setGame("K11X5");
		msg.setIssue("0");
		req.setMessengerId(messengetId);
		req.setToken(token);
		req.setTimestamp(System.currentTimeMillis()+"");
		req.setTransType(transType);
		req.setBody(msg);
		String transMessage = FastJsonHelper.converter(req);
		System.out.println(transMessage);
		String digest = RSASignature.sign(FastJsonHelper.converter(req),
				VertxConfiguration.configStr("agency_privateKey"));
		// digest = EncryptUtils.encrypt(digest, "12345678");

		String resultJson = "token=" + token + "&transType=" + transType + "&digest=" + digest + "&transMessage="
				+ transMessage;

		System.out.println(resultJson);

		String result = HttpClientUtils.postString(url, resultJson);

		System.out.println(result);
	}

	// 账户查询1005
	@Test
	public void getAccountInfoTest() throws Exception {
		// String url = "http://localhost:8080/cncp.do";
		String url = "http://localhost:8080/cncp.do";

		String token = "1234";
		int transType = 1005;

		BaseMessage req = new BaseMessage<>();
		req.setMessengerId("12-_34");
		req.setToken(token);
		req.setTimestamp(System.currentTimeMillis()+"");
		req.setTransType(transType);

		String transMessage = FastJsonHelper.converter(req);
		System.out.println(transMessage);
		String digest = RSASignature.sign(FastJsonHelper.converter(req),
				VertxConfiguration.configStr("agency_privateKey"));
		// digest = EncryptUtils.encrypt(digest, "12345678");

		String resultJson = "token=" + token + "&transType=" + transType + "&digest=" + digest + "&transMessage="
				+ transMessage;
		System.out.println(resultJson);

		String result = HttpClientUtils.postString(url, resultJson);
		System.out.println(result);
	}
	
	// 奖期查询Test
		@Test
		public void getFundDaliyReportTest() throws ConnectTimeoutException {
			String url = "http://localhost:9000/cncp.do";
			String messengetId = "1234567890ABCDEF";
			String token = "123456";
			int transType = 1007;
			// String digest ="AJDAJFLJDFLAJFDASJ";
			BaseMessage<Map> req = new BaseMessage<Map>();
			Map map = new HashMap();
			map.put("date", "20161026");
			req.setMessengerId(messengetId);
			req.setToken(token);
			req.setTimestamp(System.currentTimeMillis()+"");
			req.setTransType(transType);
			req.setBody(map);
			String transMessage = FastJsonHelper.converter(req);
			System.out.println(transMessage);
			String digest = RSASignature.sign(FastJsonHelper.converter(req),
					VertxConfiguration.configStr("agency_privateKey"));
			// digest = EncryptUtils.encrypt(digest, "12345678");

			String resultJson = "token=" + token + "&transType=" + transType + "&digest=" + digest + "&transMessage="
					+ transMessage;

			System.out.println(resultJson);

			String result = HttpClientUtils.postString(url, resultJson);

			System.out.println(result);
		}

}

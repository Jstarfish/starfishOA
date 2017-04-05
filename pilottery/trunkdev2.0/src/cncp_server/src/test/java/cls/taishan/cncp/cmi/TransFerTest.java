package cls.taishan.cncp.cmi;

import cls.taishan.cncp.cmi.model.Req1002Msg;
import cls.taishan.cncp.cmi.model.Req1003Msg;
import cls.taishan.cncp.cmi.model.Req1004Msg;
import cls.taishan.common.encrypt.RSASignature;
import cls.taishan.common.helper.FastJsonHelper;
import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.utils.HttpClientUtils;
import cls.taishan.common.utils.VertxConfiguration;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.junit.Test;

/**
 * Created by Reno Main on 2016/9/13.
 */
public class TransFerTest {

  /*  "body":{
        "ticketId":"10110032201607250000000018",
                "game":"K11X5",
                "issue":160725002,
                "amount":20000,
                "betLines":[
        "RX2-DS-(04+06)-1",
                "RX2-DS-(03+08)-1",
                "RX2-DS-(05+09)-1"
        ]
    }
*/
    @Test
    public void lotteryBet() throws Exception{
        String url = "http://localhost:8080/cncp.do";

        String token = "123456";
        int transType = 1002;
         //digest = EncryptUtils.encrypt(digest, "12345678");


        BaseMessage<Req1002Msg> req = new BaseMessage<Req1002Msg>();
        req.setMessengerId("1234567890ABCDEF");
        req.setToken(token);
        req.setTimestamp(System.currentTimeMillis()+"");
        req.setTransType(1002);

        Req1002Msg requert5002 = new Req1002Msg();
        requert5002.setTicketId("101111322016072500001143");
        requert5002.setGame("K11X5");
        requert5002.setIssue(160923005L);
        requert5002.setAmount(3000);
        requert5002.setDealer("123456");


        String []betLines = new String[]{"RX2-DS-(04+06)-1","RX2-DS-(03+08)-1","RX2-DS-(05+09)-1"};
        String obj = JSONObject.toJSONString(betLines);
        requert5002.setBetLines(obj);

        req.setBody(requert5002);

        String transMessage = FastJsonHelper.converter(req);

        String digest= RSASignature.sign(transMessage, VertxConfiguration.configStr("agency_privateKey"));

        String resultJson = "token=" +token +
                "&transType=" + transType +
                "&digest="+digest+
                "&transMessage="+ transMessage;

        String result = HttpClientUtils.postString(url, resultJson);
        System.out.println(result);
    }

    /*
    @Test
    public void lotteryQuery() throws Exception{
        String url = "http://localhost:8081/cncp.do";

        String token = "123456";
        int transType = 1003;

        BaseMessage req = new BaseMessage<>();
        req.setBody(new Req1003Msg("111111111111111111111111"));
        req.setMessengerId("1234");
        req.setToken(token);
        req.setTimestamp(System.currentTimeMillis()+"");
        req.setTransType(1003);


        String digest= RSASignature.sign(FastJsonHelper.converter(req), VertxConfiguration.configStr("agency_privateKey"));

        String resultJson = "token=" +token +
                "&transType=" + transType +
                "&digest="+digest+
                "&transMessage="+ FastJsonHelper.converter(req);

        String result = HttpClientUtils.postString(url, resultJson);
        System.out.println(result);
    }
*/
    /*
    @Test
    public void payOffQuery() throws Exception{
        String url = "http://localhost:8081/cncp.do";

        String token = "123456";
        int transType = 1004;
        String digest = "ABCDDEFDKLJSDFKLJSADF";

        BaseMessage req = new BaseMessage<>();
        req.setBody(new Req1004Msg("12",160725002));
        req.setMessengerId("1234");
        req.setToken(token);
        req.setTimestamp(System.currentTimeMillis()+"");
        req.setTransType(1004);

        String resultJson = "token=" +token +
                "&transType=" + transType +
                "&digest="+digest+
                "&transMessage="+ FastJsonHelper.converter(req);

        String result = HttpClientUtils.postString(url, resultJson);
        System.out.println(result);
    }
    */
}
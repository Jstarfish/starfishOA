package cls.taishan.web.jtdao;

import cls.taishan.web.model.control.WingWithdrawOutputParam;
import cls.taishan.web.model.db.WingReceiveWDDataDBParm;
import cls.taishan.web.model.db.WingWithdrawDBParam;
import cls.taishan.web.model.rest.WingWithdrawReq;
import cls.taishan.web.model.rest.WingWithdrawRes;

public interface WingWithdrawDAO {
	// 记录发起报文的信息，同时获取交易流水号和币种
	public void recordWithdrawJsonData(WingReceiveWDDataDBParm dbParm);
	
	// 与Wing网关交互
	public WingWithdrawRes restWingWithdraw(WingWithdrawReq req, String token);

	// 记录Wing交互结果（发起交易前）
	public WingWithdrawDBParam recordWithdrawBeforeDB(WingWithdrawReq req, String eTradeFlow);

	// 记录Wing交互结果（发起交易后）
	public WingWithdrawDBParam recordWithdrawPostDB(WingWithdrawDBParam dbParm);
	
	// 从数据库生成返回参数
	public WingWithdrawOutputParam genOutParam(String eTradeFlow);

}

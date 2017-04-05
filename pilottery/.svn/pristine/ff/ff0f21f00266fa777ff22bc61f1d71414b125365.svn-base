package cls.taishan.web.jtdao;

import cls.taishan.web.model.control.WingChargeOutputParam;
import cls.taishan.web.model.db.WingCommitDBParam;
import cls.taishan.web.model.db.WingReceiveChargeDataDBParm;
import cls.taishan.web.model.db.WingValidateDBParam;
import cls.taishan.web.model.rest.WingCommitRes;
import cls.taishan.web.model.rest.WingValidateReq;
import cls.taishan.web.model.rest.WingValidateRes;

public interface WingChargeDAO {
	// 记录发起报文的信息，同时获取交易流水号
	public void recordChargeJsonData(WingReceiveChargeDataDBParm dbParm);
	
	// 发起Validate交易前，在数据中记录交易内容
	public WingValidateDBParam recordValidateBeforeDB(WingValidateReq req, String eTradeFlow);

	// 与Wing网关进行Validate交易
	public WingValidateRes restWingValidate(WingValidateReq req, String token);

	// 发起Validate交易后，在数据中记录交易内容
	public void recordValidatePostDB(WingValidateDBParam dbParm);

	// 发起Commit交易前，在数据中记录交易内容
	public WingCommitDBParam recordCommitBeforeDB(String eTradeFlow);

	// 与Wing网关进行Commit交易
	public WingCommitRes restWingCommit(String token);

	// 发起Commit交易后，在数据中记录交易内容
	public void recordCommitPostDB(WingCommitDBParam dbParm);

	// 从数据库生成返回参数
	public WingChargeOutputParam genOutParam(String eTradeFlow);

}

package cls.taishan.web.jtdao;

import cls.taishan.web.model.db.WingLoginDBParm;
import cls.taishan.web.model.rest.WingLoginReq;
import cls.taishan.web.model.rest.WingLoginRes;

public interface WingLoginDAO {

	// 记录Wing交互结果（发起交易前）
	public WingLoginDBParm recordLoginBeforeDB(WingLoginReq req, String eTradeFlow);

	// 与Wing网关交互
	public WingLoginRes restWingLogin(WingLoginReq req);

	// 记录Wing交互结果（发起交易后）
	public WingLoginDBParm recordLoginPostDB(WingLoginDBParm dbParm);
	
}

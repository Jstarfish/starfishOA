package cls.taishan.web.jtdao;

import cls.taishan.web.model.rest.WingLoginReq;

public interface WingCommonDAO {
	
	// 根据账户信息获取登录属性
	public int getEUserLoginInfo(String euserAccount, WingLoginReq userInfo);
	
	// 获取错误编号
	public String getErrorMessage();
	
}

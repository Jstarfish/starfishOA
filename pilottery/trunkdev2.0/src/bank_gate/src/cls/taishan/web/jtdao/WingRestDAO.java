package cls.taishan.web.jtdao;

import org.springframework.http.HttpHeaders;

import cls.taishan.web.model.rest.WingBaseRes;

public interface WingRestDAO {
	// 登录操作
	public WingBaseRes loginRest(String in);
	
	// 充值之数据校验
	public WingBaseRes validateRest(String in, String token);

	// 充值之提交
	public WingBaseRes commitRest(String token);

	// 提现
	public WingBaseRes transMoneyRest(String in, String token);
}

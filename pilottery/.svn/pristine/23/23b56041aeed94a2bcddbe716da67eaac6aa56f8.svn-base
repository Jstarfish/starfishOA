package cls.taishan.web.jtdao.Impl;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.alibaba.fastjson.JSON;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.common.utils.PropertiesUtil;
import cls.taishan.web.jtdao.WingCommonDAO;
import cls.taishan.web.model.rest.WingLoginReq;
import lombok.extern.log4j.Log4j;


@Log4j
@Repository
public class WingCommonDAOImpl implements WingCommonDAO {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	private String errMsg = "";

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int getEUserLoginInfo(String euserAccount, WingLoginReq userInfo) {
		
		try {
			String sql = "{? = call f_get_euser_acc_login(?)}";
			errMsg = String.format("Get EUser login info. execute SP : [%s]", "f_get_euser_acc_login");
			log.info(errMsg);
			
			int errorcode = (int) jdbcTemplate.execute(sql, new CallableStatementCallback() {
				@Override
				public Object doInCallableStatement(CallableStatement cs) throws SQLException, DataAccessException {

					cs.setString(2, euserAccount);
					errMsg = String.format("Get EUser login info. execute SP Input Parameter : [%s]", euserAccount);
					log.info(errMsg);

					cs.registerOutParameter(1, Types.VARCHAR);
					cs.execute();

					String rtv = cs.getString(1);
					errMsg = String.format("Get EUser login info. execute SP Return Parameter : [%s]", cs.getString(1));
					log.info(errMsg);
					if (rtv == null)
						return SysConstants.ERR_COMMON_ORACLE_ERROR;

					userInfo.setWingUser(JSON.parseObject(rtv).getString("user"));
					userInfo.setWingPass(JSON.parseObject(rtv).getString("pass"));
					userInfo.setBillCode(JSON.parseObject(rtv).getString("billcode"));
					userInfo.setGrantType(PropertiesUtil.readValue("wing.grant_type"));
					userInfo.setClientID(PropertiesUtil.readValue("wing.client_id"));
					userInfo.setClientSecret(PropertiesUtil.readValue("wing.client_secret"));
					userInfo.setScope(PropertiesUtil.readValue("wing.scope"));

					return 0;
				}
			});
			return errorcode;
		} catch (DataAccessException e) {
			log.error("execute procedure f_get_euser_acc_login with oracle error: ", e);
			return SysConstants.ERR_COMMON_ORACLE_ERROR;
		}

	}

	@Override
	public String getErrorMessage() {
		return errMsg;
	}

}

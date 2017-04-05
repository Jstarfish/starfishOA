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
import cls.taishan.web.jtdao.WingLoginDAO;
import cls.taishan.web.jtdao.WingRestDAO;
import cls.taishan.web.model.db.WingLoginDBParm;
import cls.taishan.web.model.rest.WingBaseRes;
import cls.taishan.web.model.rest.WingLoginReq;
import cls.taishan.web.model.rest.WingLoginRes;
import lombok.extern.log4j.Log4j;

@Log4j
@Repository
@SuppressWarnings({ "unchecked", "rawtypes" })
public class WingLoginDAOImpl implements WingLoginDAO {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private WingRestDAO wingRestDAO;

	public String errMsg = "";

	@Override
	public WingLoginDBParm recordLoginBeforeDB(WingLoginReq req, String eTradeFlow) {
		WingLoginDBParm dbParm = new WingLoginDBParm(eTradeFlow, req.toReqString());
		dbParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_POSTING);
		executeSP(dbParm);
		return dbParm;
	}

	@Override
	public WingLoginRes restWingLogin(WingLoginReq req) {
		WingLoginRes out = new WingLoginRes();
		
		WingBaseRes restOut = wingRestDAO.loginRest(req.toReqString());

		if (restOut.getErrorCode() != 0) {
			out.setErrorCode(restOut.getErrorCode());
			out.setErrorMessage(restOut.getErrorMessage());
			out.setHttpStatus(restOut.getHttpStatus());
			return out;
		}

		out = JSON.parseObject(restOut.getJsonString(), WingLoginRes.class);
		out.setErrorCode(0);
		out.setHttpStatus(200);

		return out;
	}

	@Override
	public WingLoginDBParm recordLoginPostDB(WingLoginDBParm dbParm) {
		executeSP(dbParm);
		return dbParm;
	}
	
	public void executeSP(WingLoginDBParm dbParm) {
		try {
			String sql = "{call p_wing_get_token(?,?,?,?,?, ?,?,?)}";
			errMsg = String.format("[Login] record the data after posting Wing. execute SP : [%s]",
					"p_wing_get_token");
			log.info(errMsg);

			jdbcTemplate.execute(sql, new CallableStatementCallback() {
				@Override
				public Object doInCallableStatement(CallableStatement cs) throws SQLException, DataAccessException {

					cs.setString(1, dbParm.getETradeFlow());
					cs.setString(2, dbParm.getJsonData());
					cs.setLong(3, dbParm.getRestStatus());
					cs.setString(4, dbParm.getEInPostId());
					cs.setInt(5, dbParm.getHttpStatus());

					errMsg = String.format(
							"[Login] record the data after posting Wing. execute SP Input Parameter : [%s], [%s], [%s], [%s], [%s]",
							dbParm.getETradeFlow(), dbParm.getJsonData(), dbParm.getRestStatus(),
							dbParm.getEInPostId(), dbParm.getHttpStatus());
					log.info(errMsg);

					cs.registerOutParameter(6, Types.VARCHAR);
					cs.registerOutParameter(7, Types.INTEGER);
					cs.registerOutParameter(8, Types.VARCHAR);
					cs.execute();

					dbParm.setEOutPostId(cs.getString(6));
					dbParm.setErrorCode(cs.getInt(7));
					dbParm.setErrorMessage(cs.getString(8));

					int errCode = cs.getInt(7);

					errMsg = String.format(
							"[Login] record the data after posting Wing. execute SP Return Parameter : [%s], [%s], [%s]",
							cs.getString(6), cs.getString(7), cs.getString(8));
					log.info(errMsg);
					if (errCode != 0) {
						errMsg = String.format(
								"[Login] record the data after posting Wing. execute procedure p_wing_get_token with oracle error: code [%s], message [%s]",
								cs.getString(7), cs.getString(8));
						log.error(errMsg);
						dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
						return errCode;
					}

					return errCode;
				}
			});

		} catch (DataAccessException e) {
			log.error(
					"[Login] record the data after posting Wing. execute procedure p_wing_get_token with oracle error: ",
					e);
			dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
			dbParm.setErrorMessage(e.toString().substring(1, 100));
		}
	}

}

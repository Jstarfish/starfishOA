package cls.taishan.web.jtdao.Impl;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;
import com.alibaba.fastjson.JSON;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.web.jtdao.WingRestDAO;
import cls.taishan.web.jtdao.WingWithdrawDAO;
import cls.taishan.web.model.control.WingWithdrawOutputParam;
import cls.taishan.web.model.db.WingReceiveWDDataDBParm;
import cls.taishan.web.model.db.WingWithdrawDBParam;
import cls.taishan.web.model.rest.WingBaseRes;
import cls.taishan.web.model.rest.WingWithdrawReq;
import cls.taishan.web.model.rest.WingWithdrawRes;
import lombok.extern.log4j.Log4j;

@Log4j
@Repository
@SuppressWarnings({ "unchecked", "rawtypes" })
public class WingWithdrawDAOImpl implements WingWithdrawDAO {
	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Autowired
	private WingRestDAO wingRestDAO;

	private String errMsg = "";

	@Override
	public void recordWithdrawJsonData(WingReceiveWDDataDBParm dbParm) {
		try {
			String sql = "{call p_wing_receive_withdraw(?,?,?,?,?, ?,?,?,?)}";
			errMsg = String.format("[Withdraw] record the request json. execute SP : [%s]", "p_wing_receive_withdraw");
			log.info(errMsg);

			jdbcTemplate.execute(sql, new CallableStatementCallback() {
				@Override
				public Object doInCallableStatement(CallableStatement cs) throws SQLException, DataAccessException {

					cs.setString(1, dbParm.getEUser());
					cs.setString(2, dbParm.getAccount());
					cs.setLong(3, dbParm.getAmount());
					cs.setString(4, dbParm.getUserAcc());
					cs.setString(5, dbParm.getReqFlow());
					errMsg = String.format(
							"[Withdraw] record the request json. execute SP Input Parameter : [%s], [%s], [%s], [%s], [%s]",
							dbParm.getEUser(), dbParm.getAccount(), dbParm.getAmount(), dbParm.getUserAcc(),
							dbParm.getReqFlow());
					log.info(errMsg);

					cs.registerOutParameter(6, Types.VARCHAR);
					cs.registerOutParameter(7, Types.VARCHAR);
					cs.registerOutParameter(8, Types.INTEGER);
					cs.registerOutParameter(9, Types.VARCHAR);
					cs.execute();

					int errCode = cs.getInt(8);

					errMsg = String.format(
							"[Withdraw] record the request json. execute SP Return Parameter : [%s], [%s], [%s], [%s]",
							cs.getString(6), cs.getString(7), cs.getString(8), cs.getString(9));
					log.info(errMsg);

					if (errCode != 0) {
						dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
						dbParm.setErrorMesg(cs.getString(9));
					} else {
						dbParm.setErrorCode(0);
						dbParm.setETradeFlow(cs.getString(6));
						dbParm.setCurrency(cs.getString(7));
					}
					return errCode;
				}
			});
		} catch (DataAccessException e) {
			log.error(
					"[Withdraw] record the request json. execute procedure p_wing_receive_withdraw with oracle error: ",
					e);
			dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
			dbParm.setErrorMesg(e.toString().length() <= 100 ? e.toString().substring(1, 100) : e.toString());
		}
	}

	@Override
	public WingWithdrawRes restWingWithdraw(WingWithdrawReq req, String token) {
		WingWithdrawRes out = new WingWithdrawRes();

		WingBaseRes restOut = wingRestDAO.transMoneyRest(JSON.toJSONString(req), token);

		if (restOut.getErrorCode() != 0) {
			out.setErrorCode(restOut.getErrorCode());
			out.setErrorMessage(restOut.getErrorMessage());
			out.setHttpStatus(restOut.getHttpStatus());
			return out;
		}

		out = JSON.parseObject(restOut.getJsonString(), WingWithdrawRes.class);
		out.setErrorCode(0);
		out.setHttpStatus(200);

		return out;
	}

	@Override
	public WingWithdrawDBParam recordWithdrawBeforeDB(WingWithdrawReq req, String eTradeFlow) {
		WingWithdrawDBParam dbParm = new WingWithdrawDBParam(eTradeFlow, JSON.toJSONString(req));
		dbParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_POSTING);
		executeSP(dbParm);
		return dbParm;
	}

	@Override
	public WingWithdrawDBParam recordWithdrawPostDB(WingWithdrawDBParam dbParm) {
		executeSP(dbParm);
		return dbParm;
	}

	@Override
	public WingWithdrawOutputParam genOutParam(String eTradeFlow) {
		WingWithdrawOutputParam out = new WingWithdrawOutputParam();
		String sql = "select balance, fee, exchange_context, wing_trans_id, customer_name from trd_wing_record where e_trade_flow = ?";

		SqlRowSet r = jdbcTemplate.queryForRowSet(sql, eTradeFlow);
		if (r.next()) {
			out.setBalance(r.getLong(1));
			out.setFee(r.getLong(2));
			out.setExchange(r.getString(3));
			out.setWingFlow(r.getString(4));
			out.setUserName(r.getString(5));
			out.setResFlow(eTradeFlow);
		}

		return out;
	}

	public void executeSP(WingWithdrawDBParam dbParm) {
		try {
			String sql = "{call p_wing_transmoney(?,?,?,?,?, ?,?,?)}";
			errMsg = String.format("[Withdraw] record the data after posting Wing. execute SP : [%s]",
					"p_wing_transmoney");
			log.info(errMsg);

			jdbcTemplate.execute(sql, new CallableStatementCallback() {
				@Override
				public Object doInCallableStatement(CallableStatement cs) throws SQLException, DataAccessException {

					cs.setString(1, dbParm.getETradeFlow());
					cs.setString(2, dbParm.getJsonData());
					cs.setLong(3, dbParm.getRestStatus());
					// if (dbParm.getRestStatus() !=
					// SysConstants.DB_WING_REST_STATUS_POSTING) {
					cs.setString(4, dbParm.getEInPostId());
					cs.setInt(5, dbParm.getHttpStatus());
					// } else {
					// cs.setNull(4, Types.VARCHAR);
					// cs.setNull(5, Types.INTEGER);
					// }

					errMsg = String.format(
							"[Withdraw] record the data after posting Wing. execute SP Input Parameter : [%s], [%s], [%s], [%s], [%s]",
							dbParm.getETradeFlow(), JSON.toJSONString(dbParm.getJsonData()), dbParm.getRestStatus(),
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
							"[Withdraw] record the data after posting Wing. execute SP Return Parameter : [%s], [%s], [%s]",
							cs.getString(6), cs.getString(7), cs.getString(8));
					log.info(errMsg);
					if (errCode != 0) {
						errMsg = String.format(
								"[Withdraw] record the data after posting Wing. execute procedure p_wing_transmoney with oracle error: code [%s], message [%s]",
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
					"[Withdraw] record the data after posting Wing. execute procedure p_wing_transmoney with oracle error: ",
					e);
			dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
			dbParm.setErrorMessage(e.toString().length() <= 100 ? e.toString().substring(1, 100) : e.toString());
		}
	}

}

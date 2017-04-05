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
import cls.taishan.web.jtdao.WingChargeDAO;
import cls.taishan.web.jtdao.WingRestDAO;
import cls.taishan.web.model.control.WingChargeOutputParam;
import cls.taishan.web.model.db.WingCommitDBParam;
import cls.taishan.web.model.db.WingReceiveChargeDataDBParm;
import cls.taishan.web.model.db.WingValidateDBParam;
import cls.taishan.web.model.rest.WingBaseRes;
import cls.taishan.web.model.rest.WingCommitRes;
import cls.taishan.web.model.rest.WingValidateReq;
import cls.taishan.web.model.rest.WingValidateRes;
import lombok.extern.log4j.Log4j;

@Log4j
@Repository
@SuppressWarnings({ "unchecked", "rawtypes" })
public class WingChargeDAOImpl implements WingChargeDAO {
	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Autowired
	private WingRestDAO wingRestDAO;

	private String errMsg = "";

	@Override
	public void recordChargeJsonData(WingReceiveChargeDataDBParm dbParm) {
		try {
			String sql = "{call p_wing_receive_charge(?,?,?,?,?,?, ?,?,?)}";
			errMsg = String.format("[Charge] record the request json. execute SP : [%s]", "p_wing_receive_charge");
			log.info(errMsg);

			jdbcTemplate.execute(sql, new CallableStatementCallback() {
				@Override
				public Object doInCallableStatement(CallableStatement cs) throws SQLException, DataAccessException {

					cs.setString(1, dbParm.getEUser());
					cs.setString(2, dbParm.getAccount());
					cs.setLong(3, dbParm.getAmount());
					cs.setString(4, dbParm.getUserAcc());
					cs.setString(5, dbParm.getOtp());
					cs.setString(6, dbParm.getReqFlow());
					errMsg = String.format(
							"[Charge] record the request json. execute SP Input Parameter : [%s], [%s], [%s], [%s], [%s], [%s]",
							dbParm.getEUser(), dbParm.getAccount(), dbParm.getAmount(), dbParm.getUserAcc(),
							dbParm.getOtp(), dbParm.getReqFlow());
					log.info(errMsg);

					cs.registerOutParameter(7, Types.VARCHAR);
					cs.registerOutParameter(8, Types.INTEGER);
					cs.registerOutParameter(9, Types.VARCHAR);
					cs.execute();

					int errCode = cs.getInt(8);

					errMsg = String.format(
							"[Charge] record the request json. execute SP Return Parameter : [%s], [%s], [%s]",
							cs.getString(7), cs.getString(8), cs.getString(9));
					log.info(errMsg);

					if (errCode != 0) {
						dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
						dbParm.setErrorMesg(cs.getString(9));
					} else {
						dbParm.setErrorCode(0);
						dbParm.setETradeFlow(cs.getString(7));
					}
					return errCode;
				}
			});
		} catch (DataAccessException e) {
			log.error("[Charge] record the request json. execute procedure p_wing_receive_charge with oracle error: ",
					e);
			dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
			dbParm.setErrorMesg(e.toString().length() <= 100 ? e.toString().substring(1, 100) : e.toString());
		}
	}

	@Override
	public WingValidateDBParam recordValidateBeforeDB(WingValidateReq req, String eTradeFlow) {
		WingValidateDBParam dbParm = new WingValidateDBParam();
		dbParm.setETradeFlow(eTradeFlow);
		dbParm.setJsonData(JSON.toJSONString(req));
		dbParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_POSTING);
		executeSP(dbParm);
		return dbParm;
	}

	@Override
	public WingValidateRes restWingValidate(WingValidateReq req, String token) {
		WingValidateRes out = new WingValidateRes();

		WingBaseRes restOut = wingRestDAO.validateRest(JSON.toJSONString(req), token);

		if (restOut.getErrorCode() != 0) {
			out.setErrorCode(restOut.getErrorCode());
			out.setErrorMessage(restOut.getErrorMessage());
			out.setHttpStatus(restOut.getHttpStatus());
			return out;
		}

		out = JSON.parseObject(restOut.getJsonString(), WingValidateRes.class);
		out.setErrorCode(0);
		out.setHttpStatus(200);

		return out;
	}

	@Override
	public void recordValidatePostDB(WingValidateDBParam dbParm) {
		executeSP(dbParm);
	}

	@Override
	public WingCommitDBParam recordCommitBeforeDB(String eTradeFlow) {
		WingCommitDBParam dbParm = new WingCommitDBParam();
		dbParm.setETradeFlow(eTradeFlow);
		dbParm.setJsonData("{}");
		dbParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_POSTING);
		executeSP(dbParm);
		return dbParm;
	}

	@Override
	public WingCommitRes restWingCommit(String token) {
		WingCommitRes out = new WingCommitRes();

		WingBaseRes restOut = wingRestDAO.commitRest(token);

		if (restOut.getErrorCode() != 0) {
			out.setErrorCode(restOut.getErrorCode());
			out.setErrorMessage(restOut.getErrorMessage());
			out.setHttpStatus(restOut.getHttpStatus());
			return out;
		}

		out = JSON.parseObject(restOut.getJsonString(), WingCommitRes.class);
		out.setErrorCode(0);
		out.setHttpStatus(200);

		return out;
	}

	@Override
	public void recordCommitPostDB(WingCommitDBParam dbParm) {
		executeSP(dbParm);
	}

	@Override
	public WingChargeOutputParam genOutParam(String eTradeFlow) {
		WingChargeOutputParam out = new WingChargeOutputParam();
		String sql = "select balance, fee, exchange_context, wing_trans_id from trd_wing_record where e_trade_flow = ?";
		
		SqlRowSet r = jdbcTemplate.queryForRowSet(sql, eTradeFlow);
		if (r.next()){
			out.setBalance(r.getLong(1));
			out.setFee(r.getLong(2));
			out.setExchange(r.getString(3));
			out.setWingFlow(r.getString(4));
			out.setResFlow(eTradeFlow);
		}
		
		return out;
	}

	public void executeSP(WingValidateDBParam dbParm) {
		String spName = "p_wing_validate";
		try {
			String sql = String.format("{call %s(?,?,?,?,?, ?,?,?)}", spName);
			errMsg = String.format("[Charge] record the data after posting Wing. execute SP : [%s]", spName);
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
							"[Charge] record the data after posting Wing. execute SP %s Input Parameter : [%s], [%s], [%s], [%s], [%s]",
							spName, dbParm.getETradeFlow(), JSON.toJSONString(dbParm.getJsonData()),
							dbParm.getRestStatus(), dbParm.getEInPostId(), dbParm.getHttpStatus());
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
							"[Charge] record the data after posting Wing. execute SP %s Return Parameter : [%s], [%s], [%s]",
							spName, cs.getString(6), cs.getString(7), cs.getString(8));
					log.info(errMsg);
					if (errCode != 0) {
						errMsg = String.format(
								"[Charge] record the data after posting Wing. execute SP %s with oracle error: code [%s], message [%s]",
								spName, cs.getString(7), cs.getString(8));
						log.error(errMsg);
						dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
						return errCode;
					}

					return errCode;
				}
			});

		} catch (DataAccessException e) {
			log.error(String.format("[Charge] record the data after posting Wing. execute SP %s with oracle error: %s",
					spName, e));
			dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
			dbParm.setErrorMessage(e.toString().length() <= 100 ? e.toString().substring(1, 100) : e.toString());
		}
	}

	public void executeSP(WingCommitDBParam dbParm) {
		String spName = "p_wing_commit";
		try {
			String sql = String.format("{call %s(?,?,?,?,?, ?,?,?)}", spName);
			errMsg = String.format("[Charge] record the data after posting Wing. execute SP : [%s]", spName);
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
							"[Charge] record the data after posting Wing. execute SP %s Input Parameter : [%s], [%s], [%s], [%s], [%s]",
							spName, dbParm.getETradeFlow(), JSON.toJSONString(dbParm.getJsonData()),
							dbParm.getRestStatus(), dbParm.getEInPostId(), dbParm.getHttpStatus());
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
							"[Charge] record the data after posting Wing. execute SP %s Return Parameter : [%s], [%s], [%s]",
							spName, cs.getString(6), cs.getString(7), cs.getString(8));
					log.info(errMsg);
					if (errCode != 0) {
						errMsg = String.format(
								"[Charge] record the data after posting Wing. execute SP %s with oracle error: code [%s], message [%s]",
								spName, cs.getString(7), cs.getString(8));
						log.error(errMsg);
						dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
						return errCode;
					}

					return errCode;
				}
			});

		} catch (DataAccessException e) {
			log.error(String.format("[Charge] record the data after posting Wing. execute SP %s with oracle error: %s",
					spName, e));
			dbParm.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
			dbParm.setErrorMessage(e.toString().length() <= 100 ? e.toString().substring(1, 100) : e.toString());
		}
	}

}

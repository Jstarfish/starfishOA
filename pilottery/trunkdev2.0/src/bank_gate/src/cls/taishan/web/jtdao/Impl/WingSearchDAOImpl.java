package cls.taishan.web.jtdao.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.InvalidResultSetAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.web.jtdao.WingSearchDAO;
import cls.taishan.web.model.control.WingSearchInputParam;
import cls.taishan.web.model.control.WingSearchOutputParam;
import lombok.extern.log4j.Log4j;

@Log4j
@Repository
public class WingSearchDAOImpl implements WingSearchDAO {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Override
	public int searchTrade(WingSearchInputParam in, WingSearchOutputParam out) {
		String errMsg = "";
		// 检查输入参数
		if (!checkInput(in)){
			errMsg = "Input Parameter not valid. Can not find the record.";
			log.info(errMsg + " param is: " + in);
			out.setErrorCode(SysConstants.ERR_SEARCH_INVALID_INPUT);
			out.setErrorMessage(errMsg);
			return SysConstants.ERR_SEARCH_INVALID_INPUT;
		}
		
		try {
			String sql = "select is_succ, nvl(balance, 0), nvl(fee, 0), exchange_context, euser_trade_flow, wing_trans_id, customer_name from trd_wing_record where euser_trade_flow = ?";
			log.info("Do search for part 1. Param :" + in.getReqFlow());
			SqlRowSet r = jdbcTemplate.queryForRowSet(sql, in.getReqFlow());
			if (r.next()){
				out.setIsSucc(r.getInt(1));
				out.setBalance(r.getLong(2));
				out.setFee(r.getLong(3));
				out.setExchange(r.getString(4));
				out.setResFlow(r.getString(5));
				out.setWingFlow(r.getString(6));
				out.setUserName(r.getString(7));
			}

			sql = "select EXT_TEXT from TRD_WING_POST_DATA where E_POST_ID = (select max(E_POST_ID) from TRD_WING_POST_DATA where E_TRADE_FLOW = ?)";
			log.info("Do search for part 2. Param :" + in.getReqFlow());
			r = jdbcTemplate.queryForRowSet(sql, in.getReqFlow());
			if (r.next()){
				out.setFailReason(r.getString(1));
			}
		} catch (InvalidResultSetAccessException e) {
			errMsg = "Do search has a error. [InvalidResultSetAccessException]";
			log.info(errMsg);
			e.printStackTrace();
			out.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
			out.setErrorMessage(errMsg);
			return SysConstants.ERR_COMMON_ORACLE_ERROR;
		} catch (DataAccessException e) {
			errMsg = "Do search has a error. [DataAccessException]";
			log.info(errMsg);
			e.printStackTrace();
			out.setErrorCode(SysConstants.ERR_COMMON_ORACLE_ERROR);
			out.setErrorMessage(errMsg);
			return SysConstants.ERR_COMMON_ORACLE_ERROR;
		}
		return 0;
	}

	@Override
	public boolean checkInput(WingSearchInputParam in) {
		log.info("Checking search parameter :" + in);
		String sql = "select count(*) from TRD_WING_RECORD where EUSER_TRADE_FLOW = ? and USER_ID = ? and ACC_NO = ? and TRADE_TYPE = ?";
		int r = jdbcTemplate.queryForInt(sql, in.getReqFlow(), in.getEuser(), in.getAccount(), in.getTransType());
		if (r != 1) return false;
		return true;
	}

}
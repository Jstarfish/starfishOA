package cls.pilottery.web.logistics.service.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.STRUCT;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.logistics.controller.LogisticsController;
import cls.pilottery.web.logistics.dao.LogisticsDao;
import cls.pilottery.web.logistics.form.LogisticsForm;
import cls.pilottery.web.logistics.model.LogisticsList;
import cls.pilottery.web.logistics.model.LogisticsResult;
import cls.pilottery.web.logistics.model.PayoutModel;
import cls.pilottery.web.logistics.service.LogisticsService;

@Service
public class LogisticsServiceImpl implements LogisticsService {

	@Autowired
	LogisticsDao dao;

	static Logger logger = Logger.getLogger(LogisticsController.class);

	@Override
	public LogisticsList getLogistics(LogisticsForm form) throws Exception {

		// 先解析完后入库，是为了减少连接占用时间代码；好判断长度
		Connection conn = null;
		OracleCallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		long amount = 0;
		LogisticsList lg = new LogisticsList();
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			stmt = (OracleCallableStatement) conn.prepareCall("{ call P_GET_LOTTERY_HISTORY(?,?,?,?,?,?,?,?,?,?) }");
			logger.info("{ call P_GET_LOTTERY_HISTORY(?,?,?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, form.getPlanCode());
			stmt.setObject(2, form.getBatchCode());
			stmt.setObject(3, form.getSpecification());
			stmt.setObject(4, form.getTagCode());
			stmt.setObject(5, form.getTicketNo());
			stmt.registerOutParameter(6, Types.NUMERIC);
			stmt.registerOutParameter(7, Types.DATE);
			stmt.registerOutParameter(8, OracleTypes.ARRAY, "TYPE_LOGISTICS_LIST");
			stmt.registerOutParameter(9, Types.VARCHAR);
			stmt.registerOutParameter(10, Types.VARCHAR);
			stmt.executeQuery();
			amount = stmt.getLong(6);
			resultCode = stmt.getInt(9);
			resultMesg = stmt.getString(10);
			lg.setRewardAmount(amount);
			lg.setRewardTime(stmt.getDate(7));
			lg.setC_errcode(resultCode);
			lg.setC_errmsg(resultMesg);
			List<LogisticsResult> list = null;
			ARRAY array = (oracle.sql.ARRAY) stmt.getArray(8);
			if(array == null){
				return null;
			}
			ResultSet rs = array.getResultSet();
			while (rs != null && rs.next()) {
				LogisticsResult r = new LogisticsResult();
				STRUCT struct = (STRUCT) rs.getObject(2);
				Object[] attribs = struct.getAttributes();
				r.setTime((Date) attribs[0]);
				r.setObjType(Integer.parseInt(attribs[1].toString()));
				r.setWarehouseNo(attribs[2].toString());
				if (attribs[3] != null)
					r.setOperator(attribs[3].toString());
				if (list == null)
					list = new ArrayList<LogisticsResult>();
				list.add(r);
			}
			lg.setResult(list);
			logger.info("call P_GET_LOTTERY_HISTORY args: " + form.toString());
			if (resultCode != 0)
				throw new Exception("resultMesg");
		} catch (Exception e) {
			throw new Exception("Invalid Logistics Code");
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
		return lg;
	}

	@Override
	public String getWarehousename(String warehouseCode) {

		return dao.getWarehousename(warehouseCode);
	}

	@Override
	public String getUserName(String userCode) {

		return dao.getUserName(userCode);
	}

	@Override
	public PayoutModel getPayout(LogisticsForm form) {

		return dao.getPayout(form);
	}
}

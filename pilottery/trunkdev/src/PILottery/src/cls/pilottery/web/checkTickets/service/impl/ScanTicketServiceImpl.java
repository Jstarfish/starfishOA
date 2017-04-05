package cls.pilottery.web.checkTickets.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.checkTickets.dao.ScanTicketDao;
import cls.pilottery.web.checkTickets.form.ScanTicketDataForm;
import cls.pilottery.web.checkTickets.form.ScanTicketDataParamt;
import cls.pilottery.web.checkTickets.model.GameBatchInfo;
import cls.pilottery.web.checkTickets.service.ScanTicketService;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

@Service
public class ScanTicketServiceImpl implements ScanTicketService {
	static Logger logger = Logger.getLogger(ScanTicketServiceImpl.class);
	@Autowired
	private ScanTicketDao scanTicketDao;
	
	@Override
	public List<GameBatchInfo> getGameBatchInfo()
	{
		return this.scanTicketDao.getGameBatchInfo();
	}

	@Override
	public void submitTicketData(ScanTicketDataForm scanTicketDataForm) {
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;

		String resultMesg = "";
		
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_REWARD_INFO",
					conn);
			STRUCT[] result = new STRUCT[scanTicketDataForm.getPara().size()];
			for (int index = 0; index < scanTicketDataForm.getPara().size(); index++) {
				ScanTicketDataParamt gpr = scanTicketDataForm.getPara().get(index);
				Object[] o = new Object[5];
				o[0] =  gpr.getPlanCode(); //方案 
				o[1] =  gpr.getBatchNo(); //批次
				o[2] =  gpr.getPackageNo(); //本号
				o[3] =  gpr.getTicketNo(); //本号
				o[4] =  gpr.getSecurityCode(); //本号
				result[index] = new STRUCT(sd, conn, o);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor(
					"TYPE_LOTTERY_REWARD_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			
			logger.info("call p_lottery_reward2(?,?,?,?,?,?,?,?,?,?) ");
			
			stmt = conn.prepareCall("{ call p_lottery_reward2(?,?,?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, scanTicketDataForm.getOper());
			stmt.setObject(2, oracle_array);
			stmt.registerOutParameter(3, OracleTypes.ARRAY, "TYPE_MM_CHECK_LOTTERY_LIST");
			stmt.registerOutParameter(4, OracleTypes.NUMBER);
			stmt.registerOutParameter(5, OracleTypes.NUMBER);
			stmt.registerOutParameter(6, OracleTypes.NUMBER);
			stmt.registerOutParameter(7, OracleTypes.NUMBER);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			stmt.registerOutParameter(9, OracleTypes.NUMBER);
			stmt.registerOutParameter(10, OracleTypes.VARCHAR);
			/*logger.info("p_batch_inbound arg:"+ goodsStruct.toString());*/
			
			stmt.execute();
			
			resultCode = stmt.getInt(9);
			resultMesg = stmt.getString(10);
			
			logger.info("return code: " + resultCode);
			logger.info("return mesg: " + resultMesg);
		//	goodsStruct.setP_inbound_no(sgrNo);
			
			scanTicketDataForm.setC_errcode(resultCode);
			scanTicketDataForm.setC_errmsg(resultMesg);
			scanTicketDataForm.setPayflow(stmt.getString(8));
			
			
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}
}

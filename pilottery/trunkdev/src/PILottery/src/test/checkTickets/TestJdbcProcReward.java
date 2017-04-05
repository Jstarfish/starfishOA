package test.checkTickets;

import java.sql.CallableStatement;
import java.sql.Connection;

import org.junit.Test;

import cls.pilottery.common.utils.DBConnectUtil;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

public class TestJdbcProcReward {
	@Test
	public void test()
	{
		Connection conn = null;
		CallableStatement stmt = null;
		
		Integer operator = 0;
		
		String planCode = "J0004";
		String batchNo = "15905";
		String packageNo = "0009295";
		Integer ticketNo = 100;
		String securityCode = "AAKRVJSGHANTCMAHAH034";
		
		String oPlanCode = "";
		String oBatchNo = "";
		Integer oValidNumber = 0;
		String oTrunkNo = "";
		String oBoxNo = "";
		String oPackageNo = "";
		Integer oTickets = 0;
		Integer oStatus = 0;
		
		Integer applyTickets = 0;
		Integer failTicketsNew = 0;
		Integer rewardTickets = 0;
		Integer rewardAmount = 0;
		String payFlow = "";
		Integer errorCode = 0;
		String errorMesg = "";
		
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareCall("{ call p_lottery_reward2(?,?,?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, operator);
			
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_REWARD_INFO", conn);
			STRUCT[] result = new STRUCT[1];
			
			Object[] obj = new Object[5];
			obj[0] = planCode;
			obj[1] = batchNo;
			obj[2] = packageNo;
			obj[3] = ticketNo;
			obj[4] = securityCode;
			result[0] = new STRUCT(sd, conn, obj);
			
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor("TYPE_LOTTERY_REWARD_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			stmt.setObject(2, oracle_array);
			
			stmt.registerOutParameter(3, OracleTypes.ARRAY, "TYPE_MM_CHECK_LOTTERY_LIST");
			stmt.registerOutParameter(4, OracleTypes.NUMBER);
			stmt.registerOutParameter(5, OracleTypes.NUMBER);
			stmt.registerOutParameter(6, OracleTypes.NUMBER);
			stmt.registerOutParameter(7, OracleTypes.NUMBER);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			stmt.registerOutParameter(9, OracleTypes.NUMBER);
			stmt.registerOutParameter(10, OracleTypes.VARCHAR);
			stmt.execute();
			
			System.out.println("Callable statement is successfully executed..");
			
			applyTickets = stmt.getInt(4);
			failTicketsNew = stmt.getInt(5);
			rewardTickets = stmt.getInt(6);
			rewardAmount = stmt.getInt(7);
			payFlow = stmt.getString(8);
			errorCode = stmt.getInt(9);
			errorMesg = stmt.getString(10);
			
		} catch (Exception e) {
			System.out.println("Exception: " + e.getMessage());
		} finally {
			System.out.println("ApplyTickets: " + applyTickets);
			System.out.println("FailTicketsNew: " + failTicketsNew);
			System.out.println("RewardTickets: " + rewardTickets);
			System.out.println("RewardAmount: " + rewardAmount);
			System.out.println("PayFlow: " + payFlow);
			System.out.println("ErrorCode: " + errorCode);
			System.out.println("ErrorMesg: " + errorMesg);
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}
}

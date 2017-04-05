package test.items;

import java.sql.CallableStatement;
import java.sql.Connection;

import org.junit.Test;

import cls.pilottery.common.utils.DBConnectUtil;
import oracle.jdbc.internal.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;
import test.BaseTest;

public class TestJdbcProcItemIssue extends BaseTest {
	@Test
	public void test()
	{
		Connection conn = null;
		CallableStatement stmt = null;
		Integer operator = 0;
		String warehouseCode = "6601";
		String receivingUnit = "99";
		String issueCode = "";
		Integer errorCode = 0;
		String errorMesg  = "";
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareCall("{ call p_item_outbound(?,?,?,?,?,?,?) }");
			stmt.setObject(1, operator);
			stmt.setObject(2, warehouseCode);
			stmt.setObject(3, receivingUnit);
			
			StructDescriptor sd = new StructDescriptor("TYPE_ITEM_INFO", conn);
			STRUCT[] result = new STRUCT[3];
			
			Object[] obj1 = new Object[2];
			obj1[0] = new String("IT100010");
			obj1[1] = new Integer(1);
			result[0] = new STRUCT(sd, conn, obj1);
			
			Object[] obj2 = new Object[2];
			obj2[0] = new String("IT100011");
			obj2[1] = new Integer(1);
			result[1] = new STRUCT(sd, conn, obj2);
			
			Object[] obj3 = new Object[2];
			obj3[0] = new String("IT100012");
			obj3[1] = new Integer(1);
			result[2] = new STRUCT(sd, conn, obj3);
			
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor("TYPE_ITEM_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			stmt.setObject(4, oracle_array);
			
			stmt.registerOutParameter(5, OracleTypes.VARCHAR);
			stmt.registerOutParameter(6, OracleTypes.NUMBER);
			stmt.registerOutParameter(7, OracleTypes.VARCHAR);
			stmt.execute();
			
			System.out.println("Callable statement is successfully executed..");
			
			issueCode = stmt.getString(5);
			errorCode = stmt.getInt(6);
			errorMesg = stmt.getString(7);
		} catch (Exception e) {
			System.out.println("Exception: " + e.getMessage());
		} finally {
			System.out.println("issueCode: " + issueCode);
			System.out.println("ErrorCode: " + errorCode);
			System.out.println("ErrorMesg: " + errorMesg);
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}
}

package test.items;

import java.sql.CallableStatement;
import java.sql.Connection;

import org.junit.Test;

import cls.pilottery.common.utils.DBConnectUtil;
import oracle.jdbc.OracleTypes;
import test.BaseTest;

public class TestJdbcProcItemDelete extends BaseTest {
	@Test
	public void test()
	{
		Connection conn = null;
		CallableStatement stmt = null;
		String itemCode = "IT100001";
		Integer errorCode = 0;
		String errorMesg  = "";
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareCall("{ call p_item_delete(?,?,?) }");
			stmt.setObject(1, itemCode);
			stmt.registerOutParameter(2, OracleTypes.NUMBER);
			stmt.registerOutParameter(3, OracleTypes.VARCHAR);
			stmt.execute();
			errorCode = stmt.getInt(2);
			errorMesg = stmt.getString(3);
		} catch (Exception e) {
			System.out.println("Exception: " + e.getMessage());
		} finally {
			System.out.println("ErrorCode: " + errorCode);
			System.out.println("ErrorMesg: " + errorMesg);
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}
}

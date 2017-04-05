package cls.pilottery.common.utils;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
/**
 * JDBC连接数据库
 * @author Woo
 */
public class DBConnectUtil {
	
	
	public static void main()
	{
		Connection conn = DBConnectUtil.getConnection();
		if(conn != null)
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}
	
	/** 
     * 取得即开票数据库连接 
     * @return 
     */  
    public static Connection getConnection() {  
        Connection conn = null;  
        Properties pro = new Properties();                           
		try {
			pro.load(DBConnectUtil.class.getClassLoader().getResourceAsStream("config/jdbc.properties"));
		    String url = pro.getProperty("jdbc.db1.url");
		    String user = pro.getProperty("jdbc.db1.username");
		    String pwd = pro.getProperty("jdbc.db1.password");
			DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
			conn = DriverManager.getConnection(url, user, pwd);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
        return conn;  
    }  
    
    /** 
     * 取得OMS数据库连接 
     * @return 
     */  
    public static Connection getOmsConnection() {  
        Connection conn = null;  
        Properties pro = new Properties();                           
		try {
			pro.load(DBConnectUtil.class.getClassLoader().getResourceAsStream("config/jdbc.properties"));
		    String url = pro.getProperty("jdbc.db2.url");
		    String user = pro.getProperty("jdbc.db2.username");
		    String pwd = pro.getProperty("jdbc.db2.password");
			DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
			conn = DriverManager.getConnection(url, user, pwd);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
        return conn;  
    }  
    /** 
     * 关闭     PreparedStatement 
     * @param pstmt 
     */  
    public static void close(PreparedStatement pstmt) {  
        if (pstmt != null) {  
            try {  
                pstmt.close();  
            } catch (SQLException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
    /** 
     * 关闭     CallableStatement
     * @param stmt 
     */ 
    public static void close(CallableStatement stmt) {  
        if (stmt != null) {  
            try {  
                stmt.close();  
            } catch (SQLException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
    /** 
     * 关闭连接 
     * @param conn 
     */ 
    public static void close(Connection conn) {  
        if (conn != null) {  
            try {  
                conn.close();  
            } catch (SQLException e) {  
                e.printStackTrace();  
            }     
        }  
    }  
    /** 
     * 关闭数据库结果集的数据表 
     * @param rs 
     */ 
    public static void close(ResultSet rs) {  
        if (rs != null) {  
            try {  
                rs.close();  
            } catch (SQLException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
    /** 
     * 提交事务 
     * @param conn 
     */ 
    public static void commit(Connection conn) {  
        if (conn != null) {  
            try {  
                conn.commit();  
            } catch (SQLException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
    /** 
     * 回滚事务 
     * @param conn 
     */ 
    public static void rollback(Connection conn) {  
        if (conn != null) {  
            try {  
                conn.rollback();  
            } catch (SQLException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
    /** 
     * 自动提交事务 
     * @param conn 
     * @param autoCommit 
     */ 
    public static void setAutoCommit(Connection conn, boolean autoCommit) {  
        if (conn != null) {  
            try {  
                conn.setAutoCommit(autoCommit);  
            } catch (SQLException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
    /** 
     * 关闭执行语句 
     * @param stmt 
     */ 
    public static void close(Statement stmt) {  
        if (stmt != null) {  
            try {  
                stmt.close();  
            } catch (SQLException e) {  
                e.printStackTrace();  
            }  
        }  
    }     
}

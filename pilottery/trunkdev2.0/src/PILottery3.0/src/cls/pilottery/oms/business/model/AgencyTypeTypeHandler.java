package cls.pilottery.oms.business.model;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

public class AgencyTypeTypeHandler implements TypeHandler<AgencyType>{

	@Override
	public AgencyType getResult(ResultSet arg0, String arg1)
			throws SQLException {
		// TODO Auto-generated method stub
		Integer value = arg0.getInt(arg1);
		return new AgencyType(value);
	}

	@Override
	public AgencyType getResult(ResultSet arg0, int arg1) throws SQLException {
		// TODO Auto-generated method stub
		Integer value = arg0.getInt(arg1);
		return new AgencyType(value);
	}

	@Override
	public AgencyType getResult(CallableStatement arg0, int arg1)
			throws SQLException {
		// TODO Auto-generated method stub
		Integer value = arg0.getInt(arg1);
		return new AgencyType(value);
	}

	@Override
	public void setParameter(PreparedStatement arg0, int arg1, AgencyType arg2,
			JdbcType arg3) throws SQLException {
		// TODO Auto-generated method stub
		arg0.setInt(arg1,arg2.getValue());
	}

}

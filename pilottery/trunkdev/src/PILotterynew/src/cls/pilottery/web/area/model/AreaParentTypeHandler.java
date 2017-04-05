package cls.pilottery.web.area.model;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

public class AreaParentTypeHandler implements TypeHandler<AreaParent> {

	@Override
	public AreaParent getResult(ResultSet arg0, String arg1)
			throws SQLException {
		// TODO Auto-generated method stub
		Long val = arg0.getLong(arg1);
		return new AreaParent(val,"");
	}

	@Override
	public AreaParent getResult(ResultSet arg0, int arg1) throws SQLException {
		// TODO Auto-generated method stub
		Long val = arg0.getLong(arg1);
		return new AreaParent(val,"");
	}

	@Override
	public AreaParent getResult(CallableStatement arg0, int arg1)
			throws SQLException {
		// TODO Auto-generated method stub
		Long val = arg0.getLong(arg1);
		return new AreaParent(val,"");
	}

	@Override
	public void setParameter(PreparedStatement arg0, int arg1, AreaParent arg2,
			JdbcType arg3) throws SQLException {
		// TODO Auto-generated method stub
		arg0.setLong(arg1, arg2.getCode());
	}

}

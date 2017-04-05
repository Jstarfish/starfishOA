package cls.pilottery.oms.business.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.oms.business.dao.OMSAreaDao;
import cls.pilottery.oms.business.form.OMSAreaAuthForm;
import cls.pilottery.oms.business.form.OMSAreaQueryForm;
import cls.pilottery.oms.business.model.areamodel.OMSArea;
import cls.pilottery.oms.business.model.areamodel.OMSAreaAuth;
import cls.pilottery.oms.business.service.OMSAreaService;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

@Service
public class OMSAreaServiceImpl implements OMSAreaService {
	
	Logger logger = Logger.getLogger(OMSAreaServiceImpl.class);

	@Autowired
	private OMSAreaDao omsAreaDao;
	
	@Override
	public Integer countAreaList(OMSAreaQueryForm form) {
		return omsAreaDao.countAreaList(form);
	}
	
	@Override
	public List<OMSArea> queryAreaList(OMSAreaQueryForm form) {
		return omsAreaDao.queryAreaList(form);
	}
	
	@Override
	public Integer getAgencyCountInArea(String areaCode) {
		return omsAreaDao.getAgencyCountInArea(areaCode);
	}
	
	@Override
	public Integer getTerminalCountInArea(String areaCode) {
		return omsAreaDao.getTerminalCountInArea(areaCode);
	}
	
	@Override
	public Integer getTellerCountInArea(String areaCode) {
		return omsAreaDao.getTellerCountInArea(areaCode);
	}
	
	@Override
	public List<OMSAreaAuth> selectGameFromAreaAuth(String areaCode) {
		return omsAreaDao.selectGameFromAreaAuth(areaCode);
	}
	
	@Override
	public void updateGameAuth(OMSAreaAuthForm omsAreaAuthForm) throws Exception {
		
		Connection conn = null;
		CallableStatement stmt = null;
		
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareCall("{ call p_om_area_auth(?,?,?) }");
			
			StructDescriptor sd = new StructDescriptor("TYPE_GAME_AUTH_INFO_TS", conn);
			int length = omsAreaAuthForm.getGameAuth().size();
			STRUCT[] result = new STRUCT[length];
			for (int i = 0; i < length; i++) {
				OMSAreaAuth gameAuth = omsAreaAuthForm.getGameAuth().get(i);
				Object[] o = new Object[10];
				o[0] = gameAuth.getGameCode();
				o[1] = gameAuth.getAreaCode();
				o[2] = gameAuth.getEnabled();
				o[3] = gameAuth.getPayCommissionRate();
				o[4] = gameAuth.getSaleCommissionRate();
				o[6] = gameAuth.getAllowPay();
				o[7] = gameAuth.getAllowSale();
				o[8] = gameAuth.getAllowCancel();
				result[i] = new STRUCT(sd, conn, o);
			}
			
			logger.info("call p_om_area_auth");
			logger.info("result length:" + result.length);
			
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor("TYPE_GAME_AUTH_LIST_TS", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			
			stmt.setObject(1, oracle_array);
			stmt.registerOutParameter(2, OracleTypes.NUMBER);
			stmt.registerOutParameter(3, OracleTypes.VARCHAR);
			stmt.execute();
			
			omsAreaAuthForm.setC_errcode(stmt.getInt(2));
			omsAreaAuthForm.setC_errmsg(stmt.getString(3));
		} catch (Exception e) {
    		throw e;
    	} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
    	}
	}

	@Override
	public List<OMSArea> getInfOrgsList() {
		return omsAreaDao.getInfOrgsList();
	}
}

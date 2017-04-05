package cls.pilottery.web.capital.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.List;
import java.util.Map;

import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.pos.system.service.impl.OutletsManageServiceImpl;
import cls.pilottery.web.capital.dao.OutletAcctDao;
import cls.pilottery.web.capital.form.OutletAcctForm;
import cls.pilottery.web.capital.form.OutletAdjustForm;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.capital.model.OutletAccountExt;
import cls.pilottery.web.capital.model.OutletAccountModel;
import cls.pilottery.web.capital.model.OutletCommRate;
import cls.pilottery.web.capital.service.OutletAcctService;
import cls.pilottery.web.goodsreceipts.model.GamePlans;

@Service
public class OutletAcctServiceImpl implements OutletAcctService {

	public static Logger logger = Logger.getLogger(OutletAcctServiceImpl.class);
	
	@Autowired
	private OutletAcctDao outletAccDao;

	@Override
	public Integer getOutletAcctCount(OutletAcctForm outletAcctForm) {
		return outletAccDao.getOutletAcctCount(outletAcctForm);
	}

	@Override
	public List<OutletAccount> getOutletAcctList(OutletAcctForm outletAcctForm) {
		return outletAccDao.getOutletAcctList(outletAcctForm);
	}

	@Override
	public List<OutletAccountModel> getOutletAcctInfo(String agencyCode) {
		return outletAccDao.getOutletAcctInfo(agencyCode);
	}

	@Override
	public int deleteupdeSatus(String agencyCode) {
		return outletAccDao.deleteupdeSatus(agencyCode);
	}

	@Override
	public List<GamePlans> getGamePlans() {
		return outletAccDao.getGamePlans();
	}

	@Override
	public List<OutletAccountModel> getOutletCommRateInfo() {
		return outletAccDao.getOutletCommRateInfo();
	}

	@Override
	public void updateAccountComm(OutletAccountExt outlet) {
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_GAME_AUTH_INFO",
					conn);
			STRUCT[] result = new STRUCT[outlet.getOutletCommRate().size()];
			for (int index = 0; index < outlet.getOutletCommRate().size(); index++) {
				OutletCommRate gpr = outlet.getOutletCommRate().get(index);
				Object[] o = new Object[4];
				o[0] = outlet.getAgencyCode(); // 机构编码
				o[1] = gpr.getPlanCode(); // 方案编码
				o[2] = gpr.getSaleComm() == null ? 0 : gpr.getSaleComm(); // 销售代销费
				o[3] = gpr.getPayComm() == null ? 0 : gpr.getPayComm(); // 兑奖代销费
				result[index] = new STRUCT(sd, conn, o);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor(
					"TYPE_GAME_AUTH_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			
			logger.info("call p_outlet_plan_auth(?,?,?,?,?) ");
			stmt = conn.prepareCall("{ call p_outlet_plan_auth(?,?,?,?,?) }");
			stmt.setObject(1, outlet.getAgencyCode());
			stmt.setObject(2, outlet.getCreditLimit());
			stmt.setObject(3, oracle_array);
			stmt.registerOutParameter(4, OracleTypes.NUMBER);
			stmt.registerOutParameter(5, OracleTypes.VARCHAR);
			stmt.execute();

			resultCode = stmt.getInt(4);
			resultMesg = stmt.getString(5);
			logger.debug("return code: " + resultCode);
			logger.debug("return mesg: " + resultMesg);
			
			outlet.setC_errcode(resultCode);
			outlet.setC_errmsg(resultMesg);
			

		} catch (Exception e) {
			e.printStackTrace();		
			logger.error(e);
			
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}

	}

	@Override
	public List<OutletAccountModel> getOutletAcctInfo2(String agencyCode) {
		return outletAccDao.getOutletAcctInfo2(agencyCode);
	}

	@Override
	public void updateAccountLimit(Map<String, Object> map) {
		outletAccDao.updateAccountLimit(map);
	}

	@Override
	public OutletAccountModel getOutletAccountForAdjust(String agencyCode) {
		return outletAccDao.getOutletAccountForAdjust(agencyCode);
	}

	@Override
	@Transactional(rollbackFor={Exception.class})
	public void adjustOutletAccount(OutletAdjustForm form) {
		outletAccDao.adjustOutletAccount(form);
	}

}

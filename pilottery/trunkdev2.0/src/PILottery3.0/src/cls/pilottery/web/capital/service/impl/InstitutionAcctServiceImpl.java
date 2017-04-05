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

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.capital.dao.InstitutionAcctDao;
import cls.pilottery.web.capital.form.InstitutionAcctForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.InstitutionAccountExt;
import cls.pilottery.web.capital.model.InstitutionAccountModel;
import cls.pilottery.web.capital.model.InstitutionCommRate;
import cls.pilottery.web.capital.service.InstitutionAcctService;
import cls.pilottery.web.goodsreceipts.service.impl.GoodsReceiptsServiceImpl;

@Service
public class InstitutionAcctServiceImpl implements InstitutionAcctService {

	static Logger logger = Logger.getLogger(InstitutionAcctServiceImpl.class);
	
	@Override
	public void updateCommRate(InstitutionAccountExt insitutionInfo) {
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_GAME_AUTH_INFO",
					conn);
			STRUCT[] result = new STRUCT[insitutionInfo.getiCommRateList().size()];
			for (int index = 0; index < insitutionInfo.getiCommRateList()
					.size(); index++) {
				InstitutionCommRate gpr = insitutionInfo.getiCommRateList()
						.get(index);
				Object[] o = new Object[4];
				o[0] = gpr.getOrgCode(); // 机构编码
				o[1] = gpr.getPlanCode(); // 方案编码
				o[2] = gpr.getSaleComm() == null ? 0 : gpr.getSaleComm(); // 销售代销费
				o[3] = gpr.getPayComm() == null ? 0 : gpr.getPayComm(); // 兑奖代销费
				result[index] = new STRUCT(sd, conn, o);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor(
					"TYPE_GAME_AUTH_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);

			logger.info("call p_org_plan_auth(?,?,?,?,?) ");
			
			stmt = conn.prepareCall("{ call p_org_plan_auth(?,?,?,?,?) }");
			stmt.setObject(1, insitutionInfo.getOrgCode());
			stmt.setObject(2, insitutionInfo.getCreditLimit());
			stmt.setObject(3, oracle_array);
			stmt.registerOutParameter(4, OracleTypes.NUMBER);
			stmt.registerOutParameter(5, OracleTypes.VARCHAR);
			stmt.execute();

			resultCode = stmt.getInt(4);
			resultMesg = stmt.getString(5);
			logger.debug("return code: " + resultCode);
			logger.debug("return mesg: " + resultMesg);

			insitutionInfo.setErrCode(resultCode);
			insitutionInfo.setErrMessage(resultMesg);

		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}

	@Autowired
	private InstitutionAcctDao institutionAcctDao;

	@Override
	public List<InstitutionAccount> getInstitutionAcctList(
			InstitutionAcctForm institutionAcctForm) {
		return institutionAcctDao.getInstitutionAcctList(institutionAcctForm);
	}

	@Override
	public Integer getInstitutionAcctCount(
			InstitutionAcctForm institutionAcctForm) {
		return institutionAcctDao.getInstitutionAcctCount(institutionAcctForm);
	}

	@Override
	public List<InstitutionAccountModel> getInstitutionAcctInfo(String orgCode) {
		return institutionAcctDao.getInstitutionAcctInfo(orgCode);
	}

	@Override
	public int deleteupdeSatus(String orgCode) {
		return institutionAcctDao.deleteupdeSatus(orgCode);
	}

	@Override
	public List<InstitutionAccountModel> getInstitutionAcctInfo2(String orgCode) {
		return institutionAcctDao.getInstitutionAcctInfo2(orgCode);
	}

	@Override
	public void updateInstitutionLimit(Map<String,Object> map) {
		institutionAcctDao.updateInstitutionLimit(map);
	}
}

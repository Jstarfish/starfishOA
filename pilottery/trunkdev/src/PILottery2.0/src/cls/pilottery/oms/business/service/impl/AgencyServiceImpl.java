package cls.pilottery.oms.business.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.dao.AgencyDao;
import cls.pilottery.oms.business.form.AgencyForm;
import cls.pilottery.oms.business.model.Agency;
import cls.pilottery.oms.business.model.AgencyBank;
import cls.pilottery.oms.business.model.AgencyRefunVo;
import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.oms.business.service.AgencyService;
import cls.pilottery.web.area.model.Areas;
import cls.pilottery.web.area.model.GameAuth;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.driver.OracleConnection;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;


@Service
public class AgencyServiceImpl implements AgencyService{
	Logger logger = Logger.getLogger(AgencyServiceImpl.class);
	@Resource
	private JdbcTemplate jdbcTemplateTwo;
	@Autowired
	private AgencyDao agencyDao;

	@Override
	public List<AgencyBank> getBanks() {
		
		return agencyDao.getBanks();
	}

	@Override
	public String getAgencyName(String agencyCode) {
		return agencyDao.getAgencyName(agencyCode);
	}
	@Override
	public Integer countAgencyList(AgencyForm agencyForm) {
		
		return agencyDao.countAgencyList(agencyForm);
	}
	@Override
	public List<Agency> queryAgencyList(AgencyForm agencyForm) {
		
		return agencyDao.queryAgencyList(agencyForm);
	}
	@Override
	public void updateStatus(Agency agency) {
		
		agencyDao.updateStatus(agency);
	}
	@Override
	public Integer getSalerTellerByAgencode(String agencyCode) {
		
		return this.agencyDao.getSalerTellerByAgencode(agencyCode);
	}
	@Override
	public Integer getSalerTermByAgenCode(String agencyCode) {
		return this.agencyDao.getSalerTermByAgenCode(agencyCode);
	}
	@Override
	public List<GameAuth> selectGameFromAgencymap(Map<String, Object> map) {
		List<GameAuth>authList=new ArrayList<GameAuth>();
		
			authList=this.agencyDao.selectGameFromAgencymap(map);
		
		return authList;
	}
	@Override
	public String batchInsertGameAuth(Agency agency) {

		List<GameAuth> gameAuthList = agency.getValidGames();
		
		int resultCode = 0;
		String resultMesg = "";

		Connection conn = null;
		try {
		
			conn = jdbcTemplateTwo.getDataSource().getConnection();
			if (conn.isWrapperFor(OracleConnection.class)) {
				conn = conn.unwrap(OracleConnection.class);
			}
			conn.setAutoCommit(false);
			
			StructDescriptor sd = new StructDescriptor("TYPE_GAME_AUTH_INFO",
					conn);
			STRUCT[] result = new STRUCT[gameAuthList.size()];
			for (int index = 0; index < gameAuthList.size(); index++) {
				GameAuth gameAuth = gameAuthList.get(index);
				Object[] o = new Object[10];
				o[0] = (int) gameAuth.getGameCode();
				o[1] = gameAuth.getAgencyCode();
				o[2] = gameAuth.getStatus();
				o[3] = (int) gameAuth.getPayCommissionRate();
				o[4] = (int) gameAuth.getSaleCommissionRate();
				o[5] = gameAuth.getFee();
				o[6] = gameAuth.getPayStatus();
				o[7] = gameAuth.getSellStatus();
				o[8] = gameAuth.getCancelStatus();
				o[9] = gameAuth.getClaimingScope();
				result[index] = new STRUCT(sd, conn, o);
			}

			logger.info("call  p_om_agency_auth");
			logger.info("result length:" + result.length);

			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor(
					"TYPE_GAME_AUTH_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			logger.info("oracle_array length:" + oracle_array.getLength());

			CallableStatement stmt = conn
					.prepareCall("{ call p_om_agency_auth(?,?,?) }");
			stmt.setObject(1, oracle_array);
			stmt.registerOutParameter(2, OracleTypes.NUMBER);
			stmt.registerOutParameter(3, OracleTypes.VARCHAR);
			stmt.execute();

			resultCode = stmt.getInt(2);
			resultMesg = stmt.getString(3);
		} catch (SQLException e) {
			logger.error("", e);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					logger.error("", e);
				}
				conn = null;
			}
		}
		return resultCode + "#" + resultMesg;
		
	}
	@Override
	public Agency getAgencyByCode(String code) {
		return agencyDao.selectAgencyByCode(code);
	}

	@Override
	public List<GameAuth> getGameFromAgency(String code) {
		return agencyDao.selectGameFromAgency(code);
	}


	@Override
	public AgencyRefunVo getRefunInfoByagencycode(String code) {
		return this.agencyDao.getRefunInfoByagencycode(code);
	}
	@Override
	public Integer ifAgencyCodeExist(String agencyCode) {
		return agencyDao.ifAgencyCodeExist(agencyCode);
	}

	@Override
	public Areas getAreaCodeByInstionCode(String orgCode) {
		Areas area=new Areas();
		List<Areas> listareas=new ArrayList<Areas>();
		listareas=this.agencyDao.getAreaCodeByInstionCode(orgCode);
		if(listareas!=null && listareas.size()>0){
			area=listareas.get(0);
		}
		return area;
	}

	@Override
	public List<OrgInfo> getOrgListByOrgCode(String orgCode) {
		return agencyDao.getOrgListByOrgCode(orgCode);
	}

	@Override
	public List<GameAuth> getGameFromArea(String code) {
		return agencyDao.getGameFromArea(code);
	}

}

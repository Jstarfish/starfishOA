package cls.pilottery.web.inventory.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.goodsreceipts.model.GameBatchParamt;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GamePlans;
import cls.pilottery.web.inventory.dao.CheckPointDao;
import cls.pilottery.web.inventory.form.CheckPointForm;
import cls.pilottery.web.inventory.model.CheckBatchStruct;
import cls.pilottery.web.inventory.model.CheckPointInfoVo;
import cls.pilottery.web.inventory.model.CheckPointParmat;
import cls.pilottery.web.inventory.model.CheckPointResult;
import cls.pilottery.web.inventory.model.CheckPointVo;
import cls.pilottery.web.inventory.model.CheckStruct;
import cls.pilottery.web.inventory.model.WhInfoVo;
import cls.pilottery.web.inventory.service.CheckPointService;
import cls.pilottery.web.system.model.User;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;
@Service
public class CheckPointServiceImpl implements CheckPointService {
	
	static Logger logger = Logger.getLogger(CheckPointServiceImpl.class);
	
	@Autowired
	private CheckPointDao  checkPointDao;
	/**
	 * 
	    * @Title: getCheckCount
	    * @Description: 盘点分页总记录数
	    * @param @param checkPointForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
 
	@Override
	public Integer getCheckCount(CheckPointForm checkPointForm) {
	
		return this.checkPointDao.getCheckCount(checkPointForm);
	}
	 /**
	   * 
	      * @Title: getCheckList
	      * @Description: 盘点记录分页
	      * @param @param checkPointForm
	      * @param @return    参数
	      * @return List<CheckPointVo>    返回类型
	      * @throws
	   */

	@Override
	public List<CheckPointVo> getCheckList(CheckPointForm checkPointForm) {
		
		return this.checkPointDao.getCheckList(checkPointForm);
	}
	  /**
	   * 
	      * @Title: getCpCheckUserList
	      * @Description: 获取仓库管理员
	      * @param @return    参数
	      * @return List<User>    返回类型
	      * @throws
	   */
	 
	@Override
	public List<User> getCpCheckUserList(String orgCode) {
		
		return this.checkPointDao.getCpCheckUserList(orgCode);
	}
	 /**
	   * 
	      * @Title: getWhouseList
	      * @Description: 获取仓库信息
	      * @param @return    参数
	      * @return List<WhInfoVo>    返回类型
	      * @throws
	   */
	@Override
	public List<WhInfoVo> getWhouseList() {
	
		return this.checkPointDao.getWhouseList();
	}
	 /**
	   * 
	      * @Title: getGameBatchListBCode
	      * @Description: 获得批次信息
	      * @param @param gameBatchImport
	      * @param @return    参数
	      * @return List<GameBatchImport>    返回类型
	      * @throws
	   */
	@Override
	public List<GameBatchImport> getGameBatchListBCode(GameBatchImport gameBatchImport) {
		
		return this.checkPointDao.getGameBatchListBCode(gameBatchImport);
	}
	 /**
	   * 
	      * @Title: addCheckPoint
	      * @Description: 添加盘点
	      * @param @param checkPointParmat    参数
	      * @return void    返回类型
	      * @throws
	   */
	@Override
	public void addCheckPoint(CheckPointParmat checkPointParmat) {
		this.checkPointDao.addCheckPoint(checkPointParmat);
		
	}
	/**
	   * 
	      * @Title: getProcessCheckInfoByCode
	      * @Description: 获得盘点单信息
	      * @param @param cpNo
	      * @param @return    参数
	      * @return CheckPointInfoVo>   返回类型
	      * @throws
	   */
	@Override
	public CheckPointInfoVo getProcessCheckInfoByCode(String cpNo) {
		CheckPointInfoVo vo=new CheckPointInfoVo();
		List<CheckPointInfoVo> listvo=this.checkPointDao.getProcessCheckInfoByCode(cpNo);
		if(listvo!=null && listvo.size()>0){
			vo=listvo.get(0);
		}
		return vo;
	}
	@Override
	public List<GameBatchImport> getAllBatchinfo() {
		
		return this.checkPointDao.getAllBatchinfo();
	}
	@Override
	public List<GamePlans> getAllgameplans() {
		
		return this.checkPointDao.getAllgameplans();
	}
	@Override
	public CheckStruct addCheckPointBatch(CheckPointParmat checkPointParmat) {
		CheckStruct cstruct=new CheckStruct();
		List<GameBatchParamt> paraList=checkPointParmat.getPara();

		cstruct.setCpNo(checkPointParmat.getCpNo());
		 List<CheckBatchStruct> batchList = new ArrayList<CheckBatchStruct>();
		 
		 
		 if(paraList!=null && paraList.size()>0){
			 for(GameBatchParamt paramt:paraList){
				 if(paramt.getPlanCode()!=null && paramt.getPlanCode()!="" ){
					 CheckBatchStruct gb=new CheckBatchStruct();
					 gb.setPlanCode(paramt.getPlanCode());
					 gb.setBatchNo(paramt.getBatchCode());
					 if(paramt.getPackUnitValue()==1){
						 gb.setTrunkNo(paramt.getPackUnitCode());
						 
					 }
					 if(paramt.getPackUnitValue()==2){
						 gb.setBoxNo(paramt.getPackUnitCode());
						 
					 }
					 gb.setValidNumber(paramt.getPackUnitValue());
					 gb.setPackageNo(paramt.getFirstPkgCode());
					 gb.setRewardGroup(new Integer(paramt.getGroupCode()));
					 batchList.add(gb);
				 }
			 }
			 
			 cstruct.setBatchList(batchList);
		}
		 this.addCallProce(cstruct);
		return cstruct;
	}
	private void addCallProce(CheckStruct cstruct){

		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
	
		String resultMesg = "";
		
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
					conn);
			STRUCT[] result = new STRUCT[cstruct.getBatchList().size()];
			for (int index = 0; index < cstruct.getBatchList().size(); index++) {
				CheckBatchStruct gpr = cstruct.getBatchList().get(index);
				Object[] o = new Object[9];
				o[0] =  gpr.getPlanCode(); //方案 
				o[1] =  gpr.getBatchNo(); //批次
				o[2] =  gpr.getValidNumber(); //型号1-箱号、2-盒号、3-本号
				switch (gpr.getValidNumber()) {
				case 1:
					o[3] =  gpr.getTrunkNo();
					o[4] =  "";
					o[5] =  "";
					o[6] =  gpr.getPackageNo();
					o[7] =  "";
					break;
				case 2:
					o[3] =  "";
					o[4] =  gpr.getBoxNo();
					o[5] =  "";
					o[6] =  gpr.getPackageNo();
					o[7] =  "";
					break;
				case 3:
					o[3] =  "";
					o[4] =  "";
					o[5] =  "";
					o[6] =  gpr.getPackageNo();
					o[7] =  "";
					break;
				default:
					break;
				}
				o[8] =  gpr.getRewardGroup(); //奖组
				result[index] = new STRUCT(sd, conn, o);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor(
					"TYPE_LOTTERY_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			
			logger.info("call p_warehouse_check_step2(?,?,?,?)");
		
			stmt = conn.prepareCall("{ call p_warehouse_check_step2(?,?,?,?) }");
			stmt.setObject(1, cstruct.getCpNo());
		
			stmt.setObject(2, oracle_array);
			
			stmt.registerOutParameter(3, OracleTypes.NUMBER);
			stmt.registerOutParameter(4, OracleTypes.VARCHAR);
			stmt.execute();
          
			resultCode = stmt.getInt(3);
			resultMesg = stmt.getString(4);
			System.out.println("return code: " + resultCode);
			System.out.println("return mesg: " + resultMesg);
		//	goodsStruct.setP_inbound_no(sgrNo);
			cstruct.setC_errorcode(resultCode);
			cstruct.setC_errormesg(resultMesg);
		
			logger.info("p_warehouse_check_step2 arg:"+ cstruct.toString());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}
	@Override
	public void checkPointomplete(CheckPointResult checkPointResult) {
		this.checkPointDao.checkPointomplete(checkPointResult);
		
	}
	@Override
	public List<CheckPointResult> getCpnormaiList(String cpNo) {
		return this.checkPointDao.getCpnormaiList(cpNo);
	}
	@Override
	public List<CheckPointResult> getCheckPointDetailList(String cpNo) {
		return this.checkPointDao.getCheckPointDetailList(cpNo);
	}
	@Override
	public CheckPointResult getCheckPointSum(String cpNo) {
	
		return this.checkPointDao.getCheckPointSum(cpNo);
	}
	@Override
	public void deleteChckpoinByCode(String cpNo) {

	      this.checkPointDao.deleteChckpoinByCode(cpNo);
		
		
	}
	@Override
	public void deleteChckpoinDetailByCode(String cpNo) {
	
		  this.checkPointDao.deleteChckpoinDetailByCode(cpNo);
		
	}
	@Transactional(rollbackFor = { RuntimeException.class })
	@Override
	public void deleteChckpoin(String cpNo) {
		try{
			updateWhinfoStatus(cpNo);
			deleteChckpoinByCode(cpNo);
			deleteChckpoinDetailByCode(cpNo);
			
		}
		catch(Exception e){
			throw new RuntimeException();
		}
		
	}
	
	@Override
	public List<GamePlanVo> getGamsListCheck(String cpNo) {
		
		return this.checkPointDao.getGamsListCheck(cpNo);
	}
	@Override
	public void updateWhinfoStatus(String cpNo) {
		
		this.checkPointDao.updateWhinfoStatus(cpNo);
		
		
	}
	@Override
	public Integer getCheckInquiryCount(CheckPointForm checkPointForm) {
		return checkPointDao.getCheckInquiryCount(checkPointForm);
	}
	@Override
	public List<CheckPointVo> getCheckInquiryList(CheckPointForm checkPointForm) {
		return checkPointDao.getCheckInquiryList(checkPointForm);
	}

}

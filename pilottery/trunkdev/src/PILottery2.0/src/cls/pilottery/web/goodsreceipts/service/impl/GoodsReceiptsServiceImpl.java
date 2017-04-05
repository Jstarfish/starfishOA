package cls.pilottery.web.goodsreceipts.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsreceipts.dao.GoodsReceiptsDao;
import cls.pilottery.web.goodsreceipts.form.GoodsReceiptsForm;
import cls.pilottery.web.goodsreceipts.model.DamageVo;
import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.goodsreceipts.model.GameBatchImportDetail;
import cls.pilottery.web.goodsreceipts.model.GameBatchParamt;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GamePlans;
import cls.pilottery.web.goodsreceipts.model.GoodReceiptParamt;
import cls.pilottery.web.goodsreceipts.model.GoodsBatchStruct;
import cls.pilottery.web.goodsreceipts.model.GoodsReceiptTrans;
import cls.pilottery.web.goodsreceipts.model.GoodsStruct;
import cls.pilottery.web.goodsreceipts.model.ResultStruct;
import cls.pilottery.web.goodsreceipts.model.ReturnRecoder;
import cls.pilottery.web.goodsreceipts.model.WhGoodsReceipt;
import cls.pilottery.web.goodsreceipts.model.WhGoodsReceiptDetail;
import cls.pilottery.web.goodsreceipts.service.GoodsReceiptsService;
import cls.pilottery.web.sales.entity.StockTransfer;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

/**
 * 
    * @ClassName: GoodsReceiptsServiceImpl
    * @Description: TODO(这里用一句话描述这个类的作用)
    * @author dell
    * @date 2015年9月12日
    *
 */
@Service
public class GoodsReceiptsServiceImpl implements GoodsReceiptsService {
	
	static Logger logger = Logger.getLogger(GoodsReceiptsServiceImpl.class);
	
	@Autowired
	private GoodsReceiptsDao goodsReceiptsDao;
	/**
	 * 
	    * @Title: getGoodsReceiptCount
	    * @Description: 入库查询记录数
	    * @param @param goodsReceiptsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
	@Override
	public Integer getGoodsReceiptCount(GoodsReceiptsForm goodsReceiptsForm) {
		
		return this.goodsReceiptsDao.getGoodsReceiptCount(goodsReceiptsForm) ;
	}
	/**
	 * 
	    * @Title: getGoodsReceiptList
	    * @Description: 分页查询
	    * @param @param goodsReceiptsForm
	    * @param @return    参数
	    * @return List<WhGoodsReceipt>    返回类型
	    * @throws
	 */
	@Override
	public List<WhGoodsReceipt> getGoodsReceiptList(GoodsReceiptsForm goodsReceiptsForm) {
		
		return this.goodsReceiptsDao.getGoodsReceiptList(goodsReceiptsForm);
	}
	/**
	 * 
	    * @Title: getGoodsReceiptDetailBysgrNo
	    * @Description: 入库单详情
	    * @param @param sgrNo
	    * @param @return    参数
	    * @return List<WhGoodsReceiptDetail>    返回类型
	    * @throws
	 */
	@Override
	public List<WhGoodsReceiptDetail> getGoodsReceiptDetailBysgrNo(String sgrNo) {
		List<WhGoodsReceiptDetail>listdetail=this.goodsReceiptsDao.getGoodsReceiptDetailBysgrNo(sgrNo);
		
		return listdetail;
	}
	/**
	 * 
	    * @Title: getAllGamePlan
	    * @Description: 获得方案信息
	    * @param @return    参数
	    * @return List<GamePlans>    返回类型
	    * @throws
	 */
	@Override
	public List<GamePlans> getAllGamePlan() {
		
		return this.goodsReceiptsDao.getAllGamePlan();
	}
	/**
	 * 
	    * @Title: getGameBatchInfoBypanCode
	    * @Description: 查询方案下的批次信息
	    * @param @param planCode
	    * @param @return    参数
	    * @return List<GameBatchImport>    返回类型
	    * @ @throws
	    * */
	@Override
	public List<GameBatchImport> getGameBatchInfoBypanCode(String planCode) {
		
		return this.goodsReceiptsDao.getGameBatchInfoBypanCode(planCode);
	}
	/**
	 * 
	    * @Title: getGoodsReceiptSgrNo
	    * @Description: 获得入库单编号
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	
	
	/**
	 * 
	    * @Title: getGamePlanOrBatchInfo
	    * @Description: 获取方案，和批次信息
	    * @param @param gameBatchImport
	    * @param @return    参数
	    * @return GameBatchImportDetail   返回类型
	    * @throws
	 */

	@Override
	public GameBatchImportDetail getGamePlanOrBatchInfo(GoodReceiptParamt goodReceiptParamt) {
		GameBatchImportDetail detail=new GameBatchImportDetail();
		List<GameBatchImportDetail> listdetail=this.goodsReceiptsDao.getGamePlanOrBatchInfo(goodReceiptParamt) ;
		if(listdetail!=null && listdetail.size()>0){
			detail=listdetail.get(0);
		}
		return detail;
	}
	/**
	 * 
	    * @Title: addGameBath
	    * @Description: 增加箱入库
	    * @param @param gameBatchParamt    参数
	    * @return void    返回类型
	    * @throws
	 */
	@Override
	public void addGameBath(GameBatchParamt gameBatchParamt) {
		this.goodsReceiptsDao.addGameBath(gameBatchParamt);
		
	}
	@Override
	public GamePlans getGamePlanInfoByCode(String planCode) {
		List<GamePlans> listgame=this.goodsReceiptsDao.getGamePlanInfoByCode(planCode);
		GamePlans ga=new GamePlans();
		if(listgame!=null && listgame.size()>0){
			ga=listgame.get(0);
		}
		return ga;
	}
	/**
	 * 
	    * @Title: getGameReceiptActAmount
	    * @Description: 实际入库张数
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return Long    返回类型
	    * @throws
	 */
	@Override
	public Long getGameReceiptActAmount(GoodReceiptParamt goodReceiptParamt) {
		
		return this.goodsReceiptsDao.getGameReceiptActAmount(goodReceiptParamt);
	}
	/**
	 * 
	    * @Title: updateGoodReceiptComplete
	    * @Description: 订单完成
	    * @param @param goodReceiptParamt    参数
	    * @return void    返回类型
	    * @throws
	 */
	
	@Override
	public void updateGoodReceiptComplete(GoodReceiptParamt goodReceiptParamt) {
		this.goodsReceiptsDao.updateGoodReceiptComplete(goodReceiptParamt);
		
	}
	/**
	 * 调用存储过程
	 */
	public GoodsStruct addCallGoods(GoodReceiptParamt goodReceiptParamt) {
		List<GameBatchParamt> paraList=goodReceiptParamt.getPara();

		GoodsStruct gstruct=new GoodsStruct();
		gstruct.setSgrNo(goodReceiptParamt.getSgrNo());
		//方案
		gstruct.setPplan(goodReceiptParamt.getPlanCode());
		//批次
		gstruct.setPbatch(goodReceiptParamt.getBatchNo());
		//仓库
		gstruct.setPwarehouse(goodReceiptParamt.getWarehouseCode());
		//操作类型1新增2继续3完成
		gstruct.setPopertype(new Long(goodReceiptParamt.getOperType()));
		//操作人
		gstruct.setPoper(new Long(goodReceiptParamt.getAdminId()));
		 List<GoodsBatchStruct> batchList = new ArrayList<GoodsBatchStruct>();
		 
		 
		 if(paraList!=null && paraList.size()>0){
			 for(GameBatchParamt paramt:paraList){
				 if(paramt.getPlanCode()!=null && paramt.getPlanCode()!="" ){
					 GoodsBatchStruct gb=new GoodsBatchStruct();
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
			 
			 gstruct.setBatchList(batchList);
		}
		 this.addGoodsBatch(gstruct);
		 return gstruct;
	}
	
	/*
	 * (non-Javadoc)
	 * ---存储过程定义
	 * PLAN_CODE	 VARCHAR2(10),         -- 方案编码
	 * BATCH_NO	   VARCHAR2(10),         -- 批次
	 * VALID_NUMBER NUMBER(1),            -- 有效位数（1-箱号、2-盒号、3-本号）
	 * TRUNK_NO     VARCHAR2(10),         -- 箱号
	 * BOX_NO       VARCHAR2(20),         -- 盒号（箱号+盒子顺序号）
	 * BOX_NO_E     VARCHAR2(20),         -- 盒号（箱号+盒子顺序号）
	 * PACKAGE_NO   VARCHAR2(10),         -- 本号（当有效位数是箱和盒时，此为首本号）
	 * PACKAGE_NO_E VARCHAR2(10)          -- 本号（当有效位数是箱和盒时，此为首本号）
	 * @see cls.pilottery.web.goodsreceipts.service.GoodsReceiptsService#addGoodsBatch(cls.pilottery.web.goodsreceipts.model.GoodReceiptParamt)
	 */

	public void addGoodsBatch(GoodsStruct goodsStruct) {
		
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String sgrNo="";
		String resultMesg = "";
		
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
					conn);
			STRUCT[] result = new STRUCT[goodsStruct.getBatchList().size()];
			for (int index = 0; index < goodsStruct.getBatchList().size(); index++) {
				GoodsBatchStruct gpr = goodsStruct.getBatchList().get(index);
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
			
			logger.info("call p_batch_inbound(?,?,?,?,?,?,?,?,?,?) ");
			
			stmt = conn.prepareCall("{ call p_batch_inbound(?,?,?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, goodsStruct.getSgrNo());
			stmt.setObject(2, goodsStruct.getPplan());
			stmt.setObject(3, goodsStruct.getPbatch());
			stmt.setObject(4, goodsStruct.getPwarehouse());
			stmt.setObject(5, goodsStruct.getPopertype());
			stmt.setObject(6, goodsStruct.getPoper());
			stmt.setObject(7, oracle_array);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			stmt.registerOutParameter(9, OracleTypes.NUMBER);
			stmt.registerOutParameter(10, OracleTypes.VARCHAR);
			logger.info("p_batch_inbound arg:"+ goodsStruct.toString());
			
			stmt.execute();
			sgrNo=stmt.getString(8);
			resultCode = stmt.getInt(9);
			resultMesg = stmt.getString(10);
			
			logger.info("return code: " + resultCode);
			logger.info("return mesg: " + resultMesg);
		//	goodsStruct.setP_inbound_no(sgrNo);
			goodsStruct.setC_errorcode(resultCode);
			goodsStruct.setC_errormesg(resultMesg);
			goodsStruct.setSgrNo(sgrNo);
			
			
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}
	/**
	 * 
	    * @Title: getGoodsDamagedByNo
	    * @Description: 查询损毁信息
	    * @param @param sgrNo
	    * @param @return    参数
	    * @return List<WhGoodsReceipt>    返回类型
	    * @throws
	 */
	@Override
	public WhGoodsReceipt getGoodsDamagedByNo(String sgrNo) {
		WhGoodsReceipt pt=new WhGoodsReceipt();
		List<WhGoodsReceipt> listvo=this.goodsReceiptsDao.getGoodsDamagedByNo(sgrNo);
		if(listvo!=null && listvo.size()>0){
			pt=listvo.get(0);
		}
		return pt;
	}
	@Override
	public GoodsStruct addGameTranceBatch(GoodReceiptParamt goodReceiptParamt) {
		List<GameBatchParamt> paraList=goodReceiptParamt.getPara();

		GoodsStruct gstruct=new GoodsStruct();
		
		//仓库
		gstruct.setCode(goodReceiptParamt.getStbNo());
		gstruct.setPwarehouse(goodReceiptParamt.getWarehouseCode());
		//操作类型1新增2继续3完成
		gstruct.setPopertype(new Long(goodReceiptParamt.getOperType()));
		//操作人
		gstruct.setPoper(new Long(goodReceiptParamt.getAdminId()));
		gstruct.setRemark(goodReceiptParamt.getRemarks());
		 List<GoodsBatchStruct> batchList = new ArrayList<GoodsBatchStruct>();
		 
		 
		 if(paraList!=null && paraList.size()>0){
			 for(GameBatchParamt paramt:paraList){
				 if(paramt.getPlanCode()!=null && paramt.getPlanCode()!="" ){
					 GoodsBatchStruct gb=new GoodsBatchStruct();
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
			 
			 gstruct.setBatchList(batchList);
		}
		 this.addGoodsTransBatch(gstruct);
		return gstruct;
	}
	

	private void addGoodsTransBatch(GoodsStruct goodsStruct) {
		
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
	
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
					conn);
			STRUCT[] result = new STRUCT[goodsStruct.getBatchList().size()];
			for (int index = 0; index < goodsStruct.getBatchList().size(); index++) {
				GoodsBatchStruct gpr = goodsStruct.getBatchList().get(index);
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

			logger.info(" call p_tb_inbound(?,?,?,?,?,?,?,?) ");
			stmt = conn.prepareCall("{ call p_tb_inbound(?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, goodsStruct.getCode());
			stmt.setObject(2, goodsStruct.getPwarehouse());
			stmt.setObject(3, goodsStruct.getPopertype());
			stmt.setObject(4, goodsStruct.getPoper());
			stmt.setObject(5, goodsStruct.getRemark());
			stmt.setObject(6, oracle_array);
			logger.debug("goodsStruct.getCode(): " + goodsStruct.getCode());
			logger.debug("goodsStruct.getPwarehouse(): " + goodsStruct.getPwarehouse());
			logger.debug("goodsStruct.getPopertype(): " +goodsStruct.getPopertype());
			stmt.registerOutParameter(7, OracleTypes.NUMBER);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			stmt.execute();
  
			resultCode = stmt.getInt(7);
			resultMesg = stmt.getString(8);
			logger.debug("return code: " + resultCode);
			logger.debug("return mesg: " + resultMesg);
		
			goodsStruct.setC_errorcode(resultCode);
			goodsStruct.setC_errormesg(resultMesg);
			logger.info(" call p_tb_inbound arg: "+goodsStruct.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}
	/**
	 * 
	    * @Title: addGameRetrunBatch
	    * @Description:还货单批次入库
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return GoodsStruct    返回类型
	    * @throws
	 */
	@Override
	public GoodsStruct addGameRetrunBatch(GoodReceiptParamt goodReceiptParamt) {
		List<GameBatchParamt> paraList=goodReceiptParamt.getPara();

		GoodsStruct gstruct=new GoodsStruct();
		//方案
		//gstruct.setPplan(goodReceiptParamt.getPlanCode());
		//批次
		//gstruct.setPbatch(goodReceiptParamt.getBatchNo());
		//仓库
		gstruct.setCode(goodReceiptParamt.getReturnNo());
		gstruct.setPwarehouse(goodReceiptParamt.getWarehouseCode());
		gstruct.setRemark(goodReceiptParamt.getRemarks());
		//操作类型1新增2继续3完成
		gstruct.setPopertype(new Long(goodReceiptParamt.getOperType()));
		//操作人
		gstruct.setPoper(new Long(goodReceiptParamt.getAdminId()));
		 List<GoodsBatchStruct> batchList = new ArrayList<GoodsBatchStruct>();
		 
		 
		 if(paraList!=null && paraList.size()>0){
			 for(GameBatchParamt paramt:paraList){
				 if(paramt.getPlanCode()!=null && paramt.getPlanCode()!="" ){
					 GoodsBatchStruct gb=new GoodsBatchStruct();
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
			 
			 gstruct.setBatchList(batchList);
		}
		 this.addCallReturnBatch(gstruct);
		 return gstruct;
	}
	private void addCallReturnBatch(GoodsStruct goodsStruct){
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
	
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
					conn);
			STRUCT[] result = new STRUCT[goodsStruct.getBatchList().size()];
			for (int index = 0; index < goodsStruct.getBatchList().size(); index++) {
				GoodsBatchStruct gpr = goodsStruct.getBatchList().get(index);
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

			logger.info(" call p_rr_inbound(?,?,?,?,?,?,?,?) ");
			stmt = conn.prepareCall("{ call  p_rr_inbound(?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, goodsStruct.getCode());
			stmt.setObject(2,goodsStruct.getPwarehouse());
			stmt.setObject(3, goodsStruct.getPopertype());
			stmt.setObject(4, goodsStruct.getPoper());
			stmt.setObject(5, goodsStruct.getRemark());
			stmt.setObject(6, oracle_array);
	
			stmt.registerOutParameter(7, OracleTypes.NUMBER);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			stmt.execute();
  
			resultCode = stmt.getInt(7);
			resultMesg = stmt.getString(8);
			logger.debug("return code: " + resultCode);
			logger.debug("return mesg: " + resultMesg);
		
			goodsStruct.setC_errorcode(resultCode);
			goodsStruct.setC_errormesg(resultMesg);
			
			logger.info(" call p_rr_inbound arg: "+goodsStruct.toString());
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
	}
	@Override
	public WhGoodsReceiptDetail getGoodsReceiptDetailsumBysgrNo(String sgrNo) {
		WhGoodsReceiptDetail sdtail=new WhGoodsReceiptDetail();
	    List<WhGoodsReceiptDetail> detailist=this.goodsReceiptsDao.getGoodsReceiptDetailsumBysgrNo(sgrNo);
	    if(detailist!=null && detailist.size()>0){
	    	sdtail=detailist.get(0);
	    }
		return sdtail;
	}
	@Override
	public WhGoodsReceiptDetail getGoodetailPlancodeByreNO(String sgrNo) {
		
		return this.goodsReceiptsDao.getGoodetailPlancodeByreNO(sgrNo);
	}
	@Override
	public List<StockTransfer> getReciveStrockByorgCode(String orgCode) {
		
		return this.goodsReceiptsDao.getReciveStrockByorgCode(orgCode);
	}
	@Override
	public GameBatchImportDetail getGamePlanOrBatchInfoSum(GoodReceiptParamt goodReceiptParamt) {
		
		return this.goodsReceiptsDao.getGamePlanOrBatchInfoSum(goodReceiptParamt);
	}
	 /**
	  * 
	     * @Title: getGoodsReceiptsPrintList
	     * @Description: 打印入库单信息
	     * @param @param refNo
	     * @param @return    参数
	     * @return List<WhGoodsReceiptDetail>    返回类型
	     * @throws
	  */
	@Override
	public List<WhGoodsReceiptDetail> getGoodsReceiptsPrintList(String refNo) {
		
		return this.goodsReceiptsDao.getGoodsReceiptsPrintList(refNo);
	}
	 /**
	  * 
	     * @Title: getGoodsReceiptsPrintByrefNo
	     * @Description: 打印入库时间，入库单位
	     * @param @param refNo
	     * @param @return    参数
	     * @return List<WhGoodsReceipt>    返回类型
	     * @throws
	  */
	@Override
	public WhGoodsReceipt getGoodsReceiptsPrintByrefNo(String refNo) {
		WhGoodsReceipt vo=new WhGoodsReceipt();
		List<WhGoodsReceipt> listvo=this.goodsReceiptsDao.getGoodsReceiptsPrintByrefNo(refNo);
		if(listvo!=null && listvo.size()>0){
			vo=listvo.get(0);
		}
		return vo;
	}
	 /**
	  * 
	     * @Title: getGoodsReceiptsPrintSumByrefNo
	     * @Description: 入库统计
	     * @param @param refNo
	     * @param @return    参数
	     * @return WhGoodsReceiptDetail    返回类型
	     * @throws
	  */
	@Override
	public WhGoodsReceiptDetail getGoodsReceiptsPrintSumByrefNo(String refNo) {
		
		return this.goodsReceiptsDao.getGoodsReceiptsPrintSumByrefNo(refNo);
	}
	 /**
	  * 
	     * @Title: getGoodsReceiptsTranPrintByStbno
	     * @Description:调拨单出库打印
	     * @param @param refNo
	     * @param @return    参数
	     * @return GoodsReceiptTrans    返回类型
	     * @throws
	  */
	@Override
	public GoodsReceiptTrans getGoodsReceiptsTranPrintByStbno(String refNo) {
		
		return this.goodsReceiptsDao.getGoodsReceiptsTranPrintByStbno(refNo);
	}
	 /**
	  * 
	     * @Title: getGoodsReceiptsReturnPrintByStbno
	     * @Description: 还货入库打印
	     * @param @param refNo
	     * @param @return    参数
	     * @return ReturnRecoder    返回类型
	     * @throws
	  */
	@Override
	public ReturnRecoder getGoodsReceiptsReturnPrintByStbno(String refNo) {
		
		return this.goodsReceiptsDao.getGoodsReceiptsReturnPrintByStbno(refNo);
	}
	@Override
	public Long getGameReceiptAmount(GoodReceiptParamt goodReceiptParamt) {
	
		return this.goodsReceiptsDao.getGameReceiptAmount(goodReceiptParamt);
	}
	@Override
	public List<WhGoodsReceiptDetail> getGoodsReceiptsDetailInfoByRefNo(String refNo) {
		
		return this.goodsReceiptsDao.getGoodsReceiptsDetailInfoByRefNo(refNo);
	}
	@Override
	public void addDamage(DamageVo damageVo) {
		this.goodsReceiptsDao.addDamage(damageVo);
		
	}
	@Override
	public Integer getGoodsReceiptsSumTickts(String refNo) {
		
		return this.goodsReceiptsDao.getGoodsReceiptsSumTickts(refNo);
	}
	@Override
	public List<GamePlanVo> getGameBatchInfoTemp() {
		
		return this.goodsReceiptsDao.getGameBatchInfoTemp();
	}
	@Override
	public List<GoodsIssueDetailVo> getPlanListTemp(String houseCode) {
		// TODO Auto-generated method stub
		return this.goodsReceiptsDao.getPlanListTemp(houseCode);
	}
	@Override
	public List<GoodsIssueDetailVo> getPlanListTempDiff(String houseCode) {
		
		return this.goodsReceiptsDao.getPlanListTempDiff(houseCode);
	}
	@Override
	public GoodsStruct addCallGoodTemps(GoodReceiptParamt goodReceiptParamt) {
		List<GameBatchParamt> paraList=goodReceiptParamt.getPara();

		GoodsStruct gstruct=new GoodsStruct();
		/*gstruct.setSgrNo(goodReceiptParamt.getSgrNo());*/
	
		gstruct.setPwarehouse(goodReceiptParamt.getWarehouseCode());
	
		gstruct.setPoper(new Long(goodReceiptParamt.getAdminId()));
		 List<GoodsBatchStruct> batchList = new ArrayList<GoodsBatchStruct>();
		 
		 
		 if(paraList!=null && paraList.size()>0){
			 for(GameBatchParamt paramt:paraList){
				 if(paramt.getPlanCode()!=null && paramt.getPlanCode()!="" ){
					 GoodsBatchStruct gb=new GoodsBatchStruct();
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
			 
			 gstruct.setBatchList(batchList);
		}
	  this.addGoodsTemptBatch(gstruct);
		 return gstruct;
	}
	 private void addGoodsTemptBatch(GoodsStruct goodsStruct) {
		 Connection conn = null;
			CallableStatement stmt = null;
			int resultCode = 0;
		
			String resultMesg = "";
			
			try {
				conn = DBConnectUtil.getConnection();
				conn.setAutoCommit(false);
				StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
						conn);
				STRUCT[] result = new STRUCT[goodsStruct.getBatchList().size()];
				for (int index = 0; index < goodsStruct.getBatchList().size(); index++) {
					GoodsBatchStruct gpr = goodsStruct.getBatchList().get(index);
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
				
				logger.info("call p_batch_inbound_all(?,?,?,?,?,?) ");
				
				stmt = conn.prepareCall("{ call p_batch_inbound_all(?,?,?,?,?,?) }");
				stmt.setObject(1, goodsStruct.getPwarehouse());
				stmt.setObject(2,  goodsStruct.getPoper());
				stmt.setObject(3, oracle_array);
				stmt.registerOutParameter(4, OracleTypes.ARRAY, "TYPE_LOTTERY_IMPORT_ERR_LIST");
				stmt.registerOutParameter(5, OracleTypes.NUMBER);
				stmt.registerOutParameter(6, OracleTypes.VARCHAR);
			
				
				stmt.execute();
			
				resultCode = stmt.getInt(5);
				resultMesg = stmt.getString(6);
				logger.debug("return code: " + resultCode);
				logger.debug("return mesg: " + resultMesg);
				goodsStruct.setC_errorcode(resultCode);
				goodsStruct.setC_errormesg(resultMesg);
				/*ARRAY array = (oracle.sql.ARRAY) stmt.getArray(4);
				ResultSet rs = array.getResultSet();
				while (rs != null && rs.next()) {
					STRUCT struct = (STRUCT) rs.getObject(2);
					Object[] attribs = struct.getAttributes();
					ResultStruct rt=new ResultStruct();
				}*/
		
				logger.info("p_batch_inbound arg:"+ goodsStruct.toString());
				
			} catch (Exception e) {
				logger.error(e);
				e.printStackTrace();
			} finally {
				DBConnectUtil.close(stmt);
				DBConnectUtil.close(conn);
			}
	 }
	@Override
	public WhGoodsReceipt getRemarkByRefo(String refo) {
		// TODO Auto-generated method stub
		return this.goodsReceiptsDao.getRemarkByRefo(refo);
	}
	
}

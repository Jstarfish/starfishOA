package cls.pilottery.web.goodsIssues.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.goodsIssues.dao.GoodsIssuesDao;
import cls.pilottery.web.goodsIssues.form.GoodsIssuesForm;
import cls.pilottery.web.goodsIssues.model.DeleveryOrderInfo;
import cls.pilottery.web.goodsIssues.model.GoodIssuesParamt;
import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesBatchStruct;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStockDetailVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStockVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStruct;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesVo;
import cls.pilottery.web.goodsIssues.model.SaleDeliverOrder;
import cls.pilottery.web.goodsIssues.model.SaleDeliverOrderDetail;
import cls.pilottery.web.goodsIssues.service.GoodsIssuesService;
import cls.pilottery.web.goodsreceipts.model.GameBatchParamt;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GoodsBatchStruct;
import cls.pilottery.web.goodsreceipts.model.GoodsStruct;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.plans.controller.PlanController;
import cls.pilottery.web.sales.entity.StockTransfer;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

@Service
public class GoodsIssuesServiceImpl implements GoodsIssuesService {
	
	static Logger logger = Logger.getLogger(GoodsIssuesServiceImpl.class);
	
	@Autowired
	private GoodsIssuesDao goodsIssuesDao;

	/**
	 * 
	 * @Title: getgoodsIssuesCount @Description: 出库分页记录总数 @param @param
	 * goodsIssuesForm @param @return 参数 @return Integer 返回类型 @throws
	 */
	@Override
	public Integer getgoodsIssuesCount(GoodsIssuesForm goodsIssuesForm) {

		return this.goodsIssuesDao.getgoodsIssuesCount(goodsIssuesForm);
	}

	/**
	 * 
	 * @Title: getgoodsIssuesInfoList @Description: 出库分页查询 @param @param
	 * goodsIssuesForm @param @return 参数 @return List<GoodsIssuesVo>
	 * 返回类型 @throws
	 */
	@Override
	public List<GoodsIssuesVo> getgoodsIssuesInfoList(GoodsIssuesForm goodsIssuesForm) {

		return this.goodsIssuesDao.getgoodsIssuesInfoList(goodsIssuesForm);
	}

	/**
	 * 
	 * @Title: getSaleDeliverList @Description: 已审批的出库单 @param @return
	 * 参数 @return List<SaleDeliverOrder> 返回类型 @throws
	 */
	@Override
	public List<SaleDeliverOrder> getSaleDeliverList(GoodsIssuesForm goodsIssuesForm) {

		return this.goodsIssuesDao.getSaleDeliverList(goodsIssuesForm);
	}

	/**
	 * 
	 * @Title: getSaleDeliverDitalList @Description: 出货单详情列表 @param @param
	 * doNo @param @return 参数 @return List<SaleDeliverOrderDetail> 返回类型 @throws
	 */
	@Override
	public List<SaleDeliverOrderDetail> getSaleDeliverDitalList(String doNo) {

		return this.goodsIssuesDao.getSaleDeliverDitalList(doNo);
	}
/**
 * 调拨单出库调用的存储过程
 */
	@Override
	public GoodsIssuesStruct addGoodsIssues(GoodIssuesParamt goodIssuesParamt) {
		GoodsIssuesStruct gstruct=new GoodsIssuesStruct();
		gstruct=this.addCallGoods(goodIssuesParamt);
		return gstruct;
	}
	/**
	 * 调拨单出库调用的存储过程
	 */
	private GoodsIssuesStruct addCallGoods(GoodIssuesParamt goodIssuesParamt) {
		List<GameBatchParamt> paraList=goodIssuesParamt.getPara();

		GoodsIssuesStruct gstruct=new GoodsIssuesStruct();
		//方案
		//gstruct.setPplan(goodIssuesParamt.getp);
		//批次
		//gstruct.setPbatch(goodReceiptParamt.getBatchNo());
		//仓库
		gstruct.setRemarks(goodIssuesParamt.getRemarks());
		gstruct.setSgiNo(goodIssuesParamt.getSbtNo());
		gstruct.setPwarehouse(goodIssuesParamt.getWarehouseCode());
		//操作类型1新增2继续3完成
		gstruct.setPopertype(new Long(goodIssuesParamt.getOperType()));
		//操作人
		gstruct.setPoper(goodIssuesParamt.getAdminId());
		 List<GoodsIssuesBatchStruct> batchList = new ArrayList<GoodsIssuesBatchStruct>();
		 
		 
		 if(paraList!=null && paraList.size()>0){
			 for(GameBatchParamt paramt:paraList){
				 if(paramt.getPlanCode()!=null && paramt.getPlanCode()!="" ){
					 GoodsIssuesBatchStruct gb=new GoodsIssuesBatchStruct();
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
			 
			 gstruct.setIssList(batchList);
		}
		 this.addGoodsCallBatch(gstruct);
		 return gstruct;
	}
public void addGoodsCallBatch(GoodsIssuesStruct goodsStruct) {
		
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
					conn);
			STRUCT[] result = new STRUCT[goodsStruct.getIssList().size()];
			for (int index = 0; index < goodsStruct.getIssList().size(); index++) {
				GoodsIssuesBatchStruct gpr = goodsStruct.getIssList().get(index);
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
			
			logger.info("call p_tb_outbound(?,?,?,?,?,?,?,?)");
			stmt = conn.prepareCall("{ call p_tb_outbound(?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, goodsStruct.getSgiNo());
			stmt.setObject(2, goodsStruct.getPwarehouse());
			stmt.setObject(3, goodsStruct.getPopertype());
			stmt.setObject(4, goodsStruct.getPoper());
			stmt.setObject(5, goodsStruct.getRemarks());
			stmt.setObject(6, oracle_array);
			
			stmt.registerOutParameter(7, OracleTypes.NUMBER);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			stmt.execute();
           // sgrNo=stmt.getString(1);
			resultCode = stmt.getInt(7);
			resultMesg = stmt.getString(8);
			System.out.println("return code: " + resultCode);
			System.out.println("return mesg: " + resultMesg);
		//	goodsStruct.setP_inbound_no(sgrNo);
			goodsStruct.setC_errorcode(resultCode);
			goodsStruct.setC_errormesg(resultMesg);
			
			logger.info("call p_tb_outbound arg:"+goodsStruct.toString());
			
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
	      * @Title: getGoodsIssuesById
	      * @Description: 查询实际票数，和应录入票数
	      * @param @param sgiNO
	      * @param @return    参数
	      * @return GoodsIssuesVo    返回类型
	      * @throws
	   */
	@Override
	public GoodsIssuesVo getGoodsIssuesById(String sgiNO) {
		GoodsIssuesVo vo=new GoodsIssuesVo();
		List<GoodsIssuesVo> listvo=this.goodsIssuesDao.getGoodsIssuesById(sgiNO);
		if(listvo!=null && listvo.size()>0){
			vo=listvo.get(0);	
		}
		return vo;
	}
	 /**
	   * 
	      * @Title: getOrgslList
	      * @Description: 获得部门信息
	      * @param @return    参数
	      * @return List<InfOrgs>    返回类型
	      * @throws
	   */
	@Override
	public List<InfOrgs> getOrgslList() {
	
		return this.goodsIssuesDao.getOrgslList();
	}
	  /**
	   * 
	      * @Title: getGoodsIssuesStockInfoByCode
	      * @Description: 查看收发货单位
	      * @param @param sgiNo
	      * @param @return    参数
	      * @return GoodsIssuesStockVo    返回类型
	      * @throws
	   */
	@Override
	public GoodsIssuesStockVo getGoodsIssuesStockInfoByCode(String sgiNo) {
		List<GoodsIssuesStockVo> listvo=this.goodsIssuesDao.getGoodsIssuesStockInfoByCode(sgiNo);
		GoodsIssuesStockVo vo=new GoodsIssuesStockVo();
		if(listvo!=null && listvo.size()>0){
			vo=listvo.get(0);
		}
		return vo;
	}
	  /**
	   * 
	      * @Title: getGoodsIssuesStockDetilListByCode
	      * @Description: 调拨单详情列表
	      * @param @param sgiNo
	      * @param @return    参数
	      * @return List<GoodsIssuesStockDetailVo>    返回类型
	      * @throws
	   */
	@Override
	public List<GoodsIssuesStockDetailVo> getGoodsIssuesStockDetilListByCode(String sgiNo) {
	
		return this.goodsIssuesDao.getGoodsIssuesStockDetilListByCode(sgiNo);
	}
	  /**
	   * 
	      * @Title: getGoodsIssuesDetilListByCode
	      * @Description: 出库信息详细列表
	      * @param @param sgiNo
	      * @param @return    参数
	      * @return List<GoodsIssueDetailVo>    返回类型
	      * @throws
	   */
	@Override
	public List<GoodsIssueDetailVo> getGoodsIssuesDetilListByCode(String sgiNo) {
		
		 return this.goodsIssuesDao.getGoodsIssuesDetilListByCode(sgiNo);
	}
	/**
	   * 
	      * @Title: getGoodsIssuesByCode
	      * @Description:汇总信息
	      * @param @param sgiNo
	      * @param @return    参数
	      * @return GoodsIssuesVo    返回类型
	      * @throws
	   */
	@Override
	public GoodsIssuesVo getGoodsIssuesByCode(String sgiNo) {
		List <GoodsIssuesVo> listvo=this.goodsIssuesDao.getGoodsIssuesByCode(sgiNo);
		GoodsIssuesVo vo=new GoodsIssuesVo();
		if(listvo!=null && listvo.size()>0){
			vo=listvo.get(0);
		}
		return vo ;
	}
/**
 * 出货单出库
 */
	@Override
	public GoodsIssuesStruct addCallGoodsIssues(GoodIssuesParamt goodIssuesParamt) {
		List<GameBatchParamt> paraList=goodIssuesParamt.getPara();

		GoodsIssuesStruct gstruct=new GoodsIssuesStruct();
		//方案
		//gstruct.setPplan(goodIssuesParamt.getp);
		//批次
		//gstruct.setPbatch(goodReceiptParamt.getBatchNo());
		//仓库
		gstruct.setSgiNo(goodIssuesParamt.getDoNo());
		gstruct.setPwarehouse(goodIssuesParamt.getWarehouseCode());
		//操作类型1新增2继续3完成
		gstruct.setPopertype(new Long(goodIssuesParamt.getOperType()));
		//操作人
		gstruct.setPoper(goodIssuesParamt.getAdminId());
		gstruct.setRemarks(goodIssuesParamt.getRemarks());
		 List<GoodsIssuesBatchStruct> batchList = new ArrayList<GoodsIssuesBatchStruct>();
		 
		 
		 if(paraList!=null && paraList.size()>0){
			 for(GameBatchParamt paramt:paraList){
				 if(paramt.getPlanCode()!=null && paramt.getPlanCode()!="" ){
					 GoodsIssuesBatchStruct gb=new GoodsIssuesBatchStruct();
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
			 
			 gstruct.setIssList(batchList);
		}
		 this.addGoodsCallissusBatch(gstruct);
		return gstruct;
	}
	/**
	 * 
	    * @Title: addGoodsCallissusBatch
	    * @Description: 出货单出库调用的存储过程
	    * @param @param goodsStruct    参数
	    * @return void    返回类型
	    * @throws
	 */
private void addGoodsCallissusBatch(GoodsIssuesStruct goodsStruct) {
		
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
					conn);
			STRUCT[] result = new STRUCT[goodsStruct.getIssList().size()];
			for (int index = 0; index < goodsStruct.getIssList().size(); index++) {
				GoodsIssuesBatchStruct gpr = goodsStruct.getIssList().get(index);
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

			logger.info("call p_gi_outbound(?,?,?,?,?,?,?,?)");
			stmt = conn.prepareCall("{ call p_gi_outbound(?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, goodsStruct.getSgiNo());
			stmt.setObject(2, goodsStruct.getPwarehouse());
			stmt.setObject(3, goodsStruct.getPopertype());
			stmt.setObject(4, goodsStruct.getPoper());
			stmt.setObject(5, goodsStruct.getRemarks());
			stmt.setObject(6, oracle_array);
		
			stmt.registerOutParameter(7, OracleTypes.NUMBER);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			stmt.execute();
           // sgrNo=stmt.getString(1);
			resultCode = stmt.getInt(7);
			resultMesg = stmt.getString(8);
			System.out.println("return code: " + resultCode);
			System.out.println("return mesg: " + resultMesg);
		//	goodsStruct.setP_inbound_no(sgrNo);
			goodsStruct.setC_errorcode(resultCode);
			goodsStruct.setC_errormesg(resultMesg);
			
			logger.info("call p_gi_outbound arg:"+goodsStruct.toString());
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
	    * @Title: getGoodsIssuesStockPirnt
	    * @Description: 调拨单出库打印
	    * @param @param refNo
	    * @param @return    参数
	    * @return GoodsIssuesVo    返回类型
	    * @throws
	 */
	@Override
	public GoodsIssuesVo getGoodsIssuesStockPirnt(String refNo) {
		
		return this.goodsIssuesDao.getGoodsIssuesStockPirnt(refNo);
	}

	@Override
	public List<GoodsIssuesStockDetailVo> getGoodsIssuesStockDetailPirnt(String refNo) {
		
		return this.goodsIssuesDao.getGoodsIssuesStockDetailPirnt(refNo);
	}
	 /**
	  * 
	     * @Title: getGoodsIssuesStockSumPirnt
	     * @Description: 求和
	     * @param @param refNo
	     * @param @return    参数
	     * @return GoodsIssuesStockDetailVo    返回类型
	     * @throws
	  */
	
	@Override
	public GoodsIssuesStockDetailVo getGoodsIssuesStockSumPirnt(String refNo) {
		
		return this.goodsIssuesDao.getGoodsIssuesStockSumPirnt(refNo);
	}
	 /**
	  * 
	     * @Title: getGoodsIssuseOutPrint
	     * @Description: 出货单打印时间，出货单位
	     * @param @param refNo
	     * @param @return    参数
	     * @return GoodsIssuesVo    返回类型
	     * @throws
	  */
	@Override
	public GoodsIssuesVo getGoodsIssuseOutPrint(String refNo) {
	
		return this.goodsIssuesDao.getGoodsIssuseOutPrint(refNo);
	}
	 /**
	  * 
	     * @Title: getGoodsIssuseOutPrintList
	     * @Description: 出货单明细列表
	     * @param @param refNo
	     * @param @return    参数
	     * @return List<GoodsIssuesStockDetailVo>    返回类型
	     * @throws
	  */
	@Override
	public List<GoodsIssuesStockDetailVo> getGoodsIssuseOutPrintList(String refNo) {
		
		return this.goodsIssuesDao.getGoodsIssuseOutPrintList(refNo);
	}
	 /**
	  * 
	     * @Title: getGoodsIssuseOutPrintListSum
	     * @Description: 出货单明细求和
	     * @param @param refNo
	     * @param @return    参数
	     * @return GoodsIssuesStockDetailVo    返回类型
	     * @throws
	  */
	@Override
	public GoodsIssuesStockDetailVo getGoodsIssuseOutPrintListSum(String refNo) {
		
		 return this.goodsIssuesDao.getGoodsIssuseOutPrintListSum(refNo);
	}

	@Override
	public List<GoodsIssueDetailVo> getGoodsIssuesDetilListByCodeSum(String sgiNo) {
		
		return this.goodsIssuesDao.getGoodsIssuesDetilListByCodeSum(sgiNo);
	}

	@Override
	public List<GamePlanVo> getIssuseTransGameBystbNo(String stbNo) {
		
		return this.goodsIssuesDao.getIssuseTransGameBystbNo(stbNo);
	}

	@Override
	public List<GamePlanVo> getSaleDeliverOrderGameBystbNo(String doNo) {
		// TODO Auto-generated method stub
		return this.goodsIssuesDao.getSaleDeliverOrderGameBystbNo(doNo);
	}

	@Override
	public Long getSaleActTicktsByCode(String stbNo) {
		// TODO Auto-generated method stub
		return this.goodsIssuesDao.getSaleActTicktsByCode(stbNo);
	}

	@Override
	public List<GoodsIssueDetailVo> getSaletbTicksInfoByCode(GoodIssuesParamt goodIssuesParamt) {
		// TODO Auto-generated method stub
		return this.goodsIssuesDao.getSaletbTicksInfoByCode(goodIssuesParamt);
	}

	@Override
	public List<GoodsIssueDetailVo> getGoodsIssuseOutTicksInfoByCode(GoodIssuesParamt goodIssuesParamt) {
		// TODO Auto-generated method stub
		return this.goodsIssuesDao.getGoodsIssuseOutTicksInfoByCode(goodIssuesParamt);
	}

	@Override
	public List<GoodsIssueDetailVo> getSaleActTicktsDiffByCode(String stbNo) {
		// TODO Auto-generated method stub
		return this.goodsIssuesDao.getSaleActTicktsDiffByCode(stbNo);
	}

	@Override
	public List<GoodsIssueDetailVo> getGoodsIssuseOutTicksInfoDiffByCode(String doNo) {
		// TODO Auto-generated method stub
		return  this.goodsIssuesDao.getGoodsIssuseOutTicksInfoDiffByCode(doNo);
	}

	@Override
	public DeleveryOrderInfo getDeliveryOrderInfo(String doNo) {
		return goodsIssuesDao.getDeliveryOrderInfo(doNo);
	}

	@Override
	public List<StockTransfer> getSaltranserIssueList(GoodsIssuesForm goodsIssuesForm) {
		// TODO Auto-generated method stub
		return this.goodsIssuesDao.getSaltranserIssueList(goodsIssuesForm);
	}
	
}

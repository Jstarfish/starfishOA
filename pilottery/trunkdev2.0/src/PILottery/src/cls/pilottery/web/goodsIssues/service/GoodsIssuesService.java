package cls.pilottery.web.goodsIssues.service;

import java.util.List;

import cls.pilottery.web.goodsIssues.form.GoodsIssuesForm;
import cls.pilottery.web.goodsIssues.model.DeleveryOrderInfo;
import cls.pilottery.web.goodsIssues.model.GoodIssuesParamt;
import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStockDetailVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStockVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStruct;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesVo;
import cls.pilottery.web.goodsIssues.model.SaleDeliverOrder;
import cls.pilottery.web.goodsIssues.model.SaleDeliverOrderDetail;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.sales.entity.StockTransfer;

public interface GoodsIssuesService {
	/**
	 * 
	 * @Title: getgoodsIssuesCount
	 * @Description: 出库分页记录总数
	 * @param @param goodsIssuesForm
	 * @param @return 参数
	 * @return Integer 返回类型
	 * @throws
	 */
	public Integer getgoodsIssuesCount(GoodsIssuesForm goodsIssuesForm);

	/**
	 * 
	 * @Title: getgoodsIssuesInfoList
	 * @Description: 出库分页查询
	 * @param @param goodsIssuesForm
	 * @param @return 参数
	 * @return List<GoodsIssuesVo> 返回类型
	 * @throws
	 */
	public List<GoodsIssuesVo> getgoodsIssuesInfoList(
			GoodsIssuesForm goodsIssuesForm);

	/**
	 * 
	 * @Title: getSaleDeliverList
	 * @Description: 已审批的出库单
	 * @param @return 参数
	 * @return List<SaleDeliverOrder> 返回类型
	 * @throws
	 */
	public List<SaleDeliverOrder> getSaleDeliverList(
			GoodsIssuesForm goodsIssuesForm);

	/**
	 * 
	 * @Title: getSaleDeliverDitalList
	 * @Description: 出货单详情列表
	 * @param @param doNo
	 * @param @return 参数
	 * @return List<SaleDeliverOrderDetail> 返回类型
	 * @throws
	 */
	public List<SaleDeliverOrderDetail> getSaleDeliverDitalList(String doNo);

	public GoodsIssuesStruct addGoodsIssues(GoodIssuesParamt goodIssuesParamt);

	/**
	 * 
	 * @Title: getGoodsIssuesById
	 * @Description: 查询实际票数，和应录入票数
	 * @param @param sgiNO
	 * @param @return 参数
	 * @return GoodsIssuesVo 返回类型
	 * @throws
	 */
	public GoodsIssuesVo getGoodsIssuesById(String sgiNO);

	/**
	 * 
	 * @Title: getOrgslList
	 * @Description: 获得部门信息
	 * @param @return 参数
	 * @return List<InfOrgs> 返回类型
	 * @throws
	 */
	public List<InfOrgs> getOrgslList();

	/**
	 * 
	 * @Title: getGoodsIssuesStockInfoByCode
	 * @Description: 查看收发货单位
	 * @param @param sgiNo
	 * @param @return 参数
	 * @return GoodsIssuesStockVo 返回类型
	 * @throws
	 */
	public GoodsIssuesStockVo getGoodsIssuesStockInfoByCode(String sgiNo);

	/**
	 * 
	 * @Title: getGoodsIssuesStockDetilListByCode
	 * @Description: 调拨单详情列表
	 * @param @param sgiNo
	 * @param @return 参数
	 * @return List<GoodsIssuesStockDetailVo> 返回类型
	 * @throws
	 */
	public List<GoodsIssuesStockDetailVo> getGoodsIssuesStockDetilListByCode(
			String sgiNo);

	/**
	 * 
	 * @Title: getGoodsIssuesDetilListByCode
	 * @Description: 出库信息详细列表
	 * @param @param sgiNo
	 * @param @return 参数
	 * @return List<GoodsIssueDetailVo> 返回类型
	 * @throws
	 */
	public List<GoodsIssueDetailVo> getGoodsIssuesDetilListByCode(String sgiNo);

	/**
	 * 
	 * @Title: getGoodsIssuesByCode
	 * @Description:汇总信息
	 * @param @param sgiNo
	 * @param @return 参数
	 * @return GoodsIssuesVo 返回类型
	 * @throws
	 */
	public GoodsIssuesVo getGoodsIssuesByCode(String sgiNo);

	/**
	 * 
	 * @Title: addCallGoodsIssues
	 * @Description: 出货单出库
	 * @param @param goodIssuesParamt
	 * @param @return 参数
	 * @return GoodsIssuesStruct 返回类型
	 * @throws
	 */
	public GoodsIssuesStruct addCallGoodsIssues(
			GoodIssuesParamt goodIssuesParamt);

	/**
	 * 
	 * @Title: getGoodsIssuesStockPirnt
	 * @Description: 调拨单出库打印
	 * @param @param refNo
	 * @param @return 参数
	 * @return GoodsIssuesVo 返回类型
	 * @throws
	 */
	public GoodsIssuesVo getGoodsIssuesStockPirnt(String refNo);

	/**
	 * 
	 * @Title: getGoodsIssuesStockDetailPirnt
	 * @Description: 出库明细打印
	 * @param @param refNo
	 * @param @return 参数
	 * @return List<GoodsIssuesStockDetailVo> 返回类型
	 * @throws
	 */
	public List<GoodsIssuesStockDetailVo> getGoodsIssuesStockDetailPirnt(
			String refNo);

	/**
	 * 
	 * @Title: getGoodsIssuesStockSumPirnt
	 * @Description: 求和
	 * @param @param refNo
	 * @param @return 参数
	 * @return GoodsIssuesStockDetailVo 返回类型
	 * @throws
	 */
	public GoodsIssuesStockDetailVo getGoodsIssuesStockSumPirnt(String refNo);

	/**
	 * 
	 * @Title: getGoodsIssuseOutPrint
	 * @Description: 出货单打印时间，出货单位
	 * @param @param refNo
	 * @param @return 参数
	 * @return GoodsIssuesVo 返回类型
	 * @throws
	 */
	public GoodsIssuesVo getGoodsIssuseOutPrint(String refNo);

	/**
	 * 
	 * @Title: getGoodsIssuseOutPrintList
	 * @Description: 出货单明细列表
	 * @param @param refNo
	 * @param @return 参数
	 * @return List<GoodsIssuesStockDetailVo> 返回类型
	 * @throws
	 */
	public List<GoodsIssuesStockDetailVo> getGoodsIssuseOutPrintList(
			String refNo);

	/**
	 * 
	 * @Title: getGoodsIssuseOutPrintListSum
	 * @Description: 出货单明细求和
	 * @param @param refNo
	 * @param @return 参数
	 * @return GoodsIssuesStockDetailVo 返回类型
	 * @throws
	 */
	public GoodsIssuesStockDetailVo getGoodsIssuseOutPrintListSum(String refNo);

	public List<GoodsIssueDetailVo> getGoodsIssuesDetilListByCodeSum(
			String sgiNo);

	public List<GamePlanVo> getIssuseTransGameBystbNo(String stbNo);

	public List<GamePlanVo> getSaleDeliverOrderGameBystbNo(String doNo);

	public Long getSaleActTicktsByCode(String stbNo);

	public List<GoodsIssueDetailVo> getSaletbTicksInfoByCode(GoodIssuesParamt goodIssuesParamt);

	public List<GoodsIssueDetailVo> getGoodsIssuseOutTicksInfoByCode(GoodIssuesParamt goodIssuesParamt);

	public List<GoodsIssueDetailVo> getSaleActTicktsDiffByCode(String stbNo);

	public List<GoodsIssueDetailVo> getGoodsIssuseOutTicksInfoDiffByCode(String doNo);

	public DeleveryOrderInfo getDeliveryOrderInfo(String doNo);
	public List<StockTransfer>getSaltranserIssueList(GoodsIssuesForm goodsIssuesForm);
}

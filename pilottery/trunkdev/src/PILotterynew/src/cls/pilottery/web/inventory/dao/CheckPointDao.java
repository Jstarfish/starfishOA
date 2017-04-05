package cls.pilottery.web.inventory.dao;

import java.util.List;

import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GamePlans;
import cls.pilottery.web.inventory.form.CheckPointForm;
import cls.pilottery.web.inventory.model.CheckPointInfoVo;
import cls.pilottery.web.inventory.model.CheckPointParmat;
import cls.pilottery.web.inventory.model.CheckPointResult;
import cls.pilottery.web.inventory.model.CheckPointVo;
import cls.pilottery.web.inventory.model.WhInfoVo;
import cls.pilottery.web.system.model.User;

public interface CheckPointDao {
	/**
	 * 
	 * @Title: getCheckCount
	 * @Description: 盘点分页总记录数
	 * @param @param checkPointForm
	 * @param @return 参数
	 * @return Integer 返回类型
	 * @throws
	 */
	public Integer getCheckCount(CheckPointForm checkPointForm);

	/**
	 * 
	 * @Title: getCheckList
	 * @Description: 盘点记录分页
	 * @param @param checkPointForm
	 * @param @return 参数
	 * @return List<CheckPointVo> 返回类型
	 * @throws
	 */
	public List<CheckPointVo> getCheckList(CheckPointForm checkPointForm);

	/**
	 * 
	 * @Title: getCpCheckUserList
	 * @Description: 获取仓库管理员
	 * @param @return 参数
	 * @return List<User> 返回类型
	 * @throws
	 */
	public List<User> getCpCheckUserList(String orgCode);

	/**
	 * 
	 * @Title: getWhouseList
	 * @Description: 获取仓库信息
	 * @param @return 参数
	 * @return List<WhInfoVo> 返回类型
	 * @throws
	 */
	public List<WhInfoVo> getWhouseList();

	/**
	 * 
	 * @Title: getGameBatchListBCode
	 * @Description: 获得批次信息
	 * @param @param gameBatchImport
	 * @param @return 参数
	 * @return List<GameBatchImport> 返回类型
	 * @throws
	 */
	public List<GameBatchImport> getGameBatchListBCode(GameBatchImport gameBatchImport);

	/**
	 * 
	 * @Title: addCheckPoint
	 * @Description: 添加盘点
	 * @param @param checkPointParmat 参数
	 * @return void 返回类型
	 * @throws
	 */
	public void addCheckPoint(CheckPointParmat checkPointParmat);

	/**
	 * 
	 * @Title: getProcessCheckInfoByCode
	 * @Description: 获得盘点单信息
	 * @param @param cpNo
	 * @param @return 参数
	 * @return List<CheckPointInfoVo> 返回类型
	 * @throws
	 */
	public List<CheckPointInfoVo> getProcessCheckInfoByCode(String cpNo);

	/**
	 * 
	 * @Title: getAllBatchinfo
	 * @Description: 获得批次信息
	 * @param @return 参数
	 * @return List<> 返回类型
	 * @throws
	 */
	public List<GameBatchImport> getAllBatchinfo();

	public List<GamePlans> getAllgameplans();

	public void checkPointomplete(CheckPointResult checkPointResult);

	public List<CheckPointResult> getCpnormaiList(String cpNo);

	/**
	 * 
	 * @Title: getCheckPointDetailList
	 * @Description: 根据盘点单编号获取差异对比详情列表
	 * @param @return 参数
	 * @return List<CheckPointResult> 返回类型
	 * @throws
	 */
	public List<CheckPointResult> getCheckPointDetailList(String cpNo);

	public CheckPointResult getCheckPointSum(String cpNo);

	public void deleteChckpoinByCode(String cpNo);

	public void deleteChckpoinDetailByCode(String cpNo);

	public List<GamePlanVo> getGamsListCheck(String cpNo);

	public void updateWhinfoStatus(String cpNo);

	public Integer getCheckInquiryCount(CheckPointForm checkPointForm);

	public List<CheckPointVo> getCheckInquiryList(CheckPointForm checkPointForm);
}

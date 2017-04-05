package cls.pilottery.web.payout.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.packinfo.PackInfo;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.payout.model.PayoutRecord;
import cls.pilottery.web.payout.model.WinInfo;
import cls.pilottery.web.sales.model.PlanModel;

/**
 * 兑奖信息的service
 * 
 * @author wangjinglong
 * @version 1.0
 * 
 */
public interface PayoutService {

	/**
	 * 
	 * @param payout
	 *            页面的查询条件（方案，批次）
	 * @return 当前查询条件的数量
	 */
	Integer getPayoutCount(PayoutRecord payout);

	/**
	 * 
	 * @param payout
	 *            页面的查询条件（方案，批次）
	 * @return 中奖列表
	 */
	List<PayoutRecord> getPayoutList(PayoutRecord payout);

	/**
	 * 
	 * @param info
	 *            输入的彩票码
	 * @return 彩票是否兑过奖（0：未兑奖 1：已兑奖）
	 */
	WinInfo isValided(PackInfo info);

	/**
	 * 通过拆解的方案号，批次号和本号获取箱号和盒号返回箱盒本的拼接字符串
	 * 
	 * @param inputCode
	 *            输入的彩票码
	 * @return 箱盒本的拼接字符串
	 */
	String getNum(String inputCode);

	/**
	 * 兑奖过程
	 * 
	 * @param record
	 */
	void payout(PayoutRecord record);

	/**
	 * 获取彩票的兑奖信息（奖级，奖金..）
	 * 
	 * @param win
	 */
	void payoutQuery(WinInfo win);

	InfOrgs getOrgByUser(long userId);

	/**
	 * 获取彩票的中奖编号
	 * 
	 * @param code
	 * @return
	 */
	String getPayFlow1(String code);


	/**
	 * 获取彩票的中奖金额
	 * 
	 * @param form
	 * @return
	 */
	String getAmount(PayoutRecord form);

	/**
	 * 获取单张中奖彩票的detail
	 * 
	 * @param recordNo
	 * @return
	 */
	PayoutRecord getPayoutDetail(String recordNo);

	/**
	 * 通过当前用户id获取用户真实名称
	 * 
	 * @param userid
	 * @return
	 */
	String getUsername(long userid);

	PayoutRecord getPrintRecord(String recordNo);

	String getPlanName(Map<String,String> map);

	int isCompleted(String planCode , String batchNo);

	void updateGuiPayRemark(PayoutRecord record);

	List<PlanModel> getPayoutPlanList();
}

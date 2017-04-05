package cls.pilottery.web.plans.service;

import java.util.List;

import cls.pilottery.web.plans.form.PlanForm;
import cls.pilottery.web.plans.form.TicketsNum;
import cls.pilottery.web.plans.model.BatchPlanComm;
import cls.pilottery.web.plans.model.BatchPublisher;
import cls.pilottery.web.plans.model.BatchTermination;
import cls.pilottery.web.plans.model.ImportBatchResult;
import cls.pilottery.web.plans.model.Plan;
import cls.pilottery.web.plans.model.PlanPublisher;
import cls.pilottery.web.plans.model.Publisher;

/**
 * @InterfaceName PlanService
 * @Description
 * @author Wang Qingxiang
 * @date 2015-09-10
 */
public interface PlanService {

	/* 获得方案总数 */
	public Integer getPlanCount(PlanForm planForm);

	/* 获得方案查询记录 */
	public List<PlanPublisher> getPlanList(PlanForm planForm);

	/* 获得印刷商列表 */
	public List<Publisher> getPublisherList();

	/* 添加新方案 */
	public void addPlan(Plan plan);

	/* 修改方案信息 */
	public void modifyPlan(Plan plan);

	/* 删除方案信息 */
	public void deletePlan(Plan plan);

	/* 查询批次信息 */
	List<BatchPublisher> getBatchDetails(String planCode);

	/* 导入批次 */
	void importBatch(BatchPublisher batch);

	/* 导入详细信息 */
	ImportBatchResult importBatchDetails(BatchPublisher batchpub);

	/* 获取批次通过方案编号 */
	List<String> getBatch(String planCode);

	/* 获取终结批次内容 */
	BatchPublisher getDetailBatchTermination(String planCode , String batchCode , long userId);

	/* 终结 信息 */
	BatchTermination infoBatchTermination(BatchPublisher batch);
	
	/*接口*/
	List<Plan> getPlanListForPOS();
	/*查看该方案下是否有批次*/
	Integer haveBatch(String planCode);
	
	List<Plan> getPlanList();

	 TicketsNum getTicket(PlanForm form);

	 List<String> getBatchOnWork(String planCode);

	 int isWorking(BatchPublisher form);

	 void deleteBackup(Plan plan);
	 
	 List<Plan> getInfPlanList();

	 Integer getBatchCount(PlanForm planForm);

	 List<BatchPublisher> getBatchList(PlanForm planForm);

	public void setPlanComm(BatchPlanComm bpc);

	public List<Plan> getRefPlanList();

}

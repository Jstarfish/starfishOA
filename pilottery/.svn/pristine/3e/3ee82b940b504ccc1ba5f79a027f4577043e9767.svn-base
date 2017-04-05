package cls.pilottery.web.plans.dao;

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
 * @InterfaceName PlanDao
 * @Description
 * @author Wang Qingxiang
 * @date 2015-09-10
 */
public interface PlanDao {

	/* 获得方案总数 */
	Integer getPlanCount(PlanForm planForm);

	/* 获得方案查询记录 */
	List<PlanPublisher> getPlanList(PlanForm planForm);

	/* 获得印刷商列表 */
	List<Publisher> getPublisherList();

	/* 添加新方案 */
	void addPlan(Plan plan);

	/* 修改方案信息 */
	void modifyPlan(Plan plan);

	/* 删除方案信息 */
	void deletePlan(Plan plan);

	/* 查询批次详细信息 */
	List<BatchPublisher> getBatchDetails(String planCode);

	/* 获取所有批次列表 */
	List<String> getBatch(String planCode);

	/* 获取启用的批次列表 */
	List<String> getBatchOnWork(String planCode);

	/* 导入批次 */
	void importBatch(BatchPublisher batch);

	/* 导入详细信息 */
	ImportBatchResult importBatchDetails(BatchPublisher batchpub);

	/* 批次终结 */
	void detailsBatchTermination(BatchPublisher publisher);

	/* 终结 信息 */
	BatchTermination infoBatchTermination(BatchPublisher batch);

	List<Plan> getPlanListForPOS();

	Integer haveBatch(String planCode);

	List<Plan> getPlanList1();

	TicketsNum getTicket(PlanForm form);

	int isWorking(BatchPublisher form);

	void deleteBackup(Plan plan);
	
	List<Plan> getInfPlanList();

	Integer getBatchCount(PlanForm planForm);

	List<BatchPublisher> getBatchList(PlanForm planForm);

	void setPlanComm(BatchPlanComm bpc);

	List<Plan> getRefPlanList();
	
}

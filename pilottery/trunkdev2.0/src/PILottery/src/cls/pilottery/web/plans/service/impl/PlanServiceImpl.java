package cls.pilottery.web.plans.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.plans.model.BatchPlanComm;
import cls.pilottery.web.plans.model.BatchPublisher;
import cls.pilottery.web.plans.model.BatchTermination;
import cls.pilottery.web.plans.model.ImportBatchResult;
import cls.pilottery.web.plans.model.Plan;
import cls.pilottery.web.plans.model.PlanPublisher;
import cls.pilottery.web.plans.model.Publisher;
import cls.pilottery.web.plans.form.PlanForm;
import cls.pilottery.web.plans.form.TicketsNum;
import cls.pilottery.web.plans.dao.PlanDao;
import cls.pilottery.web.plans.service.PlanService;

/**
 * @ClassName PlanServiceImpl
 * @Description
 * @author Wang Qingxiang
 * @date 2015-09-10
 */
@Service("planService")
public class PlanServiceImpl implements PlanService {

	@Autowired
	private PlanDao planDao;

	/* 获得方案总数 */
	@Override
	public Integer getPlanCount(PlanForm planForm) {

		return this.planDao.getPlanCount(planForm);
	}

	/* 获得方案查询记录 */
	@Override
	public List<PlanPublisher> getPlanList(PlanForm planForm) {

		return this.planDao.getPlanList(planForm);
	}

	/* 获得印刷商列表 */
	@Override
	public List<Publisher> getPublisherList() {

		return this.planDao.getPublisherList();
	}

	/* 添加新方案 */
	@Override
	public void addPlan(Plan plan) {

		this.planDao.addPlan(plan);
	}

	/* 修改方案信息 */
	@Override
	public void modifyPlan(Plan plan) {

		this.planDao.modifyPlan(plan);
	}

	/* 删除方案信息 */
	@Override
	public void deletePlan(Plan plan) {

		this.planDao.deletePlan(plan);
	}

	@Override
	public List<BatchPublisher> getBatchDetails(String planCode) {

		return planDao.getBatchDetails(planCode);
	}

	@Override
	public void importBatch(BatchPublisher batch) {

		this.planDao.importBatch(batch);
	}

	@Override
	public ImportBatchResult importBatchDetails(BatchPublisher batchpub) {

		return planDao.importBatchDetails(batchpub);
	}

	@Override
	public List<String> getBatch(String planCode) {

		return planDao.getBatch(planCode);
	}

	@Override
	public BatchPublisher getDetailBatchTermination(String planCode , String batchCode , long userId) {

		BatchPublisher publisher = new BatchPublisher();
		publisher.setBatchNo(batchCode);
		publisher.setPlanCode(planCode);
		publisher.setUserId(userId);
		planDao.detailsBatchTermination(publisher);
		return publisher;
	}

	@Override
	public BatchTermination infoBatchTermination(BatchPublisher batch) {

		return planDao.infoBatchTermination(batch);
	}

	@Override
	public List<Plan> getPlanListForPOS() {

		return planDao.getPlanListForPOS();
	}

	@Override
	public Integer haveBatch(String planCode) {

		return planDao.haveBatch(planCode);
	}

	@Override
	public List<Plan> getPlanList() {

		return planDao.getPlanList1();
	}

	@Override
	public TicketsNum getTicket(PlanForm form) {

		return planDao.getTicket(form);
	}

	@Override
	public List<String> getBatchOnWork(String planCode) {

		return planDao.getBatchOnWork(planCode);
	}

	@Override
	public int isWorking(BatchPublisher form) {

		return planDao.isWorking(form);
	}

	@Override
	public void deleteBackup(Plan plan) {

		planDao.deleteBackup(plan);
	}

	@Override
	public List<Plan> getInfPlanList() {
		return planDao.getInfPlanList();
	}

	@Override
	public Integer getBatchCount(PlanForm planForm) {

		return planDao.getBatchCount(planForm);
	}

	@Override
	public List<BatchPublisher> getBatchList(PlanForm planForm) {
		List<BatchPublisher> result = planDao.getBatchList(planForm);
		return result;
	}

	@Override
	public void setPlanComm(BatchPlanComm bpc) {
		planDao.setPlanComm(bpc);
	}

	@Override
	public List<Plan> getRefPlanList() {
		return planDao.getRefPlanList();
	}

}

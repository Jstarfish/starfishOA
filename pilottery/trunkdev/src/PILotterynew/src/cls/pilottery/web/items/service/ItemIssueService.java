package cls.pilottery.web.items.service;

import java.util.List;

import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.items.form.ItemIssueQueryForm;
import cls.pilottery.web.items.form.NewItemIssueForm;
import cls.pilottery.web.items.model.ItemIssue;
import cls.pilottery.web.items.model.ItemIssueDetail;

public interface ItemIssueService {
	
	/* 获得物品出库记录总数 */
	public Integer getItemIssueCount(ItemIssueQueryForm itemIssueQueryForm);
	
	/* 获得物品出库记录列表 */
	public List<ItemIssue> getItemIssueList(ItemIssueQueryForm itemIssueQueryForm);
	
	/* 获得给定出库单下的所有物品记录 */
	public List<ItemIssueDetail> getItemIssueDetails(String iiNo);
	
	/* 获得收货机构用于下拉框选择 */
	public List<InfOrgs> getReceivingUnitForSelect();
	
	/* 新增物品出库 */
	public void addItemIssue(NewItemIssueForm newItemIssueForm) throws Exception;
}

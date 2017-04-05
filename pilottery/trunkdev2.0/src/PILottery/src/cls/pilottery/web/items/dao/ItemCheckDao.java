package cls.pilottery.web.items.dao;

import java.util.List;

import cls.pilottery.web.items.form.ItemCheckQueryForm;
import cls.pilottery.web.items.form.NewItemCheckForm;
import cls.pilottery.web.items.model.ItemCheck;
import cls.pilottery.web.items.model.ItemCheckDetail;
import cls.pilottery.web.items.model.ItemQuantity;

public interface ItemCheckDao {

	/* 获得物品盘点记录总数 */
	public Integer getItemCheckCount(ItemCheckQueryForm itemCheckQueryForm);
	
	/* 获得物品盘点记录列表 */
	public List<ItemCheck> getItemCheckList(ItemCheckQueryForm itemCheckQueryForm);
	
	/* 获得选择仓库下所有的在库物品（用于添加盘点记录） */
	public List<ItemQuantity> getAvailableItemForCheck(String warehouseCode);
	
	/* 新增盘点记录 */
	public void addItemCheck(NewItemCheckForm newItemCheckForm);
	
	/* 获得盘点物品记录明细（盘点前及盘点后） */
	public List<ItemCheckDetail> getItemCheckListDetails(String checkNo);
	
	/* 获得盘点备注 */
	public String getRemarkByCheckNo(String checkNo);
	
	/* 修改物品盘点单状态 */
	public void updateStatusCompleteCheck(String checkNo);
	
	/* 删除物品盘点记录 */
	public void deleteItemCheck(String checkNo);
	
	/* 删除物品盘点前明细记录 */
	public void deleteItemCheckDetailBefore(String checkNo);
	
	/* 删除物品盘点后明细记录 */
	public void deleteItemCheckDetailAfter(String checkNo);
}

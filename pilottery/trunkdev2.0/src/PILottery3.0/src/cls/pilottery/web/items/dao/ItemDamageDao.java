package cls.pilottery.web.items.dao;

import java.util.List;

import cls.pilottery.web.items.form.ItemDamageQueryForm;
import cls.pilottery.web.items.form.NewItemDamageForm;
import cls.pilottery.web.items.model.ItemDamage;

public interface ItemDamageDao {

	/* 获得物品损毁记录总数 */
	public Integer getItemDamageCount(ItemDamageQueryForm itemDamageQueryForm);
	
	/* 获得物品损毁记录列表 */
	public List<ItemDamage> getItemDamageList(ItemDamageQueryForm itemDamageQueryForm);
	
	/* 新增损毁记录 */
	public void addItemDamage(NewItemDamageForm newItemDamageForm);
}

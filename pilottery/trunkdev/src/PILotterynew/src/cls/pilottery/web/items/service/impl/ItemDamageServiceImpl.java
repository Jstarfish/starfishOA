package cls.pilottery.web.items.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.items.dao.ItemDamageDao;
import cls.pilottery.web.items.form.ItemDamageQueryForm;
import cls.pilottery.web.items.form.NewItemDamageForm;
import cls.pilottery.web.items.model.ItemDamage;
import cls.pilottery.web.items.service.ItemDamageService;

@Service
public class ItemDamageServiceImpl implements ItemDamageService {
	
	@Autowired
	private ItemDamageDao itemDamageDao;

	/* 获得物品损毁记录总数 */
	@Override
	public Integer getItemDamageCount(ItemDamageQueryForm itemDamageQueryForm) {
		return this.itemDamageDao.getItemDamageCount(itemDamageQueryForm);
	}
	
	/* 获得物品损毁记录列表 */
	@Override
	public List<ItemDamage> getItemDamageList(ItemDamageQueryForm itemDamageQueryForm) {
		return this.itemDamageDao.getItemDamageList(itemDamageQueryForm);
	}
	
	/* 新增损毁记录 */
	@Override
	public void addItemDamage(NewItemDamageForm newItemDamageForm) {
		this.itemDamageDao.addItemDamage(newItemDamageForm);
	}
}

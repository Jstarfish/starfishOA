package cls.pilottery.web.items.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.items.model.ItemType;
import cls.pilottery.web.items.form.ItemTypeDeleteForm;
import cls.pilottery.web.items.form.ItemTypeQueryForm;
import cls.pilottery.web.items.dao.ItemTypeDao;
import cls.pilottery.web.items.service.ItemTypeService;

@Service
public class ItemTypeServiceImpl implements ItemTypeService {

    @Autowired
    private ItemTypeDao itemTypeDao;
    
    /* 获得物品类别总数 */
    @Override
    public Integer getItemTypeCount(ItemTypeQueryForm itemTypeQueryForm) {
        return this.itemTypeDao.getItemTypeCount(itemTypeQueryForm);
    }
    
    /* 获得物品查询记录 */
    @Override
    public List<ItemType> getItemTypeList(ItemTypeQueryForm itemTypeQueryForm) {
        return this.itemTypeDao.getItemTypeList(itemTypeQueryForm);
    }

    /* 添加新物品类别 */
    @Override
    public void addItemType(ItemType itemType) {
        this.itemTypeDao.addItemType(itemType);
    }

    /* 修改物品类别信息 */
    @Override
    public void modifyItemType(ItemType itemType) {
        this.itemTypeDao.modifyItemType(itemType);
    }

    /* 删除物品类别信息 */
    @Override
    public void deleteItemType(ItemTypeDeleteForm itemTypeDeleteForm) {
        this.itemTypeDao.deleteItemType(itemTypeDeleteForm);
    }
    
    /* 获得全部可用物品用于下拉框选择 */
    @Override
    public List<ItemType> getItemsForSelect() {
    	return this.itemTypeDao.getItemsForSelect();
    }
}

package cls.pilottery.web.items.dao;

import java.util.List;

import cls.pilottery.web.items.form.ItemTypeDeleteForm;
import cls.pilottery.web.items.form.ItemTypeQueryForm;
import cls.pilottery.web.items.model.ItemType;

public interface ItemTypeDao {

    /* 获得物品类别总数 */
    public Integer getItemTypeCount(ItemTypeQueryForm itemTypeQueryForm);
    
    /* 获得物品查询记录 */
    public List<ItemType> getItemTypeList(ItemTypeQueryForm itemTypeQueryForm);
    
    /* 添加新物品类别 */
    public void addItemType(ItemType itemType);
    
    /* 修改物品类别信息 */
    public void modifyItemType(ItemType itemType);
    
    /* 删除物品类别信息 */
    public void deleteItemType(ItemTypeDeleteForm itemTypeDeleteForm);
    
    /* 获得全部可用物品用于下拉框选择 */
    public List<ItemType> getItemsForSelect();
}

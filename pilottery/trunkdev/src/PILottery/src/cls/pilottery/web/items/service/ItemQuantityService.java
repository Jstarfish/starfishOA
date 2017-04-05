package cls.pilottery.web.items.service;

import java.util.List;

import cls.pilottery.web.items.form.ItemQuantityQueryForm;
import cls.pilottery.web.items.model.ItemQuantity;
import cls.pilottery.web.items.model.ItemType;
import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;

public interface ItemQuantityService {
    /* 获得库存信息记录总数 */
    public Integer getItemQuantityCount(ItemQuantityQueryForm itemQuantityQueryForm);
    
    /* 获得库存信息记录列表 */
    public List<ItemQuantity> getItemQuantityList(ItemQuantityQueryForm itemQuantityQueryForm);
    
    /* 获得全部有库存的仓库 */
    public List<WarehouseInfo> getStorageWarehouseForSelect(UserSessionForm userSessionForm);
    
    /* 获得全部有库存的物品 */
    public List<ItemType> getStorageItemForSelect();
    
    /* 获得物品在制定仓库下的库存量 */
    public Integer getItemQuantityByWarehouse(ItemQuantity itemQuantity);
}

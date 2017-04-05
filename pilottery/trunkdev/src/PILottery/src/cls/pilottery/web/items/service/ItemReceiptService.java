package cls.pilottery.web.items.service;

import java.util.List;

import cls.pilottery.web.items.form.ItemReceiptQueryForm;
import cls.pilottery.web.items.form.NewItemReceiptForm;
import cls.pilottery.web.items.model.ItemReceipt;
import cls.pilottery.web.items.model.ItemReceiptDetail;

public interface ItemReceiptService {
    
    /* 获得物品入库记录总数 */
    public Integer getItemReceiptCount(ItemReceiptQueryForm itemReceiptQueryForm);
    
    /* 获得物品入库记录列表 */
    public List<ItemReceipt> getItemReceiptList(ItemReceiptQueryForm itemReceiptQueryForm);
    
    /* 获得给定入库单下的所有物品记录 */
    public List<ItemReceiptDetail> getItemReceiptDetails(String irNo);
    
    /* 新增物品入库 */
    public void addItemReceipt(NewItemReceiptForm newItemReceiptForm) throws Exception;
}

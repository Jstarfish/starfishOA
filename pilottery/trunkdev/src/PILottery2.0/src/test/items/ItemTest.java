package test.items;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.items.form.ItemTypeQueryForm;
import cls.pilottery.web.items.service.ItemTypeService;
import test.BaseTest;

public class ItemTest extends BaseTest {
    @Autowired
    private ItemTypeService itemTypeService;
    @Test
    public void testItemCount(){
        ItemTypeQueryForm itemTypeForm = new ItemTypeQueryForm() ;
        itemTypeForm.setItemCodeQuery("100");
        Integer count = itemTypeService.getItemTypeCount(itemTypeForm);
        System.out.println(count);
    }

}

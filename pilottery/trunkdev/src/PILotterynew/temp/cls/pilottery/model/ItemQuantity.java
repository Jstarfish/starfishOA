package cls.pilottery.model;

public class ItemQuantity extends ItemQuantityKey {
    private String itemName;

    private Long items;

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName == null ? null : itemName.trim();
    }

    public Long getItems() {
        return items;
    }

    public void setItems(Long items) {
        this.items = items;
    }
}
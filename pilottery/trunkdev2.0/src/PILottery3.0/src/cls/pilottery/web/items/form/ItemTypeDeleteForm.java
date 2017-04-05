package cls.pilottery.web.items.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class ItemTypeDeleteForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 1661465303521046155L;

	private String itemCode;

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
}

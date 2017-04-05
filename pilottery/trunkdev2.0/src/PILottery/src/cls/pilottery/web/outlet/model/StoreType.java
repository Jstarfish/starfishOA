package cls.pilottery.web.outlet.model;

import java.io.Serializable;

/**
 * 店面类型表
 * 
 * @author Administrator
 * 
 */
public class StoreType implements Serializable {
	private static final long serialVersionUID = 1L;

	private Short storeId;

	private String storeName;

	public Short getStoreId() {
		return storeId;
	}

	public void setStoreId(Short storeId) {
		this.storeId = storeId;
	}

	public String getStoreName() {
		return storeName;
	}

	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}

	public StoreType() {
	}
}


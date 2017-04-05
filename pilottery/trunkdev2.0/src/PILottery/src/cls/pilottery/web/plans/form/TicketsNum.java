package cls.pilottery.web.plans.form;

import java.io.Serializable;

public class TicketsNum implements Serializable {

	private static final long serialVersionUID = 1L;

	private long total;// 批次总数

	private long sales;// 销售数量

	private long damages;// 损毁数量

	private long manager;// 管理员库存

	private long stock;// 当前库存

	private long road;// 在途

	public long getRoad() {

		return road;
	}

	public void setRoad(long road) {

		this.road = road;
	}

	public TicketsNum() {

	}

	public long getDamages() {

		return damages;
	}

	public long getManager() {

		return manager;
	}

	public long getSales() {

		return sales;
	}

	public long getStock() {

		return stock;
	}

	public long getTotal() {

		return total;
	}

	public void setDamages(long damages) {

		this.damages = damages;
	}

	public void setManager(long manager) {

		this.manager = manager;
	}

	public void setSales(long sales) {

		this.sales = sales;
	}

	public void setStock(long stock) {

		this.stock = stock;
	}

	public void setTotal(long total) {

		this.total = total;
	}
}

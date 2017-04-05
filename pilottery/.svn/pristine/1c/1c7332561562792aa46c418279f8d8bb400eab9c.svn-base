package cls.pilottery.oms.lottery.model;

import cls.pilottery.common.model.BaseEntity;

public class LotterPrize extends BaseEntity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6532225041798988050L;
	private String name;// char[64] 奖等名称
	private int prizeCode;// uint8 奖等编码
	private long count;// uint32 中奖注数
	private long amountSingle;// money_t(int64) 单注金额
	private long amountBeforeTax;// money_t(int64) 单注金额x中奖注数
	private long amountTax;// money_t(int64) 单注税金
	private long amountAfterTax;// money_t(int64) (单注金额-税金)x中奖注数

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getPrizeCode() {
		return prizeCode;
	}

	public void setPrizeCode(int prizeCode) {
		this.prizeCode = prizeCode;
	}

	public long getCount() {
		return count;
	}

	public void setCount(long count) {
		this.count = count;
	}

	public long getAmountSingle() {
		return amountSingle;
	}

	public void setAmountSingle(long amountSingle) {
		this.amountSingle = amountSingle;
	}

	public long getAmountBeforeTax() {
		return amountBeforeTax;
	}

	public void setAmountBeforeTax(long amountBeforeTax) {
		this.amountBeforeTax = amountBeforeTax;
	}

	public long getAmountTax() {
		return amountTax;
	}

	public void setAmountTax(long amountTax) {
		this.amountTax = amountTax;
	}

	public long getAmountAfterTax() {
		return amountAfterTax;
	}

	public void setAmountAfterTax(long amountAfterTax) {
		this.amountAfterTax = amountAfterTax;
	}



}

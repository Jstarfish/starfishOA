package cls.pilottery.webncp.system.model;

import java.io.Serializable;

public class Response4001Record implements Serializable {

	private static final long serialVersionUID = 552494993031090063L;
	private String winLevel; // 奖等
	private Integer saleCount; // 注数
	private Long singleBet; // 每注金额
	private Long winSum; // 总金额
	private String winName;

	public String getWinName() {
		return winName;
	}

	public void setWinName(String winName) {
		this.winName = winName;
	}

	public String getWinLevel() {
		return winLevel;
	}

	public void setWinLevel(String winLevel) {
		this.winLevel = winLevel;
	}

	public Integer getSaleCount() {
		return saleCount;
	}

	public void setSaleCount(Integer saleCount) {
		this.saleCount = saleCount;
	}

	public Long getSingleBet() {
		return singleBet;
	}

	public void setSingleBet(Long singleBet) {
		this.singleBet = singleBet;
	}

	public Long getWinSum() {
		return winSum;
	}

	public void setWinSum(Long winSum) {
		this.winSum = winSum;
	}
}
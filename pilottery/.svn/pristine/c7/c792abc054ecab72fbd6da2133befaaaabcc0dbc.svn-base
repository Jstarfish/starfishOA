package cls.pilottery.web.area.model;

public class GameAuth implements Comparable<GameAuth>, java.io.Serializable{

	private static final long serialVersionUID = -7254370847859494043L;

	private long     areaCode;				//授权区域
	private long	 agencyCode;        	//授权销售站
	private long	 gameCode;				//游戏编号
	private String	 name;					//游戏名称
	private int		 type = 1;          	//游戏类型（1=基诺,2=乐透,3=数字）
	private int  	 enabled = 0;      	    //是否可用（1=可用，0=不可用）
	private int      fee = 0;				//发行费比例
	private int		 payStatus = 0;     	//（1=是；0=否）
	private int		 sellStatus = 0;    	//是否可销售
	private int		 cancel = 0;			//是否可退票
	private long 	 saleCommissionRate = 0;//销售代销费	
	private long 	 payCommissionRate = 0; //兑奖代销费
	private int 	 claimingScope = 1;		//兑奖范围
	private int   flag;
	
	public long getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(long areaCode) {
		this.areaCode = areaCode;
	}

	public long getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(long agencyCode) {
		this.agencyCode = agencyCode;
	}

	public long getGameCode() {
		return gameCode;
	}

	public void setGameCode(long gameCode) {
		this.gameCode = gameCode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public int getEnabled() {
		return enabled;
	}

	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}

	public int getFee() {
		return fee;
	}

	public void setFee(int fee) {
		this.fee = fee;
	}

	public int getPayStatus() {
		return payStatus;
	}

	public void setPayStatus(int payStatus) {
		this.payStatus = payStatus;
	}

	public int getSellStatus() {
		return sellStatus;
	}

	public void setSellStatus(int sellStatus) {
		this.sellStatus = sellStatus;
	}

	public int getCancel() {
		return cancel;
	}

	public void setCancel(int cancel) {
		this.cancel = cancel;
	}

	public long getSaleCommissionRate() {
		return saleCommissionRate;
	}

	public void setSaleCommissionRate(long saleCommissionRate) {
		this.saleCommissionRate = saleCommissionRate;
	}

	public long getPayCommissionRate() {
		return payCommissionRate;
	}

	public void setPayCommissionRate(long payCommissionRate) {
		this.payCommissionRate = payCommissionRate;
	}

	public int getClaimingScope() {
		return claimingScope;
	}

	public void setClaimingScope(int claimingScope) {
		this.claimingScope = claimingScope;
	}

	public int getFlag() {
		return flag;
	}

	public void setFlag(int flag) {
		this.flag = flag;
	}

	@Override	
	public int compareTo(GameAuth o) {
		// TODO Auto-generated method stub
		int result = (int)(this.gameCode - o.gameCode);
		return result;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (int) (gameCode ^ (gameCode >>> 32));
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		GameAuth other = (GameAuth) obj;
		if (gameCode != other.gameCode)
			return false;
		return true;
	}




	



}

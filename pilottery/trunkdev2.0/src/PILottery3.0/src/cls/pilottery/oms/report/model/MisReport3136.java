package cls.pilottery.oms.report.model;

public class MisReport3136 {
	//调节资金
	 private long adjbefore;//期初余额
	 private long adjissue;//本期计提
     private long adjabandon;//弃奖转入
     private long adjpool;//转出到奖池
     private long adspec;//设置特别奖
     private long adjafter;//期末余额
     //奖池资金
     private long poolbefore;//期初余额
     private long poolissue;//本期计提
     private long pooladj;//调节基金转入
     private long poolhdreward;//高等奖金
     private long poolafter;//期末余额
     private String gameName;	//游戏名称
	public long getAdjbefore() {
		return adjbefore;
	}
	public void setAdjbefore(long adjbefore) {
		this.adjbefore = adjbefore;
	}
	public long getAdjissue() {
		return adjissue;
	}
	public void setAdjissue(long adjissue) {
		this.adjissue = adjissue;
	}
	public long getAdjabandon() {
		return adjabandon;
	}
	public void setAdjabandon(long adjabandon) {
		this.adjabandon = adjabandon;
	}
	public long getAdjpool() {
		return adjpool;
	}
	public void setAdjpool(long adjpool) {
		this.adjpool = adjpool;
	}
	public long getAdspec() {
		return adspec;
	}
	public void setAdspec(long adspec) {
		this.adspec = adspec;
	}
	public long getAdjafter() {
		return adjafter;
	}
	public void setAdjafter(long adjafter) {
		this.adjafter = adjafter;
	}
	public long getPoolbefore() {
		return poolbefore;
	}
	public void setPoolbefore(long poolbefore) {
		this.poolbefore = poolbefore;
	}
	public long getPoolissue() {
		return poolissue;
	}
	public void setPoolissue(long poolissue) {
		this.poolissue = poolissue;
	}
	public long getPooladj() {
		return pooladj;
	}
	public void setPooladj(long pooladj) {
		this.pooladj = pooladj;
	}
	public long getPoolhdreward() {
		return poolhdreward;
	}
	public void setPoolhdreward(long poolhdreward) {
		this.poolhdreward = poolhdreward;
	}
	public long getPoolafter() {
		return poolafter;
	}
	public void setPoolafter(long poolafter) {
		this.poolafter = poolafter;
	}
	public String getGameName() {
		return gameName;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
	}
     
}

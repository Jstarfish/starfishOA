package cls.pilottery.oms.common.msg;

import java.util.ArrayList;
import java.util.List;

public class SendPrize3009Req implements java.io.Serializable {
	private static final long serialVersionUID = -3073968858584219378L;
	public short gameCode;
    public long issueNumber;
    public short drawTimes;
    public short prizeCount;
    public List<PrizeInfo> prizes = new ArrayList<PrizeInfo>();
    
    public class PrizeInfo implements java.io.Serializable {
		private static final long serialVersionUID = 1980461925256434068L;
		short prizeCode;
        long prizeAmount;
        public short getPrizeCode() {
            return prizeCode;
        }
        public void setPrizeCode(short prizeCode) {
            this.prizeCode = prizeCode;
        }
        public long getPrizeAmount() {
            return prizeAmount;
        }
        public void setPrizeAmount(long prizeAmount) {
            this.prizeAmount = prizeAmount;
        }  
    }

	public short getGameCode() {
		return gameCode;
	}

	public void setGameCode(short gameCode) {
		this.gameCode = gameCode;
	}

	public long getIssueNumber() {
		return issueNumber;
	}

	public void setIssueNumber(long issueNumber) {
		this.issueNumber = issueNumber;
	}

	public short getDrawTimes() {
		return drawTimes;
	}

	public void setDrawTimes(short drawTimes) {
		this.drawTimes = drawTimes;
	}

	public short getPrizeCount() {
		return prizeCount;
	}

	public void setPrizeCount(short prizeCount) {
		this.prizeCount = prizeCount;
	}

	public List<PrizeInfo> getPrizes() {
		return prizes;
	}

	public void setPrizes(List<PrizeInfo> prizes) {
		this.prizes = prizes;
	}
    
    
}

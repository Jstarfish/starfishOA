package cls.pilottery.oms.issue.model;

import java.util.List;
import java.util.ArrayList;

public class DrawNoticeXml {
    
    String gameCode;
    String gameName;
    String periodIssue;
    String codeResult;
    String saleAmount;
    String poolScroll;
    String overDual;
    
    public List<LotteryDetail> lotteryDetails = new ArrayList<LotteryDetail>();
    public List<AreaPrize> highPrizeAreas = new ArrayList<AreaPrize>(); 

    public String getGameCode() {
        return gameCode;
    }
    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }
    public String getGameName() {
        return gameName;
    }
    public void setGameName(String gameName) {
        this.gameName = gameName;
    }
    public String getPeriodIssue() {
        return periodIssue;
    }
    public void setPeriodIssue(String periodIssue) {
        this.periodIssue = periodIssue;
    }
    public String getCodeResult() {
        return codeResult;
    }
    public void setCodeResult(String codeResult) {
        this.codeResult = codeResult;
    }
    public String getSaleAmount() {
        return saleAmount;
    }
    public void setSaleAmount(String saleAmount) {
        this.saleAmount = saleAmount;
    }
    public String getPoolScroll() {
        return poolScroll;
    }
    public void setPoolScroll(String poolScroll) {
        this.poolScroll = poolScroll;
    }

    public List<LotteryDetail> getLotteryDetails() {
        return lotteryDetails;
    }
    public void setLotteryDetails(List<LotteryDetail> lotteryDetails) {
        this.lotteryDetails = lotteryDetails;
    }
    public List<AreaPrize> getHighPrizeAreas() {
        return highPrizeAreas;
    }
    public void setHighPrizeAreas(List<AreaPrize> highPrizeAreas) {
        this.highPrizeAreas = highPrizeAreas;
    }
    
    public String getOverDual() {
        return overDual;
    }
    public void setOverDual(String overDual) {
        this.overDual = overDual;
    }


    public class LotteryDetail{
        String prizeLevel;
        String betCount;
        String awardAmount;
        String amountAfterTax;
        String amountTotal;

        public String getPrizeLevel() {
            return prizeLevel;
        }
        public void setPrizeLevel(String prizeLevel) {
            this.prizeLevel = prizeLevel;
        }
        public String getBetCount() {
            return betCount;
        }
        public void setBetCount(String betCount) {
            this.betCount = betCount;
        }
        public String getAwardAmount() {
            return awardAmount;
        }
        public void setAwardAmount(String awardAmount) {
            this.awardAmount = awardAmount;
        }
        public String getAmountAfterTax() {
            return amountAfterTax;
        }
        public void setAmountAfterTax(String amountAfterTax) {
            this.amountAfterTax = amountAfterTax;
        }
        public String getAmountTotal() {
            return amountTotal;
        }
        public void setAmountTotal(String amountTotal) {
            this.amountTotal = amountTotal;
        }
    }



    public class AreaPrize {

        public String areaCode;
        public String areaName;
        public List<AreaLotteryDetail> areaLotteryDetails = new ArrayList<AreaLotteryDetail>();

        
        public String getAreaCode() {
            return areaCode;
        }
        public void setAreaCode(String areaCode) {
            this.areaCode = areaCode;
        }
        public String getAreaName() {
            return areaName;
        }
        public void setAreaName(String areaName) {
            this.areaName = areaName;
        }
        public List<AreaLotteryDetail> getAreaLotteryDetails() {
            return areaLotteryDetails;
        }
        public void setAreaLotteryDetails(List<AreaLotteryDetail> areaLotteryDetails) {
            this.areaLotteryDetails = areaLotteryDetails;
        }

    }

    public class AreaLotteryDetail {
        String prizeLevel;
        String betCount;
        public String getPrizeLevel() {
            return prizeLevel;
        }
        public void setPrizeLevel(String prizeLevel) {
            this.prizeLevel = prizeLevel;
        }
        public String getBetCount() {
            return betCount;
        }
        public void setBetCount(String betCount) {
            this.betCount = betCount;
        }
        
    }
    
    
}

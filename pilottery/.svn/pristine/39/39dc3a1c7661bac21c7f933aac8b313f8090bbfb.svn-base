package cls.pilottery.oms.lottery.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cls.pilottery.oms.common.utils.BeanFormart;

public class LotteryResModel implements Serializable {
    private static final long serialVersionUID = -1784665366781653289L;
    private String reqfn_ticket_pay;//
    private String rspfn_ticket_pay;//兑奖响应交易流水号
    private long unique_tsn;
    private long unique_tsn_pay;//
    private String rspfn_ticket;// char[25] 销售彩票TSN
    private String reqfn_ticket;//
    private long areaCode_pay;// 兑奖请求销售站编码
    private long respayagencycode;// uint64 兑奖请求销售站编码
    private int gamecode;// uint8 游戏编码
    private short issueCount;// uint8 期数
    private long startIssueNumber;// uint64 起始销售期号
    private long endIssueNumber;// uint64 结束销售期号
    private int saleTime;// uint32 销售时间
    private long winningAmountWithTax;// money_t(int64) 中奖金额(税前)
    private long taxAmount;// money_t(int64) 税金
    private long winningAmount;// money_t(int64) 中奖金额税后
    private int transTimeStamp;// uint32 交易时间
    private int betStringLen;// uint16 投注字符串长度
    private String betingstr;// 投注行信息
    private String betString; // 投注字符串
    private int prizeCount;// 中奖奖等数目
    private List<LotterPrize> prizeDetail;
    private List<Betinfo> betlist;// 投注行信息列表
    private String betprize;
    private Date saletime_format;
    private Date transtimestamp_format;

    private String alanguage;//语言\
    private int bettinglinenumber;// 投注行数目


    public String getBetingstr() {
        return betingstr;
    }

    public int getBettinglinenumber() {
        return bettinglinenumber;
    }

    public void setBettinglinenumber(int bettinglinenumber) {
        this.bettinglinenumber = bettinglinenumber;
    }

    public String getAlanguage() {
        return alanguage;
    }

    public void setAlanguage(String alanguage) {
        this.alanguage = alanguage;
    }

    public long getRespayagencycode() {
        return respayagencycode;
    }

    public void setRespayagencycode(long respayagencycode) {
        this.respayagencycode = respayagencycode;
    }

    public int getGamecode() {
        return gamecode;
    }

    public void setGamecode(int gamecode) {
        this.gamecode = gamecode;
    }

    public short getIssueCount() {
        return issueCount;
    }

    public void setIssueCount(short issueCount) {
        this.issueCount = issueCount;
    }


    public long getWinningAmountWithTax() {
        return winningAmountWithTax;
    }

    public void setWinningAmountWithTax(long winningAmountWithTax) {
        this.winningAmountWithTax = winningAmountWithTax;
    }

    public long getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(long taxAmount) {
        this.taxAmount = taxAmount;
    }

    public long getWinningAmount() {
        return winningAmount;
    }

    public void setWinningAmount(long winningAmount) {
        this.winningAmount = winningAmount;
    }

    public int getTransTimeStamp() {
        return transTimeStamp;
    }

    public void setTransTimeStamp(int transTimeStamp) {
        this.transtimestamp_format = new Date(transTimeStamp * 1000);
        this.transTimeStamp = transTimeStamp;
    }

    public int getBetStringLen() {
        return betStringLen;
    }

    public void setBetStringLen(int betStringLen) {
        this.betStringLen = betStringLen;
    }

    public String getBetString() {
        return betString;
    }



    public void setBetString(String betString) {
        if (this.getGamecode() == 14) {
            if (betString != "" && betString != null) {
                StringBuffer fbsBetingString = new StringBuffer("");

                String[] bets = betString.split("[|]");
                if (bets.length > 0) {
                    for (int j = 0; j < bets.length; j++) {
                        if (j == 1) {
                                fbsBetingString.append(bets[j]).append("&");
                        }
                        if (j == 2) {
                                fbsBetingString.append(bets[j]).append("&");
                        }
                        if (j == 4) {
                                String newbet = changedBetString(bets[1], bets[j], getAlanguage());
                                fbsBetingString.append(newbet).append("&");
                        }
                        if (j == 6) {
                                fbsBetingString.append(bets[j]).append("&");
                        }
                    }
                    this.setBetingstr(fbsBetingString.toString().endsWith("&") ?
                            fbsBetingString.toString().substring(0, fbsBetingString.toString().length() - 1) :
                            fbsBetingString.toString());
                }
            }
            this.betString = betString;
        } else {
            String[] bets = betString.split("[|]");
            String betprize = "";
            if (bets.length > 0) {
                betprize = bets[5];
            }

            if (betprize != "" && betprize != null) {
                String beprizes[] = betprize.split("/");
                if (beprizes.length > 0) {
                    betlist = new ArrayList<Betinfo>();
                    for (int i = 0; i < beprizes.length; i++) {
                        Betinfo info = new Betinfo();
                        String att[] = beprizes[i].split("-");
                        if (att.length > 0) {
                            info = BeanFormart.transBean(att);
                            betlist.add(info);
                        }
                    }
                }

            }
            this.betString = betString;
        }
    }

    public void setBetingstr(String betingstr) {
        this.betingstr = betingstr;
        if (!"".equals(betingstr) && null != betingstr) {
            String betatt[] = betingstr.split("/");
            bettinglinenumber = betatt.length;
            if (betatt.length > 0) {
                betlist = new ArrayList<Betinfo>();
                for (int i = 0; i < betatt.length; i++) {
                    Betinfo info = new Betinfo();
                    String att[] = null;
                    if (this.getGamecode() == 14) {
                        att = betatt[i].split("&");
                    } else {
                        att = betatt[i].split("-");
                    }
                    if (att.length > 0) {
                        info = BeanFormart.transBean(att);
                        betlist.add(info);
                    }
                }
            }
        }
    }


    public List<Betinfo> getBetlist() {
        return betlist;
    }

    public void setBetlist(List<Betinfo> betlist) {
        this.betlist = betlist;
    }

    public String getBetprize() {
        return betprize;
    }

    public void setBetprize(String betprize) {
        this.betprize = betprize;
    }


    public Date getSaletime_format() {
        return saletime_format;
    }

    public void setSaletime_format(Date saletime_format) {
        this.saletime_format = saletime_format;
    }

    public Date getTranstimestamp_format() {
        return transtimestamp_format;
    }

    public void setTranstimestamp_format(Date transtimestamp_format) {
        this.transtimestamp_format = transtimestamp_format;
    }

    public String getReqfn_ticket_pay() {
        return reqfn_ticket_pay;
    }

    public void setReqfn_ticket_pay(String reqfn_ticket_pay) {
        this.reqfn_ticket_pay = reqfn_ticket_pay;
    }

    public String getRspfn_ticket_pay() {
        return rspfn_ticket_pay;
    }

    public void setRspfn_ticket_pay(String rspfn_ticket_pay) {
        this.rspfn_ticket_pay = rspfn_ticket_pay;
    }

    public long getUnique_tsn() {
        return unique_tsn;
    }

    public void setUnique_tsn(long unique_tsn) {
        this.unique_tsn = unique_tsn;
    }

    public long getUnique_tsn_pay() {
        return unique_tsn_pay;
    }

    public void setUnique_tsn_pay(long unique_tsn_pay) {
        this.unique_tsn_pay = unique_tsn_pay;
    }

    public String getRspfn_ticket() {
        return rspfn_ticket;
    }

    public void setRspfn_ticket(String rspfn_ticket) {
        this.rspfn_ticket = rspfn_ticket;
    }

    public String getReqfn_ticket() {
        return reqfn_ticket;
    }

    public void setReqfn_ticket(String reqfn_ticket) {
        this.reqfn_ticket = reqfn_ticket;
    }

    public long getAreaCode_pay() {
        return areaCode_pay;
    }

    public void setAreaCode_pay(long areaCode_pay) {
        this.areaCode_pay = areaCode_pay;
    }

    public long getStartIssueNumber() {
        return startIssueNumber;
    }

    public void setStartIssueNumber(long startIssueNumber) {
        this.startIssueNumber = startIssueNumber;
    }

    public long getEndIssueNumber() {
        return endIssueNumber;
    }

    public void setEndIssueNumber(long endIssueNumber) {
        this.endIssueNumber = endIssueNumber;
    }

    public int getSaleTime() {
        return saleTime;
    }

    public void setSaleTime(int saleTime) {
        this.saletime_format = new Date(saleTime * 1000);
        this.saleTime = saleTime;
    }

    public int getPrizeCount() {
        return prizeCount;
    }

    public void setPrizeCount(int prizeCount) {
        this.prizeCount = prizeCount;
    }

    public List<LotterPrize> getPrizeDetail() {
        return prizeDetail;
    }

    public void setPrizeDetail(List<LotterPrize> prizeDetail) {
        this.prizeDetail = prizeDetail;
    }

    /*
   * 根据玩法把枚举换成字符串显示
   * [161129002:1-10-11-15-18-19-22-25]+
   * [161129002:1-10-11-15-18-19-22-25]
   * [161213010:3-4]+[161213011:4]
   * */
    public String changedBetString(String playType, String betString, String language) {
        StringBuffer newBetStr = new StringBuffer("");
        if (language == null || ("").equals(language)) {
            return betString;
        }
        if (playType.equalsIgnoreCase("WIN")) {//胜平负
            String betAreaWithIssue[] = betString.split("[+]");
            for (int i = 0; i < betAreaWithIssue.length; i++) {
                String betRealAera[] = betAreaWithIssue[i].split("[:]");
                newBetStr.append(betRealAera[0]).append(":");//期次加上
                String betRealStr = betRealAera[1].substring(0, betRealAera[1].length() - 1);
                String betRealOption[] = betRealStr.split("[-]");
                for (int j = 0; j < betRealOption.length; j++) {
                    //全场胜平负
                    newBetStr.append(getFullWinLevelLosScoreString(Integer.parseInt(betRealOption[j])));
                    if (j != betRealOption.length - 1) {
                        newBetStr.append(";");
                    }
                }
                if (i != betAreaWithIssue.length - 1) {
                    newBetStr.append("]+");
                } else {
                    newBetStr.append("]");
                }
            }
        } else if (playType.equalsIgnoreCase("HCP")) {//让分胜负
            String betAreaWithIssue[] = betString.split("[+]");
            for (int i = 0; i < betAreaWithIssue.length; i++) {
                String betRealAera[] = betAreaWithIssue[i].split("[:]");
                newBetStr.append(betRealAera[0]).append(":");//期次加上
                String betRealStr = betRealAera[1].substring(0, betRealAera[1].length() - 1);
                String betRealOption[] = betRealStr.split("[-]");
                for (int j = 0; j < betRealOption.length; j++) {
                    //全场胜平负
                    newBetStr.append(getFullWinLosScoreString(Integer.parseInt(betRealOption[j])));
                    if (j != betRealOption.length - 1) {
                        newBetStr.append(";");
                    }
                }
                if (i != betAreaWithIssue.length - 1) {
                    newBetStr.append("]+");
                } else {
                    newBetStr.append("]");
                }
            }
        } else if (playType.equalsIgnoreCase("TOT")) {//总进球
            String betAreaWithIssue[] = betString.split("[+]");
            for (int i = 0; i < betAreaWithIssue.length; i++) {
                String betRealAera[] = betAreaWithIssue[i].split("[:]");
                newBetStr.append(betRealAera[0]).append(":");//期次加上
                String betRealStr = betRealAera[1].substring(0, betRealAera[1].length() - 1);
                String betRealOption[] = betRealStr.split("[-]");
                for (int j = 0; j < betRealOption.length; j++) {
                    //全场胜平负
                    newBetStr.append(getFullScoreString(Integer.parseInt(betRealOption[j]))).append(" goals");
                    if (j != betRealOption.length - 1) {
                        newBetStr.append(";");
                    }
                }
                if (i != betAreaWithIssue.length - 1) {
                    newBetStr.append("]+");
                } else {
                    newBetStr.append("]");
                }
            }
        } else if (playType.equalsIgnoreCase("SCR")) {//比分
            String betAreaWithIssue[] = betString.split("[+]");
            for (int i = 0; i < betAreaWithIssue.length; i++) {
                String betRealAera[] = betAreaWithIssue[i].split("[:]");
                newBetStr.append(betRealAera[0]).append(":");//期次加上
                String betRealStr = betRealAera[1].substring(0, betRealAera[1].length() - 1);
                String betRealOption[] = betRealStr.split("[-]");
                for (int j = 0; j < betRealOption.length; j++) {
                    //比分
                    newBetStr.append(getSingleScoreString(Integer.parseInt(betRealOption[j]), language));
                    if (j != betRealOption.length - 1) {
                        newBetStr.append(";");
                    }
                }
                if (i != betAreaWithIssue.length - 1) {
                    newBetStr.append("]+");
                } else {
                    newBetStr.append("]");
                }
            }
        } else if (playType.equalsIgnoreCase("HFT")) {//半全场
            String betAreaWithIssue[] = betString.split("[+]");
            for (int i = 0; i < betAreaWithIssue.length; i++) {
                String betRealAera[] = betAreaWithIssue[i].split("[:]");
                newBetStr.append(betRealAera[0]).append(":");//期次加上
                String betRealStr = betRealAera[1].substring(0, betRealAera[1].length() - 1);
                String betRealOption[] = betRealStr.split("[-]");
                for (int j = 0; j < betRealOption.length; j++) {
                    //全场胜平负
                    newBetStr.append(getHfwinlevellosResultString(Integer.parseInt(betRealOption[j])));
                    if (j != betRealOption.length - 1) {
                        newBetStr.append(";");
                    }
                }
                if (i != betAreaWithIssue.length - 1) {
                    newBetStr.append("]+");
                } else {
                    newBetStr.append("]");
                }
            }

        } else if (playType.equalsIgnoreCase("OUOD")) {//大小单双

            String betAreaWithIssue[] = betString.split("[+]");
            for (int i = 0; i < betAreaWithIssue.length; i++) {
                String betRealAera[] = betAreaWithIssue[i].split("[:]");
                newBetStr.append(betRealAera[0]).append(":");//期次加上
                String betRealStr = betRealAera[1].substring(0, betRealAera[1].length() - 1);
                String betRealOption[] = betRealStr.split("[-]");
                for (int j = 0; j < betRealOption.length; j++) {
                    //全场胜平负
                    newBetStr.append(getHfSingleDoubleString(Integer.parseInt(betRealOption[j]), language));
                    if (j != betRealOption.length - 1) {
                        newBetStr.append(";");
                    }
                }
                if (i != betAreaWithIssue.length - 1) {
                    newBetStr.append("]+");
                } else {
                    newBetStr.append("]");
                }
            }
        }

        return newBetStr.toString();
    }


    /*
    * 上下盘单双
    * 语言菜蔬ZH,EN
    * */
    public String getHfSingleDoubleString(int hfSingleDoubleEnum, String language) {
        String singleDoubleString = "";
        if (language.equalsIgnoreCase("zh")) {
            switch (hfSingleDoubleEnum) {
                case 1:
                    singleDoubleString = "上盘单数";
                    break;
                case 2:
                    singleDoubleString = "上盘双数";
                    break;
                case 3:
                    singleDoubleString = "下盘单数";
                    break;
                case 4:
                    singleDoubleString = "下盘双数";
                    break;
            }
        } else {
            switch (hfSingleDoubleEnum) {
                case 1:
                    singleDoubleString = "Total Over and Odd";
                    break;
                case 2:
                    singleDoubleString = "Total Over and Even";
                    break;
                case 3:
                    singleDoubleString = "Total Under and Odd";
                    break;
                case 4:
                    singleDoubleString = "Total Under and Even";
                    break;
            }
        }
        return singleDoubleString;
    }

    /*
   * 总进球数
   * */
    public String getFullScoreString(int fullScoreEnum) {
        String fullScoreString = "";
        switch (fullScoreEnum) {
            case 1:
                fullScoreString = "0";
                break;
            case 2:
                fullScoreString = "1";
                break;
            case 3:
                fullScoreString = "2";
                break;
            case 4:
                fullScoreString = "3";
                break;
            case 5:
                fullScoreString = "4";
                break;
            case 6:
                fullScoreString = "5";
                break;
            case 7:
                fullScoreString = "6";
                break;
            case 8:
                fullScoreString = "7";
                break;
            default:
                fullScoreString = "7+";
                break;
        }
        return fullScoreString;
    }

    /*
    *
    * 全场胜平负
    * */
    public String getFullWinLevelLosScoreString(int fullWinLevelLosScoreEnum) {
        String fullWinLevelLosScoreString = "";
        switch (fullWinLevelLosScoreEnum) {
            case 1:
                fullWinLevelLosScoreString = "3";
                break;
            case 2:
                fullWinLevelLosScoreString = "1";
                break;
            case 3:
                fullWinLevelLosScoreString = "0";
                break;
            default:
                fullWinLevelLosScoreString = "1";
                break;
        }
        return fullWinLevelLosScoreString;
    }

    /*
    *
    * 全场胜负,只有两个枚举
    * FullWinLosScore
    * */
    public String getFullWinLosScoreString(int fullWinLosScoreEnum) {
        String fullWinLosScoreString = "";
        switch (fullWinLosScoreEnum) {
            case 1:
                fullWinLosScoreString = "3";
                break;
            case 2:
                fullWinLosScoreString = "0";
                break;
            default:
                fullWinLosScoreString = "0";
                break;
        }
        return fullWinLosScoreString;
    }


    /*
    *
    * 半全场胜平负
    * hfwinlevellosResultEnum
    * */
    public String getHfwinlevellosResultString(int hfwinlevellosResultEnum) {
        String hfwinlevellosResultString = "";
        switch (hfwinlevellosResultEnum) {
            case 1:
                hfwinlevellosResultString = "3-3";
                break;
            case 2:
                hfwinlevellosResultString = "3-1";
                break;
            case 3:
                hfwinlevellosResultString = "3-0";
                break;
            case 4:
                hfwinlevellosResultString = "1-3";
                break;
            case 5:
                hfwinlevellosResultString = "1-1";
                break;
            case 6:
                hfwinlevellosResultString = "1-0";
                break;
            case 7:
                hfwinlevellosResultString = "0-3";
                break;
            case 8:
                hfwinlevellosResultString = "0-1";
                break;
            case 9:
                hfwinlevellosResultString = "0-0";
                break;
            default:
                hfwinlevellosResultString = "0-0";
                break;
        }
        return hfwinlevellosResultString;
    }


    /*
  *
  * 比分
  * SingleScoreEnum
  * */
    public String getSingleScoreString(int singleScoreEnum, String language) {
        String singleScoreString = "";
        switch (singleScoreEnum) {
            case 1:
                singleScoreString = "1-0";
                break;
            case 2:
                singleScoreString = "2-0";
                break;
            case 3:
                singleScoreString = "2-1";
                break;
            case 4:
                singleScoreString = "3-0";
                break;
            case 5:
                singleScoreString = "3-1";
                break;
            case 6:
                singleScoreString = "3-2";
                break;
            case 7:
                singleScoreString = "4-0";
                break;
            case 8:
                singleScoreString = "4-1";
                break;
            case 9:
                singleScoreString = "4-2";
                break;
            case 10:
                if (language.equalsIgnoreCase("zh")) {
                    singleScoreString = "胜其他";//000000000000000000000
                } else {
                    singleScoreString = "Win Other Score";//000000000000000000000
                }
                break;
            case 11:
                singleScoreString = "0-0";
                break;
            case 12:
                singleScoreString = "1-1";
                break;
            case 13:
                singleScoreString = "2-2";
                break;
            case 14:
                singleScoreString = "3-3";
                break;
            case 15:
                if (language.equalsIgnoreCase("zh")) {
                    singleScoreString = "平其他";//000000000000000000000
                } else {
                    singleScoreString = "Draw Other Score";//000000000000000000000
                }
                break;
            case 16:
                singleScoreString = "0-1";
                break;
            case 17:
                singleScoreString = "0-2";
                break;
            case 18:
                singleScoreString = "1-2";
                break;
            case 19:
                singleScoreString = "0-3";
                break;
            case 20:
                singleScoreString = "1-3";
                break;
            case 21:
                singleScoreString = "2-3";
                break;
            case 22:
                singleScoreString = "0-4";
                break;
            case 23:
                singleScoreString = "1-4";
                break;
            case 24:
                singleScoreString = "2-4";
                break;
            case 25:
                if (language.equalsIgnoreCase("zh")) {
                    singleScoreString = "负其他";//000000000000000000000
                } else {
                    singleScoreString = "Lose Other Score";//000000000000000000000
                }
                break;
            default:
                singleScoreString = "0-0";
                break;
        }
        return singleScoreString;
    }
}

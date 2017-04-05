package cls.pilottery.oms.lottery.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cls.pilottery.oms.common.utils.BeanFormart;
import com.alibaba.fastjson.annotation.JSONField;
import com.alibaba.fastjson.annotation.JSONType;

import static java.lang.System.out;


public class CenterSelectResModel implements Serializable {

    private static final long serialVersionUID = 4482166366082698607L;
    private String rspfn_ticket;
    private int gameCode;
    private String gameName;
    private int from_sale;
    private long startIssueNumber;
    private long lastIssueNumber; // uint64 结束期次
    private int issueCount; // uint32 总期数
    private long ticketAmount;// uint64 票面金额
    private int isTrain;// uint8 是否是培训票
    private int isCancel;// uint8 是否已退票:已退票(1)
    private int isWin;// uint8 是否中奖:未开奖(0) 未中奖(1) 中奖(2)
    private int isBigPrize; // uint8 是否是大奖
    private long amountBeforeTax;// uint64 中奖金额(税前)
    private long taxAmount; // uint64 税金
    private long amountAfterTax; // uint64 中奖金额(税后)
    private long sale_termCode; // uint64 售票终端编码
    private int sale_tellerCode; // uint32 售票销售员编码
    private long sale_time; // uint32 销售时间
    private int isPayed; // uint8 是否已兑奖:未兑奖(0) 已兑奖(1)
    private String pay_termCode;
    private String pay_tellerCode; // uint32 兑奖销售员编码
    private long pay_time;// 兑奖时间
    private String cancel_termCode; // uint64 退票终端编码
    private String cancel_tellerCode; // uint32 退票销售员编码
    private int cancel_time; // uint32 退票时间
    private String customName;// char[64] 彩民姓名
    private int cardType;// 件类型:身份证(1)护照(2)军官证(3)士兵证(4)回乡证(5)其他证件(9)
    private String cardCode; // char[18] 证件号码
    private int betStringLen;// uint16 投注字符串长度
    private String betString; // 投注字符串
    private String[] betStrings;// 投注字符串解析
    private int count;// 中奖奖等数目
    private String issue;// 期号
    private String periods;// 连续购买期数
    private String betingstr;// 投注行信息
    private List<GamePrize> prizes;
    private int bettinglinenumber;// 投注行数目
    private List<Betinfo> betlist;// 投注行信息列表
    private String tickAmount;// 投注票金额
    private Date pay_timeformat;
    private Date cancel_timeformat;
    private Date sale_timeformat;

    private String alanguage = "zh";//语言

    public String getAlanguage() {
        return alanguage;
    }

    public void setAlanguage(String alanguage) {
        this.alanguage = alanguage;
    }

    public Date getCancel_timeformat() {
        return cancel_timeformat;
    }

    public void setCancel_timeformat(Date cancel_timeformat) {
        this.cancel_timeformat = cancel_timeformat;
    }

    public String getRspfn_ticket() {
        return rspfn_ticket;
    }

    public void setRspfn_ticket(String rspfn_ticket) {
        this.rspfn_ticket = rspfn_ticket;
    }

    public int getGameCode() {
        return gameCode;
    }

    public void setGameCode(int gameCode) {
        this.gameCode = gameCode;
    }

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    public long getStartIssueNumber() {
        return startIssueNumber;
    }

    public void setStartIssueNumber(long startIssueNumber) {
        this.startIssueNumber = startIssueNumber;
    }

    public long getLastIssueNumber() {
        return lastIssueNumber;
    }

    public void setLastIssueNumber(long lastIssueNumber) {
        this.lastIssueNumber = lastIssueNumber;
    }

    public int getIssueCount() {
        return issueCount;
    }

    public void setIssueCount(int issueCount) {
        this.issueCount = issueCount;
    }

    public long getTicketAmount() {
        return ticketAmount;
    }

    public void setTicketAmount(long ticketAmount) {
        this.ticketAmount = ticketAmount;
    }

    public int getIsTrain() {
        return isTrain;
    }

    public void setIsTrain(int isTrain) {
        this.isTrain = isTrain;
    }

    public int getIsCancel() {
        return isCancel;
    }

    public void setIsCancel(int isCancel) {
        this.isCancel = isCancel;
    }

    public int getIsWin() {
        return isWin;
    }

    public void setIsWin(int isWin) {
        this.isWin = isWin;
    }

    public int getIsBigPrize() {
        return isBigPrize;
    }

    public void setIsBigPrize(int isBigPrize) {
        this.isBigPrize = isBigPrize;
    }

    public long getAmountBeforeTax() {
        return amountBeforeTax;
    }

    public void setAmountBeforeTax(long amountBeforeTax) {
        this.amountBeforeTax = amountBeforeTax;
    }

    public long getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(long taxAmount) {
        this.taxAmount = taxAmount;
    }

    public long getAmountAfterTax() {
        return amountAfterTax;
    }

    public void setAmountAfterTax(long amountAfterTax) {
        this.amountAfterTax = amountAfterTax;
    }

    public long getSale_termCode() {
        return sale_termCode;
    }

    public void setSale_termCode(long sale_termCode) {
        this.sale_termCode = sale_termCode;
    }

    public int getSale_tellerCode() {
        return sale_tellerCode;
    }

    public void setSale_tellerCode(int sale_tellerCode) {
        this.sale_tellerCode = sale_tellerCode;
    }

    public long getSale_time() {
        return sale_time;
    }

    public void setSale_time(long sale_time) {
        if (sale_time > 0) {
            this.sale_timeformat = new Date(sale_time * 1000L);
        }
        this.sale_time = sale_time;
    }

    public int getIsPayed() {
        return isPayed;
    }

    public void setIsPayed(int isPayed) {
        this.isPayed = isPayed;
    }

    public String getPay_termCode() {
        return pay_termCode;
    }

    public void setPay_termCode(String pay_termCode) {
        this.pay_termCode = pay_termCode;
    }

    public String getPay_tellerCode() {
        return pay_tellerCode;
    }

    public void setPay_tellerCode(String pay_tellerCode) {
        this.pay_tellerCode = pay_tellerCode;
    }

    public long getPay_time() {
        return pay_time;
    }

    public void setPay_time(long pay_time) {
        if (pay_time > 0) {
            this.pay_timeformat = new Date(pay_time * 1000L);
        }
        this.pay_time = pay_time;
    }

    public String getCancel_termCode() {
        return cancel_termCode;
    }

    public void setCancel_termCode(String cancel_termCode) {
        this.cancel_termCode = cancel_termCode;
    }

    public String getCancel_tellerCode() {
        return cancel_tellerCode;
    }

    public void setCancel_tellerCode(String cancel_tellerCode) {
        this.cancel_tellerCode = cancel_tellerCode;
    }

    public int getCancel_time() {
        return cancel_time;
    }

    public void setCancel_time(int cancel_time) {
        if (cancel_time > 0) {
            this.cancel_timeformat = new Date(cancel_time * 1000L);
        }
        this.cancel_time = cancel_time;
    }

    public String getCustomName() {
        return customName;
    }

    public void setCustomName(String customName) {
        this.customName = customName;
    }

    public int getCardType() {
        return cardType;
    }

    public void setCardType(int cardType) {
        this.cardType = cardType;
    }

    public String getCardCode() {
        return cardCode;
    }

    public void setCardCode(String cardCode) {
        this.cardCode = cardCode;
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

    /*
    * 14为足彩的游戏编码，这里需要根据游戏编码特殊处理
    * 并保证不改变界面展现，界面使用原电脑票展现界面
    * FBS|SCR|1C1|1|[161213007:5-6-16-17-21]|10000|2|0
    * */
    public void setBetString(String betString) {
        if (betString != "" && betString != null) {
            StringBuffer fbsBetingString = new StringBuffer("");

            String[] bets = betString.split("[|]");
            if (bets.length > 0) {
                for (int j = 0; j < bets.length; j++) {
                    if (j == 1) {
                        // issue = bets[j];z
                        if (this.getGameCode() != 14) {
                            this.setIssue(bets[j]);
                        } else {
                            fbsBetingString.append(bets[j]).append("&");
                            this.setIssue(String.valueOf(this.getStartIssueNumber()));
                            this.setPeriods(String.valueOf(this.getIssueCount()));
                        }
                    }
                    if (j == 2) {
                        // periods = bets[j];

                        if (this.getGameCode() != 14) {
                            this.setPeriods(bets[j]);
                        } else {
                            fbsBetingString.append(bets[j]).append("&");
                        }
                    }
                    if (j == 3) {
                        // tickAmount = bets[j];
                        if (this.getGameCode() != 14) {
                            this.setTickAmount(bets[j]);
                        }
                    }
                    if (j == 4) {
                        if (this.getGameCode() == 14) {
                            String newbet = changedBetString(bets[1], bets[j], getAlanguage());
                            fbsBetingString.append(newbet).append("&");
                        }
                    }
                    if (j == 5) {
                        // betingstr = bets[j];
                        if (this.getGameCode() != 14) {
                            this.setBetingstr(bets[j]);
                        } else {
                            this.setTickAmount(bets[j]);
                        }
                    }
                    if (j == 6) {
                        if (this.getGameCode() == 14) {
                            fbsBetingString.append(bets[j]).append("&");
                        }
                    }
                }
                this.setBetingstr(fbsBetingString.toString().endsWith("&") ?
                        fbsBetingString.toString().substring(0, fbsBetingString.toString().length() - 1) :
                        fbsBetingString.toString());
            }
        }
        this.betString = betString;
    }

    public String[] getBetStrings() {
        return betStrings;
    }

    public void setBetStrings(String[] betStrings) {
        this.betStrings = betStrings;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getIssue() {
        return issue;
    }

    public void setIssue(String issue) {
        this.issue = issue;
    }

    public String getPeriods() {
        return periods;
    }

    public void setPeriods(String periods) {
        this.periods = periods;
    }

    public String getBetingstr() {
        return betingstr;
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
                    if (this.getGameCode() == 14) {
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

    public List<GamePrize> getPrizes() {
        return prizes;
    }

    public void setPrizes(List<GamePrize> prizes) {
        this.prizes = prizes;
    }

    public int getBettinglinenumber() {
        return bettinglinenumber;
    }

    public void setBettinglinenumber(int bettinglinenumber) {
        this.bettinglinenumber = bettinglinenumber;
    }

    public List<Betinfo> getBetlist() {
        return betlist;
    }

    public void setBetlist(List<Betinfo> betlist) {
        this.betlist = betlist;
    }

    public String getTickAmount() {
        return tickAmount;
    }

    public void setTickAmount(String tickAmount) {
        this.tickAmount = tickAmount;
    }

    public Date getPay_timeformat() {
        return pay_timeformat;
    }

    public void setPay_timeformat(Date pay_timeformat) {
        this.pay_timeformat = pay_timeformat;
    }

    public Date getSale_timeformat() {
        return sale_timeformat;
    }

    public void setSale_timeformat(Date sale_timeformat) {
        this.sale_timeformat = sale_timeformat;
    }

    public int getFrom_sale() {
        return from_sale;
    }

    public void setFrom_sale(int from_sale) {
        this.from_sale = from_sale;
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


    public static void main(String args[]) {
        CenterSelectResModel ce = new CenterSelectResModel();
        String betString = "FBS|TOT|4C1|6|[161014001:1-2-3-4]+[161014002:1-2]+[161014003:2-3-4]+[161014004:2-3-4]+[161014005:2-3-4]+[161014006:7]|639000|1|0";
        String[] bets = betString.split("[|]");
        String area[] = bets[4].split("[+]");

        StringBuffer newBetStr = new StringBuffer("");
        for (int i = 0; i < area.length; i++) {
            String betRealAera[] = area[i].split("[:]");
            newBetStr.append(betRealAera[0]).append(":");//期次加上
            String betRealStr = betRealAera[1].substring(0, betRealAera[1].length() - 1);
            String betRealOption[] = betRealStr.split("[-]");
            for (int j = 0; j < betRealOption.length; j++) {
                //全场胜平负
                newBetStr.append(ce.getHfwinlevellosResultString(Integer.parseInt(betRealOption[j])));
                if (j != betRealOption.length - 1) {
                    newBetStr.append(";");
                }
            }
            if (i != area.length - 1) {
                newBetStr.append("]+");
            } else {
                newBetStr.append("]");
            }
        }
        String betAera[] = area[0].split("[:]");
        System.out.println("betAera=" + betAera[1]);
        out.println("betString=" + area.length);
        out.println("newBetStr=" + newBetStr);
    }

}

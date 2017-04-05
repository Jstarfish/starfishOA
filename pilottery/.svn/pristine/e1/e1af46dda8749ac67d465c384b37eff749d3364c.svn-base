package cls.pilottery.oms.lottery.form;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.common.utils.DateUtil;

import java.util.Date;

/**
 * Created by Reno Main on 2016/5/19.
 */
public class BadTicketForm extends BaseEntity {

    private static final long serialVersionUID = 1L;
    private String agencyCode;//站点编号
    private String startqueryTime;//段的开始时间
    private String endqueryTime;//查询时间段的结束时间
    private String defaultDatePattern = "yyyy-MM-dd HH:mm:ss";

    public String getAgencyCode() {
        return agencyCode;
    }

    public void setAgencyCode(String agencyCode) {
        this.agencyCode = agencyCode;
    }

    public String getStartqueryTime() {
        if(this.getEndqueryTime() != null && !("").equals(this.getEndqueryTime())){
            Date endDate = DateUtil.getFormatDate(this.getEndqueryTime(), defaultDatePattern);
            long startTime = endDate.getTime() - (3600 * 1000);
            this.startqueryTime = DateUtil.getDate(startTime, defaultDatePattern);
        }
        return startqueryTime;
    }

    public void setStartqueryTime(String startqueryTime) {
        this.startqueryTime = startqueryTime;
    }

    public String getEndqueryTime() {
       /* if (this.endqueryTime == null || ("").equals(this.endqueryTime)) {
            this.endqueryTime = DateUtil.getNowTime(defaultDatePattern);
        }*/
        return endqueryTime;
    }

    public void setEndqueryTime(String endqueryTime) {
        this.endqueryTime = endqueryTime;
    }

}

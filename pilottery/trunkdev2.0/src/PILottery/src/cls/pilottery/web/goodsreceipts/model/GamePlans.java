package cls.pilottery.web.goodsreceipts.model;

import java.io.Serializable;

/**
 * 
    * @ClassName: GamePlans
    * @Description: 方案基本信息
    * @author yuyuanhua
    * @date 2015年9月11日
    *
 */
public class GamePlans implements Serializable {
    
	    /**
	    * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	    */
	    
	private static final long serialVersionUID = 1L;

	private String planCode;

    private String fullName;

    private String shortName;

    private Short publisherCode;

    public String getPlanCode() {
        return planCode;
    }

    public void setPlanCode(String planCode) {
        this.planCode = planCode == null ? null : planCode.trim();
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName == null ? null : fullName.trim();
    }

    public String getShortName() {
        return shortName;
    }

    public void setShortName(String shortName) {
        this.shortName = shortName == null ? null : shortName.trim();
    }

    public Short getPublisherCode() {
        return publisherCode;
    }

    public void setPublisherCode(Short publisherCode) {
        this.publisherCode = publisherCode;
    }
}
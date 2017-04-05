package cls.pilottery.web.goodsreceipts.model;

import java.io.Serializable;
import java.util.Date;
/**
 * 
    * @ClassName: GameBatchImport
    * @Description: 游戏批次信息
    * @author yuyuanhua
    * @date 2015年9月12日
    *
 */

public class GameBatchImport implements Serializable{
    
	    /**
	    * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	    */
	    
	private static final long serialVersionUID = 6708968158486479852L;

	private String importNo;//数据导入序号（IMP-12345678）

    private String planCode;//方案编码

    private String batchNo;// 	生产批次

    private String packageFile;//包装信息文件

    private String rewardMapFile;//奖符构成表文件

    private String rewardDetailFile;//中奖明细文件

    private Date startDate;//导入开始时间

    private Date endDate;//导入完成时间

    private Short importAdmin;//导入人

    public String getImportNo() {
        return importNo;
    }

    public void setImportNo(String importNo) {
        this.importNo = importNo == null ? null : importNo.trim();
    }

    public String getPlanCode() {
        return planCode;
    }

    public void setPlanCode(String planCode) {
        this.planCode = planCode == null ? null : planCode.trim();
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo == null ? null : batchNo.trim();
    }

    public String getPackageFile() {
        return packageFile;
    }

    public void setPackageFile(String packageFile) {
        this.packageFile = packageFile == null ? null : packageFile.trim();
    }

    public String getRewardMapFile() {
        return rewardMapFile;
    }

    public void setRewardMapFile(String rewardMapFile) {
        this.rewardMapFile = rewardMapFile == null ? null : rewardMapFile.trim();
    }

    public String getRewardDetailFile() {
        return rewardDetailFile;
    }

    public void setRewardDetailFile(String rewardDetailFile) {
        this.rewardDetailFile = rewardDetailFile == null ? null : rewardDetailFile.trim();
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Short getImportAdmin() {
        return importAdmin;
    }

    public void setImportAdmin(Short importAdmin) {
        this.importAdmin = importAdmin;
    }
}
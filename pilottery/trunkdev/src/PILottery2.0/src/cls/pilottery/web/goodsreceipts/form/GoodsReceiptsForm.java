package cls.pilottery.web.goodsreceipts.form;

/**
 * 
 * @ClassName: GoodsReceiptsForm
 * @Description:入库查询Form
 * @author yuyuanhua
 * @date 2015年9月12日
 *
 */
public class GoodsReceiptsForm {
	
	private String sgrNo;//入库单编号
	private String sendDate;//入库日期
	private String houseCode;
	// 分页参数
	private Integer beginNum;
	private Integer endNum;
	public String getSgrNo() {
		return sgrNo;
	}
	public void setSgrNo(String sgrNo) {
		this.sgrNo = sgrNo;
	}
	public String getSendDate() {
		return sendDate;
	}
	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}
	public Integer getBeginNum() {
		return beginNum;
	}
	public void setBeginNum(Integer beginNum) {
		this.beginNum = beginNum;
	}
	public Integer getEndNum() {
		return endNum;
	}
	public void setEndNum(Integer endNum) {
		this.endNum = endNum;
	}
	public String getHouseCode() {
		return houseCode;
	}
	public void setHouseCode(String houseCode) {
		this.houseCode = houseCode;
	}
	
}

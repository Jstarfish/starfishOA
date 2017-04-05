package cls.pilottery.web.goodsIssues.form;

/**
 * 
 * @ClassName: GoodsIssuesForm
 * @Description: 出库查询表单
 * @author yuyuanhua
 * @date 2015年9月19日
 *
 */
public class GoodsIssuesForm {
	private String sgiNo1;// 出货单编号
	private String sendDate;// 出货时间
	String houseCode;
	private String orgCode;
	// 分页参数
	private Integer beginNum;
	private Integer endNum;



	public String getSgiNo1() {
		return sgiNo1;
	}

	public void setSgiNo1(String sgiNo1) {
		this.sgiNo1 = sgiNo1;
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

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

}

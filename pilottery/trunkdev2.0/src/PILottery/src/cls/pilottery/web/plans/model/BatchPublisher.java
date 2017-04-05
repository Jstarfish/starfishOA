package cls.pilottery.web.plans.model;

import java.io.Serializable;

/**
 * @ClassName BatchPublisher
 * @author Wangjinglong
 * @description
 * @date 2015/19/16
 * 
 * 
 */
public class BatchPublisher implements Serializable {

	private static final long serialVersionUID = 1L;

	private String planCode;// 方案代码

	private String planName;// 方案名称

	private String batchNo;// 生产批次

	private long ticketsNum;// 奖组数量

	private long ticketsAccount;// 奖组张数

	private long userId;// 用户名编码

	private int totalTrunk;// 总箱数

	private long totalPaper;// 总张数

	private short status;// 状态(在售,暂停,退市)

	private String statusen;

	// ------------
	private int errorCode;

	private String errorMessage;

	public BatchPublisher() {

	}

	public String getBatchNo() {

		return batchNo;
	}

	public int getErrorCode() {

		return errorCode;
	}

	public String getErrorMessage() {

		return errorMessage;
	}

	public String getPlanCode() {

		return planCode;
	}

	public String getPlanName() {

		return planName;
	}

	public short getStatus() {

		return status;
	}

	public String getStatusen() {

		return statusen;
	}

	public long getTicketsAccount() {

		return ticketsAccount;
	}

	public long getTicketsNum() {

		return ticketsNum;
	}

	public long getTotalPaper() {

		return totalPaper;
	}

	public int getTotalTrunk() {

		return totalTrunk;
	}

	public long getUserId() {

		return userId;
	}

	public void setBatchNo(String batchNo) {

		this.batchNo = batchNo;
	}

	public void setErrorCode(int errorCode) {

		this.errorCode = errorCode;
	}

	public void setErrorMessage(String errorMessage) {

		this.errorMessage = errorMessage;
	}

	public void setPlanCode(String planCode) {

		this.planCode = planCode;
	}

	public void setPlanName(String planName) {

		this.planName = planName;
	}

	public void setStatus(short status) {

		this.status = status;
	}

	public void setStatusen(String statusen) {

		this.statusen = statusen;
	}

	public void setTicketsAccount(long ticketsAccount) {

		this.ticketsAccount = ticketsAccount;
	}

	public void setTicketsNum(long ticketsNum) {

		this.ticketsNum = ticketsNum;
	}

	public void setTotalPaper(long totalPaper) {

		this.totalPaper = totalPaper;
	}

	public void setTotalTrunk(int totalTrunk) {

		this.totalTrunk = totalTrunk;
	}

	public void setUserId(long userId) {

		this.userId = userId;
	}
}

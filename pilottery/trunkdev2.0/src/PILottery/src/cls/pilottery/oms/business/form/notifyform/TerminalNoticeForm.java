package cls.pilottery.oms.business.form.notifyform;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.oms.business.model.notifymodel.TerminalNotice;

public class TerminalNoticeForm extends BaseEntity {

	private static final long serialVersionUID = 8284956243310085759L;

	private TerminalNotice terminalNotice;

	private String sendStartTime;

	private String sendEndTime;

	private String adminName;

	public TerminalNotice getTerminalNotice() {
		if (terminalNotice == null)
			terminalNotice = new TerminalNotice();
		return terminalNotice;
	}

	public String getSendStartTime() {
		return sendStartTime;
	}

	public void setSendStartTime(String sendStartTime) {
		this.sendStartTime = sendStartTime;
	}

	public String getSendEndTime() {
		return sendEndTime;
	}

	public void setSendEndTime(String sendEndTime) {
		this.sendEndTime = sendEndTime;
	}

	public String getAdminName() {
		return adminName;
	}

	public void setAdminName(String adminName) {
		this.adminName = adminName;
	}

}

package cls.pilottery.oms.business.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cls.pilottery.oms.business.form.notifyform.TerminalNoticeForm;
import cls.pilottery.oms.business.model.notifymodel.TerminalNotice;
import cls.pilottery.oms.business.model.notifymodel.TreeNode;
import cls.pilottery.oms.game.model.SystemParameter;

public interface NotifyService {

	List<TreeNode> getAgencys(String ids);

	List<TreeNode> getTerminals(String ids);

	List<TreeNode> getAreas(String areaCode);

	List<TerminalNotice> getNotices(TerminalNotice notice);

	Integer getNoticesCount(TerminalNotice notice);

	void updateNoticeStatus(TerminalNotice notice);

	void batchInsertNotice(ArrayList<TerminalNotice> notices);

	void sendNotice(TerminalNotice notice);

	Integer countNotifyList(TerminalNoticeForm terminalNoticeForm);

	List<TerminalNotice> queryNotifyList(TerminalNoticeForm terminalNoticeForm);

	Map<Long, String> getUser();

	Map<String, String> getNoticeById(String noticeId);

	void sendIMInfo(TerminalNotice notice);

	void updateTicketMessage(String ticketInfo);

	Integer getTicketInfoCount();

	String getTicketMessage();

	String getScrollingNotice1();

	String getScrollingNotice2();

	String getScrollingNotice3();

	void updateScrollingNotice(SystemParameter rollingNotice);

}

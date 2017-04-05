package cls.pilottery.oms.business.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import cls.pilottery.oms.business.form.notifyform.TerminalNoticeForm;
import cls.pilottery.oms.business.model.notifymodel.TerminalNotice;
import cls.pilottery.oms.business.model.notifymodel.TreeNode;

public interface NotifyDao {

	// 获取销售站
	List<TreeNode> getAgencys(@Param(value = "ids") String ids);

	// 获取区域
	List<TreeNode> getAreas(@Param(value = "areaCode") String areaCode);
	// List<TreeNode> getInstitutions(@Param(value = "institutionCode")String
	// institutionCode);

	List<TerminalNotice> getNotices(TerminalNotice notice);

	Integer getNoticesCount(TerminalNotice notice);

	void updateNoticeStatus(TerminalNotice notice);

	void batchInsertNotice(ArrayList<TerminalNotice> notices);

	void sendNotice(TerminalNotice notice);

	Integer countNotifyList(TerminalNoticeForm terminalNoticeForm);

	List<TerminalNotice> queryNotifyList(TerminalNoticeForm terminalNoticeForm);

	List<Map<String, String>> getUser();

	Map<String, String> getNoticeById(String noticeId);

	void sendIMInfo(TerminalNotice notice);

	void updateTicketMessage(String ticketInfo);

	Integer getTicketInfoCount();

	String getTicketMessage();

	// 获取终端机
	List<TreeNode> getTerminals(@Param(value = "ids") String ids);
}

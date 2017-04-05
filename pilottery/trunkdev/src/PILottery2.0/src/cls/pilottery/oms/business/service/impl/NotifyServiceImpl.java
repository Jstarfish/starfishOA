package cls.pilottery.oms.business.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.dao.NotifyDao;
import cls.pilottery.oms.business.form.notifyform.TerminalNoticeForm;
import cls.pilottery.oms.business.model.notifymodel.TerminalNotice;
import cls.pilottery.oms.business.model.notifymodel.TreeNode;
import cls.pilottery.oms.business.service.NotifyService;
@Service
public class NotifyServiceImpl implements NotifyService {

	@Autowired
	private NotifyDao notifyDao;
	
	

	@Override
	public List<TerminalNotice> getNotices(TerminalNotice notice) {
		return notifyDao.getNotices(notice);
	}

	@Override
	public Integer getNoticesCount(TerminalNotice notice) {
		return notifyDao.getNoticesCount(notice);
	}

	@Override
	public void updateNoticeStatus(TerminalNotice notice) {
		notifyDao.updateNoticeStatus(notice);		
	}

	@Override
	public void batchInsertNotice(ArrayList<TerminalNotice> notices) {
		notifyDao.batchInsertNotice(notices);			
	}

	@Override
	public List<TreeNode> getAgencys(String ids) {
		return notifyDao.getAgencys(ids);
	}

	@Override
	public void sendNotice(TerminalNotice notice) {
		notifyDao.sendNotice(notice);
	}

	@Override
	public Integer countNotifyList(TerminalNoticeForm terminalNoticeForm) {
		return notifyDao.countNotifyList(terminalNoticeForm);
	}

	@Override
	public List<TerminalNotice> queryNotifyList(TerminalNoticeForm terminalNoticeForm) {
		
		return notifyDao.queryNotifyList(terminalNoticeForm);
	}

	@Override
	public Map<Long, String> getUser() {
		Map<Long,String> map = new HashMap<Long, String>();
		List<Map<String, String>> userList = new ArrayList<Map<String, String>>();
		userList = notifyDao.getUser();
		if (userList!=null && userList.size()>0) {
			for (Map<String,String> user : userList) {
				map.put(Long.valueOf(String.valueOf(user.get("ID"))), String.valueOf(user.get("NAME")));
			}
		}
		return map;
	}

	@Override
	public Map<String, String> getNoticeById(String noticeId) {
		return notifyDao.getNoticeById(noticeId);
	}

	@Override
	public void sendIMInfo(TerminalNotice notice) {
		notifyDao.sendIMInfo(notice);
		
	}

	@Override
	public void updateTicketMessage(String ticketInfo) {
		notifyDao.updateTicketMessage(ticketInfo);
		
	}

	@Override
	public Integer getTicketInfoCount() {
		return notifyDao.getTicketInfoCount();
	}

	@Override
	public String getTicketMessage() {
		return notifyDao.getTicketMessage();
	}

	@Override
	public List<TreeNode> getTerminals(String ids) {
		return notifyDao.getTerminals(ids);
	}


	@Override
	public List<TreeNode> getAreas(String areaCode) {
		return notifyDao.getAreas(areaCode);
	}
}

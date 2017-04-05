package cls.pilottery.webncp.system.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.webncp.system.model.Response4001Record;
import cls.pilottery.webncp.system.model.Response4002Record;
import cls.pilottery.webncp.system.model.Response4003Record;
import cls.pilottery.webncp.system.model.Response4004Model;
import cls.pilottery.webncp.system.model.Response4005Record;
import cls.pilottery.webncp.system.model.Response4090Model;
import cls.pilottery.webncp.system.model.Response4101Record;
import cls.pilottery.webncp.system.model.Response4102Record;
import cls.pilottery.webncp.system.model.Response4103Model;
import cls.pilottery.webncp.system.model.Response4104Model;
import cls.pilottery.webncp.system.vo.Response4001Vo;
import cls.pilottery.webncp.system.vo.Response4002Vo;

public interface MessageServiceDao {

	public Integer getIssueCount4001(Map<String, Object> map);

	public String getDefaultIssue4001(String gameCode);

	public List<Response4001Vo> getDrawInfo4001(Map<String, Object> map);

	public List<Response4001Record> getPrizeLevelInfo4001(Map<String, Object> map);

	public Integer getIssueCount4002(Map<String, Object> map);

	public String getDefaultIssue4002(Map<String, Object> map);

	public List<Response4002Vo> getDrawInfo4002(Map<String, Object> map);

	public List<Response4002Record> getPrizeLevelInfo4002(Map<String, Object> map);

	public String getAreaCode4003(String agencyCode);

	public List<Response4003Record> getNoticeList4003(Map<String, Object> map);

	public Response4004Model getNotice4004(String notCode);

	public Integer getIssueCount4005(Map<String, Object> map);

	public List<Response4005Record> getDrawNumber4005(Map<String, Object> map);

	public String getNewNoticeId4009(String agencyCode);
	
	String getOrgCodeByAgency(String agencyCode);

	public int getNoticeList4003Count(Map<String, Object> map);

	public Response4090Model getLastDrawInfo4090(Map<String, Object> map);

	public List<Response4001Vo> getLastDrawInfo4091(Map<String, Object> map);

	public List<Response4101Record> getOutletDealFlow(Map<String, Object> map);

	public List<Response4102Record> getSaleFlowDetail(String dealNo);

	public List<Response4102Record> getPayoutFlowDetail(String dealNo);

	public List<Response4102Record> getCancelFlowDetail(String dealNo);

	public Response4103Model getPayoutResult(String paySqlNo);

	public Response4104Model getCurrentIssueInfo(Integer gameCode);
}

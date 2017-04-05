package cls.pilottery.web.monitor.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.monitor.form.MonitorForm;
import cls.pilottery.web.monitor.model.AreasInfo;
import cls.pilottery.web.monitor.model.OrgSalesDrillDownModel;
import cls.pilottery.web.monitor.model.OrgSalesModel;
import cls.pilottery.web.monitor.model.RankingModel;
import cls.pilottery.web.monitor.model.SalesLineModel;
import cls.pilottery.web.monitor.model.SummaryStatisticsModel;

public interface MonitorService {

	Map<String, List<Long>> getHoursSaleForSummary(String institutionCode);

	List<SummaryStatisticsModel> getSalePerByGames(String institutionCode);

	List<SummaryStatisticsModel> getSalePerByInstitution();

	List<SummaryStatisticsModel> getRankingByInstitution(String institutionCode);

	// sales statistics by year
	Map<String, List<Long>> getHoursSalesTrend(String institutionCode, String planCode);

	Map<String, Object> getSalePerByYear(String year, String insCode);

	/* Institution Sales */
	public List<OrgSalesModel> getDataForOrgSales(Map<String, Object> map);

	public List<OrgSalesDrillDownModel> getDataForOrgSalesDrillDown(Map<String, Object> map);

	int getOutletRankingCount(MonitorForm form);

	List<RankingModel> getOutletRankingList(MonitorForm form);

	List<AreasInfo> getAreasInfo(String institutionCode);

	Map<String, List<Long>> getHoursSaleForSummaryTotal(String institutionCode);

}

package cls.pilottery.web.monitor.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.monitor.form.MonitorForm;
import cls.pilottery.web.monitor.form.YearMonthForm;
import cls.pilottery.web.monitor.model.AreasInfo;
import cls.pilottery.web.monitor.model.OrgSalesDrillDownModel;
import cls.pilottery.web.monitor.model.OrgSalesModel;
import cls.pilottery.web.monitor.model.RankingModel;
import cls.pilottery.web.monitor.model.SalesLineModel;
import cls.pilottery.web.monitor.model.SalesStatisticsDayModel;
import cls.pilottery.web.monitor.model.SalesStatisticsYearModel;
import cls.pilottery.web.monitor.model.SummaryStatisticsModel;

public interface MonitorDao {

	List<Long> getHoursSaleForSummary(Map<String, Object> map);

	List<SummaryStatisticsModel> getRankingByInstitution(Map<String, Object> map);

	List<SummaryStatisticsModel> getSalePerByGames(Map<String, Object> map);

	List<SummaryStatisticsModel> getSalePerByInstitution(int hour);

	// Map<String, List<Long>> getHoursSalesTrend(String institutionCode, String planCode);

	List<Long> getHoursSalesTrend(Map<String, Object> map);

	List<SalesStatisticsYearModel> getMonthcategories(YearMonthForm form);

	List<SalesStatisticsDayModel> getDayofAmount(YearMonthForm form);

	/* Institution Sales */
	public List<OrgSalesModel> getDataForOrgSales(Map<String, Object> map);

	public List<OrgSalesDrillDownModel> getDataForOrgSalesDrillDown(Map<String, Object> map);

	int getOutletRankingCount(MonitorForm form);

	List<RankingModel> getOutletRankingList(MonitorForm form);

	List<AreasInfo> getAreasInfo(String orgCode);

	List<Long> getHoursSaleForSummaryTotal(Map<String, Object> map);
}

package cls.pilottery.web.monitor.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.monitor.dao.MonitorDao;
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
import cls.pilottery.web.monitor.service.MonitorService;

@Service
public class MonitorServiceImpl implements MonitorService {

	@Autowired
	private MonitorDao monitorDao;

	@Override
	public Map<String, List<Long>> getHoursSaleForSummaryTotal(String institutionCode) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cld = Calendar.getInstance();
		int hour = cld.get(Calendar.HOUR_OF_DAY);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orgCode", institutionCode);
		map.put("date", sdf.format(cld.getTime()));
		map.put("hour", hour);
		List<Long> today = monitorDao.getHoursSaleForSummaryTotal(map);

		cld.add(Calendar.DATE, -1);
		map.put("date", sdf.format(cld.getTime()));
		map.remove("hour");
		List<Long> yestoday = monitorDao.getHoursSaleForSummaryTotal(map);
		cld.add(Calendar.DATE, -6);
		map.put("date", sdf.format(cld.getTime()));
		List<Long> dayOfLastWeek = monitorDao.getHoursSaleForSummaryTotal(map);
		Map<String, List<Long>> result = new HashMap<String, List<Long>>();
		result.put("today", today);
		result.put("yestoday", yestoday);
		result.put("dayOfLastWeek", dayOfLastWeek);
		return result;
	}

	@Override
	public List<SummaryStatisticsModel> getRankingByInstitution(String institutionCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orgCode", institutionCode);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cld = Calendar.getInstance();
		int hour = cld.get(Calendar.HOUR_OF_DAY);
		map.put("hour", hour);
		map.put("queryDate", sdf.format(cld.getTime()));
		return monitorDao.getRankingByInstitution(map);
	}

	@Override
	public List<SummaryStatisticsModel> getSalePerByGames(String institutionCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orgCode", institutionCode);
		Calendar cld = Calendar.getInstance();
		int hour = cld.get(Calendar.HOUR_OF_DAY);
		map.put("hour", hour);
		List<SummaryStatisticsModel> list = monitorDao.getSalePerByGames(map);
		return list;
	}

	@Override
	public List<SummaryStatisticsModel> getSalePerByInstitution() {
		Calendar cld = Calendar.getInstance();
		int hour = cld.get(Calendar.HOUR_OF_DAY);
		return monitorDao.getSalePerByInstitution(hour);
	}

	@Override
	public Map<String, List<Long>> getHoursSalesTrend(String institutionCode, String planCode) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calendar = Calendar.getInstance();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orgCode", institutionCode);
		map.put("date", dateFormat.format(calendar.getTime()));
		map.put("planCode", planCode);
		int hour = calendar.get(Calendar.HOUR_OF_DAY);
		map.put("hour", hour);
		List<Long> today = monitorDao.getHoursSalesTrend(map);
		map.remove("hour");
		calendar.add(Calendar.DATE, -1);
		map.put("date", dateFormat.format(calendar.getTime()));
		map.put("planCode", planCode);
		List<Long> yestoday = monitorDao.getHoursSalesTrend(map);
		calendar.add(Calendar.DATE, -6);
		map.put("date", dateFormat.format(calendar.getTime()));
		map.put("planCode", planCode);
		List<Long> dayOfLastWeek = monitorDao.getHoursSalesTrend(map);
		Map<String, List<Long>> result = new HashMap<String, List<Long>>();
		result.put("today", today);
		result.put("yestoday", yestoday);
		result.put("dayOfLastWeek", dayOfLastWeek);
		return result;
	}

	@Override
	public Map<String, Object> getSalePerByYear(String year, String insCode) {
		Map<String, Object> resultList = new HashMap<String, Object>();
		List<List<String>> dayName = new ArrayList<List<String>>();// 天的名称集合
		List<List<Long>> dayAmount = new ArrayList<List<Long>>();// 天的销售集合
		// 获取每月的数据
		List<SalesStatisticsYearModel> monthData = monitorDao.getMonthcategories(new YearMonthForm(year, insCode));
		List<String> monthName = new ArrayList<String>();// 月的名称集合
		List<Map<String, Long>> monthAmount = new ArrayList<Map<String, Long>>();// 月的销售集合
		for (SalesStatisticsYearModel month : monthData) {
			month.setMonth(month.getMonth().substring(month.getMonth().indexOf("-") + 1));
			monthName.add(month.getMonth());
			Map<String, Long> item = new HashMap<String, Long>();
			item.put("y", month.getAmount());
			monthAmount.add(item);
			// 获取当月下每日的数据
			List<SalesStatisticsDayModel> dayData = monitorDao.getDayofAmount(new YearMonthForm(year, month.getMonth(), insCode));
			List<String> name = new ArrayList<String>();
			List<Long> amount = new ArrayList<Long>();
			for (SalesStatisticsDayModel day : dayData) {
				name.add(day.getDay());
				amount.add(day.getAmount());
			}
			dayName.add(name);
			dayAmount.add(amount);
		}
		for (String month : monthName) {
			month = String.valueOf(Integer.valueOf(month) + 1);
		}
		resultList.put("monthName", monthName);
		resultList.put("monthAmount", monthAmount);
		resultList.put("dayName", dayName);
		resultList.put("dayAmount", dayAmount);
		return resultList;
	}

	/* Institution Sales */
	@Override
	public List<OrgSalesModel> getDataForOrgSales(Map<String, Object> map) {
		return this.monitorDao.getDataForOrgSales(map);
	}

	@Override
	public List<OrgSalesDrillDownModel> getDataForOrgSalesDrillDown(Map<String, Object> map) {
		return this.monitorDao.getDataForOrgSalesDrillDown(map);
	}

	@Override
	public int getOutletRankingCount(MonitorForm form) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		form.setQueryDate(sdf.format(new Date()));
		return monitorDao.getOutletRankingCount(form);
	}

	@Override
	public List<RankingModel> getOutletRankingList(MonitorForm form) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		form.setQueryDate(sdf.format(new Date()));
		return monitorDao.getOutletRankingList(form);
	}

	@Override
	public List<AreasInfo> getAreasInfo(String orgCode) {
		return monitorDao.getAreasInfo(orgCode);
	}

	@Override
	public Map<String, List<Long>> getHoursSaleForSummary(String institutionCode) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cld = Calendar.getInstance();
		int hour = cld.get(Calendar.HOUR_OF_DAY);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orgCode", institutionCode);
		map.put("date", sdf.format(cld.getTime()));
		map.put("hour", hour);
		List<Long> today = monitorDao.getHoursSaleForSummary(map);
		map.remove("hour");

		cld.add(Calendar.DATE, -1);
		map.put("date", sdf.format(cld.getTime()));
		map.remove("hour");
		List<Long> yestoday = monitorDao.getHoursSaleForSummary(map);
		Map<String, List<Long>> result = new HashMap<String, List<Long>>();
		result.put("today", today);
		result.put("yestoday", yestoday);
		return result;
	}
}

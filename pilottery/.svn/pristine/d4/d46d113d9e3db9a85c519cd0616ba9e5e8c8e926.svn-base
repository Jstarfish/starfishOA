package cls.pilottery.web.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.report.dao.AnalysisStatisticsDao;
import cls.pilottery.web.report.form.AnalysisStatisticsForm;
import cls.pilottery.web.report.model.OutletInfoVO;
import cls.pilottery.web.report.service.AnalysisStatisticsService;

@Service
public class AnalysisStatisticsServiceImpl implements AnalysisStatisticsService {
	@Autowired
	private AnalysisStatisticsDao analysisStatisticsDao;
	
	@Override
	public List<OutletInfoVO> getAgencyInfoList(AnalysisStatisticsForm form) {
		return analysisStatisticsDao.getAgencyInfoList(form);
	}

}

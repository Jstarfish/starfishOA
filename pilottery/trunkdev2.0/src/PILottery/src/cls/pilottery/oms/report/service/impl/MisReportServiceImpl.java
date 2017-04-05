package cls.pilottery.oms.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.report.dao.MisReportDao;
import cls.pilottery.oms.report.form.MisReportForm;
import cls.pilottery.oms.report.model.GameInfo;
import cls.pilottery.oms.report.model.MisReport3132;
import cls.pilottery.oms.report.model.MisReport3133;
import cls.pilottery.oms.report.model.MisReport3134;
import cls.pilottery.oms.report.model.MisReport3135;
import cls.pilottery.oms.report.model.MisReport3136;
import cls.pilottery.oms.report.service.MisReportService;

@Service
public class MisReportServiceImpl implements MisReportService {
	@Autowired
	private MisReportDao misReportDao;

	@Override
	public List<MisReport3132> getMisReport3132List(MisReportForm form) {
		return misReportDao.getMisReport3132List(form);
	}

	@Override
	public MisReport3132 getMisReport3132Sum(MisReportForm form) {
		return misReportDao.getMisReport3132Sum(form);
	}

	@Override
	public List<MisReport3133> getMisReport3133List(MisReportForm form) {
		return misReportDao.getMisReport3133List(form);
	}

	@Override
	public MisReport3133 getMisReport3133Sum(MisReportForm form) {
		return misReportDao.getMisReport3133Sum(form);
	}

	@Override
	public List<MisReport3134> getMisReport3134List(MisReportForm form) {
		return misReportDao.getMisReport3134List(form);
	}

	@Override
	public MisReport3134 getMisReport3134Sum(MisReportForm form) {
		return misReportDao.getMisReport3134Sum(form);
	}

	@Override
	public List<MisReport3135> getMisReport3135List(MisReportForm form) {
		return misReportDao.getMisReport3135List(form);
	}

	@Override
	public MisReport3135 getMisReport3135Sum(MisReportForm form) {
		return misReportDao.getMisReport3135Sum(form);
	}

	@Override
	public MisReport3136 getMisReport3136Sum(MisReportForm form) {
		return misReportDao.getMisReport3136Sum(form);
	}

	@Override
	public List<GameInfo> getReportGames() {
		return misReportDao.getReportGames();
	}

}

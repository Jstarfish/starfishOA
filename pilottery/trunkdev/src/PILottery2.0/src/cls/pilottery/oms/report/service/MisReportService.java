package cls.pilottery.oms.report.service;

import java.util.List;

import cls.pilottery.oms.report.form.MisReportForm;
import cls.pilottery.oms.report.model.GameInfo;
import cls.pilottery.oms.report.model.MisReport3132;
import cls.pilottery.oms.report.model.MisReport3133;
import cls.pilottery.oms.report.model.MisReport3134;
import cls.pilottery.oms.report.model.MisReport3135;
import cls.pilottery.oms.report.model.MisReport3136;

public interface MisReportService {

	List<GameInfo> getReportGames();

	List<MisReport3132> getMisReport3132List(MisReportForm newReportForm);

	MisReport3132 getMisReport3132Sum(MisReportForm newReportForm);

	List<MisReport3133> getMisReport3133List(MisReportForm newReportForm);

	MisReport3133 getMisReport3133Sum(MisReportForm newReportForm);

	List<MisReport3134> getMisReport3134List(MisReportForm newReportForm);

	MisReport3134 getMisReport3134Sum(MisReportForm newReportForm);

	List<MisReport3135> getMisReport3135List(MisReportForm newReportForm);

	MisReport3135 getMisReport3135Sum(MisReportForm newReportForm);

	MisReport3136 getMisReport3136Sum(MisReportForm newReportForm);

}

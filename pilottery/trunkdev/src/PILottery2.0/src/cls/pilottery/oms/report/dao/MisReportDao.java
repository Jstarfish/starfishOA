package cls.pilottery.oms.report.dao;

import java.util.List;

import cls.pilottery.oms.report.form.MisReportForm;
import cls.pilottery.oms.report.model.GameInfo;
import cls.pilottery.oms.report.model.MisReport3132;
import cls.pilottery.oms.report.model.MisReport3133;
import cls.pilottery.oms.report.model.MisReport3134;
import cls.pilottery.oms.report.model.MisReport3135;
import cls.pilottery.oms.report.model.MisReport3136;

public interface MisReportDao {

	List<MisReport3132> getMisReport3132List(MisReportForm form);

	MisReport3132 getMisReport3132Sum(MisReportForm form);

	List<MisReport3133> getMisReport3133List(MisReportForm form);

	MisReport3133 getMisReport3133Sum(MisReportForm form);

	List<MisReport3134> getMisReport3134List(MisReportForm form);

	MisReport3134 getMisReport3134Sum(MisReportForm form);

	List<MisReport3135> getMisReport3135List(MisReportForm form);

	MisReport3135 getMisReport3135Sum(MisReportForm form);

	MisReport3136 getMisReport3136Sum(MisReportForm form);

	List<GameInfo> getReportGames();

}

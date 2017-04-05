package cls.pilottery.oms.business.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import cls.pilottery.oms.business.form.tmversionform.TerminalSoftWareForm;
import cls.pilottery.oms.business.model.tmversionmodel.Software;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwareVersion;
import cls.pilottery.oms.business.model.tmversionmodel.TerminalSoftWare;

public interface TerminalSoftwareDao {

	List<Software> getSoftwares();

	Software getSoftware(@Param(value = "id") int id);

	List<SoftwareVersion> getSoftVersions(@Param(value = "id") int id);

	SoftwareVersion getSoftVersion(@Param(value = "id") int id,
			@Param(value = "version") String version);

	void intsertSoftVer(SoftwareVersion ver);

	void updateSoftVer(SoftwareVersion ver);

	void deleteSoftVer(SoftwareVersion ver);

	Integer countTerminalSoftware(TerminalSoftWareForm terminalSoftWareForm);

	List<TerminalSoftWare> getTerminalSoftWareQuery(
			TerminalSoftWareForm terminalSoftWareForm);

}

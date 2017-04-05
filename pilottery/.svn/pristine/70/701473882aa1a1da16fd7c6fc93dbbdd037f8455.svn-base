package cls.pilottery.web.capital.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import cls.pilottery.web.capital.form.CapitalRecordForm;
import cls.pilottery.web.capital.model.CapitalRecord;
import cls.pilottery.web.capital.model.InstitutionCommDetailVO;

public interface CapitalRecordService {

	Integer getCapitalRecordCount(CapitalRecordForm form);

	List<CapitalRecord> getCapitalRecordList(CapitalRecordForm form);

	List<InstitutionCommDetailVO> getCapitalRecordDetail(String flowNo);

	InstitutionCommDetailVO getCapitalRecordDetailSum(String flowNo);

	Map<Integer, String> getTransFlowList(String institutionCode, HttpServletRequest request);

}

package cls.pilottery.oms.monitor.service;

import java.util.List;

import cls.pilottery.oms.monitor.form.UploadTraceForm;
import cls.pilottery.oms.monitor.model.UploadTrace;

public interface UploadTraceService {

	public Integer getTraceCount(UploadTraceForm form);

	public List<UploadTrace> getTraceList(UploadTraceForm form);

	public void saveTrace(UploadTraceForm uploadTraceForm);

}

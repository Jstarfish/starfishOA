package cls.pilottery.oms.monitor.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.UploadTraceDao;
import cls.pilottery.oms.monitor.form.UploadTraceForm;
import cls.pilottery.oms.monitor.model.UploadTrace;
import cls.pilottery.oms.monitor.service.UploadTraceService;

@Service
public class UploadTraceServiceImpl implements UploadTraceService {
	
	@Autowired
	private UploadTraceDao uploadTraceDao;
	
	@Override
	public Integer getTraceCount(UploadTraceForm form) {
		return uploadTraceDao.getTraceCount(form);
	}

	@Override
	public List<UploadTrace> getTraceList(UploadTraceForm form) {
		return uploadTraceDao.getTraceList(form);
	}

	@Override
	public void saveTrace(UploadTraceForm uploadTraceForm) {
		uploadTraceDao.saveTrace(uploadTraceForm);
	}
}

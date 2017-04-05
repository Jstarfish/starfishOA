package cls.pilottery.oms.monitor.service;

import java.util.List;

import cls.pilottery.oms.monitor.form.OperateLogForm;
import cls.pilottery.oms.monitor.form.OperateTypeForm;
import cls.pilottery.oms.monitor.model.OperateLog;
import cls.pilottery.oms.monitor.model.OperateType;

public interface OperateLogService {

	Integer getOperateLogCount(OperateLogForm form);

	List<OperateLog> getOperateLogList(OperateLogForm form);

	Integer getOperateTypeCount(OperateTypeForm form);

	List<OperateType> getOperateTypeList(OperateTypeForm form);

	OperateType getOperateTypeInfo(String operModeId);

	void updateOperateType(OperateType operateType);

	List<OperateType> getAllOperateType();

	// 公共方法，某些操作后插入日志信息
	void insertOperateLog(OperateLog operateLog);

	String getOperateContent(String operNo);

	String getThreshold(int typeCode);

}

package cls.pilottery.web.system.service;

import java.util.List;

import cls.pilottery.web.system.form.SysParameterForm;
import cls.pilottery.web.system.model.SysParameter;

public interface SysParameterService {

	int getSysParameterCount(SysParameterForm form);

	List<SysParameter> getParameterList(SysParameterForm form);

	SysParameter getParameterDetail(String id);

	void updateSysParameter(SysParameter sysParameter);

}

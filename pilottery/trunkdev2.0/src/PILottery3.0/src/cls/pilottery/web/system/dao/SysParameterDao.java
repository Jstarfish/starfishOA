package cls.pilottery.web.system.dao;

import java.util.List;

import cls.pilottery.web.system.form.SysParameterForm;
import cls.pilottery.web.system.model.SysParameter;

public interface SysParameterDao {

	int getSysParameterCount(SysParameterForm form);

	List<SysParameter> getParameterList(SysParameterForm form);

	SysParameter getParameterDeatil(String id);

	void updateSysParameter(SysParameter sysParameter);
}

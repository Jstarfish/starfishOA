package cls.pilottery.web.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.system.dao.SysParameterDao;
import cls.pilottery.web.system.form.SysParameterForm;
import cls.pilottery.web.system.model.SysParameter;
import cls.pilottery.web.system.service.SysParameterService;
@Service
public class SysParameterImpl implements SysParameterService {

	@Autowired
	private SysParameterDao sysParameterDao;
	
	@Override
	public int getSysParameterCount(SysParameterForm form) {
		return sysParameterDao.getSysParameterCount(form);
	}

	@Override
	public List<SysParameter> getParameterList(SysParameterForm form) {
		return sysParameterDao.getParameterList(form);
	}

	@Override
	public SysParameter getParameterDetail(String id) {
		return sysParameterDao.getParameterDeatil(id);
	}

	@Override
	public void updateSysParameter(SysParameter sysParameter) {
		sysParameterDao.updateSysParameter(sysParameter);
		
	}

}

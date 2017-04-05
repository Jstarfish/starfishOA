package cls.pilottery.oms.business.service;

import java.util.List;

import cls.pilottery.oms.business.form.OMSAreaAuthForm;
import cls.pilottery.oms.business.form.OMSAreaQueryForm;
import cls.pilottery.oms.business.model.areamodel.OMSArea;
import cls.pilottery.oms.business.model.areamodel.OMSAreaAuth;

public interface OMSAreaService {

	public Integer countAreaList(OMSAreaQueryForm form);
	public List<OMSArea> queryAreaList(OMSAreaQueryForm form);
	
	public Integer getAgencyCountInArea(String areaCode);
	public Integer getTerminalCountInArea(String areaCode);
	public Integer getTellerCountInArea(String areaCode);
	
	public List<OMSAreaAuth> selectGameFromAreaAuth(String areaCode);
	public void updateGameAuth(OMSAreaAuthForm omsAreaAuthForm) throws Exception;
	
	public List<OMSArea> getInfOrgsList();
}

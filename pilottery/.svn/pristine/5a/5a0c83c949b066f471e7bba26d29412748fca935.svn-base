package cls.pilottery.webncp.system.dao.oms;

import java.util.List;

import cls.pilottery.webncp.system.model.Request3001Model;
import cls.pilottery.webncp.system.model.Request3002Model;
import cls.pilottery.webncp.system.model.Request3003Model;
import cls.pilottery.webncp.system.model.Request3007Model;
import cls.pilottery.webncp.system.model.Request3008Model;
import cls.pilottery.webncp.system.model.Request3009Model;
import cls.pilottery.webncp.system.model.Response3001Record;
import cls.pilottery.webncp.system.model.Response3002Record;
import cls.pilottery.webncp.system.model.Response3003Model;
import cls.pilottery.webncp.system.model.Response3005Model;
import cls.pilottery.webncp.system.model.Response3007Model;
import cls.pilottery.webncp.system.model.Response3008Model;
import cls.pilottery.webncp.system.model.Response3009Model;
import cls.pilottery.webncp.system.vo.RequestParamt3005;

public interface DataReportDao {

	String getMaxDate(Request3001Model req);

	List<Response3001Record> getSaleReportByDate(Request3001Model req);

	List<Response3002Record> getSaleReport(Request3002Model req);

	String get3003MaxDate(Request3003Model req);

	Response3003Model get3003Report(Request3003Model req);

	Response3005Model get3005Report(RequestParamt3005 req);
	
	Response3007Model get3007Report(Request3007Model req);

	Response3008Model get3008Report(Request3008Model req);

	Response3009Model get3009Report(Request3009Model req);

}

package cls.pilottery.common.export.intf;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface IExportReport {
	/**
	 * 功能描述:定义字体类型<br>
	 * 创建时间:2014-07-22
	 * @author yyh
	 *
	 */
	public enum ReportType {
		JPG, PDF, Excel, Word
	}

	/**
	 * 功能描述:根据data创建报表
	 * @param HttpServletRequest request 
	 * @param HttpServletResponse response
	 * @param Map data
	 * @throws Exception 
	 */
	public void createReport(HttpServletRequest request,HttpServletResponse response,Map<?,?> reportInfo) throws Exception;
}

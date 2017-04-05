package cls.pilottery.common.export.factory;

import cls.pilottery.common.export.impl.ExportReportForExcel;
import cls.pilottery.common.export.impl.ExportReportForJPG;
import cls.pilottery.common.export.impl.ExportReportForPDF;
import cls.pilottery.common.export.intf.IExportReport;
import cls.pilottery.common.export.intf.IExportReport.ReportType;

/**
 * Function 实例化对象的报表对象
 * CreateTime 2014年7月22日
 * @author yyh
 * @version 1.1.0
 */
public class ExportReportFactory {
	private static IExportReport exportReport;
	private ExportReportFactory(){}

	/**
	 * Function 根据报表类型实例化报表对象
	 * CreateTime 2011年7月8日
	 * @param reportType 报表类型(enum)
	 * @return IExportReport 报表实例
	 */
	public static IExportReport newInstance(ReportType reportType) {
		switch (reportType) {
		    case Excel:
		    	exportReport=new ExportReportForExcel();
		    		break;
		    case PDF:
		    	exportReport=new ExportReportForPDF();
		    		break;
		    case JPG:
		    	exportReport=new ExportReportForJPG();
		    		break;	
		}
		return exportReport;
	}
}

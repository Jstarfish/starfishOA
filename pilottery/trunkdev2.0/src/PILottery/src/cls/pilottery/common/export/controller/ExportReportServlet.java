package cls.pilottery.common.export.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cls.pilottery.common.export.factory.ExportReportFactory;
import cls.pilottery.common.export.intf.IExportReport;
import cls.pilottery.common.export.intf.IExportReport.ReportType;

public class ExportReportServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	private String encoding="UTF-8";
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding(encoding);
		response.setCharacterEncoding(encoding);
		//获取报表相关数据
		Map<String, Object> mapInfo = getReportInfo(request);
		// 生成Excel报表
		if (mapInfo.get("type").equals("excel")) {
			try{
				IExportReport exportReport =ExportReportFactory.newInstance(ReportType.Excel);
				exportReport.createReport(request, response, mapInfo);
			}catch(Exception e){
				e.printStackTrace();
			}
		} else if(mapInfo.get("type").equals("pdf") || mapInfo.get("type").equals("pdfInfo")){
			//生成PDF报表
			try {
				IExportReport exportReport =ExportReportFactory.newInstance(ReportType.PDF);
				exportReport.createReport(request, response, mapInfo);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(mapInfo.get("type").equals("word")){
			//生成WORD报表
			try {
				IExportReport exportReport =ExportReportFactory.newInstance(ReportType.Word);
				exportReport.createReport(request, response, mapInfo);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(mapInfo.get("type").equals("word")){
			//生成WORD报表
			try {
				IExportReport exportReport =ExportReportFactory.newInstance(ReportType.Word);
				exportReport.createReport(request, response, mapInfo);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else {
			//生成jpg图片
			try {
				IExportReport exportReport =ExportReportFactory.newInstance(ReportType.JPG);
				exportReport.createReport(request, response, mapInfo);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * Function：获取生产报表的相关信息
	 * @author chenck
	 * CreateTime 2011年7月2日
	 * 
	 * @param HttpServletRequest request
	 * 
	 * @return Map<String, Object> 
	 */
	private Map<String, Object> getReportInfo(HttpServletRequest request) {
	
		// 存放报表内容的相关信息
		Map<String, Object> report_map = new HashMap<String, Object>();
		
		//获取客户端信息
		String type 		= request.getParameter("type");					// 要导出的文件类型
		String title 		= request.getParameter("title");				// 导出的文件名称
		String tableCaption = request.getParameter("tableCaption");			// 表示前台<table>中元素<caption>的集合
		String tableCol 	= request.getParameter("tableCol");				// 表示前台<table>的最大列数的集合
		String tableContext	= request.getParameter("tableBody");			// 表示前台<table>的内容的集合
		String widthTD		= request.getParameter("widthTD");				// 表示前台<table>第一行所有列的宽度
		
		String[]	tableCaptionList	= tableCaption.split("#CAPTION#");
		String[]    tableColList 		= tableCol.split(";");
		String[]    tableList 			= tableContext.split("#TABLE#");
		String[]	widthList			= widthTD.split(";");
		String[] reportTitle = title.split("\\|");
		
		report_map.put("widthList", widthList);
		
		//将处理后的信息放入HashMap中
		report_map.put("type", type);
		report_map.put("title", title);
		report_map.put("tableCaptionList", tableCaptionList);
		report_map.put("tableColList", tableColList);
		
		report_map.put("tableList", tableList);
		report_map.put("reportTitle", title);
		
		if(reportTitle != null && reportTitle.length>1){
			report_map.put("reportTitle", reportTitle[0]);
			report_map.put("queryInfo", reportTitle[1]);
		}
		
		//返回map
		return report_map;
	}

	@Override
	public void init() throws ServletException {
       String _encoding=getInitParameter("encoding");	
       if(null!=_encoding && !"".equals(_encoding)){
    	   this.encoding=_encoding;
       }
	}
	public String getEncoding() {
		return encoding;
	}
	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}
	
}

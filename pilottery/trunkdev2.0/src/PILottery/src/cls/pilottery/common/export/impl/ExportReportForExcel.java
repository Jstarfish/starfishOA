package cls.pilottery.common.export.impl;

import java.io.ByteArrayOutputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.export.intf.IExportReport;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;
/**
 * 报表Excel导出功能，目前只支持特定格式导出，除最后一行“合计”处，无其他合并单元格情况
 * @author Administrator
 *
 */
public class ExportReportForExcel implements IExportReport{
	private boolean isEn = true;

	@Override
	public void createReport(HttpServletRequest request,HttpServletResponse response, Map<?, ?> reportInfo)throws Exception {
		String[] tableList = (String[]) reportInfo.get("tableList");
		// 判断生成数据是否为空
		if (tableList == null || tableList.length < 0) {
			System.out.println("没有导出数据");
		}
		// 设置文件响应信息
		String fileTitle = ((String) reportInfo.get("reportTitle")).trim().replaceAll(",", "").replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "_");
		if ("".equals(fileTitle)) {
			fileTitle = "export";
		}
		String showFileName = URLEncoder.encode(fileTitle + ".xls", "UTF-8");
		showFileName = new String(showFileName.getBytes("iso8859-1"), "gb2312");

		// 定义输出类型
		response.reset();
		response.setContentType("application/msexcel");
		response.setHeader("Pragma", "public");
		response.setHeader("Cache-Control", "max-age=30");
		response.setHeader("Content-disposition", "attachment; filename="
				+ new String(showFileName.getBytes("gb2312"), "iso8859-1"));

		// 生成Excel并响应客户端
		ServletOutputStream out = response.getOutputStream();
		Object queryInfo = reportInfo.get("queryInfo");
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		isEn = user.getUserLang().equals(UserLanguage.EN);
		
		ByteArrayOutputStream bos = null;
		if(queryInfo == null){
			bos = (ByteArrayOutputStream) getStream(reportInfo);
		}else{
			bos = (ByteArrayOutputStream) getStream2(reportInfo);
		}
		response.setContentLength(bos.size());
		bos.writeTo(out);
		out.close();
		out.flush();
		bos.close();
		bos.flush();
		
	}
	
	private OutputStream getStream(Map<?, ?> reportInfo) throws Exception {
		// 实例化HSSFWorkbook
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Sheet");
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String[] tableList = (String[]) reportInfo.get("tableList");
		String[] tableColList = (String[]) reportInfo.get("tableColList"); // 记录每一个<table>的最大列数
		
		HSSFRow row = null;
		HSSFCell cell = null;
		int colNum = Integer.parseInt(tableColList[0]);
		
		// 创建表头样式
		HSSFCellStyle cellStyle = wb.createCellStyle();
		HSSFFont font = wb.createFont();
		
		//加标题、查询条件及制表日期等
		sheet.addMergedRegion(new CellRangeAddress(0,1,0,colNum-1));
		row = sheet.createRow(0);
		cell = row.createCell(0);
		cell.setCellValue(""+reportInfo.get("reportTitle"));
		cell.setCellStyle(this.getStyle("TITLE", cellStyle, font));
	
		//创建条件样式
		/*cellStyle = wb.createCellStyle();
		font = wb.createFont();
		sheet.addMergedRegion(new CellRangeAddress(2,2,0,colNum*2/3));
		row = sheet.createRow(2);
		cell = row.createCell(0);
		cell.setCellValue(""+reportInfo.get("queryInfo"));
		cell.setCellStyle(this.getStyle("CONDITION", cellStyle, font));
		
		sheet.addMergedRegion(new CellRangeAddress(2,2,colNum*2/3+1,colNum-1));
		cell = row.createCell(colNum*2/3+1);
		cell.setCellValue("Create Date:"+createDate);
		cell.setCellStyle(this.getStyle("CONDITION", cellStyle, font));*/
		
		int rowIndex = 2;	//记录行的位置，去掉标题查询条件行，默认从3（第四行）开始
		//解析数据
		List<String[]> list = parseTableStr(tableList);
		
		//创建表格内容样式
		cellStyle = wb.createCellStyle();
		font = wb.createFont();
		//写入表头和数据区（除最后一行）
		for(int i=0;i<list.size();i++){
			String[] str = list.get(i);
			row = sheet.createRow(i+rowIndex);
			if(i==0){	//根据表头设置列宽
				for(int k=0;k<str.length;k++){
					String cellValue = this.getCellValue(str[k]);
					//sheet.setColumnWidth(k, (cellValue.getBytes().length+2)*256);
					sheet.setColumnWidth(k, 2560*2);
					cell = row.createCell(k);
					cell.setCellValue(cellValue);
					cell.setCellStyle(this.getStyle("CONTENT", cellStyle, font));
				}
			}else{
				for(int k=0;k<str.length;k++){
					cell = row.createCell(k);
					cell.setCellValue(this.getCellValue(str[k]));
					cell.setCellStyle(this.getStyle("CONTENT", cellStyle, font));
				}
			}
		}
		
		// 写入字节流
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		wb.write(bos);
		return bos;
	}
	
	private OutputStream getStream2(Map<?, ?> reportInfo) throws Exception {
		// 实例化HSSFWorkbook
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Sheet");
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String createDate = df.format(new Date());

		String[] tableList = (String[]) reportInfo.get("tableList");
		String[] tableColList = (String[]) reportInfo.get("tableColList"); // 记录每一个<table>的最大列数
		
		HSSFRow row = null;
		HSSFCell cell = null;
		int colNum = Integer.parseInt(tableColList[0]);
		
		// 创建表头样式
		HSSFCellStyle cellStyle = wb.createCellStyle();
		HSSFFont font = wb.createFont();
		
		//加标题、查询条件及制表日期等
		sheet.addMergedRegion(new CellRangeAddress(0,1,0,colNum-1));
		row = sheet.createRow(0);
		cell = row.createCell(0);
		cell.setCellValue(""+reportInfo.get("reportTitle"));
		cell.setCellStyle(this.getStyle("TITLE", cellStyle, font));
	
		//创建条件样式
		cellStyle = wb.createCellStyle();
		font = wb.createFont();
		sheet.addMergedRegion(new CellRangeAddress(2,2,0,colNum*2/3));
		row = sheet.createRow(2);
		cell = row.createCell(0);
		cell.setCellValue(""+reportInfo.get("queryInfo"));
		cell.setCellStyle(this.getStyle("CONDITION", cellStyle, font));
		
		sheet.addMergedRegion(new CellRangeAddress(2,2,colNum*2/3+1,colNum-1));
		cell = row.createCell(colNum*2/3+1);
		if(isEn){
			cell.setCellValue("Create Date:"+createDate);
		}else{
			cell.setCellValue("制表时间："+createDate);
		}
		cell.setCellStyle(this.getStyle("CONDITION", cellStyle, font));
		
		int rowIndex = 3;	//记录行的位置，去掉标题查询条件行，默认从3（第四行）开始
		//解析数据
		List<String[]> list = parseTableStr(tableList);
		
		//创建表格内容样式
		cellStyle = wb.createCellStyle();
		font = wb.createFont();
		//写入表头和数据区（除最后一行）
		for(int i=0;i<list.size();i++){
			String[] str = list.get(i);
			row = sheet.createRow(i+rowIndex);
			if(i==0){	//根据表头设置列宽
				for(int k=0;k<str.length;k++){
					String cellValue = this.getCellValue(str[k]);
					//sheet.setColumnWidth(k, (cellValue.getBytes().length+2)*256);
					sheet.setColumnWidth(k, 2560*2);
					
					/*if(local.getLanguage().equals("zh")){
						sheet.setColumnWidth(k, cellValue.getBytes().length*256);
					}else{
						sheet.setColumnWidth(k, cellValue.getBytes().length*128);
					}*/
					cell = row.createCell(k);
					cell.setCellValue(cellValue);
					cell.setCellStyle(this.getStyle("CONTENT", cellStyle, font));
				}
			}else{
				for(int k=0;k<str.length;k++){
					cell = row.createCell(k);
					cell.setCellValue(this.getCellValue(str[k]));
					cell.setCellStyle(this.getStyle("CONTENT", cellStyle, font));
				}
			}
		}
		
		// 写入字节流
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		wb.write(bos);
		return bos;
	}
	
	/*
	 * 获取单元格中真实的值，去掉其中的无效字符
	 */
	private String getCellValue(String data) {
		String value = data.indexOf("#COLSPAN#") >= 0 ? data.substring(0,data.indexOf("#COLSPAN#")) : data;
		value = value.indexOf("#ROWSPAN#") >= 0 ? value.substring(0,value.indexOf("#ROWSPAN#")) : value;
		value = value.indexOf("#ALIGN#") >= 0 ? value.substring(value.indexOf("#ALIGN#")+7) : value;
		value = value.indexOf("#VALIGN#") >= 0 ? value.substring(value.indexOf("#VALIGN#")+8) : value;
		
		return value;
	}
	
	/*
	 * 解析字符串格式的数据
	 */
	private List<String[]> parseTableStr(String[] tableList) {
		List<String[]> list = new ArrayList<String[]>();
		if(tableList.length>1){		//有表头的情况
			String[] tabHeadArray = tableList[0].split("#ROW#");		//表头内容
			list.add(tabHeadArray[0].split("#TD#"));
			String[] rowArray = tableList[1].split("#ROW#");		//数据区内容
			for(int i=0;i<rowArray.length;i++){
				String[] colstr = rowArray[i].split("#TD#");
				list.add(colstr);
			}
		}else{		//没有表头的情况
			String[] rowArray = tableList[0].split("#ROW#");		//数据区内容
			for(int i=0;i<rowArray.length;i++){
				String[] colstr = rowArray[i].split("#TD#");
				list.add(colstr);
			}
		}
		return list;
	}
	
	/*
	 * 设置Excel各个区域的样式
	 */
	private HSSFCellStyle getStyle(String type,HSSFCellStyle cellStyle,HSSFFont font){
		if("TITLE".equals(type)){
			// 文本位置(居中)
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			font.setFontHeightInPoints((short) 20);// 字体大小
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);// 加粗
			font.setFontName("宋体");
			cellStyle.setFont(font);
			//设置边框
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_NONE);
			
		}else if("CONTENT".equals(type)){
			// 文本位置(居中)
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			font.setFontHeightInPoints((short) 10);// 字体大小
			font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
			font.setFontName("宋体");
			cellStyle.setFont(font);
			//设置边框
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			cellStyle.setWrapText(true); 
		}else if("CONDITION".equals(type)){
			// 文本位置(居中)
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			font.setFontHeightInPoints((short) 10);// 字体大小
			font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
			font.setFontName("宋体");
			cellStyle.setFont(font);
			//设置边框
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_NONE);
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_NONE);
		}
		return cellStyle;
	}

}

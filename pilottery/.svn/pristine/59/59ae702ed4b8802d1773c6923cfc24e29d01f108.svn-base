package cls.pilottery.common.export.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cls.pilottery.common.export.factory.ReportFontFactory;
import cls.pilottery.common.export.factory.ReportFontFactory.Font_Type;
import cls.pilottery.common.export.intf.IExportReport;
import cls.pilottery.common.utils.RegexUtil;

import com.lowagie.text.Cell;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
/**
 * Function 生成PDF报表
 * CreateTime 2014年7月22日
 * @author yyh
 * @version 1.2.0
 */
public class ExportReportForPDF implements IExportReport{
	/**
	 * Function 生成PDF报表
     * CreateTime 2014年7月22日
	 * @author yyh
	 * @version 1.0.0
	 * @param HttpServletRequest request
	 * @param HttpServletResponse response
	 * @param Map<?,?> reportInfo 生成报表所需要的数据
	 * 
	 * 说明：不能同时跨行跨列;可设置Cell宽度
	 * (yyh UpdateTime 2014-7-22)
	 */
	@Override
	public void createReport(HttpServletRequest request,
			HttpServletResponse response, Map<?, ?> reportInfo)
			throws Exception {
		String[] tableCaptionList   = (String[])reportInfo.get("tableCaptionList");
		String[] tableList   	  = (String[])reportInfo.get("tableList");
		String[] tableColList 	  = (String[])reportInfo.get("tableColList");
		String[] widthList 	  	  = (String[])reportInfo.get("widthList");
		String reportTitle = (String)reportInfo.get("reportTitle");
		String queryInfo = (String)reportInfo.get("queryInfo");

		//判断生成数据是否为空
		if(tableList == null || tableList.length < 0){
			System.out.println("没有导出数据");
		}
		String reg = "[\\u4e00-\\u9fa5]+";
		//生成PDF文档
		//Document document = new Document(PageSize.A4, 36,36,36,36);
		Document document = new Document(PageSize.A4.rotate());
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try {
			String fileTitle = ((String) reportInfo.get("reportTitle")).trim().replaceAll(",", "").replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "_");
			if ("".equals(fileTitle)) {
				fileTitle = "export";
			}
			//设置文件响应信息
			String showFileName = URLEncoder.encode(fileTitle + ".pdf", "UTF-8");
			showFileName = new String(showFileName.getBytes("iso8859-1"), "gb2312");
			
			//定义输出类型
			response.reset();
			response.setContentType("application/pdf"); 
			response.setHeader("Pragma", "public");
			response.setHeader("Cache-Control", "max-age=30");
			response.setHeader("Content-disposition", "attachment; filename="+ new String(showFileName.getBytes("gb2312"), "iso8859-1"));
			//System.out.println(response.toString());
			PdfWriter.getInstance(document, bos);
			
			com.lowagie.text.Font font;
			com.lowagie.text.Font titleFont;
			com.lowagie.text.Font titleFont2;
			HeaderFooter footer;
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String createDate = df.format(new Date());
			font=ReportFontFactory.getFontEnglish(Font_Type.CONTENT);
			 titleFont = ReportFontFactory.getFontEnglish(Font_Type.CONTENT);
			 titleFont.setSize(20);
			 titleFont2 = ReportFontFactory.getFontEnglish(Font_Type.CONTENT);
			 titleFont2.setSize(10);
			 footer = new HeaderFooter(new Phrase("Page ",font),new Phrase("",font));
			 createDate = "Create Date:"+createDate;
			footer.setBorder(Rectangle.NO_BORDER);   
			footer.setAlignment(Element.ALIGN_CENTER);   
			document.setFooter(footer);
			
			//打开doc
			document.open();
			
			PdfPTable t1 = new PdfPTable(3);
			if(getStrLength(reportTitle) > 26){
				t1.setTotalWidth(new float[]{25f,55f, 20f});
			}else{
				t1.setTotalWidth(new float[]{35f,35f, 30f});
			}
		
			PdfPCell n = new PdfPCell(new Paragraph("\t"));
			n.setBorder(0);
			t1.addCell(n);
			t1.setWidthPercentage(100);
			Paragraph p = new Paragraph(reportTitle, titleFont);
			p.setAlignment(Paragraph.ALIGN_CENTER);
			PdfPCell title = new PdfPCell(p);
			title.setBorder(0);
			title.setVerticalAlignment(Element.ALIGN_CENTER);
			t1.addCell(title);
			t1.addCell(n);
			
			t1.addCell(n);t1.addCell(n);t1.addCell(n);//增加一空行
			
			PdfPTable t2 = new PdfPTable(2);
			t2.setWidthPercentage(100);  
			t2.setTotalWidth(new float[]{70f, 30f});
			PdfPCell c1 = new PdfPCell(new Paragraph(queryInfo, titleFont2));
			c1.setBorder(0);
			c1.setVerticalAlignment(Element.ALIGN_LEFT);
			t2.addCell(c1);
			PdfPCell c2 = new PdfPCell(new Paragraph(createDate, titleFont2));
			c1.setBorder(0);
			c2.setVerticalAlignment(Element.ALIGN_RIGHT);
			c2.setBorder(0);
			t2.addCell(c2);
			t2.addCell(n);
			t2.addCell(n);
			
			document.add(t1);
			document.add(t2);
			//document.add(new Paragraph("\n"));
			
			Table table =  null;
			Cell cell = null;		// 能同时跨行跨列
			
			Paragraph paragraph = null;
			for (int i = 0; i < tableColList.length; i++) {

					String colInfo = tableColList[i];
					String colStr = colInfo.indexOf("#PAGINATION#") >= 0 ? colInfo.substring(0,colInfo.indexOf("#PAGINATION#")) : colInfo;
					colStr = colStr.indexOf("#NOBORDER#") >= 0 ? colStr.substring(0,colStr.indexOf("#PAGINATION#")) : colStr;

					int col = Integer.parseInt(colStr);
					
					boolean flag = false;  // 判断是否存在图片
					if (tableCaptionList.length > 0) {

						//添加标题
						paragraph = new Paragraph(""+tableCaptionList[i].replaceAll("#IMG#", ""),font);
						//paragraph = new Paragraph(""+tableCaptionList[i].replaceAll("#IMG#", ""),ReportFontFactory.getFontCambodia(Font_Type.TITLE));
						
						paragraph.setAlignment(Paragraph.ALIGN_CENTER);
						paragraph.setSpacingAfter(4);
						paragraph.setSpacingBefore(10);
		
						document.add(paragraph);
						flag = tableCaptionList[i].indexOf("#IMG#") >= 0 ? true : false;
					}
					
					if (col > 0) {

						table = new Table(col);
						table.setWidth(100f);
						table.setBorder(0);
						table.setAutoFillEmptyCells(true);
						table.setPadding(2);
//						table.setAlignment(Element.ALIGN_CENTER);
						
						table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
						table.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);
						
						if(widthList.length>i)// 说明：设置表格第一行所有列的width属性
						{
							String[] width = widthList[i].split(",");
							if (width.length > 0 ) {
								int [] ai = new int[width.length];
								for (int j = 0; j < width.length; j++) {
									if (!"".equals(width[j].trim())) {
										ai[j] = Integer.parseInt(width[j]);
									}
								}
								table.setWidths(ai);  // 设置表格Cell的宽度,注意列的数量
							}
						}

						String[] 	rows 	 = null;
						Object[][] 	cellInfo = null;
						for (int j = 0; j < tableList.length; j++) {
							if (i == j) {
								rows 		= tableList[j].split("#ROW#");
								
								for (int k = 0; k < rows.length; k++) {
									
									String cells[] = rows[k].split("#TD#");
									if (cellInfo == null) {
										cellInfo = new Object[rows.length][cells.length];
									}
									cellInfo[k] = cells;
								}
								
								//生成PDF数据
								for(int k=0;k<cellInfo.length;k++){
									Object[] datapdf=cellInfo[k];								
									for (int l = 0; l < datapdf.length; l++) {
								
											String value = datapdf[l].toString().indexOf("#COLSPAN#") >= 0 ? datapdf[l].toString().substring(0,datapdf[l].toString().indexOf("#COLSPAN#")) : datapdf[l].toString();
											
											value = value.indexOf("#ROWSPAN#") >= 0 ? value.substring(0,value.indexOf("#ROWSPAN#")) : value;
											value = value.indexOf("#ALIGN#") >= 0 ? value.substring(value.indexOf("#ALIGN#")+7) : value;
											value = value.indexOf("#VALIGN#") >= 0 ? value.substring(value.indexOf("#VALIGN#")+8) : value;
											if(value.trim().matches(reg)){
											  paragraph=new Paragraph(RegexUtil.getStringNoBlank(value) , ReportFontFactory.getFontChinese(Font_Type.CONTENT));
											}
											else{
												paragraph=new Paragraph(RegexUtil.getStringNoBlank(value.trim()) , ReportFontFactory.getFontEnglish(Font_Type.CONTENT));
											}
											
											cell= new Cell(paragraph);
											
										    if (colInfo.indexOf("#NOBORDER#") >= 0) {
												cell.setBorder(0);
											}
										    
										    cellStyleConsole(cell , RegexUtil.getStringNoBlank(datapdf[l].toString()));
										  
										    table.addCell(cell);
											
								
									}
							    }
							}
						}
						
						if (colInfo.indexOf("#PAGINATION#") >= 0) {
							table.deleteLastRow();
						}
						if (flag) {
							table.deleteLastRow();
						}
						
						//添加table到Document对象中
						document.add(table);
						if (colInfo.indexOf("#PAGINATION#") >= 0) {
							document.newPage();
						}
					}
			}
		    
			//关闭document
		    document.close();
			
		    //生成pdf文档品并响应客户端
			response.setContentLength(bos.size());
			ServletOutputStream out = response.getOutputStream();
		
			response.setContentLength(bos.size());
			bos.writeTo(out);
			out.flush();
			out.close();
			bos.flush();
			bos.close();

		} catch (UnsupportedEncodingException e) {
			
			e.printStackTrace();
		} catch (DocumentException e) {
			
			e.printStackTrace();
		} catch (MalformedURLException e) {
			
			e.printStackTrace();
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		finally{
			if (document.isOpen()) {
				//关闭document
			    document.close();
			}
		}
	
	}

	/**
	 * 
	 *  Cell样式控制：跨行、跨列、居中
	 *  说明：不能同时跨行跨列
	 * @param cell
	 * @param context
	 */
//	public void cellStyleConsole(PdfPCell cell, String context) {
	public void cellStyleConsole(Cell cell, String context) {
		
		// 默认
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);// 垂直居中
		// cell.setNoWrap(false);						// 自动换行

		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		
		int colspan = 0;
		int rowspan = 0;
		
		if (context.indexOf("#ROWSPAN#") >= 0 && context.indexOf("#COLSPAN#") >= 0) {// 跨行且跨列
			
			colspan = Integer.parseInt(context.substring(context.indexOf("#COLSPAN#")+9).trim());
			rowspan = Integer.parseInt(context.substring(context.indexOf("#ROWSPAN#")+9 , context.indexOf("#COLSPAN#")).trim());
			cell.setRowspan(rowspan);
			 cell.setColspan(colspan);
		}else if (context.indexOf("#ROWSPAN#") >= 0) {// 跨行
			
			rowspan = Integer.parseInt(context.substring(context.indexOf("#ROWSPAN#")+9).trim());
			cell.setRowspan(rowspan);
		}else if (context.indexOf("#COLSPAN#") >= 0) {// 跨列
			
			colspan = Integer.parseInt(context.substring(context.indexOf("#COLSPAN#")+9).trim());
			cell.setColspan(colspan);
		}
		
		// 位置设置：居中、右、左对齐
		if (context.indexOf("#ALIGN#") >=0) {
			String align = context.substring(0, context.indexOf("#ALIGN#")).trim();
			if ("right".equals(align)) {
				cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
			}else if ("left".equals(align)) {
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
			}else if ("center".equals(align)) {
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			}
		}
		
		// 垂直对齐方式：
		if (context.indexOf("#VALIGN#") >=0) {
			String vAlign = context.substring(context.indexOf("#ALIGN#")>=0?(context.indexOf("#ALIGN#")+7):0, context.indexOf("#VALIGN#")).trim();
			if ("top".equals(vAlign)) {
				cell.setVerticalAlignment(Element.ALIGN_TOP);
			}else if ("bottom".equals(vAlign)) {
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
			}else if ("middle".equals(vAlign)) {
				cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			}
		}
	}
	
	/**
     * 获取字符串的长度，中文占2个字符,英文数字占1个字符
     * 设置报表标题的宽度时使用(itext的居中不好使,改用此方法)
     *
     * @param value  指定的字符串          
     * @return 字符串的长度
     */
    public static double getStrLength(String value) {
        double valueLength = 0;
        String chinese = "[\u4e00-\u9fa5]";
        // 获取字段值的长度，如果含中文字符，则每个中文字符长度为2，否则为1
        for (int i = 0; i < value.length(); i++) {
            // 获取一个字符
            String temp = value.substring(i, i + 1);
            // 判断是否为中文字符
            if (temp.matches(chinese)) {
                // 中文字符长度为2
                valueLength += 2;
            } else {
                // 其他字符长度为1
                valueLength += 1;
            }
        }
        //进位取整
        return  Math.ceil(valueLength);
    }

}

package cls.pilottery.common.export.impl;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.net.URLEncoder;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cls.pilottery.common.export.intf.IExportReport;


/**
 * Function 生成图片(JPG)报表
 * CreateTime 2014年7月22日
 * @author yyh
 * @version 1.1.0
 */
public class ExportReportForJPG implements IExportReport{
	/**
	 * Function 生成图片(JPG)报表
     * CreateTime 2014年7月22日
	 * @author yyh
	 * @version 1.1.0
	 * @param HttpServletRequest request
	 * @param HttpServletResponse response
	 * @param Map<?,?> reportInfo 生成报表所需要的数据
	 */
	@Override
	public void createReport(HttpServletRequest request,
			HttpServletResponse response, Map<?, ?> reportInfo)
			throws Exception {
		//判断生成数据是否为空
		if(reportInfo.get("cellInfo")==null){
			throw new Exception("没有导出数据");
		}
		
		//设置文件响应信息
		String showFileName =URLEncoder.encode(reportInfo.get("title") + ".jpg", "UTF-8");
		showFileName = new String(showFileName.getBytes("iso8859-1"), "gb2312");
		
		//定义输出类型
		response.reset();
		response.setContentType("image/jpeg"); 
		response.setHeader("Pragma", "public");
		response.setHeader("Cache-Control", "max-age=30");
		response.setHeader("Content-disposition", "attachment; filename="+ new String(showFileName.getBytes("gb2312"), "iso8859-1"));
       
        //创建一个图像
        String [] header=(String[])reportInfo.get("header");
        int width = header.length*360,height =768;
        BufferedImage image = new BufferedImage(width, height,
        BufferedImage.TYPE_INT_RGB);
        
        //得到图形环境对象 
        Graphics graphics = image.getGraphics();
        //填充背景
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, width, height);
        
        graphics.setColor(Color.WHITE);
        graphics.fillRect(11, 35, width-21, height-47);
        
        graphics.setColor(Color.BLACK);
        graphics.drawRect(10, 35, width-20, height-46);
        
        graphics.setColor(Color.black);
        graphics.setFont(new Font("宋体", Font.BOLD, 28));
        graphics.drawString(""+reportInfo.get("title"), width/2, 25);
        
        //生成表头
		for(int i=0;i<header.length;i++){
			graphics.setColor(Color.black);
		    graphics.setFont(new Font("宋体", Font.PLAIN, 24));
			graphics.drawString(header[i],i*345+20,60);
		}
        
		//生成Image数据
		Object[][] datas=(Object[][])reportInfo.get("cellInfo");
		for(int i=0;i<datas.length;i++){
			Object[] data=datas[i];
			for(int j=0;j<data.length;j++){
				graphics.setColor(Color.BLACK);
			    graphics.setFont(new Font("宋体", Font.PLAIN, 18));
				graphics.drawString(""+data[j],j*345+20,(i+3)*35);
			}
			
	    }
       
        //利用ImageIO类的write方法对图像输出
        ServletOutputStream sos = response.getOutputStream();
        ImageIO.write(image, "jpeg", sos);
        sos.flush();
        sos.close();
		
	}

		


}

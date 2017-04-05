package cls.pilottery.common.export.tags;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

/**
 * Function 动态生成JS<br>
 * CreateTime 2014年7月22日
 * @author yyh
 * @version 1.1.0
 */
public class ERTagUtil {
	/**
	 * Function 创建js文件
	 * CreateTime 2014年7月22日
	 * @author yyh
	 * @param pageContext
	 * @version 1.1.0
	 */
	public  void createReportJS(PageContext pageContext){
		try{
			 HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		     // String root=request.getRealPath("/");
		     String root=request.getSession().getServletContext().getRealPath("/");
		     File file=new File(root,"er_js");
		     if(!file.exists()){
		    	 file.mkdir();
		     }
		     //生成Report JS
		     String createPath=root+"er_js\\";
		     file=new File(createPath,"export_report.js");
		     if(!file.exists()){
		    	 file.createNewFile();
		    	 createJs(root,createPath);
		     }
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	/**
	 * Function 将js文件拷贝到服务器下
	 * CreateTime 2014年7月22日
	 * @author yyh
	 * @param root
	 * @param createPath
	 *  @version 1.1.0
	 */
	private  void createJs(String root,String createPath){
		try {
			InputStream is=this.getClass().getResourceAsStream("/META-INF/export_report.js");    
	        BufferedReader br=new BufferedReader(new InputStreamReader(is));   
            FileWriter fw = new FileWriter(createPath+"\\export_report.js");
            BufferedWriter bw = new BufferedWriter(fw);   
            String myreadline;    
            while (br.ready()) {
                myreadline = br.readLine();
                bw.write(myreadline); 
                bw.newLine();
            }
            bw.close();
            br.close();
            fw.close();
            br.close();
            is.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
	}
}

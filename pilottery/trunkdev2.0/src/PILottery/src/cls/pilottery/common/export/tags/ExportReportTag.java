package cls.pilottery.common.export.tags;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.taglibs.standard.lang.support.ExpressionEvaluatorManager;
import org.springframework.web.servlet.support.RequestContext;
public class ExportReportTag extends BodyTagSupport{
	private static final long serialVersionUID = 1L;
	private Object tableId;		//tableID
	private String title;		//文档标题
	private String tableTitle;	//Table的标题
	private String types;		//报表类型(支持pdf,word,excel,jpg)
	private String url;			//请求路径
	private String classs;		//样式
	private String icons;		//
	
	private String imageId;		//图片id
	private String imageUrl;	//图片url
	@Override
	public int doEndTag() throws JspException {
		JspWriter out = pageContext.getOut(); 
		try {
			HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
			out.print("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/js/export_report.js\"></script>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return super.doEndTag();
	}
	@Override
	public int doStartTag() throws JspException {
		JspWriter out = pageContext.getOut();  
		HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		try{
			String er_types []=(null!=this.getTypes() && !"".equals(this.getTypes())) ?  this.getTypes().split(",") : null;
			String er_classs []=(null!=this.getClasss() && !"".equals(this.getClasss())) ?  this.getClasss().split(",") : null;
			String er_icons []=(null!=this.getIcons() && !"".equals(this.getIcons())) ?  this.getIcons().split(",") : null;
			StringBuffer sbER=new StringBuffer();
			RequestContext requestContext = new RequestContext(request);
			if(null!=er_types && er_types.length>0){
				for(int i=0;i<er_types.length;i++){
					if(null!=er_types[i] && !"".equals(er_types[i].trim()) && "pdf".equalsIgnoreCase(er_types[i])){
						sbER.append("&nbsp;&nbsp;<a id=\"expor_pdf\" class=\""+getStypeC(er_classs,i)+"\" icon=\""+getStyleIcon(er_icons,i)+"\" href=\"javascript:export_report('"+this.tableId+"','pdf','"+this.title+"','"+this.url+ "','" + this.imageId +  "');\" >" +
								"<img src=\""+request.getContextPath()+"/img/daochu.png\" width=\"25\" height=\"18\">Export"+"</a>");
					} 
					if(null!=er_types[i] && !"".equals(er_types[i].trim()) && "pdfinfo".equalsIgnoreCase(er_types[i])){
						
						sbER.append("&nbsp;&nbsp;<a id=\"expor_pdf\" class=\""+getStypeC(er_classs,i)+"\" icon=\""+getStyleIcon(er_icons,i)+"\" href=\"javascript:export_reporttable('"+this.tableId+"','pdf','"+this.title+"','"+this.url+ "','" + this.imageId +  "');\" >" +
								"<img src=\""+request.getContextPath()+"/img/daochu.png\" width=\"25\" height=\"18\">Export"+"</a>");
					}
					if(null!=er_types[i] && !"".equals(er_types[i].trim()) && "excel".equalsIgnoreCase(er_types[i])){
						  sbER.append("&nbsp;&nbsp;<a id=\"expor_excel\" class=\""+getStypeC(er_classs,i)+"\" icon=\""+getStyleIcon(er_icons,i)+"\" href=\"javascript:export_report('"+this.tableId+"','excel','"+this.title+"','"+this.url+ "','" + this.imageId +  "');\" >" +
								"<img src=\""+request.getContextPath()+"/img/daochu.png\" width=\"25\" height=\"18\">"+"Excel"+"</a>");
					}
				
					if(null!=er_types[i] && !"".equals(er_types[i].trim()) && "word".equalsIgnoreCase(er_types[i])){
						sbER.append("&nbsp;&nbsp;<a id=\"expor_word\" class=\""+getStypeC(er_classs,i)+"\" icon=\""+getStyleIcon(er_icons,i)+"\" href=\"javascript:export_report('"+this.tableId+"','word','"+this.title+"','"+this.url+  "','" + this.imageId +  "');\" >导出"+er_types[i]+"</a>");
					}
					if(null!=er_types[i] && !"".equals(er_types[i].trim()) && "jpg".equalsIgnoreCase(er_types[i])){
						sbER.append("&nbsp;&nbsp;<a id=\"expor_Jpg\" class=\""+getStypeC(er_classs,i)+"\" icon=\""+getStyleIcon(er_icons,i)+"\" href=\"javascript:export_report('"+this.tableId+"','jpg','"+this.title+"','"+this.url+"');\" >导出"+er_types[i]+"</a>");
					}
				}
				
				out.print(sbER);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return super.doStartTag();
	}
	/**
	 * Function：报表导出标签
	 * CreateTime：2014年7月22日
	 * @author yyh
	 * @param er_classs
	 * @param i
	 * @return String 当前有效样式
	 */
	private String getStypeC(String[] er_classs ,int i){
		String cl = "";
		if (null != er_classs && er_classs.length > 0) {
			if (er_classs.length > 1 && er_classs.length>=(i+1)) {
				cl = er_classs[i];
			} else {
				cl = er_classs[er_classs.length - 1];
			}
		}
		return cl;
	}

	/**
	 * Function：报表导出标签
	 * CreateTime：2014年7月22日
	 * @author chenck
	 * @param er_icons 
	 * @param i
	 * @return 当前有效icon
	 */
	private String getStyleIcon(String[] er_icons ,int i){
		String icon="";
		if(null!=er_icons && er_icons.length>0 ){
			if(er_icons.length>1 && er_icons.length>=(i+1)){
				icon=(null!=er_icons[i]) ? er_icons[i] : er_icons[0];
			}else{
				icon=er_icons[er_icons.length-1];
			}
		}
		return icon;
	}
	
	public Object getTableId() {
		return tableId;
	}
	public void setTableId(Object tableId) throws JspException {
		this.tableId = (String) ExpressionEvaluatorManager.evaluate("tableId", tableId.toString(), Object.class, this, pageContext);
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getTableTitle() {
		return tableTitle;
	}
	public void setTableTitle(String tableTitle) {
		this.tableTitle = tableTitle;
	}
	public String getTypes() {
		return types;
	}
	public void setTypes(String types) {
		this.types = types;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getClasss() {
		return classs;
	}
	public void setClasss(String classs) {
		this.classs = classs;
	}
	public String getIcons() {
		return icons;
	}
	public void setIcons(String icons) {
		this.icons = icons;
	}
	public String getImageId() {
		return imageId;
	}
	public void setImageId(String imageId) {
		this.imageId = imageId;
	}
	public String getImageUrl() {
		return imageUrl;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	
}

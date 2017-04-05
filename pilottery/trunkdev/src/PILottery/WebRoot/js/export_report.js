/**
 *  => 将要导出为 文档的<Ttable>内容，以字符串形式传递到后台
 *  => 实现导出多个<Table>、多个<img>
 * 
 * 图片导出说明：：前台<table>必须包含<caption>元素
 * 
 * @param {Object} tableId		表示<Table>的id: 此方法中是使用匹配id的方式来传递多个<Table>的内容，以便导出
 * @param {Object} type			导出的类型(pdf、excel、jpg、doc)
 * @param {Object} title		导出文件的标题
 * @param {Object} url			servlet URL
 * @param {Object} imgId		表示<img>的id
 * @memberOf {TypeName} 
 * @return {TypeName} 
 * @author yyh 2014年7月22日
 */
function export_report(tableId, type, title ,url, imgId ) {

	var tableBody = "";
	var tableCaption = "";  	// 从<caption>中取<Table>的标题
	
	var tableCol = "";		// 表示table的列数
	var widthTD = "";		// 用于存储每个table的所有列的宽度值，列与列的分隔符“,”,表与表的分隔符“;”
	
	$("table[id^=" + tableId + "]").each(function(j, _table) {
		
		var len = $("#" + $(this).attr("id") + " img").size();
		if( len > 0 )
		{
			var url = "";
			$("#" + $(this).attr("id") + " img").each(function(){
				url += $(this).attr("src") + " #TD#";		//以每一张图片作为一个TD
			});
			
			tableCaption += "#IMG#";							//用于标识图片table
			tableCol 	=  tableCol + 1 + ";" ;
			
			tableBody 	+= url + " #TD#";					// 作为Cell<td>分隔符
			tableBody 	+= "#ROW#"; 						// 作为Row<tr>分隔符
		}
		else
		{
			
			var col = 0;
			
			$("#" + $(this).attr("id") + " tr").each(function(i, _tr) {
				$(_tr).children().each(function(k, _td) {
					
					var colspan = $(_td).attr("colspan");
					var rowspan = $(_td).attr("rowspan");
					
					var align  = $(_td).attr("align");
					var valign  = $(_td).attr("valign");
					
					var noExp  = $(_td).attr("noExp");	//不导出
					if(noExp){
					}else{
					
						if(align != ""){
							tableBody += align + "#ALIGN#";
						}
						if(valign != ""){
							tableBody += valign + "#VALIGN#";
						}
						
						if (i == 0) {
							var width  = $(_td).attr("width");  		// 说明：设置表格第一行所有列的width属性
							if(colspan > 1){							//  跨列
								
								col = col + colspan;
								if(width > 0){
									for(var t = 0;t < colspan;t++){		// 第一行中存在跨列的情况下，平均分配列宽
										widthTD += width/colspan + ","; 
									}
								}
							}else{
								col ++;
								if(width > 0){
									widthTD += width + ","; 
								}
							}
						} 
							
						if(colspan > 1){					//  跨列
							
							if(rowspan > 1){				//  跨行
								tableBody 	+= $.trim($(_td).text()) + "#ROWSPAN#" + rowspan + "#COLSPAN#" + colspan + " #TD#";
							}else{
								tableBody 	+= $.trim($(_td).text()) + "#COLSPAN#" + colspan + " #TD#";// 作为Cell<td>分隔符
							}
						}else{
							
							if(rowspan > 1){				//  跨行
								tableBody 	+= $.trim($(_td).text()) + "#ROWSPAN#" + rowspan + " #TD#";
							}else{
								tableBody 	+= $.trim($(_td).text()) + " #TD#";// 作为Cell<td>分隔符
							}
						}
					}
				});
				tableBody += "#ROW#"; 					// 作为Row<tr>分隔符
			});
			tableCol 	=  tableCol + col;
			
			if($("#" + $(this).attr("id") + " input[id=pagination]").length>0)
			{
				tableCol += "#PAGINATION#";// 用来判断是否分页的标识,在需要分页的表格后边加上一个<input id="pagination" type="hidden">用来new Page
			}
			if($("#" + $(this).attr("id") + " input[id=noBorder]").length>0)
			{
				tableCol += "#NOBORDER#";				// 用来判断是否显示边框的标识,在需要分页的表格后边加上一个<input id="noBorder" type="hidden">
			}
			
			tableCol += ";" ;
		}
		widthTD += ";";
		tableBody 	+= "#TABLE#";						// 作为Table<table>分隔符
		tableCaption += $("#" + $(this).attr("id") + " caption").text() + "#CAPTION#"; 
	});
	
	if (tableBody == "") {
		alert("TableBody Error!");
		return false;
	}

	title = $("#reportTitle").val();
	$("#export_report_div").remove();
	var dataDiv = "<div id='export_report_div'>";
		dataDiv += "<form action='" + url + "' method='post' id='report_export_form'>";
		dataDiv += "<input type='hidden' name='title' value='" + title + "' />";
		dataDiv += "<input type='hidden' name='type' value='" + type + "'/>";
		dataDiv += "<input type='hidden' name='tableCol' value='" + tableCol	+ "'/>";
		dataDiv += "<input type='hidden' name='tableBody'  value=\"" + tableBody + "\"/>";
		dataDiv += "<input type='hidden' name='tableCaption'  value='" + tableCaption+ "'/>";
		dataDiv += "<input type='hidden' name='widthTD'  value='" + widthTD+ "'/>";
		dataDiv += "</form>";
		dataDiv += "</div>";
		
	$(document.body).append(dataDiv);
	$("#report_export_form").submit();
}

function export_reporttable(tableId, type, title ,url, imgId ) {

	var tableBody = "";
	var tableCaption = "";  	// 从<caption>中取<Table>的标题
	
	var tableCol = 0;		// 表示table的列数
	var widthTD = "";		// 用于存储每个table的所有列的宽度值，列与列的分隔符“,”,表与表的分隔符“;”
	
	$("table[id^=" + tableId + "]").each(function(j, _table) {
		var len = $("#" + $(this).attr("id") + " img").size();
		
		if( len > 0 )
		{
			var url = "";
			$("#" + $(this).attr("id") + " img").each(function(){
				url += $(this).attr("src") + " #TD#";		//以每一张图片作为一个TD
			});
			
			tableCaption += "#IMG#";							//用于标识图片table
			tableCol 	=  parseInt(tableCol) + 1;
			
			tableBody 	+= url + " #TD#";					// 作为Cell<td>分隔符
			tableBody 	+= "#ROW#"; 						// 作为Row<tr>分隔符
		}
		else
		{
			
			var col = 0;	
		
			$("#" + $(this).attr("id") + " tr").each(function(i, _tr) {
				$(_tr).children().each(function(k, _td) {
					
					var colspan = $(_td).attr("colspan");
					var rowspan = $(_td).attr("rowspan");
					
					var align  = $(_td).attr("align");
					var valign  = $(_td).attr("valign");
					
					if(align != ""){
						tableBody += align + "#ALIGN#";
					}
					if(valign != ""){
						tableBody += valign + "#VALIGN#";
					}
					
					if (i == 0) {
						var width  = $(_td).attr("width");  		// 说明：设置表格第一行所有列的width属性
						if(colspan > 1){							//  跨列
							
							col = col + parseInt(colspan);
							if(width > 0){
								for(var t = 0;t < colspan;t++){		// 第一行中存在跨列的情况下，平均分配列宽
									widthTD += width/colspan + ","; 
								}
							}
						}else{
							col ++;
							if(width > 0){
								widthTD += width + ","; 
							}
						}
					} 
						
					if(colspan > 1){					//  跨列
						
						if(rowspan > 1){				//  跨行
							tableBody 	+= $.trim($(_td).text()) + "#ROWSPAN#" + rowspan + "#COLSPAN#" + colspan + " #TD#";
						}else{
							tableBody 	+= $.trim($(_td).text()) + "#COLSPAN#" + colspan + " #TD#";// 作为Cell<td>分隔符
						}
					}else{
						
						if(rowspan > 1){				//  跨行
							tableBody 	+= $.trim($(_td).text()) + "#ROWSPAN#" + rowspan + " #TD#";
						}else{
							tableBody 	+= $.trim($(_td).text()) + " #TD#";// 作为Cell<td>分隔符
						}
					}
				});
				tableBody += "#ROW#"; 					// 作为Row<tr>分隔符
			});
			tableCol 	=  parseInt(tableCol) + parseInt(col);
		
		}
		widthTD += ";";
		tableBody 	+= "#TABLE#";						// 作为Table<table>分隔符
		tableCaption += $("#" + $(this).attr("id") + " caption").text() + "#CAPTION#"; 
	});
	
	if (tableBody == "") {
		alert("TableBody Error!");
		return false;
	}
	title = $("#reportTitle").val();
	$("#export_report_div").remove();
	var dataDiv = "<div id='export_report_div'>";
		dataDiv += "<form action='" + url + "' method='post' id='report_export_form'>"
		dataDiv += "<input type='hidden' name='title' value='" + title + "' />";
		dataDiv += "<input type='hidden' name='type' value='" + type + "'/>";
		dataDiv += "<input type='hidden' name='tableCol' value='" + tableCol	+ "'/>";
		dataDiv += "<input type='hidden' name='tableBody'  value='" + tableBody + "'/>";
		dataDiv += "<input type='hidden' name='tableCaption'  value='" + tableCaption+ "'/>";
		dataDiv += "<input type='hidden' name='widthTD'  value='" + widthTD+ "'/>";
		dataDiv += "</form>";
		dataDiv += "</div>";
	$(document.body).append(dataDiv);
	$("#report_export_form").submit();
}
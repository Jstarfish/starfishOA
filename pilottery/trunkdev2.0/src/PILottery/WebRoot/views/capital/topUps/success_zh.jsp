<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" charset="UTF-8">
function doCloseAndPrint() {
	window.parent.closeBoxAndOpen('${url}','打印');
/* 	window.parent.closeBoxAndOpen('${url}','print',750,1200); */
}
</script>
</head>

<body>
 <div id="success_page">
	<div style="padding:50px;">
	   <table width="100%" border="0" cellspacing="0" cellpadding="0"">
	   	<tr>
	   		<td width="11%" align="left" valign="top">
	   			<img alt="success" src="${basePath}/img/success.png" width="49" height="49">
	   		</td>
	   		<td width="89%" colspan="2" valign="top">
				<p>充值成功！</p><br/>
				<table><tr>
					<td>
						<div>
							<input type="button" class="button-normal" value="打印" 
				 					onclick="doCloseAndPrint();"/>
						</div>
					</td>
				</tr></table>
	   		</td>
	   	</tr>
	   </table>
	</div>
</div> 

</body>
</html>
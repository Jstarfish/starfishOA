<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" charset="UTF-8">
function doCloseAndPrint() {
	window.parent.closeBoxAndOpen('${url}','打印');
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
				<p>The batch has been successfully terminition！</p><br/>
				<table><tr>
					<td>
						<div>
							<input type="button" class="button-normal" value="print" 
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
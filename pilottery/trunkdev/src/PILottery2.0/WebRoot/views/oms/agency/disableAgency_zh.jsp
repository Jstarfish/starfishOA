<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>禁用</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" charset="UTF-8">
	function doClose(){
		window.parent.closeBox();
	}
	function doSubmit(){
		 $('#theArea').submit();	
        // button_off("okBtn");
		}
</script>

</head>
<body>
  <form  action="agency.do?method=disableAgency" id="theArea" method="POST">
	    <div class="pop-body">
	        <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	        <tr>
					<td align="right">销售站编码：</td>
					<td align="left">${agencyCodeTochar}</td>					
				</tr>
				<tr>
					<td><input type="hidden" name="agencyCode"  value="${agency.agencyCode}"/></td>				
				</tr>
				<tr>
					<td align="right">销售站名称：</td>
					<td align="left">${ agency.agencyName}</td>				
				</tr>
	              
	        </table>
        </div>
        <div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="提交" onclick="doSubmit();" class="button-normal"></span>
            <span class="right"><input id="okBtn" type="button" value="关闭" onclick="doClose();" class="button-normal"></input></span>
        </div>
    </form>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Disable</title>
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
					<td align="right">Agency Code：</td>
					<td align="left">${agencyCodeTochar}</td>					
				</tr>
				<tr>
					<td><input type="hidden" name="agencyCode"  value="${agency.agencyCode}"/></td>				
				</tr>
				<tr>
					<td align="right">Agency Name：</td>
					<td align="left">${ agency.agencyName}</td>				
				</tr>
	              
	        </table>
        </div>
        <div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();" class="button-normal"></span>
            <span class="right"><input id="okBtn" type="button" value="Close" onclick="doClose();" class="button-normal"></input></span>
        </div>
    </form>
</body>
</html>
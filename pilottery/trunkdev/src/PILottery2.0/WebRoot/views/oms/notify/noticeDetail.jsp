<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Notice Details</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8" > 

</script>
</head>
<body>
	<form action="updatePlan.do?method=executeplan" id="theForm" method="post">
		<div class="pop-body">
		<!-- <div> -->
			<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0" > -->
			<table border="0" cellspacing="0" cellpadding="0" >
				<tr>
				    <%-- <td align="right" style="width:35%">Sender：</td>
				    <td align="left" style="width:45%">	 --%>	
				    <td align="right" style="width:130px">Sender：</td>
				    <td align="left">		
				    	<input class="text-big" style="border: none;" disabled="disabled" type="text" value="${noticeMap.ADMIN_REALNAME }"/>    	
				    </td>
				    <td style="width:*%">&nbsp;</td>
				  </tr>
				  <tr>
				    <td align="right">Send Time：</td>
				    <td align="left">		
				    	<input class="text-big" style="border: none;" disabled="disabled" type="text" value="${noticeMap.SEND_TIME}"/> 	    	
				    </td>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td align="right">Target Agency：</td>
				    <td align="left" title="${noticeMap.CAST_STRING}">		
				    	<%-- <input class="text-big" style="border: none;" disabled="disabled" type="text" value="${noticeMap.CAST_STRING}"/>  --%>	    	
				    	<div class="edit_div_text" style="width:100%;word-break: break-word; word-wrap: break-word;"> ${noticeMap.CAST_STRING}</div> 	    	
				    </td>
				    <td>&nbsp;</td>
				  </tr>
			      <tr>
				    <td align="right">Notice Title：</td>
				    <td align="left">	
				    	<input class="text-big" style="border: none;" disabled="disabled" type="text" value="${noticeMap.TITLE}"/> 		    	
				    </td>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td align="right">Notice Content：</td>
				    <td align="left">	
				    	<div class="edit_div_text" style="width:100%;word-break: break-word; word-wrap: break-word;"> ${noticeMap.CONTENT}</div>
				    </td>
				    <td>&nbsp;</td>
				  </tr>
			</table>
		</div>
        <div class="pop-footer" align="right">
        <span class="right"><input type="button" value="Close" class="button-normal" onclick="javascript:window.parent.closeBox();"></input></span>
    </div>
	</form>
</body>
</html>

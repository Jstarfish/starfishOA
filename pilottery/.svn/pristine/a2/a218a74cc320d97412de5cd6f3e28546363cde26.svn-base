<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>公告详情</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8" > 

</script>
<script type="text/javascript" charset="UTF-8">
	function doClose(){
		window.parent.closeBox();
	}
</script>
</head>
<body>
	<form action="agency.do?method=addAgency" id="theArea" method="POST">
		 <input type="hidden" name="areaType" id="areaType" value="${agency.areaType }"/>
		 <input type="hidden" id="preRecomendIdhidden" name="preRecomendIdhidden" value="${preRecomendIdhidden}"/>
		<div class="pop-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
				    <td align="right" style="width:35%">销售站编码：</td>
				    <td align="left" style="width:45%">			
				    	<input class="text-big" style="border: none;" disabled="disabled" type="text" value="${agency.agencyCode}"/>    	
				    </td>
				    <td style="width:*%">&nbsp;</td>
				  </tr>
				  <tr>
				    <td align="right">销售站名称：</td>
				    <td align="left">		
				    	<input class="text-big" style="border: none;" disabled="disabled" type="text" value="${agency.agencyName}"/> 	    	
				    </td>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td align="right">联系人：</td>
				    <td align="left">		
				    	<input class="text-big" style="border: none;" disabled="disabled" type="text" value="${agency.agencyManager }"/> 	    	
				    </td>
				    <td>&nbsp;</td>
				  </tr>
			      <tr>
				    <td align="right">银行名称：</td>
				    <td align="left">	
				    	<input class="text-big" style="border: none;" disabled="disabled" type="text" value="${agency.agencyBank.bankName}"/> 		    	
				    </td>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td align="right">银行账号：</td>
				    <td align="left">	
				    	<div class="edit_div_text" style="width:100%;word-break: break-word; word-wrap: break-word;"> ${agency.bankAccount}</div>
				    </td>
				    <td>&nbsp;</td>
				  </tr>
				   <tr>
				    <td align="right">联系方式：</td>
				    <td align="left">	
				    	<div class="edit_div_text" style="width:100%;word-break: break-word; word-wrap: break-word;"> ${agency.agencyPhone}</div>
				    </td>
				    <td>&nbsp;</td>
				  </tr>
				   <tr>
				    <td align="right">销售站地址：</td>
				    <td align="left">	
				    	<div class="edit_div_text" style="width:100%;word-break: break-word; word-wrap: break-word;"> ${agency.agencyAddress}</div>
				    </td>
				    <td>&nbsp;</td>
				  </tr>
				    <tr>
				    <td align="right">开始营业时间：</td>
				    <td align="left">	
				    	<div class="edit_div_text" style="width:100%;word-break: break-word; word-wrap: break-word;"> ${agency.startTime}</div>
				    </td>
				    <td>&nbsp;</td>
				  </tr>
				   <tr>
				    <td align="right">结束营业时间：</td>
				    <td align="left">	
				    	<div class="edit_div_text" style="width:100%;word-break: break-word; word-wrap: break-word;"> ${agency.endTime }</div>
				    </td>
				    <td>&nbsp;</td>
				  </tr>
			</table>
		</div>
        <div class="pop-footer" align="right">
        <span class="right"><input type="button" value="关闭" class="button-normal" onclick="doClose();"></input></span>
    </div>
	</form>
</body>
</html>

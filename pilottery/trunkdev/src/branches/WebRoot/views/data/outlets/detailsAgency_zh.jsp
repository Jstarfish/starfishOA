<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>站点详细信息</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />

<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function doClose() {
		window.parent.closeBox();
	}
</script>
</head>
<body>
<div id="tck" >
 	<div class="mid">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	      <tr>
			  <td align="right" width="25%">所属部门：</td>
			  <td align="left" width="25%">${listForm.orgName}</td>
			  <td align="right" width="25%">所属区域：</td>
			  <td align="left">${listForm.areaName}</td>
	      </tr>
	      <tr>
	      	  <td align="right">市场管理员：</td>
	      	  <td align="left" >${listForm.marketName}</td>
			  <td align="right">商店类型：</td>
			  <td align="left" >${listForm.storeType}</td>
		  </tr>
		  <tr>
		   	  <td align="right">站点类型：</td>
	      	  <td align="left" >${agencyType}</td>
			  <td align="right">站点名称：</td>
			  <td align="left" >${listForm.agencyName}</td>
		  </tr>
		  <tr>
		      <td align="right">所属银行：</td>
	      	  <td align="left" >${listForm.bankName}</td>
			  <td align="right">银行账号：</td>
			  <td align="left" >${listForm.bankAccount}</td>
		  </tr>
		  <tr>
		      <td align="right">联系人：</td>
	      	  <td align="left" >${listForm.contactPerson}</td>
			  <td align="right">联系电话：</td>
			  <td align="left" >${listForm.telephone}</td>
		  </tr>
		   <tr>
		      <td align="right">证件号码：</td>
	      	  <td align="left" >${listForm.personalId}</td>
			  <td align="right">合同编号：</td>
			  <td align="left" >${listForm.contractNo}</td>
		  </tr>
		  
		   <tr>
		      <td align="right">地址：</td>
	      	  <td align="left" >${listForm.address}</td>
			  <td align="right">登录密码 ：</td>
			  <td align="left" >${listForm.pass}</td>
		  </tr>
		   <tr>
		      <td align="right">经度：</td>
	      	  <td align="left" >${listForm.glatlng_n}</td>
			  <td align="right">纬度：</td>
			  <td align="left" >${listForm.glatlng_e}</td>
		  </tr>
	    </table>
  	</div>
 </div>

</body>
</html>
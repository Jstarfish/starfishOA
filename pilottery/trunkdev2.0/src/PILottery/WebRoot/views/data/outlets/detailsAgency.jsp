<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Details Outlet</title>

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
			  <td align="right" width="25%">Institution：</td>
			  <td align="left" width="25%">${listForm.orgName}</td>
			  <td align="right" width="25%">Administrative Area：</td>
			  <td align="left">${listForm.areaName}</td>
	      </tr>
	      <tr>
	      	  <td align="right">Market Managers：</td>
	      	  <td align="left" >${listForm.marketName}</td>
			  <td align="right">Store Type：</td>
			  <td align="left" >${listForm.storeType}</td>
		  </tr>
		  <tr>
		   	  <td align="right">Outlet Type：</td>
	      	  <td align="left" >${agencyType}</td>
			  <td align="right">Outlet Name：</td>
			  <td align="left" >${listForm.agencyName}</td>
		  </tr>
		  <tr>
		      <td align="right">Bank：</td>
	      	  <td align="left" >${listForm.bankName}</td>
			  <td align="right">Bank Account：</td>
			  <td align="left" >${listForm.bankAccount}</td>
		  </tr>
		  <tr>
		      <td align="right">Contact Person：</td>
	      	  <td align="left" >${listForm.contactPerson}</td>
			  <td align="right">Contact Phone：</td>
			  <td align="left" >${listForm.telephone}</td>
		  </tr>
		   <tr>
		      <td align="right">Personal ID：</td>
	      	  <td align="left" >${listForm.personalId}</td>
			  <td align="right">Contract No：</td>
			  <td align="left" >${listForm.contractNo}</td>
		  </tr>
		  
		   <tr>
		      <td align="right">Outlet Address：</td>
	      	  <td align="left" >${listForm.address}</td>
			  <td align="right">Login Password ：</td>
			  <td align="left" >${listForm.pass}</td>
		  </tr>
		   <tr>
		      <td align="right">Glatlng_n：</td>
	      	  <td align="left" >${listForm.glatlng_n}</td>
			  <td align="right">Glatlng_e：</td>
			  <td align="left" >${listForm.glatlng_e}</td>
		  </tr>
	    </table>
  	</div>
 </div>

</body>
</html>
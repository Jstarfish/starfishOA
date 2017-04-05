<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>



<head>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript">

function doClose(){
	
	window.parent.location.reload();
	//window.parent.closeBox();
}
function exportPdf() {

	$("#printDiv").jqprint();
}
</script>
</head>

<body>
<div style="margin:60px 100px; float:right;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr >
      <td align="right">
          <button class="report-print-button" type="button" onclick="exportPdf();">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr  height="50">
                      <td><img src="views/inventory/goodsReceipts/images/printx.png" width="18" height="17"   /></td>
                    <td style="color: #fff;">打印</td>
                  </tr>
                </table>
          </button>
      </td>
    </tr>
  </table>
</div>
 <div id="printDiv">
<div class="pop-body" style="text-align:center;">
<table style="margin:auto; width:95%;" border="1" id="exportPdf" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="4" align="center" style="font-size:24px; line-height:50px;">
				<c:if test="${applicationScope.useCompany == 1}">
        			柬埔寨国家体育彩票公司销售站账户清退凭证
	        	</c:if>
	        	<c:if test="${applicationScope.useCompany == 2}">
	        		柬埔寨高棉彩池福利彩票有限公司销售站账户清退凭证
	        	</c:if>
			</td>
		</tr>
		<tr>
			<td colspan="2" class="gm-sty-dj-left">日期  &nbsp;&nbsp; <fmt:formatDate value="${agencys.refunddate }" pattern="yyyy-MM-dd  HH:mm:ss "/> </td>
			<td colspan="2" class="gm-sty-dj-right">单号 &nbsp;&nbsp;  ${agencys.id }</td>
		</tr>
		<tr>
			<td width="14%">销售站编码</td>
			<td width="23%">${agencys.agencyCode}</td>
			<td width="20%">销售站名称</td>
			<td width="43%">${agencys.agencyName}</td>
		</tr>
		<tr>
			<td>联系人</td>
			<td>${agencys.person}</td>
			<td>销售站地址</td>
			<td>${agencys.address}</td>
		</tr>
		<tr>
			<td>序号</td>
			<td>项目</td>
			<td colspan="2">金额</td>
		</tr>
		<tr>
			<td>1</td>
			<td>账户余额</td>
			<td colspan="2" class="gm-sty-dj-right"><fmt:formatNumber value='${agencys.fundamount}'/></td>
		</tr>
		<tr>
			<td>2</td>
			<td>固定费用</td>
			<td colspan="2" class="gm-sty-dj-right">0</td>
		</tr>
		<tr>
			<td>3</td>
			<td>设备押金</td>
			<td colspan="2" class="gm-sty-dj-right">0</td>
		</tr>
		<tr>
			<td>4</td>
			<td>其他费用</td>
			<td colspan="2" class="gm-sty-dj-right">0</td>
		</tr>
		<tr>
			<td colspan="2">合计</td>
			<td colspan="2" class="gm-sty-dj-right"><fmt:formatNumber value='${agencys.fundamount}'/> </td>
		</tr>
		<tr>
			<td colspan="2">经办人：</td>
			<td colspan="2">清退人：</td>
		</tr>
	</table>
</div>
</div>
</body>
</html>

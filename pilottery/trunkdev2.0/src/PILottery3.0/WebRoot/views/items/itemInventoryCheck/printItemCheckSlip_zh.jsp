<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>

<title>物品盘点单</title>

<style>
body {
	font-family:"Times New Roman",Times,serif,"微软雅黑";
}
</style>

<script type="text/javascript">
    function exportPdf() {
    	$("#printDiv").jqprint();
    }
    
    $(document).ready(function(){
    	var row = $("#itemCheckList tr[name=itemCheckRow]");
    	row.each(function(){
    		var beforeQuantity = $(this).find("#beforeQuantity").text();
    		beforeQuantity = parseInt(beforeQuantity);
    		
    		var checkQuantity = $(this).find("#checkQuantity").text();
    		checkQuantity = parseInt(checkQuantity);
    		
    		var discrepancy = checkQuantity - beforeQuantity;
    		$(this).find("#discrepancy").text(discrepancy);
    		
    		if (discrepancy > 0) {
    			$(this).find("#result").text("盘盈");
    		} else if (discrepancy < 0) {
    			$(this).find("#result").text("盘亏");
    		} else {
    			$(this).find("#result").text("一致");
    		}
    	});
    });
</script>

</head>
<body>

<div style="margin:10px 40px; float:right;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="right">
				<button class="report-print-button" type="button" onclick="exportPdf();">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><img src="img/icon-printer.png" width="18" height="17"/></td>
							<td style="color: #fff;">打印</td>
						</tr>
					</table>
				</button>
			</td>
		</tr>
	</table>
</div>

<div id="printDiv">
	<table width="1000" border="0" cellspacing="0" cellpadding="0" align="center" class="normal">
		<tr>
			<td colspan="3" align="right"><img src="img/KPW.jpg" width="170" height="55"/></td>
		</tr>
		<tr>
			<td colspan="3" style="font-size:24px;line-height:80px;border-bottom:2px solid #000;font-weight:bold;text-align:center;">物品盘点单</td>
		</tr>
		<tr height="40">
      		<td colspan="3">
      			<table width="100%" border="0" cellspacing="0" cellpadding="0">
         			<tr>
            			<td>盘点人: ${operator}</td>
            			<td align="right"><fmt:formatDate value="${date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
          			</tr>
        		</table>
        	</td>
    	</tr>
    	<tr height="40">
      		<td align="left" colspan="3">盘点编号: ${checkNo}</td>
    	</tr>
		<tr height="40">
      		<td align="left" colspan="3">盘点名称: ${checkName}</td>
    	</tr>
    	<tr height="40">
      		<td align="left" colspan="3">盘点仓库: ${checkWarehouseName}</td>
    	</tr>
    	<tr>
    		<td colspan="3" style="padding:20px 0;">
    			<table id="itemCheckList" width="1000" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
          			<tr align="center" height="80">
            			<td width="166">物品编码</td>
            			<td width="166">物品名称</td>
            			<td width="166">盘点前数量</td>
            			<td width="166">盘点后数量</td>
            			<td width="166">盘点差异</td>
            			<td width="166">盘点结果</td>
			        </tr>
			        <c:forEach var="data" items="${itemCheckDetailList}" varStatus="status">
			        	<tr name="itemCheckRow" align="center" height="80">
			        		<td>${data.itemCode}</td>
			        		<td>${data.itemName}</td>
			        		<td><span id="beforeQuantity">${data.beforeQuantity}</span></td>
			        		<c:if test="${not empty data.checkQuantity}">
			        			<td><span id="checkQuantity">${data.checkQuantity}</span></td>
			        		</c:if>
			        		<c:if test="${empty data.checkQuantity}">
			        			<td><span id="checkQuantity">0</span></td>
			        		</c:if>
			        		<td><span id="discrepancy"></span></td>
			        		<td><span id="result"></span></td>
			        	</tr>
			        </c:forEach>
        		</table>
    		</td>
    	</tr>
    	<c:if test="${not empty remark}">
			<tr height="40">
				<td colspan="3" align="left" style="word-break:break-all">备注: ${remark}</td>
			</tr>
		</c:if>
		<tr height="80">
      		<td width="150" align="left">签字:</td>
      		<td width="953"><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    	</tr>
    	<tr height="80">
      		<td align="left">审批人:</td>
      		<td><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    	</tr>
    	
	</table>
</div>

</body>
</html>
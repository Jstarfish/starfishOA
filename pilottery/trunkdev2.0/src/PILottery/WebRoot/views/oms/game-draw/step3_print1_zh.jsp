<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>print</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/printStyle.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>

<script type="text/javascript">
	function exportPdf() {
		$("#printDiv").jqprint();
	}
</script>
</head>

<body class="body">
<div style="margin:10px 70px; float:right;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td align="right">
                <button class="report-print-button" type="button" onclick="exportPdf();">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td><img src="<%=request.getContextPath() %>/img/icon-printer.png" width="18" height="17"/>
                            </td>
                            <td style="color: #fff;">打印</td>
                        </tr>
                    </table>
                </button>
            </td>
        </tr>
    </table>
</div>
<div id="printDiv">
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="top" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td align="center" valign="top" colspan="3">
			<h1>
				<c:if test="${applicationScope.useCompany == 1}">
        			柬埔寨国家体育彩票“${gameDrawInfo.shortName }”销售报表
	        	</c:if>
	        	<c:if test="${applicationScope.useCompany == 2}">
	        		柬埔寨高棉彩池“${gameDrawInfo.shortName }”销售报表
	        	</c:if>
			</h1>
            <br/>
            <h1>第${gameDrawInfo.issueNumber }期</h1>
		</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3"><h2>单位：（瑞尔）</h2></td>
	</tr>

	<tr>
		<td colspan="3" valign="top" height="">
		<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#000">

			<tr>
				<td width="40%" align="center"><h2>机构</h2></td>
				<td width="30%" align="center"><h2>销售额</h2></td>
				<td width="30%" align="center"><h2>销售收入</h2></td>
			</tr>
			<c:forEach var="item" items="${areaSaleList}">
			<tr>
                <td width="40%" align="center"><h2>${item.areaName }</h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${empty item.s_amount ? 0 : item.s_amount }" pattern="#,###"/></h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${empty item.s_amount_r ? 0 : item.s_amount_r }" pattern="#,###"/></h2></td>
            </tr>
			</c:forEach>
            <tr>
                <td width="40%" align="center"><h2>合计</h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount }" pattern="#,###"/></h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount_r }" pattern="#,###"/></h2></td>
            </tr>
		</table>
		</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3"><h2>以上数据核对无误，以此打印签字盖章为准。</h2></td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td colspan="3">
		<table width="460" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right">
				<table width="460" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="3" align="left"><h2>负责人：</h2></td></tr>
					<tr><td align="left"><h2>审核人：</h2></td></tr>
					<tr><td align="left"><h2>操作员：</h2></td></tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td align="right" colspan="3">
			<h2>
				<c:if test="${applicationScope.useCompany == 1}">
        			柬埔寨国家体育彩票公司技术部
	        	</c:if>
	        	<c:if test="${applicationScope.useCompany == 2}">
	        		柬埔寨高棉彩池福利彩票有限公司技术部
	        	</c:if>
			</h2>
			<h2>${gameDrawInfo.realColseTime }</h2>
		</td>
	</tr>
</table>
</div>
</body>
</html>
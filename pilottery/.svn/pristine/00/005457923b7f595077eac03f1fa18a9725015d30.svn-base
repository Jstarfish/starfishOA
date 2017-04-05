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
                            <td style="color: #fff;">Print</td>
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
        			National Sports Lottery "${gameDrawInfo.shortName }" Sales Statement
	        	</c:if>
	        	<c:if test="${applicationScope.useCompany == 2}">
	        		Khmer Pools Welfare Lottery "${gameDrawInfo.shortName }" Sales Statement
	        	</c:if>
			</h1>
            <br/>
            <h1>Issue${gameDrawInfo.issueNumber }</h1>
		</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3"><h2>Currency in riels</h2></td>
	</tr>

	<tr>
		<td colspan="3" valign="top" height="">
		<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#000">

			<tr>
				<td width="40%" align="center"><h2>Institution</h2></td>
				<td width="30%" align="center"><h2>Sales Amount</h2></td>
				<td width="30%" align="center"><h2>Sales Income</h2></td>
			</tr>
			<c:forEach var="item" items="${areaSaleList}">
			<tr>
                <td width="40%" align="center"><h2>${item.areaName }</h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${empty item.s_amount ? 0 : item.s_amount }" pattern="#,###"/></h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${empty item.s_amount_r ? 0 : item.s_amount_r }" pattern="#,###"/></h2></td>
            </tr>
			</c:forEach>
            <tr>
                <td width="40%" align="center"><h2>Total</h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount }" pattern="#,###"/></h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount_r }" pattern="#,###"/></h2></td>
            </tr>
		</table>
		</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3"><h2>The above data have been examined and are correct, hereby certified under the printed signatures with stamp.</h2></td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td colspan="3">
		<table width="460" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right">
				<table width="460" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="3" align="left"><h2>Person in Charge:&nbsp;</h2></td></tr>
					<tr><td align="left"><h2>Auditor:&nbsp;</h2></td></tr>
					<tr><td align="left"><h2>Operator:&nbsp;</h2></td></tr>
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
        			Technical Department, National Sports Lottery Ltd.
	        	</c:if>
	        	<c:if test="${applicationScope.useCompany == 2}">
	        		Technical Department, Khmer Pools Welfare Lottery Co. Ltd.
	        	</c:if>
			</h2>
			<h2>${gameDrawInfo.realColseTime }</h2>
		</td>
	</tr>
</table>
</div>
</body>
</html>
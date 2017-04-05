<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>Draw Announcement</title>
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
    <table width="1000" border="0" align="center" cellpadding="0" cellspacing="0" style="line-height:35px;" >
        <tr>
            <td colspan="3" align="right">
        	<c:if test="${applicationScope.useCompany == 1}">
        		<img src="<%=request.getContextPath() %>/img/NSL.png" width="170" height="55" />
        	</c:if>
        	<c:if test="${applicationScope.useCompany == 2}">
        		<img src="<%=request.getContextPath() %>/img/KPW.jpg" width="170" height="55" />
        	</c:if>
        </td>
        </tr>
        <tr>
            <td align="center" colspan="3"
                style="font-size: 24px; line-height: 60px; border-bottom: 2px solid #000; text-align: center;">
               "${gameDrawInfo.shortName }" Draw Announcement
                <br/>
                Issue: ${gameDrawInfo.issueNumber }
            </td>
        </tr>
        <tr height="50">
            <td colspan="3"><table width="100%" border="0" cellspacing="0"
                                   cellpadding="0">
                <tr height="40">
                    <td>Operator:${operator}</td>
                    <td align="right">${currdatetime}</td>
                </tr>
            </table></td>
        </tr>
        <tr><td colspan="3"  height="40">Total Sales Amount：<fmt:formatNumber value="${gameDrawInfo.isssueSaleAmount }" pattern="#,###"/> KHR</td></tr>
        <tr><td colspan="3"  height="40">Current Draw Numbers：</td></tr>

        <tr>
            <td colspan="3" align="center" height="">
                <table width="70%"  border="1" cellspacing="0" cellpadding="0" bordercolor="#000">
                    <tr>
                        <td align="center" width="300px" height="50">Draw Numbers</td>
                        <td align="center" height="50">${gameDrawInfo.finalDrawNumber }</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
        <tr><td colspan="4">Winning Results (currency in riels):</td></tr>
        <tr>
            <td colspan="4">
                <table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#000">
                    <tr>
                        <td align="center" width="25%" height="30">Prize Level</td>
                        <td align="center" width="25" height="30">Award Count</td>
                        <td align="center" width="25%" height="30">Winning Amount per Bet</td>
                        <td align="center" width="25%" height="30">Winning Amount Total</td>
                    </tr>

                    <c:forEach var="item" items="${drawNotice.lotteryDetails}" varStatus="status">
                        <tr>
                            <td align="center" height="50">${item.prizeLevel}</td>
                            <td align="center" height="50">${item.betCount }</td>
                            <td align="center" height="50" ><fmt:formatNumber value="${item.awardAmount }" pattern="#,###"/></td>
                            <td align="center" height="50"><fmt:formatNumber value="${item.amountTotal }" pattern="#,###"/></td>
                        </tr>
                    </c:forEach>

                </table>
            </td>
        </tr>
        <tr><td colspan="4">&nbsp;</td></tr>

        <tr height="40">
            <td width="53" align="left">Signature:</td>
            <td><div style="border-bottom:1px solid;width:150px;height: 20px">&nbsp;</div></td>
        </tr>
        <tr height="80">
            <td align="left">Approved:</td>
            <td><div style="border-bottom:1px solid;width:150px;height: 20px">&nbsp;</div></td>
        </tr>
    </table>
</div>
</body>
</html>
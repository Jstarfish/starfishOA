<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>无标题文档</title>
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
            “${gameDrawInfo.shortName }”开奖公告
            <br/>
            第${gameDrawInfo.issueNumber } 期
        </td>
    </tr>
    <tr>
        <td colspan="3"  height="50">
            <table width="100%" border="0" cellspacing="0"
                               cellpadding="0">
            <tr height="40">
                <td>操作人:${operator}</td>
                <td align="right">${currdatetime}</td>
            </tr>
        </table></td>
    </tr>
    <tr><td colspan="3" height="40">本期销售总额：<fmt:formatNumber value="${gameDrawInfo.isssueSaleAmount }" pattern="#,###"/> 瑞尔</td></tr>
    <tr><td colspan="3" height="40">本期中奖号码：</td></tr>

    <tr>
        <td colspan="3" align="center" height="">
            <table width="70%"  border="1" cellspacing="0" cellpadding="0" bordercolor="#000">
                <tr>
                    <td align="center" width="300px" height="50px">中奖号码</td>
                    <td align="center" height="50px">${gameDrawInfo.finalDrawNumber }</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td colspan="4">本期中奖结果（金额单位：瑞尔）：</td></tr>
    <tr>
        <td colspan="4">
            <table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#000">
                <tr>
                    <td align="center" width="25%" height="30">玩法</td>
                    <td align="center" width="25" height="30">中奖注数</td>
                    <td align="center" width="25%" height="30">单注中奖金额</td>
                    <td align="center" width="25%" height="30">中奖金额合计</td>
                </tr>

                <c:forEach var="item" items="${drawNotice.lotteryDetails}" varStatus="status">
                <tr>
                    <td align="center" height="50">${item.prizeLevel}</td>
                    <td align="center" height="50">${item.betCount }</td>
                    <td align="center" height="50"><fmt:formatNumber value="${item.awardAmount }" pattern="#,###"/></td>
                    <td align="center" height="50"><fmt:formatNumber value="${item.amountTotal }" pattern="#,###"/></td>
                </tr>
                </c:forEach>

            </table>
        </td>
    </tr>
    <tr><td colspan="4">&nbsp;</td></tr>

    <tr height="40">
        <td width="53" align="left">签字:</td>
        <td><div style="border-bottom:1px solid;width:150px;height: 20px">&nbsp;</div></td>
    </tr>
    <tr height="80">
        <td align="left">审核:</td>
        <td><div style="border-bottom:1px solid;width:150px;height: 20px">&nbsp;</div></td>
    </tr>
</table>
</div>
</body>
</html>
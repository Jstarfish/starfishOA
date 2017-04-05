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
<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td align="center" valign="top" colspan="3">
            <h1>“${gameDrawInfo.shortName}”开奖公告</h1>
            <br/>
            <h1>第${gameDrawInfo.issueNumber}期</h1>
        </td>
    </tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td colspan="3"><h2>本期销售总额：<fmt:formatNumber value="${drawNotice.saleAmount}" pattern="#,###"/> 瑞尔</h2></td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3"><h2>本期中奖号码：</h2></td></tr>

    <tr>
        <td colspan="3" valign="top">
            <table width="100%"  border="1" cellspacing="0" cellpadding="0" bordercolor="#000" >
                <tr>
                    <td align="center" width="70%"><h2>普通号码</h2></td>
                    <td align="center" width="30%"><h2>特别号码</h2></td>
                </tr>
                <tr>
                    <td align="center"><h2>${drawNumber1 }</h2></td>
                    <td align="center"><h2>${drawNumber2 }</h2></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr>
        <td colspan="3"><h2>本期中奖结果（金额单位：瑞尔）：</h2></td>
    </tr>
    <tr>
        <td colspan="3">
            <table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#000" id="8"  >
                <tr>
                    <td align="center"><h2>奖等</h2></td>
                    <td align="center"><h2>中奖注数</h2></td>
                    <td align="center"><h2>单注奖金</h2></td>
                    <td align="center"><h2>奖等</h2></td>
                    <td align="center"><h2>中奖注数</h2></td>
                    <td align="center"><h2>单注奖金</h2></td>
                </tr>
                <c:set var="length" value="${(fn:length(drawNotice.lotteryDetails)+1)/2}" />
                <c:forEach var="index" begin="0" end="${length - 1}">
	                <c:set var="index2"  value="${length + index}" />
	                <tr>
	                    <td align="center"><h2>${drawNotice.lotteryDetails[index].prizeLevel}</h2></td>
	                    <td align="center"><h2>${drawNotice.lotteryDetails[index].betCount}</h2></td>
	                    <td align="right"><h2><fmt:formatNumber value="${drawNotice.lotteryDetails[index].awardAmount}" pattern="#,###"/></h2></td>
	                    <td align="center"><h2>${drawNotice.lotteryDetails[index2].prizeLevel}</h2></td>
	                    <td align="center"><h2>${drawNotice.lotteryDetails[index2].betCount}</h2></td>
	                    <td align="right"><h2><fmt:formatNumber value="${drawNotice.lotteryDetails[index2].awardAmount}" pattern="#,###"/></h2></td>
	                </tr>
                </c:forEach>
                
            </table>
        </td>
    </tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr>
        <td colspan="3">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr >
                                <td colspan="4" align="left">
                                    <h2>
	                                    奖池资金累计金额 ${drawNotice.poolScroll }
	                                    瑞尔 滚入下期奖池。 <br />本期兑奖期限： ${drawNotice.overDual } 
                                    </h2>
                                    <h2>&nbsp;</h2>
                                </td>
                            </tr>
						    <tr>
						        <td colspan="4">&nbsp;</td>
						    </tr>
                            <tr>
                                <td align="left">
                                    <h2> 操作员： </h2>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <h2>负责人：  </h2>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2" align="left">
                                    <h2>&nbsp;</h2>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>无标题文档</title>
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/printStyle.css" />

<style type="text/css">

</style>
<script type="text/javascript">

function exportPdf() {
    //var html = document.documentElement.outerHTML;
    var html = printDiv.innerHTML;

    var input1 = document.createElement("input");
    input1.type = "hidden";
    input1.name = "htmlStr";
    input1.value = encodeURIComponent(html);

    var form1 = document.createElement("form");
    form1.appendChild(input1);
    //document.body.appendChild(form1);
    form1.action = "export.do";
    form1.method="post";
    form1.submit();

}


</script>

</head>


<body class="body">
<div style="height:30px;">
<span class="print" onclick="exportPdf()"><a href="#">打印</a></span>
</div>
<div id="printDiv">
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0" style="line-height:35px;">
    
    <tr>
        <td align="center" valign="top" colspan="3">
            <h1>国家体育彩票“${gameDrawInfo.shortName }”开奖公告</h1>
            <br/>
            <h1>第${gameDrawInfo.issueNumber } 期</h1>
        </td>
    </tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td colspan="3"><h2 style="line-height:25px">本期销售总额：<fmt:formatNumber value="${gameDrawInfo.isssueSaleAmount }" pattern="#,###"/> 瑞尔</h2></td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3"><h2 style="line-height:25px">本期中奖号码：</h2></td></tr>

    <tr>
        <td colspan="3" valign="top" height="">
            <table width="100%"  border="1" cellspacing="0" cellpadding="0" bordercolor="#000">
                <tr><td align="center"><h2 style="line-height:25px">${gameDrawInfo.finalDrawNumber }</h2></td></tr>
            </table>
        </td>
    </tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td colspan="3"><h2 style="line-height:25px">本期中奖结果（金额单位：瑞尔）：</h2></td></tr>
    <tr>
        <td colspan="3">
            <table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#000">
                <tr>
                    <td align="center" width="*%"><h2 style="line-height:25px">奖等</h2></td>
                    <td align="center" width="20%"><h2 style="line-height:25px">中奖注数</h2></td>
                    <td align="center" width="30%"><h2 style="line-height:25px">单注中奖金额</h2></td>
                </tr>

                <c:forEach var="item" items="${drawNotice.lotteryDetails}" varStatus="status">
                <tr>
                    <td align="center"><h2 style="line-height:25px">${item.prizeLevel }</h2></td>
                    <td align="center"><h2 style="line-height:25px">${item.betCount }</h2></td>
                    <td align="right"><h2 style="line-height:25px"><fmt:formatNumber value="${item.awardAmount }" pattern="#,###"/></h2></td>
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
                            <tr>
                                <td colspan="4" align="left">
                                    <h2 style="line-height:25px">本期兑奖期限：${drawNotice.overDual }</h2>
                                    <h2 style="line-height:25px">&nbsp;</h2>
                                </td>
                            </tr>
						    <tr><td colspan="4">&nbsp;</td></tr>
                            <tr>
                                <td align="left"><h2 style="line-height:25px">操作人：</h2></td>
                                <td align="left"><h2 style="line-height:25px">负责人：</h2></td>
                            </tr>
                            <tr><td colspan="2" align="left">&nbsp;</td></tr>
                            <tr><td colspan="2" align="left"><h2 style="line-height:25px">&nbsp;</h2></td></tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td align="right" colspan="3">
            <h2 style="line-height:25px">国家体育彩票公司技术部</h2>
            <h2 style="line-height:25px">${gameDrawInfo.issueEndTime } </h2>
        </td>
    </tr>
</table>
</div>
</body>
</html>
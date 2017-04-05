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
<span class="print" onclick="exportPdf()"><a href="#">Print</a></span>
</div>
<div id="printDiv">
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td align="center" valign="top" colspan="3">
            <h1>National Sports Lottery "${gameDrawInfo.shortName}" Draw Announcement</h1>
            <br/>
            <h1>Issue${gameDrawInfo.issueNumber}</h1>
        </td>
    </tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td align="center" valign="top" colspan="3">&nbsp; </td></tr>
    <tr><td colspan="3"><h2>Total Sales Amount:&nbsp;<fmt:formatNumber value="${drawNotice.saleAmount}" pattern="#,###"/> &nbsp;riels</h2></td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3"><h2>Draw Numbers:&nbsp;</h2></td></tr>

    <tr>
        <td colspan="3" valign="top">
            <table width="100%"  border="1" cellspacing="0" cellpadding="0" bordercolor="#000" >
                <tr>
                    <td align="center" width="70%"><h2>Basic Numbers</h2></td>
                    <td align="center" width="30%"><h2>Special Number</h2></td>
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
        <td colspan="3"><h2>Winning Results (currency in riels):&nbsp;</h2></td>
    </tr>
    <tr>
        <td colspan="3">
            <table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#000" id="8"  >
                <tr>
                    <td align="center"><h2>Prize Level</h2></td>
                    <td align="center"><h2>Bets</h2></td>
                    <td align="center"><h2>Prize Per Bet</h2></td>
                    <td align="center"><h2>Prize Level</h2></td>
                    <td align="center"><h2>Bets</h2></td>
                    <td align="center"><h2>Prize Per Bet</h2></td>
                </tr>
                <c:set var="length"  value="${fn:length(drawNotice.lotteryDetails)/2}" />
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
	                                    The cumulative pool amount&nbsp; ${drawNotice.poolScroll }
	                                    &nbsp;shall be rolled to the next issue.<br />Payout Period: ${drawNotice.overDual } 
                                    </h2>
                                    <h2>&nbsp;</h2>
                                </td>
                            </tr>
						    <tr>
						        <td colspan="4">&nbsp;</td>
						    </tr>
                            <tr>
                                <td align="left">
                                    <h2> Operator:&nbsp; </h2>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <h2>Person in charge:&nbsp;  </h2>
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

    <tr>
        <td align="right" colspan="3">
			<h2>Technical Department, National Sports Lottery Ltd.</h2>
			<h2>${gameDrawInfo.issueEndTime } </h2>
        </td>
    </tr>
</table>
</div>
</body>
</html>
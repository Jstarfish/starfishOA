<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
    <link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
    <title>无标题文档</title>
    <style>
        body {
            font-family: "Times New Roman", Times, serif, "微软雅黑";
        }
    </style>
    <script type="text/javascript">
        function exportPdf() {

            $("#printDiv").jqprint();
        }
    </script>
</head>

<body>
<div style="margin:10px 70px; float:right;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>

                <button class="report-print-button" type="button" onclick="exportPdf();">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td><img src="views/inventory/goodsReceipts/images/printx.png" width="18" height="17"/></td>
                            <td style="color: #fff;">Print</td>
                        </tr>
                    </table>
                </button>

            </td>
        </tr>
    </table>
</div>


<div id="printDiv">
    <table width="1000" border="0" cellspacing="0" cellpadding="0"
           align="center" class="normal" style="margin: 30px 20px 0px 60px;">
        <tr>
            <td colspan="3" align="right"><img src="views/inventory/goodsReceipts/images/KPW.jpg" width="170"
                                               height="55"/></td>
        </tr>

        <tr>
            <td colspan="3"
                style="font-size: 24px; line-height: 60px; border-bottom: 2px solid #000; text-align: center;">Ticket Inquiry
            </td>
        </tr>
        <tr height="50">
            <td colspan="3">
                <table width="100%" border="0" cellspacing="0"
                       cellpadding="0">
                    <tr height="60">
                        <td>Operator:${operator}</td>
                        <td align="right">${currdatetime}</td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr>
            <td>
                <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                    <tr height="50" align="center">
                        <td colspan="3">Ticket Message</td>
                    </tr>
                    <tr height="50">
                        <td colspan="3">Ticket No.: ${tsn}</td>
                    </tr>
                    <tr height="50" height="50">
                        <td width="36%">Terminal Code for Sales: ${centerSelectReq.sale_termCode }</td>
                        <td width="37%">Teller Code for Sales: ${centerSelectReq.sale_tellerCode }</td>
                        <td width="27%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    </tr>
                    <tr height="50">
                        <td>Game:${centerSelectReq.gameName}</td>
                        <td>Game Code:${centerSelectReq.gameCode}</td>
                        <td><!--
                         -->Issue:
                            <c:choose>
                                <c:when test="${!empty centerSelectReq.startIssueNumber}">${centerSelectReq.startIssueNumber}</c:when>
                                <c:when test="${!empty centerSelectReq.startIssueNumber && !empty centerSelectReq.lastIssueNumber}"><!--
                                    -->${centerSelectReq.startIssueNumber}-${centerSelectReq.lastIssueNumber}
                                </c:when>
                            </c:choose><!--
                     --></td>
                    </tr>
                    <tr height="50">
                        <td>Issues Bought:${centerSelectReq.periods}</td>
                        <td>Number of Bet Lines:${centerSelectReq.bettinglinenumber}</td>
                        <td>Ticket Amount:<fmt:formatNumber value="${centerSelectReq.tickAmount}" pattern="#,###"/></td>
                    </tr>
                </table>

                <p>
                    <c:if test="${!empty centerSelectReq.betlist}">
                <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
                    <tr height="50" style="background:#2aa1d9; ">
                        <td align="center" width="10%">Game Subtype</td>
                        <td align="center" width="16%">Betting</td>
                        <td align="center" width="45%">Bet Numbers</td>
                        <td align="center" width="13%">Multiple</td>
                    </tr>
                    <c:forEach items="${centerSelectReq.betlist}" var="be">
                        <tr height="50">
                            <td align="center">${be.play}</td>
                            <td align="center">${be.bet}</td>
                            <td align="center">${be.bettingnumber}</td>
                            <td align="center">${be.multiple}</td>
                        </tr>
                    </c:forEach>
                </table>
                </c:if>
                </p></td>
        </tr>
        <tr>
            <td height="10px"></td>
        </tr>
        <tr>
            <td>
                <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                    <tr height="50">
                        <td class="bt" colspan="3" align="center">Training Ticket Information</td>
                    </tr>
                    <tr height="50">
                        <td width="36%"><!--
                         -->Training Ticket:
                            <c:choose>
                                <c:when test="${centerSelectReq.isTrain ==1}">Yes</c:when>
                                <c:otherwise>No</c:otherwise>
                            </c:choose><!--
                     --></td>
                        <td width="37%"><!--
                         -->Ticket  Source:
                            <c:choose>
                                <c:when test="${centerSelectReq.from_sale==1}">Terminal</c:when>
                                <c:when test="${centerSelectReq.from_sale==2}">Website</c:when>
                                <c:when test="${centerSelectReq.from_sale==3}">Mobile phone</c:when>
                                <c:when test="${centerSelectReq.from_sale==4}">Handset POS machine</c:when>
                            </c:choose><!--
                     --></td>
                        <td width="27%">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr>
            <td height="20px"></td>
        </tr>

        <tr>
            <td>
                <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                    <tr height="50">
                        <td class="bt" colspan="3" align="center">Winning Information</td>
                    </tr>
                    <tr height="50">
                        <td width="36%"><!--
                     -->Big Prize:
                            <c:choose>
                                <c:when test="${centerSelectReq.isBigPrize==0}">No</c:when>
                                <c:when test="${centerSelectReq.isBigPrize==1}">Yes</c:when>
                            </c:choose><!--
                 --></td>
                        <td width="37%">Winning Before Tax: <fmt:formatNumber value="${centerSelectReq.amountBeforeTax}"
                                                                    pattern="#,###"/></td>
                        <td width="27%">&nbsp;</td>
                    </tr>
                    <tr height="50">
                        <td>Tax:<fmt:formatNumber value="${centerSelectReq.taxAmount}" pattern="#,###"/></td>
                        <td> Winning After Tax: <fmt:formatNumber value="${centerSelectReq.amountAfterTax}"
                                                         pattern="#,###"/></td>
                        <td>&nbsp; </td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr>
            <td height="20px"></td>
        </tr>

        <c:if test="${centerSelectReq.isPayed==1}">
            <tr>
                <td>
                    <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
                        <tr>
                            <td class="bt"  colspan="3" align="center">Payout Information</td>
                        </tr>

                        <tr height="50">
                            <td width="36%"><!--
                             -->Paid:
                                <c:choose>
                                    <c:when test="${centerSelectReq.isPayed==0}">Not Paid</c:when>
                                    <c:when test="${centerSelectReq.isPayed==1}">Paid</c:when>
                                </c:choose><!--
                         --></td>
                            <td width="37%"><!--
                             -->Big Prize: <c:choose>
                                <c:when test="${centerSelectReq.isBigPrize==0}">No</c:when>
                                <c:when test="${centerSelectReq.isBigPrize==1}">Yes</c:when>
                            </c:choose><!--
                         --></td>
                            <td width="27%"><!--
                             -->Payout Time:
                                <fmt:formatDate value="${centerSelectReq.pay_timeformat}" pattern="yyyy-MM-dd HH:mm:ss"/><!--
                         --></td>
                        </tr>
                        <tr height="50">
                            <td>Name: ${centerSelectReq.customName}</td>
                            <td><!--
                             -->Certificate Type:
                                <c:choose>
                                    <c:when test="${centerSelectReq.cardType ==1}">ID Card</c:when>
                                    <c:when test="${centerSelectReq.cardType ==2}">Passport</c:when>
                                    <c:when test="${centerSelectReq.cardType ==3}">Officer Card</c:when>
                                    <c:when test="${centerSelectReq.cardType ==4}">Soldier Card</c:when>
                                    <c:when test="${centerSelectReq.cardType ==5}">Home-Visit Permit</c:when>
                                    <c:when test="${centerSelectReq.cardType ==9}">Other Certificate</c:when>
                                </c:choose><!--
                         --></td>
                            <td>Certificate Code: ${centerSelectReq.cardCode}</td>
                        </tr>
                        <tr height="50">
                            <td>Terminal Code for Payout: ${centerSelectReq.pay_termCode}</td>
                            <td>Teller Code for Payout: ${centerSelectReq.pay_tellerCode}</td>
                            <td></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </c:if>

        <tr>
            <td height="20px"></td>
        </tr>

        <c:if test="${not empty centerSelectReq.prizes}">
            <tr>
                <td>
                    <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
                        <tr height="50" style="background:#2aa1d9;">
                            <td align="center">Prize Code</td>
                            <td align="center">Prize Name</td>
                            <td align="center">Winning Bets</td>
                            <td align="center">Winning Amount per Bet</td>
                        </tr>
                        <c:forEach items="${centerSelectReq.prizes}" var="prize">
                            <tr height="50">
                                <td align="center">${prize.prizeCode}</td>
                                <td align="center">${prize.prizeName}</td>
                                <td align="center"> ${prize.betCount} </td>
                                <td align="center"><fmt:formatNumber value="${prize.prizeAmount}" pattern="#,###"/></td>
                            </tr>
                        </c:forEach>
                    </table>
                </td>
            </tr>
        </c:if>

        <tr>
            <td height="20px"></td>
        </tr>

        <c:if test="${centerSelectReq.isCancel==1}">
            <tr>
                <td>
                    <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
                        <tr height="50">
                            <td class="bt" colspan="3" align="center">Refund Information</td>
                        </tr>
                        <tr height="50">
                            <td width="36%">Terminal Code for Refund: ${centerSelectReq.cancel_termCode}</td>
                            <td width="37%">Teller Code for Refund: ${centerSelectReq.cancel_tellerCode}</td>
                            <td width="27%">Refund Time:
                                <fmt:formatDate value="${centerSelectReq.cancel_timeformat}"
                                                pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </c:if>

    </table>
</div>
</body>
</html>
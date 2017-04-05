<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/printStyle.css" />
    <script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>
    <link href="${basePath}/css/gm-st-css.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
    <title>Delivery Issue Slip</title>
    <script type="text/javascript">
        function exportPdf() {

            $("#printDiv").jqprint();
        }
        function check() {
            var ss = '${expirydateForm.carId }';

            var str = ss.substring(0, 1) + " " + ss.substring(1, 5) + " " + ss.substring(5, 10) + " " + ss.substring(10, 12) + " " + ss.substring(12, 13);
            $("#cadId").html(str);

        }
    </script>
</head>

<body onload="check();">

<div style="margin:10px 70px; float:right;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td align="right">

                <button class="report-print-button" type="button" onclick="exportPdf();">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td><img src="<%=request.getContextPath() %>/img/icon-printer.png" width="18" height="17"/></td>
                            <td style="color: #fff;">Print</td>
                        </tr>
                    </table>
                </button>

            </td>
        </tr>
    </table>
</div>
<div id="printDiv">
    <table width="1000" cellspacing="0" cellpadding="0" align="center">
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
            <table width="1000" border="0" cellspacing="0" cellpadding="0" align="center" class="normal">
                <tr>
                    <td colspan="6" align="center" style="font-size:24px;text-align: center; line-height:50px;border-bottom: 2px solid #000;">Company Payout Claiming
                        Form
                    </td>
                </tr>

                <tr height="40">
                    <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="40">Payout Record No.：${id}</td>
                            <td align="right"  height="40">Payout Date：${currdatetime}</td>
                        </tr>
                        <tr>
                            <td height="40">Operator：${operator}</td>
                        </tr>
                        <tr>
                            <td height="40">Unit：KHR</td>
                        </tr>
                    </table></td>

                </tr>

                <tr>
                    <td colspan="3" style="padding:20px 0;">
                        <table width="1000" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
                            <tr align="center" height="80">

                                <td width="126">Name</td>
                                <td width="269">${expirydateForm.name }</td>
                                <td width="129">Certificate ID</td>
                                <td width="144">
                                    <div id="cadId"></div>
                                </td>
                                <td width="142">Ticket No.：</td>
                                <td width="176">${expirydateForm.tsnquery}</td>
                            </tr>

                            <tr align="center" height="80">

                                <td width="126">Game</td>
                                <td width="269">${expirydateForm.playname}</td>
                                <td width="129">Issue</td>
                                <td width="144">
                                    <c:choose>
                                        <c:when test="${empty expirydateForm.issuenumbrend}">
                                            ${expirydateForm.issuenumber }
                                        </c:when>
                                        <c:when test="${!empty expirydateForm.issuenumbrend}">
                                            <c:if test="${expirydateForm.issuenumber==expirydateForm.issuenumbrend}">
                                                ${expirydateForm.issuenumber }
                                            </c:if>
                                            <c:if test="${expirydateForm.issuenumber!=expirydateForm.issuenumbrend}">
                                                ${expirydateForm.issuenumber }-${expirydateForm.issuenumbrend}
                                            </c:if>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td width="142">Institution</td>
                                <td width="176">${expirydateForm.agencyCodeFormart}</td>
                            </tr>
                            <tr align="left" height="80">
                                <td colspan="1" align="center">Bet Number</td>
                                <td colspan="5" align="center"><c:if test="${not empty lotteryReq.betlist}">
                                    <c:forEach var="bet" items="${lotteryReq.betlist}">
                                        ${bet.bettingnumber}
                                    </c:forEach>
                                </c:if></td>
                            </tr>
                            <tr align="center" height="80">

                                <td>Prize Levels</td>
                                <td>Winning Bets</td>
                                <td>Cost Per Bet</td>
                                <td>Total Award</td>
                                <td>Tax</td>
                                <td>Actual Award</td>
                            </tr>
                            <c:if test="${not empty lotteryReq.prizeDetail}">
                                <c:forEach var="prize" items="${lotteryReq.prizeDetail}">
                                    <tr align="center" height="80">
                                        <td>${prize.name }</td>
                                        <td>${prize.count }</td>
                                        <td><fmt:formatNumber value="${prize.amountSingle}" pattern="#,###"/></td>
                                        <td class="gm-sty-dj-right"><fmt:formatNumber value="${prize.amountBeforeTax}"
                                                                                      pattern="#,###"/></td>
                                        <td><fmt:formatNumber value="${prize.amountTax}" pattern="#,###"/></td>
                                        <td class="gm-sty-dj-right"><fmt:formatNumber value="${prize.amountAfterTax}"
                                                                                      pattern="#,###"/></td>
                                    </tr>
                                </c:forEach>
                            </c:if>


                            <tr align="left" height="80">
                                <td colspan="5" style="padding:10px;">Total:</td>
                                <td colspan="1" align="center" style="padding:10px;"><fmt:formatNumber
                                        value="${sumprize}" pattern="#,###"/></td>
                            </tr>
                            <tr align="left" height="80">
                                <td colspan="6" style="padding:10px;">Remark: 1. The receipt is valid only if stamped.
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr height="80">
                    <td width="53" align="left">Operator：</td>
                    <td width="897">
                        <div style="border-bottom:1px solid;width:150px;">&nbsp;</div>
                    </td>
                </tr>
                <tr height="80">
                    <td align="left">Approver：</td>
                    <td>
                        <div style="border-bottom:1px solid;width:150px;">&nbsp;</div>
                    </td>
                </tr>
            </table>

        </tr>

    </table>
</div>


</body>
</html>
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
                            <td style="color: #fff;">打印</td>
                        </tr>
                    </table>
                </button>

            </td>
        </tr>
    </table>
</div>


<div id="printDiv">
    <table width="1000" border="0" cellspacing="0" cellpadding="0"
           align="center">
        <tr>
            <td colspan="3" align="right"><img src="views/inventory/goodsReceipts/images/KPW.jpg" width="170"
                                               height="55"/></td>
        </tr>

        <tr>
            <td colspan="3"
                style="font-size: 24px; line-height: 60px; border-bottom: 2px solid #000; text-align: center;">彩票查询
            </td>
        </tr>
        <tr height="50">
            <td colspan="3">
                <table width="100%" border="0" cellspacing="0"
                       cellpadding="0">
                    <tr height="60">
                        <td>操作人:${operator}</td>
                        <td align="right">${currdatetime}</td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr>
            <td>
                <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                    <tr height="50" align="center">
                        <td colspan="3">彩票信息</td>
                    </tr>
                    <tr height="50">
                        <td colspan="3">彩票票号: ${tsn}</td>
                    </tr>
                    <tr height="50" height="50">
                        <td width="36%">售票终端编码: ${centerSelectReq.sale_termCode }</td>
                        <td width="37%">售票销售员编码: ${centerSelectReq.sale_tellerCode }</td>
                        <td width="27%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    </tr>
                    <tr height="50">
                        <td>游戏名称:${centerSelectReq.gameName}</td>
                        <td>游戏编码:${centerSelectReq.gameCode}</td>
                        <td><!--
                         -->销售期号:
                            <c:choose>
                                <c:when test="${!empty centerSelectReq.startIssueNumber}">${centerSelectReq.startIssueNumber}</c:when>
                                <c:when test="${!empty centerSelectReq.startIssueNumber && !empty centerSelectReq.lastIssueNumber}"><!--
                                    -->${centerSelectReq.startIssueNumber}-${centerSelectReq.lastIssueNumber}
                                </c:when>
                            </c:choose><!--
                     --></td>
                    </tr>
                    <tr height="50">
                        <td>购买期数:${centerSelectReq.periods}</td>
                        <td>投注行数目:${centerSelectReq.bettinglinenumber}</td>
                        <td>票面总金额:<fmt:formatNumber value="${centerSelectReq.tickAmount}" pattern="#,###"/></td>
                    </tr>
                </table>

                <p>
                   <c:if test="${!empty centerSelectReq.betlist}">
                    <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
                        <tr height="50" style="background:#2aa1d9; ">
                            <td align="center" width="10%">玩法</td>
                            <td align="center" width="16%">投注方式</td>
                            <td align="center" width="45%">投注号码区</td>
                            <td align="center" width="13%">倍数</td>
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
                        <td class="bt" colspan="3" align="center">培训票信息</td>
                    </tr>
                    <tr height="50">
                        <td width="36%"><!--
                         -->是否是培训票:
                            <c:choose>
                                <c:when test="${centerSelectReq.isTrain ==1}">是</c:when>
                                <c:otherwise>否</c:otherwise>
                            </c:choose><!--
                     --></td>
                        <td width="37%"><!--
                         -->票面来源:
                            <c:choose>
                                <c:when test="${centerSelectReq.from_sale==1}">终端机</c:when>
                                <c:when test="${centerSelectReq.from_sale==2}">网站</c:when>
                                <c:when test="${centerSelectReq.from_sale==3}">手机</c:when>
                                <c:when test="${centerSelectReq.from_sale==4}">手持POS机</c:when>
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
                        <td class="bt" colspan="3" align="center">中奖信息</td>
                    </tr>
                    <tr height="50">
                        <td width="36%"><!--
                     -->是否是大奖:
                            <c:choose>
                                <c:when test="${centerSelectReq.isBigPrize==0}">否</c:when>
                                <c:when test="${centerSelectReq.isBigPrize==1}">是</c:when>
                            </c:choose><!--
                 --></td>
                        <td width="37%">中奖金额(税前): <fmt:formatNumber value="${centerSelectReq.amountBeforeTax}"
                                                                    pattern="#,###"/></td>
                        <td width="27%">&nbsp;</td>
                    </tr>
                    <tr height="50">
                        <td>税金:<fmt:formatNumber value="${centerSelectReq.taxAmount}" pattern="#,###"/></td>
                        <td> 中奖金额(税后): <fmt:formatNumber value="${centerSelectReq.amountAfterTax}"
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
                            <td class="bt"  colspan="3" align="center">兑奖信息</td>
                        </tr>

                        <tr height="50">
                            <td width="36%"><!--
                             -->是否已兑奖:
                                <c:choose>
                                    <c:when test="${centerSelectReq.isPayed==0}">未兑奖</c:when>
                                    <c:when test="${centerSelectReq.isPayed==1}">已兑奖</c:when>
                                </c:choose><!--
                         --></td>
                            <td width="37%"><!--
                             -->是否是大奖: <c:choose>
                                <c:when test="${centerSelectReq.isBigPrize==0}">否</c:when>
                                <c:when test="${centerSelectReq.isBigPrize==1}">是</c:when>
                            </c:choose><!--
                         --></td>
                            <td width="27%"><!--
                             -->兑奖时间:
                                <fmt:formatDate value="${centerSelectReq.pay_timeformat}" pattern="yyyy-MM-dd HH:mm:ss"/><!--
                         --></td>
                        </tr>
                        <tr height="50">
                            <td>姓名: ${centerSelectReq.customName}</td>
                            <td><!--
                             -->证件类型:
                                <c:choose>
                                    <c:when test="${centerSelectReq.cardType ==1}">身份证</c:when>
                                    <c:when test="${centerSelectReq.cardType ==2}">护照</c:when>
                                    <c:when test="${centerSelectReq.cardType ==3}">军官证</c:when>
                                    <c:when test="${centerSelectReq.cardType ==4}">士兵证</c:when>
                                    <c:when test="${centerSelectReq.cardType ==5}">回乡证</c:when>
                                    <c:when test="${centerSelectReq.cardType ==9}">其他证件</c:when>
                                </c:choose><!--
                         --></td>
                            <td>证件号码: ${centerSelectReq.cardCode}</td>
                        </tr>
                        <tr height="50">
                            <td>兑奖终端编码: ${centerSelectReq.pay_termCode}</td>
                            <td>兑奖销售员编码: ${centerSelectReq.pay_tellerCode}</td>
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
                            <td align="center">奖级编号</td>
                            <td align="center">奖等名称</td>
                            <td align="center">中奖注数</td>
                            <td align="center">单注中奖金额</td>
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
                            <td class="bt" colspan="3" align="center">退票信息</td>
                        </tr>
                        <tr height="50">
                            <td width="36%">退票终端编码: ${centerSelectReq.cancel_termCode}</td>
                            <td width="37%">退票销售员编码: ${centerSelectReq.cancel_tellerCode}</td>
                            <td width="27%">退票时间:
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
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>无标题文档</title>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/printStyle.css"/>
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
<div style="height:30px;">
    <span class="print" onclick="exportPdf()"><a href="#">Print</a></span>
</div>
<div id="printDiv">
    <table width="1000" border="0" cellspacing="0" cellpadding="0" align="center" class="normal">

        <tr>
            <td colspan="3" style="font-size: 24px;
	 line-height: 80px;
     border-bottom:2px solid #000;
	font-weight: bold;
	 text-align:center;">FBS Lottery Draw Notice
            </td>
        </tr>
        <tr style="text-align:center;" height="20"></tr>
        <tr height="50" style="text-align:center; font-size:20px;">
            <td colspan="3">
                <p>Issue:${issueCode} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Match:${matchCode} </p>
            </td>
        </tr>
        <tr style="text-align:center;font-size:20px;" height="50">
            <td colspan="3">
                <p>${matchStr}</p>
                <p>310 Handicap:${fbsmatch.score310}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;30 Handicap:${fbsmatch.score30}</p>
            </td>
        </tr>
        <tr style="text-align:center;" height="30"></tr>
        <tr>
            <td colspan="3" style="padding:20px 0;">
                <table width="1000" border="1" align="center" cellpadding="0" cellspacing="0" class="normal">
                    <tr align="center" height="60">
                        <td width="498">Subtype</td>
                        <td width="496">Result</td>
                        <td width="498">Sale Amount</td>
                        <td width="496">Award Amount</td>
                        <td width="496">SP Value</td>
                    </tr>
                    <c:forEach var="data" items="${fbsMatchDraw}" varStatus="status">
                        <tr align="center" height="60">
                            <td>
                                <c:if test="${data.matchSubTypeCode==1}">
                                    Winner
                                </c:if>
                                <c:if test="${data.matchSubTypeCode==2}">
                                    Handicap
                                </c:if>
                                <c:if test="${data.matchSubTypeCode==3}">
                                    Totals Goal
                                </c:if>
                                <c:if test="${data.matchSubTypeCode==4}">
                                    Score
                                </c:if>
                                <c:if test="${data.matchSubTypeCode==5}">
                                    Half/Full Time Pool
                                </c:if>
                                <c:if test="${data.matchSubTypeCode==6}">
                                    OUOD
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${data.matchSubTypeCode==3}">
                                    <c:if test="${data.matchResultEnum == 99}">
                                        -
                                    </c:if>
                                    <c:if test="${data.matchResultEnum == 8}">
                                        7+
                                    </c:if>
                                    <c:if test="${data.matchResultEnum != 8 and data.matchResultEnum != 99}">
                                        ${data.matchResult}
                                    </c:if>
                                </c:if>
                                <c:if test="${data.matchSubTypeCode==4}">
                                    <c:if test="${data.matchResultEnum == 99}">
                                        -
                                    </c:if>
                                    <c:if test="${data.matchResultEnum == 10}">
                                        Home Win Other
                                    </c:if>
                                    <c:if test="${data.matchResultEnum == 15}">
                                        Draw Other
                                    </c:if>
                                    <c:if test="${data.matchResultEnum == 25}">
                                        Away Win Other
                                    </c:if>
                                    <c:if test="${data.matchResultEnum !=10
                                                        and data.matchResultEnum !=15
                                                        and data.matchResultEnum !=25
                                                         and data.matchResultEnum != 99}">
                                        ${data.matchResult}
                                    </c:if>
                                </c:if>
                                <c:if test="${data.matchSubTypeCode!=6
                                                    and data.matchSubTypeCode!=4
                                                    and data.matchSubTypeCode!=3}">
                                    <c:if test="${data.matchResultEnum == 99}">
                                        -
                                    </c:if>
                                    <c:if test="${data.matchResultEnum != 99}">
                                        ${data.matchResult}
                                    </c:if>
                                </c:if>
                                <c:if test="${data.matchSubTypeCode==6}">
                                    <c:if test="${data.matchResultEnum ==99}">
                                        -
                                    </c:if>
                                    <c:if test="${data.matchResultEnum ==1}">
                                        Over Odd
                                    </c:if>
                                    <c:if test="${data.matchResultEnum ==2}">
                                        Over Even
                                    </c:if>
                                    <c:if test="${data.matchResultEnum ==3}">
                                        Under Odd
                                    </c:if>
                                    <c:if test="${data.matchResultEnum ==4}">
                                        Under Even
                                    </c:if>
                                </c:if>
                            </td>
                            <td>${data.betAmount}</td>
                            <td>${data.winAmount}</td>
                            <td><fmt:formatNumber type="number" value="${data.refSPValue>1?(data.refSPValue-0.004):(data.refSPValue)}" pattern="0.00" maxFractionDigits="2"/></td>
                        </tr>
                    </c:forEach>
                </table>
            </td>
        </tr>
        <tr style="text-align:center;" height="20"></tr>
        <tr height="80">
            <td width="60" align="left">Signature:</td>
            <td width="953">
                <div style="border-bottom:1px solid;width:150px;">&nbsp;</div>
            </td>
        </tr>
        <tr height="80">
            <td width="60" align="left">Review:</td>
            <td>
                <div style="border-bottom:1px solid;width:150px;">&nbsp;</div>
            </td>
        </tr>
        <tr height="100">
            <td align="left"></td>
            <td align="right">Nation Sport Center Ministry of Technology</td>

        </tr>
    </table>
</div>
</body>
</html>
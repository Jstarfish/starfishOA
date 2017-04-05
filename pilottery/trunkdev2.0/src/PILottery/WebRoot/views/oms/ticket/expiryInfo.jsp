<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>

<html>
<head>
    <title>游戏开奖</title>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css"/>
    <script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>

    <style type="text/css">

    </style>
    <script type="text/javascript">
        <c:if test="${not empty reservedSuccessMsg}">
        alert("${reservedSuccessMsg}");
        </c:if>

        function doSubmit() {
            document.expirydateForm.submit();

        }

    </script>
</head>

<body>
<form action="centerSelect.do?method=printinit" method="post" id="expirydateForm" name="expirydateForm">
    <input type="hidden" name="carId" value="${info.id}"/>
    <div id="title">Payout at Center</div>
    <div id="mainDiv">
        <div class="jdt" style="background: url(views/oms/game-draw/img/zxdjbj-3.png) no-repeat left top;">
        </div>
        <div class="xd" style="width:650px">
            <span>1.Ticket Inquiry</span>
            <span>2.Winning Data Entry</span>
            <span class="zi">3.Winning Information</span>
            <span style="margin-left: 20px;">4.Print Payout Form</span>
        </div>
        <div class="CPage">
            <table width="900" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="820" align="left" valign="middle">
                        <div class="tab">
                            <c:choose>
                                <c:when test="${status==0 && winningamount>0}">
                                    <table border="1" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td colspan="6" class="tit">
                                                <span style="font-size: 24px;">3.Winning Informaion</span>
                                            </td>

                                        </tr>
                                        <tr height="60px">
                                            <td colspan="6" valign="top">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td style="text-align: right;height: 30px;width: 100px" class="lz">Game：</td>
                                                        <td style="text-align: left;height: 30px">${info.playname}</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right;height: 30px;width: 100px" class="lz">Issue：</td>
                                                        <td style="text-align: left;height: 30px">${info.issueNumber}</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right;height: 30px;width: 100px" class="lz">TSN：</td>
                                                        <td style="text-align: left;height: 30px">${info.saleTsn}</td>
                                                    </tr>
                                                </table>
                                                    <%--<span style="color:#000">
                                                    Game：${info.playname} <br/>
                                                    Issue：${info.issueNumber } <br/>
                                                    TSN：${info.saleTsn }</span>--%>
                                            </td>
                                        </tr>
                                        <c:if test="${not empty lotteryReq.prizeDetail}">
                                            <tr class="biaot">
                                                <th>Prize Levels</th>
                                                <th>Winning Bets</th>
                                                <th>Cost Per Bet</th>
                                                <th>Total Award</th>
                                                <th>Tax</th>
                                                <th>Actual Award</th>
                                            </tr>
                                            <c:forEach var="prize" items="${lotteryReq.prizeDetail}">
                                                <tr class="jjzi">
                                                    <td class="tabxian-td">${prize.name}</td>
                                                    <td class="tabxian-td">${prize.count}</td>
                                                    <td class="tabxian-td"><fmt:formatNumber
                                                            value="${prize.amountSingle}" pattern="#,###"/></td>
                                                    <td class="tabxian-td"><fmt:formatNumber
                                                            value="${prize.amountBeforeTax}" pattern="#,###"/></td>
                                                    <td class="tabxian-td"><fmt:formatNumber value="${prize.amountTax}"
                                                                                             pattern="#,###"/></td>
                                                    <td class="tabxian-td"><fmt:formatNumber
                                                            value="${prize.amountAfterTax}" pattern="#,###"/></td>
                                                </tr>
                                            </c:forEach>
                                        </c:if>
                                    </table>
                                </c:when>

                            </c:choose>
                        </div>

                    </td>
                    <td align="right">
                        <c:if test="${status==0 && winningamount>0}">
                            <img id="nextBtn" onclick="doSubmit()" src="views/oms/game-draw/img/right-hover.png"
                                 alt="Next"/>
                        </c:if>
                    </td>
                </tr>
                <tr height="60"></tr>
            </table>
        </div>

    </div>

</form>
</body>
</html>
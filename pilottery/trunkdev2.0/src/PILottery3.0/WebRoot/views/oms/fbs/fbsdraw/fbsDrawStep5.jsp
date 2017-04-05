<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>Fbs Match Draw</title>
    <%@ include file="/views/common/meta.jsp" %>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css"/>

    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>

    <script type="text/javascript">
        function reDraw() {
            location.href = "fbsDraw.do?method=reDrawSteps&matchCode=" +${fbsMatch.matchCode};
        }

        function toFinish() {
            $('#confirm').attr("disabled","disabled");
            location.href = "fbsDraw.do?method=finishDrawSteps&matchCode=" + ${fbsMatch.matchCode} +"&issueCode=" +${fbsMatch.matchIssue};
        }
    </script>
</head>
<body>
<div id="title">Show Result</div>
<div id="mainDiv">
    <div class="jdt"
         style="background: url(views/oms/fbs/fbsdraw/img/fbsbj-5.png) no-repeat left top;width:850px;"></div>
    <div class="xd" style="width:850px">
        <span style="margin-left: 30px;">1.Type In Result</span>
        <span style="margin-left: 25px;">2.Wait For Result</span>
        <span style="margin-left: 25px;">3.Show Result</span>
        <span style="margin-left: 25px;">4.Drawing</span>
        <span class="zi" style="margin-left: 25px;">5.Show Result</span>
        <span style="margin-left: 25px;">6.Finish</span>
    </div>

    <div class="CPage">
        <table width="80%" border="0" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td align="left" valign="middle">
                    <div class="tab" style="height:600px;">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" class="tabxian">
                            <tbody>
                            <tr>
                                <td class="tit"><span style="font-size: 24px;">5.Show Result </span></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="90%" align="center" cellpadding="0" cellspacing="0">
                                        <tbody>
                                        <tr>
                                            <td width="11%" height="30px" class="lzx">
                                                <div align="right">Match Code:</div>
                                            </td>
                                            <td width="14%" height="30px" class="lzx"
                                                style="text-align: left"> ${fbsMatch.matchCode} </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">Home Team:</div>
                                            </td>
                                            <td class="lzx" height="30px" style="text-align: left"><span class="lzx"
                                                                                                         style="text-align: left">${fbsMatch.homeTeam}</span>
                                            </td>

                                            <td width="14%" height="30px" class="lzx">
                                                <div align="right">Draw Pool Amount:</div>
                                            </td>
                                            <td width="11%" height="30px" class="lzx"
                                                style="text-align: left"> ${poolAmount} </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">310 Handicap:</div>
                                            </td>
                                            <td class="lzx" height="30px"
                                                style="text-align: left">${fbsMatch.score310}</td>
                                        </tr>
                                        <tr>


                                            <td width="14%" height="30px" class="lzx">
                                                <div align="right">Issue:</div>
                                            </td>
                                            <td width="13%" height="30px" class="lzx"
                                                style="text-align: left"> ${fbsMatch.matchIssue} </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">Guest Team:</div>
                                            </td>
                                            <td class="lzx" height="30px" style="text-align: left"><span class="lzx"
                                                                                                         style="text-align: left">${fbsMatch.guestTeam}</span>
                                            </td>
                                            <td width="14%" height="30px" class="lzx">
                                                <div align="right">Match Status:</div>
                                            </td>
                                            <td width="9%" height="30px" class="lzx" style="text-align: left">
                                                <c:if test="${fbsMatch.matchStatus==3}">Sale Over</c:if>
                                                <c:if test="${fbsMatch.matchStatus==4}">Type In Result</c:if>
                                                <c:if test="${fbsMatch.matchStatus==5}">Reward Finish</c:if>
                                            </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">30 Handicap:</div>
                                            </td>
                                            <td class="lzx" height="30px"
                                                style="text-align: left">${fbsMatch.score30}</td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" style="border-bottom:1px solid #eff1f4;">&nbsp;</td>
                                        </tr>
                                        </tbody>
                                    </table>

                            <tr>
                                <td>
                                    <table width="85%" border="0" align="center" cellpadding="0" cellspacing="0"
                                           class="tabxian" style=" font-size:14px;">
                                        <tr class="biaot">
                                            <th>Play Method</th>
                                            <th>Result</th>
                                            <th>Note Bonus</th>
                                            <th>SP Value</th>
                                        </tr>
                                        <c:forEach var="data" items="${fbsMatchDraw}" varStatus="status">
                                            <tr class="jjzi">
                                                <td class="tabxian-td">
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
                                                <td class="tabxian-td">
                                                    <c:if test="${data.matchSubTypeCode==3}">
                                                        <c:if test="${data.matchResultEnum == 99}">
                                                            -
                                                        </c:if>
                                                        <c:if test="${data.matchResultEnum == 8}">
                                                            7+
                                                        </c:if>
                                                        <c:if test="${data.matchResultEnum != 8 && data.matchResultEnum != 99}">
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
                                                        <c:if test="${data.matchResultEnum == 99}">
                                                            -
                                                        </c:if>
                                                        <c:if test="${data.matchResultEnum ==1}">
                                                            Over Odd
                                                        </c:if>
                                                        <c:if test="${data.matchResultEnum==2}">
                                                            Over Even
                                                        </c:if>
                                                        <c:if test="${data.matchResultEnum==3}">
                                                            Under Odd
                                                        </c:if>
                                                        <c:if test="${data.matchResultEnum==4}">
                                                            Under Even
                                                        </c:if>
                                                    </c:if>
                                                </td>
                                                <td class="tabxian-td"> ${data.winAmount}</td>
                                                <td class="tabxian-td">
                                                    <fmt:formatNumber type="number" value="${data.refSPValue>1?(data.refSPValue-0.004):(data.refSPValue)}"
                                                                      pattern="0.00" maxFractionDigits="2"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </table>
                                    <div align="center" style=" width:85%; margin:0 auto;margin-top:10px; ">
                                        <input type="button" value="Confirm" onClick="toFinish();" class="button-normal"
                                               style="float:right; ">
                                        <input type="button" value="Draw Again" onClick="reDraw();"
                                               class="button-normal"
                                               style="float:right; margin-right:20px; ">
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
            <tr height="80">
                <td align="center" valign="middle"></td>
                <td></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
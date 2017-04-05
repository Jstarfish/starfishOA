<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>足彩比赛开奖</title>
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
        function doDraw() {
            var url = "fbsDraw.do?method=initFbsDraw";
            $("#calculateForm").attr("action", url);
            $("#calculateForm").submit();
        }
    </script>
</head>
<body>
<div id="title">Show Result</div>
<div id="mainDiv">
    <div class="jdt"
         style="background: url(views/oms/fbs/fbsdraw/img/fbsbj-3.png) no-repeat left top;width:850px;"></div>
    <div class="xd" style="width:850px">
        <span style="margin-left: 30px;">1.Type In Result</span>
        <span style="margin-left: 25px;">2.Wait For Result</span>
        <span class="zi" style="margin-left: 25px;">3.Show Result</span>
        <span style="margin-left: 25px;">4.Drawing</span>
        <span style="margin-left: 25px;">5.Show Result</span>
        <span style="margin-left: 25px;">6.Finish</span>
    </div>

    <div class="CPage">
        <table width="80%" border="0" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td align="left" valign="middle">
                    <div class="tab" style="height:400px;">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" class="tabxian">
                            <tbody>
                            <tr>
                                <td class="tit"><span style="font-size: 24px;">3. Show Result</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="90%" align="center" cellpadding="0" cellspacing="0">
                                        <tbody>
                                        <tr>
                                            <td width="11%" height="30px" class="lzx">
                                                <div align="right">Match Code:</div>
                                            </td>
                                            <td width="14%" height="30px" class="lzx" style="text-align: left">
                                                ${fbsMatch.matchCode}
                                            </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">Home Team:</div>
                                            </td>
                                            <td class="lzx" height="30px" style="text-align: left">
                                                ${fbsMatch.homeTeam}
                                            </td>
                                            <td width="14%" height="30px" class="lzx">
                                                <div align="right">Competition:</div>
                                            </td>
                                            <td width="11%" height="30px" class="lzx" style="text-align: left">
                                                ${fbsMatch.matchComp}
                                            </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">310 Handicap:</div>
                                            </td>
                                            <td class="lzx" height="30px" style="text-align: left">
                                                ${fbsMatch.score310}
                                            </td>
                                        </tr>
                                        <tr>


                                            <td width="14%" height="30px" class="lzx">
                                                <div align="right">Issue:</div>
                                            </td>
                                            <td width="13%" height="30px" class="lzx" style="text-align: left">
                                                ${fbsMatch.matchIssue}
                                            </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">Guest Team:</div>
                                            </td>
                                            <td class="lzx" height="30px" style="text-align: left">
                                                ${fbsMatch.guestTeam}
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
                                            <td class="lzx" height="30px" style="text-align: left">
                                                ${fbsMatch.score30}
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" style="border-bottom:1px solid #eff1f4;">&nbsp;</td>
                                        </tr>
                                        </tbody>
                                    </table>
                            <tr>
                                <td>
                                    <form id="calculateForm" method="post">
                                        <table border="0" width="85%" align="center" cellpadding="0" cellspacing="0"
                                               style="border:1px solid #eff1f4; font-size:14px;">
                                            <input type="hidden" name="matchCode" value="${fbsMatch.matchCode}">
                                            <input type="hidden" name="issueCode" value="${issueCode}">
                                            <input type="hidden" name="finalScoreTeam"
                                                   value="${fbsDrawForm.finalScoreTeam}">
                                            <input type="hidden" name="secondfhHomeScore"
                                                   value="${fbsDrawForm.secondfhHomeScore}">
                                            <input type="hidden" name="secondfhGuestScore"
                                                   value="${fbsDrawForm.secondfhGuestScore}">
                                            <input type="hidden" name="secondshHomeScore"
                                                   value="${fbsDrawForm.secondshHomeScore}">
                                            <input type="hidden" name="secondshGuestScore"
                                                   value="${fbsDrawForm.secondshGuestScore}">
                                            <input type="hidden" name="homeTeamCode" value=" ${fbsMatch.homeTeamCode}">
                                            <input type="hidden" name="guestTeamCode" value="${fbsMatch.guestTeamCode}">
                                            <input type="hidden" name="homeTeam" value=" ${fbsMatch.homeTeam}">
                                            <input type="hidden" name="guestTeam" value="${fbsMatch.guestTeam}">
                                            <input type="hidden" name="finalScoreTeam" value="${firstGoalTeamCode}">
                                            <input type="hidden" name="winlevellosResult" value="${full310Result}">
                                            <input type="hidden" name="winlosResult" value="${full30Result}">
                                            <input type="hidden" name="hfwinlevellosResult" value="${hf310Result}">
                                            <input type="hidden" name="hfSingleDoubleString" value="${hfSingleDouble}">
                                            <input type="hidden" name="fullScore" value="${fullScore}">
                                            <input type="hidden" name="singleScore" value="${singleScore}">
                                            <tbody>
                                            <tr>
                                                <td width="32%" height="30px" class="xh">
                                                    First Goal Team:
                                                </td>
                                                <td width="14%" height="30px" align="left">
                                                    ${firstGoalTeam}
                                                </td>
                                                <td width="29%" height="30px" class="xh">
                                                </td>
                                                <td width="25%" height="30px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="30px" class="xh">Winner:</td>
                                                <td height="30px" align="left"><span
                                                        id="score310">${full310Result==99?"-":full310Result}</span></td>
                                                <td height="30px" class="xh">Handicap:</td>
                                                <td height="30px" align="left"><span
                                                        id="score30">${full30Result==99?"-":full30Result}</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="30px" class="xh">Half/Full time pool:</td>
                                                <td height="30px" align="left"><span
                                                        id="hfscore310">${hf310Result}</span></td>
                                                <td height="30px" class="xh">OUOD:</td>
                                                <td height="30px" align="left"><span id="hfsingledouble">
                                                              <c:if test="${hfSingleDouble==99}">
                                                                  -
                                                              </c:if>
                                                         <c:if test="${hfSingleDouble ==1}">
                                                             Over Odd
                                                         </c:if>
                                                        <c:if test="${hfSingleDouble==2}">
                                                            Over Even
                                                        </c:if>
                                                        <c:if test="${hfSingleDouble==3}">
                                                            Under Odd
                                                        </c:if>
                                                        <c:if test="${hfSingleDouble==4}">
                                                            Under Even
                                                        </c:if>
                                                 </span></td>
                                            </tr>
                                            <tr>
                                                <td height="30px" class="xh">Totals Goal:</td>
                                                <td height="30px" align="left">
                                                    <span id="fullscore">
                                                   <c:if test="${fullScoreEum==8}">
                                                       7+
                                                   </c:if>
                                                        <c:if test="${fullScoreEum!=8}">
                                                            ${fullScore==99?"-":fullScore}
                                                        </c:if>
                                                      </span>
                                                </td>
                                                <td height="30px" class="xh">Score:</td>
                                                <td height="30px" align="left"><span
                                                        id="singlescore">
                                                           <c:if test="${singleScoreEum==10}">
                                                               Home Win Other
                                                           </c:if>
                                                        <c:if test="${singleScoreEum==15}">
                                                            Draw Other
                                                        </c:if>
                                                        <c:if test="${singleScoreEum==25}">
                                                            Away Win Other
                                                        </c:if>
                                                        <c:if test="${singleScoreEum!=10 and
                                                            singleScoreEum!=15 and
                                                            singleScoreEum!=25}">
                                                            ${singleScore}
                                                        </c:if>
                                                </span></td>
                                            </tr>

                                            </tbody>
                                        </table>

                                    </form>
                                    <div align="center">
                                        <input id="okBtn" type="button" value="Next" onclick="doDraw();"
                                               class="button-normal"/>
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
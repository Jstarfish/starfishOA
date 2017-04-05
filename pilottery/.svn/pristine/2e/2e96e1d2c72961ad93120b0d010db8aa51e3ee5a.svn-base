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

    <script type="text/javascript" charset="UTF-8">
        jQuery(document).ready(function ($) {
            $("input[type='text']").each(
                    function () {
                        $(this).keypress(function (e) {
                            var key = window.event ? e.keyCode : e.which;
                            if (key.toString() == "13") {
                                return false;
                            }
                        });
                    }
            );
            $("#firstfhHomeScore").change(function () {
                document.getElementById("firstfhHomeScoreTip").innerHTML = "*";
                $("#firstfhHomeScoreTip").css("color", "#CDC9C9");
                document.getElementById("firstScoreTeamTip").innerHTML = "*";
                $("#firstScoreTeamTip").css("color", "#CDC9C9");
            });
            $("#firstfhGuestScore").change(function () {
                document.getElementById("firstfhGuestScoreTip").innerHTML = "*";
                $("#firstfhGuestScoreTip").css("color", "#CDC9C9");
                document.getElementById("firstScoreTeamTip").innerHTML = "*";
                $("#firstScoreTeamTip").css("color", "#CDC9C9");
            });
            $("#firstshHomeScore").change(function () {
                document.getElementById("firstshHomeScoreTip").innerHTML = "*";
                $("#firstshHomeScoreTip").css("color", "#CDC9C9");
                document.getElementById("firstScoreTeamTip").innerHTML = "*";
                $("#firstScoreTeamTip").css("color", "#CDC9C9");
            });
            $("#firstshGuestScore").change(function () {
                document.getElementById("firstshGuestScoreTip").innerHTML = "*";
                $("#firstshGuestScoreTip").css("color", "#CDC9C9");
                document.getElementById("firstScoreTeamTip").innerHTML = "*";
                $("#firstScoreTeamTip").css("color", "#CDC9C9");
            });
            $("#calculate").click(function () {
                document.getElementById("resultTip").innerHTML = "";
                $("#resultTip").css("color", "#CDC9C9");
            });
            $("#firstScoreTeam").click(function () {
                document.getElementById("firstScoreTeamTip").innerHTML = "*";
                $("#firstScoreTeamTip").css("color", "#CDC9C9");
            });
        });


        function checkData() {
            var regType = "^\\d+$";
            var reg = new RegExp(regType);
            var firstScoreTeam = $("#firstScoreTeam").val();
            var firstfhHomeScore = $("#firstfhHomeScore").val();
            var firstfhGuestScore = $("#firstfhGuestScore").val();
            var firstshHomeScore = $("#firstshHomeScore").val();
            var firstshGuestScore = $("#firstshGuestScore").val();
            if (firstScoreTeam == 0) {
                if (firstfhHomeScore > 0 ||
                        firstfhGuestScore > 0 ||
                        firstshHomeScore > 0 ||
                        firstshGuestScore > 0) {
                    document.getElementById("firstScoreTeamTip").innerHTML = '请选择进球队伍';
                    $("#firstScoreTeamTip").css("color", "red");
                    return false;
                }
            }
            if (firstScoreTeam > 0) {
                if (firstfhHomeScore == 0 &&
                        firstfhGuestScore == 0 &&
                        firstshHomeScore == 0 &&
                        firstshGuestScore == 0) {
                    document.getElementById("firstScoreTeamTip").innerHTML = '请填写进球数';
                    $("#firstScoreTeamTip").css("color", "red");
                    return false;
                }
            }
            if (Number(firstfhHomeScore)> 0 && Number(firstfhGuestScore)== 0) {
                if (firstScoreTeam !=${fbsMatch.homeTeamCode}) {
                    document.getElementById("firstScoreTeamTip").innerHTML = '首先进球队伍与进球数不符';
                    $("#firstScoreTeamTip").css("color", "red");
                    return false;
                }
            }
            if (Number(firstfhHomeScore)== 0 && Number(firstfhGuestScore)>0) {
                if (firstScoreTeam !=${fbsMatch.guestTeamCode}) {
                    document.getElementById("firstScoreTeamTip").innerHTML = '首先进球队伍与进球数不符';
                    $("#firstScoreTeamTip").css("color", "red");
                    return false;
                }
            }
            if (Number(firstfhHomeScore) + Number(firstshHomeScore) > 0 && Number(firstfhGuestScore) + Number(firstshGuestScore) == 0) {
                if (firstScoreTeam !=${fbsMatch.homeTeamCode}) {
                    document.getElementById("firstScoreTeamTip").innerHTML = '首先进球队伍与进球数不符';
                    $("#firstScoreTeamTip").css("color", "red");
                    return false;
                }
            }
            if (Number(firstfhHomeScore) + Number(firstshHomeScore) == 0 && Number(firstfhGuestScore) + Number(firstshGuestScore) >0) {
                if (firstScoreTeam !=${fbsMatch.guestTeamCode}) {
                    document.getElementById("firstScoreTeamTip").innerHTML = '首先进球队伍与进球数不符';
                    $("#firstScoreTeamTip").css("color", "red");
                    return false;
                }
            }
            if (firstfhHomeScore == "" || firstfhHomeScore < 0 || firstfhHomeScore.match(reg) == null || Number(firstfhHomeScore)==99) {
                document.getElementById("firstfhHomeScoreTip").innerHTML = '数据不合法';
                $("#firstfhHomeScoreTip").css("color", "red");
                return false;
            }
            if (firstfhGuestScore == "" || firstfhGuestScore < 0 || firstfhGuestScore.match(reg) == null || Number(firstfhGuestScore)==99) {
                document.getElementById("firstfhGuestScoreTip").innerHTML = '数据不合法';
                $("#firstfhGuestScoreTip").css("color", "red");
                return false;
            }
            if (firstshHomeScore == "" || firstshHomeScore < 0 || firstshHomeScore.match(reg) == null || Number(firstshHomeScore)==99) {
                document.getElementById("firstshHomeScoreTip").innerHTML = '数据不合法';
                $("#firstshHomeScoreTip").css("color", "red");
                return false;
            }
            if (firstshGuestScore == "" || firstshGuestScore < 0 || firstshGuestScore.match(reg) == null || Number(firstshGuestScore)==99) {
                document.getElementById("firstshGuestScoreTip").innerHTML = '数据不合法';
                $("#firstshGuestScoreTip").css("color", "red");
                return false;
            }
            return true;
        }
        function calculateSubmit() {
            if (checkData()) {
                var url = "fbsDraw.do?method=calculateFbsResult";
                $.ajax({
                    cache: true,
                    async: false,
                    url: url,
                    type: "get",
                    dataType: "json",
                    data: $('#calculateForm').serialize(),
                    success: function (r) {
                        if (r.msg != '' && r.msg != null) {
                            closeDialog();
                            showError(decodeURI(r.msg));
                        } else {
                            if(r.fullScore >= 7){
                                document.getElementById("fullscore").innerHTML = "7+";
                            }else{
                                document.getElementById("fullscore").innerHTML = r.fullScore;
                            }
                            document.getElementById("score30").innerHTML = r.full30Result;
                            document.getElementById("score310").innerHTML = r.full310Result;
                            document.getElementById("hfscore310").innerHTML = r.hf310Result;
                            if (r.hfSingleDouble == 1) {
                                document.getElementById("hfsingledouble").innerHTML = "上盘单数";
                            } else if (r.hfSingleDouble == 2) {
                                document.getElementById("hfsingledouble").innerHTML = "上盘双数";
                            } else if (r.hfSingleDouble == 3) {
                                document.getElementById("hfsingledouble").innerHTML = "下盘单数";
                            } else {
                                document.getElementById("hfsingledouble").innerHTML = "下盘双数";
                            }
                            formatSingleScore(r.singleScore);
                        }
                    }
                });
                return false;
            }
        }


        function formatSingleScore(score) {
            var scoreArr = score.split(":");
            var homeScore = Number(scoreArr[0]);
            var guestScore = Number(scoreArr[1]);
            if ((homeScore > guestScore) && homeScore > 4) {
                document.getElementById("singlescore").innerHTML = "胜其他";
            } else if ((homeScore == guestScore) && homeScore >3) {
                document.getElementById("singlescore").innerHTML = "平其他";
            } else if ((homeScore < guestScore) && guestScore > 4) {
                document.getElementById("singlescore").innerHTML = "负其他";
            } else {
                document.getElementById("singlescore").innerHTML = score;
            }
        }

        function changeSel(value) {
            if (value == 1) {
                $("#firstScoreTeam").attr("disabled", true);
                $("#calculate").attr("disabled", true);
                $("#calculate").css("background-color", "gray");
                $("#firstScoreTeam").css("color", "gray");
                $("#firstfhHomeScore").attr("readonly", true).css("color", "gray");
                $("#firstfhGuestScore").attr("readonly", true).css("color", "gray");
                $("#firstshHomeScore").attr("readonly", true).css("color", "gray");
                $("#firstshGuestScore").attr("readonly", true).css("color", "gray");
                document.getElementById("resultTip").innerHTML = "";
                $("#resultTip").css("color", "#CDC9C9");
            } else {
                $("#firstScoreTeam").attr("disabled", false);
                $("#calculate").attr("disabled", false);
                $("#calculate").css("background-color", "#9bdb03");
                $("#firstScoreTeam").css("color", "black");
                $("#firstfhHomeScore").attr("readonly", false).css("color", "black");
                $("#firstfhGuestScore").attr("readonly", false).css("color", "black");
                $("#firstshHomeScore").attr("readonly", false).css("color", "black");
                $("#firstshGuestScore").attr("readonly", false).css("color", "black");
                document.getElementById("resultTip").innerHTML = "";
                $("#resultTip").css("color", "#CDC9C9");
            }
        }

        function checkResult() {
            var team = $("#mactchResultStatus").val();
            if (team == 1) {
                return true;
            } else {
                var scor = $("#score310").text();
                if (scor == "") {
                    document.getElementById("resultTip").innerHTML = '请计算赛果';
                    $("#resultTip").css("color", "red");
                    return false;
                } else {
                    return true;
                }
            }
        }
        function doSubmit() {
            if (checkData()) {
                if (checkResult()) {
                    var url = "fbsDraw.do?method=submitFirstFbsDraw";
                    $("#calculateForm").attr("action", url);
                    button_off("okBtn");
                    $("#calculateForm").submit();
                }
            }
        }


    </script>

</head>
<body>
<div id="title">第一次开奖</div>
<div id="mainDiv">
    <div class="jdt"
         style="background: url(views/oms/fbs/fbsdraw/img/fbsbj-1.png) no-repeat left top;width:850px;"></div>
    <div class="xd" style="width:850px">
        <span class="zi" style="margin-left: 30px;">&nbsp;&nbsp;&nbsp;1.录入比赛结果</span>
        <span style="margin-left: 25px;">2.等待再次录入开奖数据</span>
        <span style="margin-left: 25px;">3.显示比赛结果</span>
        <span style="margin-left: 25px;">4.开奖中</span>
        <span style="margin-left: 25px;">5.显示开奖结果</span>
        <span style="margin-left: 25px;">6.开奖完成</span>
    </div>
    <div class="CPage">
        <table width="80%" border="0" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td align="left" valign="middle">
                    <div class="tab" style="height:500px;">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" class="tabxian">
                            <tbody>
                            <tr>
                                <td class="tit"><span style="font-size: 24px;">1.录入比赛结果 </span></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="90%" align="center" cellpadding="0" cellspacing="0">
                                        <tbody>
                                        <tr>
                                            <td width="11%" height="30px" class="lzx">
                                                <div align="right">比赛编号:</div>
                                            </td>
                                            <td width="14%" height="30px" class="lzx"
                                                style="text-align: left"> ${fbsMatch.matchCode} </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">主队:</div>
                                            </td>
                                            <td class="lzx" height="30px"
                                                style="text-align: left"> ${fbsMatch.homeTeam} </td>

                                            <td width="14%" height="30px" class="lzx">
                                                <div align="right">所属联赛:</div>
                                            </td>
                                            <td width="11%" height="30px" class="lzx"
                                                style="text-align: left"> ${fbsMatch.matchComp} </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">胜平负让球:</div>
                                            </td>
                                            <td class="lzx" height="30px"
                                                style="text-align: left"> ${fbsMatch.score310} </td>
                                        </tr>
                                        <tr>
                                            <td width="14%" height="30px" class="lzx">
                                                <div align="right">比赛期次:</div>
                                            </td>
                                            <td width="13%" height="30px" class="lzx"
                                                style="text-align: left"> ${fbsMatch.matchIssue} </td>
                                            <td class="lzx" height="30px">
                                                <div align="right">客队:</div>
                                            </td>
                                            <td class="lzx" height="30px"
                                                style="text-align: left"> ${fbsMatch.guestTeam} </td>
                                            <td width="14%" height="30px" class="lzx">
                                                <div align="right">比赛状态:</div>
                                            </td>
                                            <td width="9%" height="30px" class="lzx" style="text-align: left">
                                                <c:if test="${fbsMatch.matchStatus==3}">已截止</c:if>
                                                <c:if test="${fbsMatch.matchStatus==4}">输入开奖结果</c:if>
                                            </td>

                                            <td class="lzx" height="30px">
                                                <div align="right">胜负让球:</div>
                                            </td>
                                            <td class="lzx" height="30px"
                                                style="text-align: left"> ${fbsMatch.score30} </td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" style="border-bottom:1px solid #eff1f4;">&nbsp;</td>
                                        </tr>
                                        </tbody>
                                    </table>
                            <tr>
                                <td><form:form id="calculateForm" method="post">
                                    <table width="85%" border="0" align="center" cellpadding="0" cellspacing="0"
                                           style=" font-size:14px;">
                                        <input type="hidden" name="matchCode" value="${fbsMatch.matchCode}">
                                        <tbody>
                                        <tr>
                                            <td height="30px" width="90px" class="xh">结果状态:</td>
                                            <td height="30px" width="30px" align="left">
                                                <select class="select-normal" id="mactchResultStatus"
                                                        name="matchResultStatus" onchange="changeSel(this.value)">
                                                    <option value="0" selected>正常</option>
                                                    <option value="1">取消</option>
                                                </select>
                                            </td>
                                            <td height="30px" width="90px" class="xh">首先进球队伍:</td>
                                            <td height="30px" width="30px" align="left">
                                                <select class="select-normal" id="firstScoreTeam" name="firstScoreTeam">
                                                    <option value="0">无进球</option>
                                                    <option value="${fbsMatch.homeTeamCode}">主队</option>
                                                    <option value="${fbsMatch.guestTeamCode}">客队</option>
                                                </select>
                                                <span id="firstScoreTeamTip" style="color:#CDC9C9;width: 100%">*</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="30px" width="90px" class="xh">上半场主队进球数:</td>
                                            <td height="30px" width="10px" align="left"><input type="text" class="text-normal"
                                                                                  value="0"
                                                                                  maxlength="2"
                                                                                  id="firstfhHomeScore"
                                                                                  name="firstfhHomeScore">
                                                <span id="firstfhHomeScoreTip" style="color:#CDC9C9">*</span></td>
                                            <td height="30px" width="90px">
                                                <div class="xh">上半场客队进球数:</div>
                                            </td>
                                            <td height="30px" width="10px" align="left"><input type="text" class="text-normal"
                                                                                  value="0"
                                                                                  maxlength="2"
                                                                                  id="firstfhGuestScore"
                                                                                  name="firstfhGuestScore">
                                                <span id="firstfhGuestScoreTip" style="color:#CDC9C9">*</span></td>
                                            <td height="30px" colspan="2" width="10px"></td>
                                        </tr>
                                        <tr>
                                            <td height="30px" width="90px">
                                                <div class="xh">下半场主队进球数:</div>
                                            </td>
                                            <td height="30px"  width="10px" align="left"><input type="text" class="text-normal"
                                                                                  value="0"
                                                                                  maxlength="2"
                                                                                  id="firstshHomeScore"
                                                                                  name="firstshHomeScore">
                                                <span id="firstshHomeScoreTip" style="color:#CDC9C9">*</span></td>
                                            <td height="30px" width="90px">
                                                <div class="xh">下半场客队进球数:</div>
                                             </td>
                                            <td height="30px"  width="30px" align="left"><input type="text" class="text-normal"
                                                                                  value="0"
                                                                                  maxlength="2"
                                                                                  id="firstshGuestScore"
                                                                                  name="firstshGuestScore">
                                                <span id="firstshGuestScoreTip" style="color:#CDC9C9">*</span></td>
                                            <td height="30px" width="20px">
                                                <input type="button" id="calculate" class="button-normal"
                                                       onClick="calculateSubmit()" value="计算"></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </form:form></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" width="85%" align="center" cellpadding="0" cellspacing="0"
                                           style="border:1px solid #eff1f4;  font-size:14px;">
                                        <tbody>
                                        <tr>
                                            <td height="10px" align="center" colspan="4">
                                                <span id="resultTip" style="color:#CDC9C9"></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="22%" height="30px" class="xh">胜平负过关(让球):</td>
                                            <td width="22%" height="30px" align="left"><span id="score310"></span></td>
                                            <td width="24%" height="30px" class="xh">胜负过关(让球):</td>
                                            <td width="32%" height="30px" align="left"><span id="score30"></span></td>
                                        </tr>
                                        <tr>
                                            <td height="30px" class="xh">半全场胜平负:</td>
                                            <td height="30px" align="left"><span id="hfscore310"></span></td>
                                            <td height="30px" class="xh">上下盘单双:</td>
                                            <td height="30px" align="left"><span id="hfsingledouble"></span></td>
                                        </tr>
                                        <tr>
                                            <td height="30px" class="xh">总进球:</td>
                                            <td height="30px" align="left"><span id="fullscore"></span></td>
                                            <td height="30px" class="xh">单场比分:</td>
                                            <td height="30px" align="left"><span id="singlescore"></span></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <div align="center">
                                        <input id="okBtn" type="button" value="提交" onclick="doSubmit();"
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
                <td align="center" valign="middle">
                </td>
                <td></td>
            </tr>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
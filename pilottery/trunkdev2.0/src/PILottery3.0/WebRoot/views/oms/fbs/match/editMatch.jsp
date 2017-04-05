<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>

    <title>Edit Match</title>

    <%@ include file="/views/common/meta.jsp" %>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>
    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
          type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
    <script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript" charset="UTF-8">
        function switchTeams() {
            var competition = $('#competition').val();
            $('#homeTeamCode').empty();
            $('#guestTeamCode').empty();
            $('#homeTeamCode').append("<option value=''>--Please Select--</option>");
            $('#guestTeamCode').append("<option value=''>--Please Select--</option>");
            if (competition == '') {
                return false;
            }

            $.ajax({
                url: "fbsGame.do?method=getTeamsByComptt&competition=" + competition,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result != '' && result != null) {
                        for (var i = 0; i < result.length; i++) {
                            $('#homeTeamCode').append("<option value='" + result[i].teamCode + "'>" + result[i].shortName + "</option>");
                            $('#guestTeamCode').append("<option value='" + result[i].teamCode + "'>" + result[i].shortName + "</option>");
                        }
                    }
                }
            });
        }

        function doClose() {
            window.parent.closeBox();
        }

        function isNull(data) {
            return (data == "" || data == undefined || data == null);
        }

        $(document).ready(
                function () {
                    $("#okButton2").bind(
                            "click",
                            function () {
                                var result = true;
                                if (isNull(trim($("#competition").val()))) {
                                    ckSetFormOjbErrMsg('competition', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#fbsIssueNumber").val()))) {
                                    ckSetFormOjbErrMsg('fbsIssueNumber', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#matchStartDate").val()))) {
                                    ckSetFormOjbErrMsg('matchStartDate', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#matchEndDate").val()))) {
                                    ckSetFormOjbErrMsg('matchEndDate', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#beginSaleDate").val()))) {
                                    ckSetFormOjbErrMsg('beginSaleDate', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#endSaleDate").val()))) {
                                    ckSetFormOjbErrMsg('endSaleDate', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#homeTeamCode").val()))) {
                                    ckSetFormOjbErrMsg('homeTeamCode', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#guestTeamCode").val()))) {
                                    ckSetFormOjbErrMsg('guestTeamCode', 'Not Empty');
                                    result = false;
                                }
                                if (isNull(trim($("#winLevelLosScore").val()))) {
                                    ckSetFormOjbErrMsg('winLevelLosScore', 'Not Empty');
                                    result = false;
                                }

                                if (result) {
                                    $("#editMatchForm").submit();
                                }
                            });
                });
        function checkThisVlue(obj) {
            var guestTeam = $(obj).val();
            var homeTeam = $('#homeTeamCode').val();
            if (homeTeam == guestTeam) {
                document.getElementById("guestTeamCodeTip").innerHTML = 'The team is same as home team';
                $("#guestTeamCodeTip").css("color", "red");
                $(obj).val(0);
            } else {
                document.getElementById("guestTeamCodeTip").innerHTML = '';
            }
        }
        function clearMatchDate() {
            $("#matchEndDate").val("");
            $("#beginSaleDate").val("");
            $("#endSaleDate").val("");
        }
        function checkPreDate(idVal, obj, nextObj) {
            if (nextObj != '') {
                $('#' + nextObj).val("");
            }
            var dateStr = $('#' + idVal).val();
            if (dateStr == '') {
                $(obj).val("");
            }
        }
    </script>
    <style type="text/css">
        .pop-body table tr td {
            padding: 10px 5px;
        }
    </style>
</head>
<body>
<form action="fbsGame.do?method=editMatch" id="editMatchForm" method="POST">
    <div class="pop-body">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td align="right" width="30%">Match No.：</td>
                <td align="left">
                    <input type="hidden" name="matchCode" value="${match.matchCode }">
                    ${match.matchCode }
                </td>
            </tr>
            <tr>
                <td align="right">Competition：</td>
                <td align="left">
                    <select name="competition" class="select-big" id="competition" onchange="switchTeams();">
                        <c:forEach var="data" items="${competitionList}">
                            <option value="${data.competitionCode}"
                                    <c:if test="${data.competitionCode == match.competition }">selected="selected"</c:if>>${data.competitionName }</option>
                        </c:forEach>
                    </select>
                    <span id="competitionTip" class="tip_init"> *</span></td>
            </tr>
            <tr>
                <td align="right">Issue：</td>
                <td align="left">
                    <input id="fbsIssueNumber" name="fbsIssueNumber" value="${match.fbsIssueNumber}" class="text-big"
                           maxLength="10" oninput="this.value=this.value.replace(/[^\d,]/g,'')"/>
                    <span id="fbsIssueNumberTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Match Begin Time：</td>
                <td align="left">
                    <input id="startIssueTime" value="${issueStart}" type="hidden"/>
                    <input id="endIssueTime" value="${issueEnd}" type="hidden"/>

                    <input id="matchStartDate" name="matchStartDate" class="Wdate text-big"
                           value="<fmt:formatDate value="${match.matchStartDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                           onfocus="WdatePicker({lang:'zh',minDate:'#F{$dp.$D(\'startIssueTime\')}',maxDate:'#F{$dp.$D(\'endIssueTime\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                           onchange="clearMatchDate()" maxlength="40"/>
                    <span id="matchStartDateTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Match End Time：</td>
                <td align="left">
                    <input id="matchEndDate" name="matchEndDate" class="Wdate text-big"
                           value="<fmt:formatDate value="${match.matchEndDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                           onfocus="WdatePicker({lang:'zh',minDate:'#F{$dp.$D(\'matchStartDate\')}',maxDate:'#F{$dp.$D(\'endIssueTime\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                           maxlength="40"
                           onchange="checkPreDate('matchStartDate',this,'beginSaleDate')"/>
                    <span id="matchEndDateTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Sale Begin Time：</td>
                <td align="left">
                    <input id="beginSaleDate" name="beginSaleDate" class="Wdate text-big"
                           value="<fmt:formatDate value="${match.beginSaleDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                           onfocus="WdatePicker({lang:'zh',maxDate:'#F{$dp.$D(\'matchStartDate\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                           maxlength="40"
                           onchange="checkPreDate('matchEndDate',this,'endSaleDate')"/>
                    <span id="beginSaleDateTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Sale End Time：</td>
                <td align="left">
                    <input id="endSaleDate" name="endSaleDate" class="Wdate text-big"
                           value="<fmt:formatDate value="${match.endSaleDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                           onfocus="WdatePicker({lang:'zh',maxDate:'#F{$dp.$D(\'matchStartDate\')}',
							   minDate:'#F{$dp.$D(\'beginSaleDate\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})" maxlength="40"
                           onchange="checkPreDate('beginSaleDate',this,'')"/>
                    <span id="endSaleDateTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Home Team：</td>
                <td align="left">
                    <select name="homeTeamCode" class="select-big" id="homeTeamCode">
                        <c:forEach var="data" items="${teamList}">
                            <option value="${data.teamCode}"
                                    <c:if test="${data.teamCode == match.homeTeamCode }">selected="selected"</c:if>>${data.shortName }</option>
                        </c:forEach>
                    </select>
                    <span id="homeTeamCodeTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">Guest Team：</td>
                <td align="left">
                    <select name="guestTeamCode" class="select-big" id="guestTeamCode"
                            onchange="checkThisVlue(this)">
                        <c:forEach var="data2" items="${teamList}">
                            <option value="${data2.teamCode}"
                                    <c:if test="${data2.teamCode == match.guestTeamCode }">selected="selected"</c:if>>${data2.shortName }</option>
                        </c:forEach>
                    </select>
                    <span id="guestTeamCodeTip" class="tip_init"></span>
                </td>
            </tr>
            <tr>
                <td align="right">310 Handicap：</td>
                <td align="left">
                    <select name="winLevelLosScore" class="select-big" id="winLevelLosScore">
                        <option value="-7" <c:if test="${match.winLevelLosScore == -7 }">selected="selected"</c:if>>-7
                        </option>
                        <option value="-6" <c:if test="${match.winLevelLosScore == -6 }">selected="selected"</c:if>>-6
                        </option>
                        <option value="-5" <c:if test="${match.winLevelLosScore == -5 }">selected="selected"</c:if>>-5
                        </option>
                        <option value="-4" <c:if test="${match.winLevelLosScore == -4 }">selected="selected"</c:if>>-4
                        </option>
                        <option value="-3" <c:if test="${match.winLevelLosScore == -3 }">selected="selected"</c:if>>-3
                        </option>
                        <option value="-2" <c:if test="${match.winLevelLosScore == -2 }">selected="selected"</c:if>>-2
                        </option>
                        <option value="-1" <c:if test="${match.winLevelLosScore == -1 }">selected="selected"</c:if>>-1
                        </option>
                        <option value="0" <c:if test="${match.winLevelLosScore == 0 }">selected="selected"</c:if>>0
                        </option>
                        <option value="1" <c:if test="${match.winLevelLosScore == 1 }">selected="selected"</c:if>>1
                        </option>
                        <option value="2" <c:if test="${match.winLevelLosScore == 2 }">selected="selected"</c:if>>2
                        </option>
                        <option value="3" <c:if test="${match.winLevelLosScore == 3 }">selected="selected"</c:if>>3
                        </option>
                        <option value="4" <c:if test="${match.winLevelLosScore == 4 }">selected="selected"</c:if>>4
                        </option>
                        <option value="5" <c:if test="${match.winLevelLosScore == 5 }">selected="selected"</c:if>>5
                        </option>
                        <option value="6" <c:if test="${match.winLevelLosScore == 6 }">selected="selected"</c:if>>6
                        </option>
                        <option value="7" <c:if test="${match.winLevelLosScore == 7 }">selected="selected"</c:if>>7
                        </option>
                    </select>
                    <span id="winLevelLosScoreTip" class="tip_init"> * Number </span>
                </td>
            </tr>
            <tr>
                <td align="right">30 Handicap：</td>
                <td align="left">
                    <select name="winLosScore" class="select-big" id="winLosScore">
                        <option value="-7.5" <c:if test="${match.winLosScore == -7.5 }">selected="selected"</c:if>>
                            -7.5
                        </option>
                        <option value="-6.5" <c:if test="${match.winLosScore == -6.5 }">selected="selected"</c:if>>
                            -6.5
                        </option>
                        <option value="-5.5" <c:if test="${match.winLosScore == -5.5 }">selected="selected"</c:if>>
                            -5.5
                        </option>
                        <option value="-4.5" <c:if test="${match.winLosScore == -4.5 }">selected="selected"</c:if>>
                            -4.5
                        </option>
                        <option value="-3.5" <c:if test="${match.winLosScore == -3.5 }">selected="selected"</c:if>>
                            -3.5
                        </option>
                        <option value="-2.5" <c:if test="${match.winLosScore == -2.5 }">selected="selected"</c:if>>
                            -2.5
                        </option>
                        <option value="-1.5" <c:if test="${match.winLosScore == -1.5 }">selected="selected"</c:if>>
                            -1.5
                        </option>
                        <option value="-0.5" <c:if test="${match.winLosScore == -0.5 }">selected="selected"</c:if>>
                            -0.5
                        </option>
                        <option value="0.5" <c:if test="${match.winLosScore == 0.5 }">selected="selected"</c:if>>0.5
                        </option>
                        <option value="1.5" <c:if test="${match.winLosScore == 1.5 }">selected="selected"</c:if>>1.5
                        </option>
                        <option value="2.5" <c:if test="${match.winLosScore == 2.5 }">selected="selected"</c:if>>2.5
                        </option>
                        <option value="3.5" <c:if test="${match.winLosScore == 3.5 }">selected="selected"</c:if>>3.5
                        </option>
                        <option value="4.5" <c:if test="${match.winLosScore == 4.5 }">selected="selected"</c:if>>4.5
                        </option>
                        <option value="5.5" <c:if test="${match.winLosScore == 5.5 }">selected="selected"</c:if>>5.5
                        </option>
                        <option value="6.5" <c:if test="${match.winLosScore == 6.5 }">selected="selected"</c:if>>6.5
                        </option>
                        <option value="7.5" <c:if test="${match.winLosScore == 7.5 }">selected="selected"</c:if>>7.5
                        </option>
                    </select>
                    <span id="winLosScoreTip" class="tip_init"> * Number </span>
                </td>
            </tr>
        </table>
    </div>

    <div class="pop-footer">
			<span class="left"> 
				<input id="okButton2" type="button" value='Save' class="button-normal"></input>
			</span> 
			<span class="right"> 
				<input type="button" value="Cancel" onclick="doClose();" class="button-normal"></input>
			</span>
    </div>

</form>
</body>
</html>
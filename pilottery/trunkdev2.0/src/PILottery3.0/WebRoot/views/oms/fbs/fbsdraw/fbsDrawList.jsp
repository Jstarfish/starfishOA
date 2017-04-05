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
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>

    <script type="text/javascript" charset="UTF-8">

        function checkIssueCode() {
            if ($("#fbsIssueCode").val() == '') {
                return false;
            }
            return true;
        }
        function checkEndQueryTime() {
            if ($("#endqueryTime").val() == '') {
                return false;
            }
            return true;
        }
        function checkStartQueryTime() {
            if ($("#startqueryTime").val() == '') {
                return false;
            }
            return true;
        }
        function promptDelete(url, issueCode) {
            var msg = "Confirm Delete Issue:" + issueCode + "?";
            showDialog("submitAjaxAction('" + url + "')", "Delete Issue", msg);
        }
        function promptPublish(url, issueCode) {
            var msg = "Confirm Publish Issue" + issueCode + "?";
            showDialog("submitAjaxAction('" + url + "')", "Publish Issue", msg);
        }
        function submitAjaxAction(url) {
            button_off("ok_button");
            $.ajax({
                url: url,
                dataType: "json",
                method: "post",
                async: false,
                success: function (r) {
                    if (r.msg != '' && r.msg != null) {
                        closeDialog();
                        showError(decodeURI(r.msg));
                    } else {
                        window.location.reload();
                    }
                }
            });
        }
        function submitForm() {
            $("#fbsDrawForm").submit();
        }
        function clearForm() {
            $("#issueCode").val('');
            $("#startqueryTime").val('');
            $("#endqueryTime").val('');
            $("#matchStatus").val('');
        }
    </script>

</head>
<body>
<div id="title">Fbs Match Draw</div>

<div class="queryDiv">

    <form:form modelAttribute="fbsDrawForm" action="fbsDraw.do?method=initFbsDraw">
        <div class="left">
                     <span>Issue：<form:input path="issueCode" id="issueCode" maxlength="20" class="text-normal"/>
                     </span>
                      <span>
                     Match Date：<input id="startqueryTime" name="startqueryTime" value="${fbsDrawForm.startqueryTime}"
                                 class="Wdate"
                                 type="text"
                                 onFocus="WdatePicker({isShowClear:true,dateFmt:'yyyy-MM-dd'})"/>
                     </span>
                      <span>
                    - <input id="endqueryTime" name="endqueryTime" value="${fbsDrawForm.endqueryTime}" class="Wdate"
                             type="text"
                             onFocus="WdatePicker({isShowClear:true,dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startqueryTime\')}'})"/>
                     </span>
                  <span>Match Status:
                        <select name="matchStatus" id="matchStatus" class="select-normal">
                            <option value="">--ALL--</option>
                            <option value="1" <c:if test="${fbsDrawForm.matchStatus==1}">selected</c:if>>Pre Schedule</option>
                            <option value="2" <c:if test="${fbsDrawForm.matchStatus==2}">selected</c:if>>Saling</option>
                            <option value="3" <c:if test="${fbsDrawForm.matchStatus==3}">selected</c:if>>Sale Over</option>
                            <option value="4" <c:if test="${fbsDrawForm.matchStatus==4}">selected</c:if>>Type In Result</option>
                            <option value="5" <c:if test="${fbsDrawForm.matchStatus==5}">selected</c:if>>Reward Finish</option>
                            <option value="6" <c:if test="${fbsDrawForm.matchStatus==6}">selected</c:if>>Draw Finish</option>
                        </select>
                    </span>
            </span>
            <input type="button" value="Query" onclick="submitForm();" class="button-normal"/>
            <input type="button" class="button-normal" value="Clear" onclick="clearForm()">
        </div>
    </form:form>
</div>
<div id="headDiv">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table class="datatable" id="exportPdf">
                    <tr class="headRow">
                        <td style="width: 10px;">&nbsp;</td>
                        <td style="width:3%">Match Code</td>
                        <td width="1%">|</td>
                        <td style="width:2%">Issue</td>
                        <td width="1%">|</td>
                        <td style="width:2%">Home Team</td>
                        <td width="1%">|</td>
                        <td style="width:2%">Guest Team</td>
                        <td width="1%">|</td>
                        <td style="width:3%">Match Status</td>
                        <td width="1%">|</td>
                        <td style="width:3%">Regular Status</td>
                        <td width="1%">|</td>
                        <td style="width:3%">Match Date</td>
                        <td width="1%">|</td>
                        <td style="width:3%">First Half Result</td>
                        <td width="1%">|</td>
                        <td style="width:3%">Second Half Result</td>
                        <td width="1%">|</td>
                        <td style="width:6%">Sale End Time</td>
                        <td width="1%">|</td>
                        <td style="width:14%" class="no-print">Operation</td>
                    </tr>
                </table>
            </td>
            <td style="width:17px;background:#2aa1d9"></td>
        </tr>
    </table>
</div>

<div id="bodyDiv">
    <table class="datatable" id="exportPdfData">
        <c:forEach var="data" items="${pageDataList}" varStatus="status">
            <tr class="dataRow">
                <td style="width: 10px;">&nbsp;</td>
                <td style="width:3%">${data.matchCode}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:2%">${data.matchIssue}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:2%">${data.homeTeam}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:2%">${data.guestTeam}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">
                    <c:if test="${data.matchStatus==1}">Pre Schedule</c:if>
                    <c:if test="${data.matchStatus==2}">Saling</c:if>
                    <c:if test="${data.matchStatus==3}">Sale Over</c:if>
                    <c:if test="${data.matchStatus==4}">Type In Result</c:if>
                    <c:if test="${data.matchStatus==5}">Reward Finish</c:if>
                    <c:if test="${data.matchStatus==6}">Draw Finish</c:if>
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">
                    <c:if test="${data.saleStatus==0}">Forbid</c:if>
                    <c:if test="${data.saleStatus==1}">Normally</c:if>
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">${data.matchDate}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">${data.firstfhHomeScore==99?0:data.firstfhHomeScore}-${data.firstfhGuestScore==99?0:data.firstfhGuestScore}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:3%">${data.firstshHomeScore==99?0:data.firstshHomeScore}-${data.firstshGuestScore==99?0:data.firstshGuestScore}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.endSaleTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:14%" class="no-print">
                        <span>
                            <span><a href="#"
                                     onclick="showBox('fbsGame.do?method=getMatchDetail&matchCode=${data.matchCode}','Match Detail',400,800)">Detail</a></span>&nbsp;|
                            <c:if test="${data.drawStatus<=2 && data.matchStatus<3}">
                                <span><a href="#"
                                         onclick="showBox('fbsDraw.do?method=updatePublishMatch&matchCode=${data.matchCode}','Match Update',300,600)">
                                    Match Edit</a></span>|
                                <span>Match Draw</span>|
                                <span>Draw Notice</span>|
                            </c:if>
                            <c:if test="${data.drawStatus<=2 &&
                                    data.matchStatus>=3 &&
                                    data.matchEndTime>nowDate}">
                                <span>Match Edit</span>|
                                <span>Match Draw</span>|
                                <span>Draw Notice</span>|
                            </c:if>
                             <c:if test="${data.drawStatus<=2 &&
                                    data.matchStatus>=3 &&
                                    data.matchEndTime<nowDate}">
                                 <span>Match Edit</span>|
                                <span><a
                                        href="fbsDraw.do?method=firstFbsDraw&matchCode=${data.matchCode}">
                                    Match Draw</a></span>|
                                 <span>Draw Notice</span>|
                             </c:if>

                             <c:if test="${data.drawStatus == 5 && data.firstDrawUserId != userId}">
                                 <span>Match Edit</span>|
                                     <span>
                                         <a
                                                 href="fbsDraw.do?method=secondFbsDraw&matchCode=${data.matchCode}">Match Draw</a></span>|
                                 <span>Draw Notice</span>|
                             </c:if>
                             <c:if test="${data.drawStatus == 5 && data.firstDrawUserId == userId}">
                                 <span>Match Edit</span>|
                                     <span>
                                         <a
                                                 href="fbsDraw.do?method=firstFbsDraw&matchCode=${data.matchCode}">Match Draw</a></span>|
                                 <span>Draw Notice</span>|
                             </c:if>
                            <c:if test="${ data.drawStatus >= 6 && data.drawStatus<16}">
                                <c:if test="${data.firstDrawUserId==userId}">
                                    <span>Match Edit</span>|
                                     <span><a
                                             href="fbsDraw.do?method=firstFbsDraw&matchCode=${data.matchCode}">Match Draw</a></span>|
                                    <span>Draw Notice</span>|
                                </c:if>
                                <c:if test="${data.firstDrawUserId != userId}">
                                    <span>Match Edit</span>|
                                    <c:if test="${data.matchStatus==3}">
                                     <span>
                                           Match Draw
                                     </span>|
                                    </c:if>
                                    <c:if test="${data.matchStatus!=3}">
                                        <span>Match Draw</span>|
                                    </c:if>
                                    <span>Draw Notice</span>|
                                </c:if>
                            </c:if>
                              <c:if test="${data.drawStatus == 16 }">
                                  <span>Match Edit</span>|
                                  <span>Match Draw</span>|
                                  <span><a href="#"
                                           onclick="showPage('fbsDraw.do?method=fbsDrawNotice&matchCode=${data.matchCode}&issueCode=${data.matchIssue}','Draw Notice')">
                                      Draw Notice</a></span>|
                              </c:if>
                             <span><a href="#"
                                      onclick="showPage('fbsDraw.do?method=queryMatchMessage&matchCode=${data.matchCode}','Real Data')">Real Data</a></span>
                        </span>
                </td>
            </tr>
        </c:forEach>
    </table>
    ${pageStr}
</div>

</body>
</html>
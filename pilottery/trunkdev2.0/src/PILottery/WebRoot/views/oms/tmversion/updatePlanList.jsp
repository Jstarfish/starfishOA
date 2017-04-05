<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>

<head>
    <title>
        Upgrade Plan
    </title>
    <%@ include file="/views/common/meta.jsp" %>

    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>

    <script type="text/javascript" charset="UTF-8">
        var existName = 'This name already exists, please input again';
        var charactValid = '*Not empty, Chinese, English, digit, and no special characters';
        var correct = 'Congratulations, you have entered correctly';
        var length = 'Not empty and not more than 20 characters';
        var error = 'Your input is incorrect';
        var select = '* Please select';
        var hint = 'Please select a terminal or a institution!';
        var region = 'Institution';
        var version = 'Select version';
        var confirm = 'Confirm';

        function updateQuery() {
            var obj = document.getElementById("terminalCode");
            obj.value = obj.value.replace(/[^\d]/g, '');
            $("#queryForm").submit();
        }

        function ifCanExe(url, planName, planId) {
            $.ajax({
                url: "updatePlan.do?method=getUpdateDate&planId=" + planId,
                dataType: "text",
                async: false,
                success: function(data) {
                    if (data != '' && data != null && data != undefined) {
                        promptExe(url, planName);
                    } else {
                        showMsg('Warning', 'Please specify an upgrade time before execution', "warn");
                    }
                }
            });
        }

        function promptExe(url, planName) {
            //var msg = "您确认执行 "+planName+" 计划吗?";
            var msg = "Are you sure you want to execute plan" + planName + " ?";
            showDialog("operTeller('" + url + "')", "Execute", msg);
        }

        function promptCancel(url, planName) {
            //var msg = "您确认取消 "+planName+" 计划吗?";
            var msg = "Are you sure you want to cancel the plan " + planName + " ?";
            showDialog("operTeller('" + url + "')", "Cancel", msg);
        }

        function operTeller(url) {
            button_off("ok_button");
            $.ajax({
                url: url,
                dataType: "json",
                method: "post",
                async: false,
                success: function(r) {
                    if (r.reservedSuccessMsg != '' && r.reservedSuccessMsg != null) {
                        closeDialog();
                        showError(decodeURI(r.reservedSuccessMsg));
                    } else {
                        window.location.reload();
                    }
                }
            });
        }

        function clearValue() {
            $(".text-normal").val('');
            $(".select-normal").val(0);
        }

        $(function() {
            $("#planState").val('${planQueryForm.planState}');
        });
    </script>
</head>

<body>
    <div id="title">
        <span>Upgrade Plan</span>
    </div>
    <div class="queryDiv">
        <form:form modelAttribute="planQueryForm" action="updatePlan.do?method=updatePlanList" id="queryForm">
        <div class="left">
            <span>
                Setup Time:
                <input readonly="readonly" type="text" id="fromDateString" name="fromDateString" value="${planQueryForm.fromDateString}" class="Wdate text-normal" onFocus="var toDateString=$dp.$('toDateString');WdatePicker({onpicked:function(){toDateString.focus();},maxDate:'#F{$dp.$D(\'toDateString\')}'})"/>
         </span>-
            <span>
                <input readonly="readonly" type="text" id="toDateString" name="toDateString" value="${planQueryForm.toDateString}" class="Wdate text-normal" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'fromDateString\')}'})"/>
            </span>
            <span>
                Status:
                <form:select path="planState" id="planState" class="select-normal">
                    <form:option value="0">--Empty--</form:option>
                    <form:options items="${planStatusMap}"/>
                </form:select>
            </span>
            <span>
                Version:
                <form:select path="packageVersion" class="select-normal">
                    <form:option value="0">--Empty--</form:option>
                    <c:forEach var="s" items="${validSoftVersion}">
                        <form:option value="${s.pkgVer}">${s.pkgVer}</form:option>
                    </c:forEach>
                </form:select>
            </span>
            <span>
                Terminal Code:
                <form:input path="terminalCode" id="terminalCode" class="text-normal" autocomplete="off" maxlength="100" onkeyup="this.value=this.value.replace(/[^\d]/g,'')"/>
            </span>
            <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
            <input type="button" value="Clear" class="button-normal" onclick="clearValue();"></input>
            <input type="button" value="New Plan" onclick="showBox('updatePlan.do?method=addPlan','New Plan',420,700)" class="button-normal"></input>
        </div>
        <div class="right" style="float: left">
            <table width="100" border="0" cellspacing="0" cellpadding="0">
                <tr style="height:50px;line-height:50px">
                    <td align="right">
                        
                    </td>
                    <td style="width:30px"></td>
                    <td align="right" style="display: none">
                        <a href="#" onclick="">
                            <img src="img/printx.png" width="53" height="24" style="margin-top:10px;" onclick="myPrint();"/>
                        </a>
                    </td>
                    <td align="right" style="display: none">
                        <a href="#" onclick="">
                            <img src="img/daochu.png" width="53" height="24" style="margin-top:10px;" onclick="doExport();"/>
                        </a>
                    </td>
                </tr>
            </table>
        </div>
        </form:form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <table class="datatable">
                <tr class="headRow">
                	<td style="width: 10px;">&nbsp;</td>
                   <td style="width:6%" class="nowrap">Plan</td>
                   <th width="1%">|</th>
                   <td style="width:6%" class="nowrap">Machine</td>
                   <th width="1%">|</th>
                   <td style="width:6%" class="nowrap">Version</td>
                   <th width="1%">|</th>
                   <td style="width:6%" class="nowrap">Status</td>
                   <th width="1%">|</th>
                   <td style="width:9%" class="nowrap">Setup Time</td>
                   <th width="1%">|</th>
                   <td style="width:9%" class="nowrap">Execution Time</td>
                   <th width="1%">|</th>
                   <td style="width:9%" class="nowrap">Upgrade Time</td>
                   <th width="1%">|</th>
                   <td style="width:9%" class="nowrap">Cancellation Time</td>
                   <th width="1%">|</th>
                   <td style="width:6%" class="nowrap" title="下载进度">Progress</td>
                   <th width="1%">|</th>
                   <td style="width:*%" class="nowrap noprint">Operation</td>
                </tr>
            </table>
           </td>
           <td style="width:17px;background:#2aa1d9"></td>
          </tr>
        </table>
    </div>
    <div id="bodyDiv">
        <table class="datatable">
            <c:forEach var="data" items="${pageDataList}" varStatus="status">
                <tr class="dataRow">
                	<td style="width: 10px;">&nbsp;</td>
                    <td style="width:6%" title="${data.planName}">${data.planName}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:6%" title="${data.terminalTypes.typeName}">${data.terminalTypes.typeName}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:6%" title="${data.softNo}">${data.softNo}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:6%" title="${planStatusMap[data.planStatus]}">${planStatusMap[data.planStatus]}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:9%">${data.createDate}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:9%">${data.executeDate}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:9%">${data.updateDate}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:9%">${data.cancelDate}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:6%">${data.progress}</td>
                    <td width="1%">&nbsp;</td>
                    <td style="width:*%" class="operate">
                        <c:choose>
                            <c:when test="${data.planStatus == 1}">
                                <span><a href="#" onclick="showBox('updatePlan.do?method=editPlan&planid=${data.planId}&updatetime=${data.updateDate}&termtype=${data.termType}&softNo=${data.softNo}','EditUpgrade Plan',250,700)">Edit</a></span> |
                            </c:when>
                            <c:when test="${data.planStatus != 1}">
                                <span>Edit</span> |
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${data.planStatus == 1}">
                                <span><a href="#" onclick="showBox('updatePlan.do?method=changeupdatetime&planid=${data.planId}&updatetime=${data.updateDate}','Upgrade Time',250,700)">Upgrade Time</a></span> |
                            </c:when>
                            <c:when test="${data.planStatus != 1}">
                                <span>Upgrade Time</span> |
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${data.planStatus < 2}">
                                <!--<span><a href="#" onclick="promptExe('updatePlan.do?method=executeplanByCode&planid=${data.planId}&planStatus=2','${data.planName}','${data.planId}');">Execute</a></span> |-->
                                <span><a href="#" onclick="ifCanExe('updatePlan.do?method=executeplanByCode&planid=${data.planId}&planStatus=2','${data.planName}','${data.planId}');">Execute</a></span> |
                            </c:when>
                            <c:when test="${data.planStatus >= 2}">
                                <span>Execute</span> |
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${data.planStatus == 1}">
                                <span><a href="#" onclick="promptCancel('updatePlan.do?method=cancelplanByCode&planid=${data.planId}&planStatus=3','${data.planName}');">Cancel</a></span> |
                            </c:when>
                            <c:when test="${data.planStatus != 1}">
                                <span>Cancel</span> |
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${data.planStatus == 2}">
                                <span>
                                    <a href="#" onclick="showBox('updatePlan.do?method=viewprogress&planid=${data.planId}','Progress',400,1100)">
                                        Progress
                                    </a>
                                </span>
                            </c:when>
                            <c:when test="${data.planStatus != 2}">
                                <span>Progress</span>
                            </c:when>
                        </c:choose>
                   </td>
                </tr>
            </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>

</html>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>

<head>
    <title>
        升级计划
    </title>
    <%@ include file="/views/common/meta.jsp" %>

    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>

    <script type="text/javascript" charset="UTF-8">
        var existName = '此升级计划名称已存在，请重新输入';
        var charactValid = '*非空，中文，英文，数字，不允许输入符号';
        var correct = '恭喜你,你输对了';
        var length = '非空，长度不超过20';
        var error = '您输入的不正确';
        var select = '* 请选择';
        var hint = '选择机构和指定终端至少输入其中一项！';
        var region = '选择机构';
        var version = '选择版本';
        var confirm = '确定';

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
                        showMsg('信息提示', '此升级计划没有指定更新时间，请指定更新时间再执行', "warn");
                    }
                }
            });
        }

        function promptExe(url, planName) {
            //var msg = "您确认执行 "+planName+" 计划吗?";
            var msg = "您确认执行" + planName + " 计划吗?";
            showDialog("operTeller('" + url + "')", "执行计划", msg);
        }

        function promptCancel(url, planName) {
            //var msg = "您确认取消 "+planName+" 计划吗?";
            var msg = "您确认取消 " + planName + " 计划吗?";
            showDialog("operTeller('" + url + "')", "取消计划", msg);
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
        <span>升级计划</span>
    </div>
    <div class="queryDiv">
        <form:form modelAttribute="planQueryForm" action="updatePlan.do?method=updatePlanList" id="queryForm">
        <div class="left">
            <span>
                建立时间:
                <input readonly="readonly" type="text" id="fromDateString" name="fromDateString" value="${planQueryForm.fromDateString}" class="Wdate text-normal" onFocus="var toDateString=$dp.$('toDateString');WdatePicker({onpicked:function(){toDateString.focus();},maxDate:'#F{$dp.$D(\'toDateString\')}'})"/>
         </span>-
            <span>
                <input readonly="readonly" type="text" id="toDateString" name="toDateString" value="${planQueryForm.toDateString}" class="Wdate text-normal" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'fromDateString\')}'})"/>
            </span>
            <span>
                计划状态：
                <form:select path="planState" id="planState" class="select-normal">
                    <form:option value="0">请选择</form:option>
                    <form:options items="${planStatusMap}"/>
                </form:select>
            </span>
            <span>
                软件版本号：
                <form:select path="packageVersion" class="select-normal">
                    <form:option value="0">请选择</form:option>
                    <c:forEach var="s" items="${validSoftVersion}">
                        <form:option value="${s.pkgVer}">${s.pkgVer}</form:option>
                    </c:forEach>
                </form:select>
            </span>
            <span>
                终端机编码：
                <form:input path="terminalCode" id="terminalCode" class="text-normal" autocomplete="off" maxlength="100" onkeyup="this.value=this.value.replace(/[^\d]/g,'')"/>
            </span>
            <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
            <input type="button" value="清空" class="button-normal" onclick="clearValue();"></input>
            <input type="button" value="新增计划" onclick="showBox('updatePlan.do?method=addPlan','新增计划',420,700)" class="button-normal"></input>
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
                   <td style="width:6%" class="nowrap">计划名称</td>
                   <th width="1%">|</th>
                   <td style="width:6%" class="nowrap">终端机型号</td>
                   <th width="1%">|</th>
                   <td style="width:6%" class="nowrap">软件版本号</td>
                   <th width="1%">|</th>
                   <td style="width:6%" class="nowrap">计划状态</td>
                   <th width="1%">|</th>
                   <td style="width:9%" class="nowrap">建立时间</td>
                   <th width="1%">|</th>
                   <td style="width:9%" class="nowrap">执行时间</td>
                   <th width="1%">|</th>
                   <td style="width:9%" class="nowrap">更新时间</td>
                   <th width="1%">|</th>
                   <td style="width:9%" class="nowrap">取消时间</td>
                   <th width="1%">|</th>
                   <td style="width:6%" class="nowrap" title="下载进度">下载进度</td>
                   <th width="1%">|</th>
                   <td style="width:*%" class="nowrap noprint">操作</td>
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
                                <span><a href="#" onclick="showBox('updatePlan.do?method=editPlan&planid=${data.planId}&updatetime=${data.updateDate}&termtype=${data.termType}&softNo=${data.softNo}','修改升级计划',250,700)">修改</a></span> |
                            </c:when>
                            <c:when test="${data.planStatus != 1}">
                                <span>修改</span> |
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${data.planStatus == 1}">
                                <span><a href="#" onclick="showBox('updatePlan.do?method=changeupdatetime&planid=${data.planId}&updatetime=${data.updateDate}','修改更新时间',250,700)">修改更新时间</a></span> |
                            </c:when>
                            <c:when test="${data.planStatus != 1}">
                                <span>修改更新时间</span> |
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${data.planStatus < 2}">
                                <!--<span><a href="#" onclick="promptExe('updatePlan.do?method=executeplanByCode&planid=${data.planId}&planStatus=2','${data.planName}','${data.planId}');">执行</a></span> |-->
                                <span><a href="#" onclick="ifCanExe('updatePlan.do?method=executeplanByCode&planid=${data.planId}&planStatus=2','${data.planName}','${data.planId}');">执行</a></span> |
                            </c:when>
                            <c:when test="${data.planStatus >= 2}">
                                <span>执行</span> |
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${data.planStatus == 1}">
                                <span><a href="#" onclick="promptCancel('updatePlan.do?method=cancelplanByCode&planid=${data.planId}&planStatus=3','${data.planName}');">取消</a></span> |
                            </c:when>
                            <c:when test="${data.planStatus != 1}">
                                <span>取消</span> |
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${data.planStatus == 2}">
                                <span>
                                    <a href="#" onclick="showBox('updatePlan.do?method=viewprogress&planid=${data.planId}','查看升级过程',400,1100)">
                                        查看升级过程
                                    </a>
                                </span>
                            </c:when>
                            <c:when test="${data.planStatus != 2}">
                                <span>查看升级过程</span>
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

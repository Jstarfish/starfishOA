<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>足彩期次查询</title>
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
        function promptDelete(url,issueCode){
            var msg = "您确认删除第"+issueCode+" 期吗?";
            showDialog("submitAjaxAction('"+url+"')","删除期次",msg);
        }
        function promptPublish(url,issueCode,matchCount){
            if(matchCount<=0){
                showError("不允许发布没有比赛的期次");
                return false;
            }else{
                var msg = "您确认发布第"+issueCode+" 期吗?";
                showDialog("submitAjaxAction('"+url+"')","发布期次",msg);
            }
        }
        function submitAjaxAction(url){
            button_off("ok_button");
            $.ajax({
                url : url,
                dataType : "json",
                method: "post",
                async : false,
                success : function(r){
                    if (r.msg != '' && r.msg!= null) {
                        closeDialog();
                        showError(decodeURI(r.msg));
                    }else {
                        window.location.reload();
                    }
                }
            });
        }
        function submitForm() {
            var result = true;
                if (result) {
                    $("#fbsIssueForm").submit();
                }
        }
        function clearForm() {
            $("#fbsIssueCode").val('');
            $("#startqueryTime").val('');
            $("#endqueryTime").val('');
        }

    </script>

</head>
<body>
<div id="title">足彩期次查询</div>

<div class="queryDiv">

    <form:form modelAttribute="fbsIssueForm" action="fbsIssue.do?method=listFbsIssue">
        <div class="left">
                     <span>期次编号：<form:input path="fbsIssueCode" id="fbsIssueCode" maxlength="20" class="text-normal"/>
                     </span>
            <input type="button" value="查询" onclick="submitForm();" class="button-normal"/>
            <input type="button" class="button-normal" value="清除" onclick="clearForm()">
        </div>
        <div class="right">
            <table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
                <tr style="height:50px;line-height:50px">
                    <td><input type="button" class="button-normal" value="期次添加"
                               onclick="showBox('fbsIssue.do?method=issueAdd','期次添加',300,850)"/></td>
                    <td align="right">
                        &nbsp;
                    </td>
                </tr>
            </table>
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
                        <td style="width:4%">期次编号</td>
                        <td width="1%">|</td>
                        <td style="width:5%">开始时间</td>
                        <td width="1%">|</td>
                        <td style="width:5%">结束时间</td>
                        <td width="1%">|</td>
                        <td style="width:5%">发布时间</td>
                        <td width="1%">|</td>
                        <td style="width:4%">发布状态</td>
                        <td width="1%">|</td>
                        <td style="width:4%">期次日期</td>
                        <td width="1%">|</td>
                        <td style="width:15%" class="no-print">操作</td>
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
                <td style="width:4%">${data.fbsIssueNumber}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:5%">${data.fbsIssueStart}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:5%">${data.fbsIssueEnd}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:5%">${data.publishTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:4%">
                    <c:if test="${data.publishStatus==1}">已发布</c:if>
                    <c:if test="${data.publishStatus==0}">未发布</c:if>
                </td>

                <td width="1%">&nbsp;</td>
                <td style="width:4%">${data.fbsIssueDate}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%" class="no-print">
                    <c:if test="${data.publishStatus == 1}">
                        <span><a href="#" onclick="showBox('fbsIssue.do?method=detailIssue&fbsIssueNumber=${data.fbsIssueNumber}','查看',620,1130)">查看</a></span> |
                        <span>修改</span> |
                        <span>编辑比赛</span> |
                        <span>删除</span> |
                        <span>发布</span>
                    </c:if>
                    <c:if test="${data.publishStatus == 0}">
                        <span><a href="#" onclick="showBox('fbsIssue.do?method=detailIssue&fbsIssueNumber=${data.fbsIssueNumber}','查看',620,1130)">查看</a></span> |
                        <span><a href="#" onclick="showBox('fbsIssue.do?method=updateIssue&fbsIssueNumber=${data.fbsIssueNumber}','修改',300,850)">修改</a></span> |
                        <span><a href="fbsIssue.do?method=joinMatch&fbsIssueNumber=${data.fbsIssueNumber}&issueStart=${data.fbsIssueStart}&issueEnd=${data.fbsIssueEnd}">编辑比赛</a></span> |
                        <span><a href="#" onclick="promptDelete('fbsIssue.do?method=deleteIssue&fbsIssueNumber=${data.fbsIssueNumber}','${data.fbsIssueNumber}')">删除</a></span> |
                        <span><a href="#" onclick="promptPublish('fbsIssue.do?method=piblishIssue&fbsIssueNumber=${data.fbsIssueNumber}','${data.fbsIssueNumber}','${data.matchCount}')">发布</a></span>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>

</body>
</html>
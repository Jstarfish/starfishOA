<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>残票查询</title>
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

        function checkAgencyCode() {
            if ($("#agencyCode").val() == '') {
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
        function submitForm() {
            var result = true;
            if (!checkAgencyCode()) {
                showError("站点编码不能为空");
                result = false;
            } else {
                var reg = new RegExp("^[0-9]*$");
                if (!reg.test($("#agencyCode").val())) {
                    showError("请输入正确站点编码");
                    result = false;
                }
                if (!checkEndQueryTime()) {
                    showError("查询时间结点不能为空");
                    result = false;
                }
                if (result) {
                    $("#badTicketForm").submit();
                }
                return result;
            }
        }
        function clearForm() {
            $("#agencyCode").val('');
            $("#endqueryTime").val('');
        }

    </script>

</head>
<body>
<div id="title">残票查询</div>

<div class="queryDiv">

    <form:form modelAttribute="badTicketForm" action="badticketquery.do?method=badticketquery">

        <div class="left">
                     <span>站点编号：<form:input path="agencyCode" id="agencyCode" maxlength="20" class="text-normal"/>
                     </span>
                      <span>
                     时间：<input id="endqueryTime" name="endqueryTime" value="${badTicketForm.endqueryTime}" class="Wdate"
                               type="text"
                               onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'%y-%M-%d %H:%m:%s'})"/>
                     </span>
            <input type="button" value="查询" onclick="submitForm();" class="button-normal"/>
            <input type="button" class="button-normal" value="清除" onclick="clearForm()">
        </div>
        <div class="right">
            <table width="260" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right">

                    </td>
                    <td style="width:30px"></td>
                    <td align="right">

                    </td>
                    <td align="right">

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
                        <td style="width:5%">站点编号</td>
                        <th width="1%">|</th>
                        <td style="width:6%">销售时间</td>
                        <th width="1%">|</th>
                        <td style="width:6%">游戏名称</td>
                        <th width="1%">|</th>
                        <td style="width:6%">游戏期次</td>
                        <th width="1%">|</th>
                        <td style="width:25%">投注玩法/号码/倍数/金额</td>
                        <th width="1%">|</th>
                        <td style="width:6%">流水号</td>
                        <th width="1%">|</th>
                        <td style="width:10%">彩票TSN</td>
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
                <td style="width:5%">${data.agencyCode}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.saleTime}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.gameName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.issueNumber}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:25%" title="${data.betlistStr}">${data.betlistStr}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:6%">${data.sellSeq}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%">${data.saleTsn}</td>
            </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>

</body>
</html>
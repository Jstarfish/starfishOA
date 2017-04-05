<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>
<html>
<head>
    <title>区域列表</title>
    <%@ include file="/views/common/meta.jsp" %>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css"/>

    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>
    <style type="text/css">
    </style>


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
                showError("Outlet Code Can Not Be Empty");
                result = false;
            } else {
                var reg = new RegExp("^[0-9]*$");
                if (!reg.test($("#agencyCode").val())) {
                    showError("Please Enter A Correct Outlet Code");
                    result = false;
                }
                if (!checkEndQueryTime()) {
                    showError("Time String Can Not Be Empty");
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
<div id="title">Broken Ticket Inquiry</div>
<div class="queryDiv">

    <form:form modelAttribute="badTicketForm" action="badticketquery.do?method=badticketquery">

        <div class="left">
            <span>Outlet Code：<form:input path="agencyCode" maxlength="20" class="text-normal"/></span>
            <span id="agencyCodeTip" class="tip_init">*</span>
                      <span>
                     Time：<input id="endqueryTime" name="endqueryTime" value="${badTicketForm.endqueryTime}"
                                 class="Wdate" type="text"
                                 onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'%y-%M-%d %H:%m:%s'})"/>
                     </span>
            <span id="endqueryTimeTip" class="tip_init">*</span>
            <input type="button" value="Query" onclick="submitForm()" class="button-normal"/>
            <input type="button" class="button-normal" value="Clear" onclick="clearForm()">
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
                        <td style="width:5%">Outlet Code</td>
                        <th width="1%">|</th>
                        <td style="width:6%">Sale Time</td>
                        <th width="1%">|</th>
                        <td style="width:6%">Game Name</td>
                        <th width="1%">|</th>
                        <td style="width:6%">Issue Number</td>
                        <th width="1%">|</th>
                        <td style="width:25%">Game Subtype/Bet Numbers/Multiple/Line Amount</td>
                        <th width="1%">|</th>
                        <td style="width:6%">Seq No.</td>
                        <th width="1%">|</th>
                        <td style="width:10%">Ticket No.</td>
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
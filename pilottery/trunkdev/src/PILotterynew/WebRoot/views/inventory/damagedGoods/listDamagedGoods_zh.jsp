<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Damaged Goods</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
    showWarn("TODO");
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">损毁货物</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="" id="queryForm">
            <div class="left">
                <span>记录编号: <input id="recordCodeQuery" class="text-normal" maxlength="4"/></span>
                <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="注册损毁货物" onclick="showWarn('TODO');" class="button-normal"></input>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                            <td style="width:14%">记录编号</td>
                            <td style="width:14%">方案编号</td>
                            <td style="width:14%">方案名称</td>
                            <td style="width:14%">标签编号</td>
                            <td style="width:14%">登记日期</td>
                            <td style="width:14%">登记人</td>
                            <td style="width:*%">备注</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
            <tr class="dataRow">
                <td style="width:14%">12345644</td>
                <td style="width:14%">2015001</td>
                <td style="width:14%">Happy Football</td>
                <td style="width:14%">123456789.guardz</td>
                <td style="width:14%">2015-09-07 14:25:21</td>
                <td style="width:14%">Tom Liang</td>
                <td style="width:*%">my remark</td>
            </tr>
            </tr>
        </table>
        <!-- ${pageStr} -->
    </div>
</body>
</html>
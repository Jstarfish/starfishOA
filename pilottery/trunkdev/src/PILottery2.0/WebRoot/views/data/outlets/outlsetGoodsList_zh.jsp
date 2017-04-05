<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Sales Records</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
  
   $("#outletGoodsForm").submit();
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">销售记录列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="outletGoods.do?method=outletGoodsList" name="outletGoodsForm" id="outletGoodsForm" method="post">
            <div class="left">
                
             
                <span>销售站编码:
                    <input type="text" name="arAgency" class="text-normal" value="${outletGoodsForm.arAgency}">
                </span>
                <span>日期:
                    <input id="arDate" class="Wdate text-normal" name="arDate" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})" value="${outletGoodsForm.arDate }"/>
                </span>
              
                
                <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                  
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
                         <td style="width:10px;">&nbsp;</td>
                            <td style="width:12%">编码</td>
                               <td width="1%" >|</td>
                            <td style="width:12%">销售站编码</td>
                               <td width="1%" >|</td>
                            <td style="width:12%">销售站名称</td>
                               <td width="1%" >|</td>
                            <td style="width:12%">票数(张)</td>
                               <td width="1%" >|</td>
                            <td style="width:12%">金额(瑞尔)</td>
                               <td width="1%" >|</td>
                            <td style="width:*%">日期</td>
                          
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
        <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
                 <td style="width:10px;">&nbsp;</td>
                <td style="width:12%">${data.arNo }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:12%">${data.arAgency }</td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:12%">${data.agencyName}</td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:12%"><fmt:formatNumber value="${data.tickets}" type="number"/></td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:12%" title="<fmt:formatNumber value='${data.amount}' type='number'/>" align="right"><fmt:formatNumber value="${data.amount}" type="number"/></td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:*%"><fmt:formatDate  value="${data.arDate}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
        </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>

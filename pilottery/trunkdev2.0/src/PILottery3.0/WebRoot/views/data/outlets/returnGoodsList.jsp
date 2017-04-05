<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Inventory Checks (Lottery)</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
   
   $("#returnedGoodsForm").submit();
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Return Delivery Records</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="returnedGoods.do?method=returnGoodsList" name="returnedGoodsForm" id="returnedGoodsForm" method="post"> 
            <div class="left">
                
             
                <span>Outlet Code:
                    <input type="text" name="arAgency" class="text-normal" value="${returnedGoodsForm.arAgency}">
                </span>
              
              
                <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
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
                            
                            <td style="width:20%">Outlet Code</td>
                              <td width="1%" >|</td>
                            <td style="width:20%">Outlet Name</td>
                              <td width="1%" >|</td>
                            <td style="width:20%">Tickets</td>
                              <td width="1%" >|</td>
                            <td style="width:20%">Amount(riels)</td>
                              <td width="1%" >|</td>
                            <td style="width:*%">Date</td>
                          
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
                
                <td style="width:20%">${data.arAgency }</td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:20%">${data.agencyName}</td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:20%" ><fmt:formatNumber value="${data.tickets}" type="number"/></td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:20%" align="right"><fmt:formatNumber value="${data.amount}" type="number"/></td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:*%"><fmt:formatDate  value="${data.arDate}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
          
        </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>

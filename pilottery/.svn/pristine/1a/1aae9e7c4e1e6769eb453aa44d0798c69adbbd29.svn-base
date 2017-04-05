<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Inventory Information (Lottery)</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
$(document).ready(function(){
	 var planCode=$("#planCode").val();
	initSelectbactch(planCode);
	var batchNo=$("#batchNo").val();
     
	initSelect(batchNo,planCode);
	$('#planCode').change(function(){ 
		var planCode=$("#planCode").val();
		if(planCode==null || planCode=='')
			return;
		initSelectbactch(planCode);
	});
	$('#batchNo').change(function(){ 
		var planCode=$("#planCode").val();
		var batchNo=$("#batchNo").val();
		if(planCode==null || planCode==''||batchNo==null|| batchNo=='')
			return;
		initSelect(batchNo,planCode);
	});

});
function initSelectbactch(planCode){
	
	var url="inventory.do?method=getBatchListByPlanCode&planCode=" + planCode;
	$.ajax({
		url : url,
		dataType : "json",
		async : false,
		success : function(r){
			$("#batchNo").empty();
			$("#batchNo").append("<option value=''>All</option>");
			$("#prizeGroup").empty();
			$("#prizeGroup").append("<option value=''>All</option>");
	          for(var i = 0; i < r.length; i++) { 
                  var option = $("<option>").val(r[i].batchNo).text(r[i].batchNo);  
                  $("#batchNo").append(option);  
              }
	}
	});
}
function initSelect(value,planCode){
	
    
	var url="inventory.do?method=getGroup&batchNo=" + value+"&planCode="+planCode;
	  
	 //alert(url);
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
					$("#prizeGroup").empty();
					$("#prizeGroup").append("<option value=''>All</option>");
			          for(var i = 0; i < r.length; i++) { 	
                          var option = $("<option>").val(r[i].rewardGroup).text(r[i].rewardGroup);  
                          $("#prizeGroup").append(option);  
                      }
			}
			});
			
			
}
function updateQuery() {
   
   $("#inventoryForm").submit();
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Inventory Information (Lottery)</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="inventory.do?method=listInventoryInfo" name="inventoryForm" id="inventoryForm" method="post">
            <div class="left">
                <span>Warehouse:
                    <select name="whcode" id="whcode" class="select-normal">
                        <option value="">All</option>
                        <c:forEach var="data" items="${listwh}" >
                         <option value="${data.whcode}" <c:if test="${inventoryForm.whcode==data.whcode }">selected</c:if> >${data.whname}</option>
                        </c:forEach>
                       
                    </select>
                </span>
                <span>Plan:<select name="planCode" id="planCode" class="select-normal">
                    	<option value="">All</option>
                        <c:forEach var="data" items="${listplan}" >
                         <option value="${data.planCode}" <c:if test="${inventoryForm.planCode==data.planCode}">selected</c:if>>${data.fullName}</option>
                        </c:forEach>                      
                    </select>
                </span>
                <span>Batch: <select name="batchNo" id="batchNo" class="select-normal">
                     
                       <%--  <c:forEach var="data" items="${listbatch}" >
                         <option value="${data.batchNo}" <c:if test="${inventoryForm.batchNo==data.batchNo }">selected</c:if>>${data.batchNo}</option>
                        </c:forEach> --%>
                       
                    </select>
                    </span>
                     <span>Prize Group: <select name="prizeGroup" id="prizeGroup" class="select-normal">
                        <option value="">All</option>
                       <%--  <c:forEach var="data" items="${listplan}" >
                         <option value="${data.planCode}">${data.fullName}</option>
                        </c:forEach> --%>
                       
                    </select>
                    </span>
                <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
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
                            <td style="width:20%">Plan Code</td>
                              <td width="1%" >|</td>
                            <td style="width:20%">Plan Name</td>
                              <td width="1%" >|</td>
                            <td style="width:20%">Batch Name</td>
                              <td width="1%" >|</td>
                            <td style="width:20%">Storage Quantity</td>
                              <td width="1%" >|</td>
                            <td style="width:*%">Storage Value</td>
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
                <td style="width:20%">${data.planCode}</td>
                  <td width="1%" >&nbsp;</td>
                <td style="width:20%">${data.planName}</td>
                  <td width="1%" >&nbsp;</td>
                <td style="width:20%">${data.batchNo}</td>
                  <td width="1%" >&nbsp;</td>
                <td style="width:20%"><fmt:formatNumber value="${data.tickts}" type="number"/></td>
                  <td width="1%" >&nbsp;</td>
                <td style="width:*%" align="right"><fmt:formatNumber value="${data.amount}" type="number"/></td>
            </tr>
            </c:forEach>
            <tr class="dataRow">
                
                <td style="width:10px;">&nbsp;</td>
                <td style="width:20%">Totals</td>
                  <td width="1%" >&nbsp;</td>
                <td style="width:20%"></td>
                  <td width="1%" >&nbsp;</td>
                <td style="width:20%"></td>
                  <td width="1%" >&nbsp;</td>
                <td style="width:20%"><fmt:formatNumber value="${vo.tickts}" type="number"/></td>
                  <td width="1%" >&nbsp;</td>
                <td style="width:*%" align="right"><fmt:formatNumber value="${vo.amount}" type="number"/></td>
             
            
            </tr>
        </table>
         ${pageStr}
    </div>
</body>
</html>
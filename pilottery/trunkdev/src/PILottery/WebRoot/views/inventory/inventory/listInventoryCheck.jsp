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
   
   $("#checkPointForm").submit();
}
function delte(orgCode){
	var msg = "Are you sure you want to delete ?";
	showDialog("delteCheck('"+orgCode+"')","Delete",msg);
}
function delteCheck(areaCode) {
   
	var url="inventory.do?method=processCheckPointDelete&cpNo=" + areaCode;
	  	 
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
			            if(r.message!='' && r.message!=null){
				            closeDialog();
			            	showError(decodeURI(r.message));
				        }
			            else{
			            	closeDialog();	
			            	window.location.reload(); 
				       }
			}
			});
	  
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Inventory Checks (Lottery)</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
		<form action="inventory.do?method=listInventoryCheck" id="checkPointForm" method="post">
			<div class="left">
				<span>
					Date: 
					<input id="cpDate" class="Wdate text-normal" name="cpDate" value="${checkPointForm.cpDate }" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>
				</span> 
				<span>
					Warehouse: 
					<select name="houseCode" id="houseCode" class="select-normal">         
                   		<option value="">All</option>
                       <c:forEach var="wh" items="${ listwh}">
                         <option value="${wh.whcode}" <c:if test="${checkPointForm.houseCode==wh.whcode }">selected</c:if> >${wh.whname}</option>
                       </c:forEach>
                   </select>
				</span>
				<span>
					Checked By:
					<select name="cpAdmin" id="cpAdmin" class="select-normal">
                    	<option value="">All</option>
                        <c:forEach var="user" items="${listuser}">
                          	<option value="${user.id}" <c:if test="${checkPointForm.cpAdmin==user.id }">selected</c:if> >${user.realName}</option>
                        </c:forEach>                        
                    </select>
				</span>
				<span>
					Status:
					<select name="status" id="status" class="select-normal">
                        <option value="">All</option>
                          <c:forEach var="item" items="${checkPointStatus}">
                          <option value="${item.key }" <c:if test="${checkPointForm.status==item.key }">selected</c:if>>${item.value }</option>
                           </c:forEach>
                    </select>
				</span>
				<span>
					Result:
					<select name="result" id="result" class="select-normal">
                        <option value="">All</option>                        
                         <c:forEach var="item" items="${checkResult}">
                             <option value="${item.key }" <c:if test="${checkPointForm.result==item.key }">selected</c:if>>${item.value }</option>
                        </c:forEach>
                    </select>
				</span>
				
				<input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
			</div>
			<div class="right">
				<table width="150" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
						<td align="right">
							<input type="button" value="New Inventory Check" onclick="showBox('inventory.do?method=addInit','New Inventory Check',400,550);" class="button-normal"></input>
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
                          <td style="width:10px;">&nbsp;</td>
                            <td style="width:10%">Check Code</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">Check Name</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">Warehouse</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">Date of Check</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">Status</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">Result</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">Checked By</td>
                             <td width="1%" >|</td>
                            <td style="width:*%">Operation</td>
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
                <td style="width:10%">${data.cpNo }</td>
                   <td width="1%" >&nbsp;</td>
                <td style="width:10%" title="${data.cpName }">${data.cpName }</td>
                      <td width="1%" >&nbsp;</td>
                <td style="width:10%" title="${data.houseCode}">${data.houseCode}</td>
                      <td width="1%" >&nbsp;</td>
                <td style="width:10%"><fmt:formatDate  value="${data.cpDate}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
                      <td width="1%" >&nbsp;</td>
                <td style="width:10%">
                		<c:forEach var="item" items="${checkPointStatus}">
                             <c:if test="${item.key==data.status}">${item.value }</c:if>
                           </c:forEach></td>
                                 <td width="1%" >&nbsp;</td>
                <td style="width:10%">
                		<c:if test="${data.status>1}">
                			<c:forEach var="itemx" items="${checkResult}">
                              <c:if test="${itemx.key==data.result}">${itemx.value }</c:if>
                			</c:forEach>
                		</c:if>
                </td>
                      <td width="1%" >&nbsp;</td>
                <td style="width:10%" title="${data.chName }">${data.chName }</td>
                      <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showBox('inventory.do?method=getCheckPointDetail&cpNo=${data.cpNo}','Checked Details', 550, 980);">Details</a></span>                    
                     <c:if test="${data.status==1}">
                     	<span>&nbsp;|&nbsp;<a href="inventory.do?method=checkPointNext&cpNo=${data.cpNo}">Check</a></span>
                     	<span>&nbsp;|&nbsp;<a href="inventory.do?method=checkFinsh&cpNo=${data.cpNo}">Finish</a></span>
                     	<span>&nbsp;|&nbsp;<a href="#" onclick="delte('${data.cpNo}');">Delete</a></span>
                    </c:if>
                  
                </td>
            </tr>
        </c:forEach>
        </table>
     ${pageStr} 
    </div>
</body>
</html>

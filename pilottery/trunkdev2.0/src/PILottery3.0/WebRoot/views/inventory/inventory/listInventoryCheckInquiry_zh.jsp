<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>	盘点列表 (Lottery)</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
$().ready(function(){
	$('#houseCode').val('${checkPointForm.houseCode}');
});
function updateQuery() {
    $("#checkPointForm").submit();
}
function delte(orgCode){
	var msg = "确定要删除吗 ?";
	showDialog("delteCheck('"+orgCode+"')","删除",msg);
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

function getWhByInst(){
	var orgCode = $('#institutionCode').val();
	$('#houseCode').empty();
	if(orgCode == ''){
		$('#houseCode').append("<option value=''>--全部--</option>"); 
		return false;
	}
	
	$.ajax({
		url : "saleReport.do?method=getWarehouseByInst&orgCode=" + orgCode,
		dataType : "json",
		async : false,
		success : function(result){
            if(result != '' && result !=null){
	            for(var i=0;i<result.length;i++){
	            	 $('#houseCode').append("<option value='"+result[i].warehouseCode+"'>"+result[i].warehouseName+"</option>"); 
	            }
	        }
		}
	});	
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">盘点列表查询</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
		<form action="inventory.do?method=listInventoryCheckInquiry" id="checkPointForm" method="post">
			<div class="left">
				<span>日期: 
					<input id="cpDate" class="Wdate text-normal" name="cpDate" value="${checkPointForm.cpDate }" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
				</span> 
				<span>机构:
            		<select class="select-normal" id="institutionCode" name="institutionCode"  onchange="getWhByInst();">
            			<option value="">--全部--</option>
                   	    <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == checkPointForm.institutionCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != checkPointForm.institutionCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	    </c:forEach>
                    </select>
            	</span>
				<span>仓库: 
					<select name="houseCode" id="houseCode" class="select-normal">         
                   		<option value="">--全部--</option>
            			<c:forEach var="obj" items="${warehouseList}" varStatus="plan">
                   	   		<c:if test="${obj.warehouseCode == checkPointForm.houseCode}">
                   	   			<option value="${obj.warehouseCode}" selected="selected">${obj.warehouseName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.warehouseCode != checkPointForm.houseCode}">
                   	   			<option value="${obj.warehouseCode}">${obj.warehouseName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                   </select>
				</span>
				<span>盘点结果:
					<select name="result" id="result" class="select-normal">
                        <option value="">-全部-</option>                        
                         <c:forEach var="item" items="${checkResult}">
                             <option value="${item.key }" <c:if test="${checkPointForm.result==item.key }">selected</c:if>>${item.value }</option>
                        </c:forEach>
                    </select>
				</span>
				
				<input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
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
                            <td style="width:10%">盘点编号</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">盘点名称</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">仓库</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">盘点日期</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">盘点状态</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">盘点结果</td>
                             <td width="1%" >|</td>
                            <td style="width:10%">盘点人</td>
                             <td width="1%" >|</td>
                            <td style="width:*%">操作</td>
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
				<td style="width: 10%">${data.cpNo }</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%" title="${data.cpName }">${data.cpName }</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%" title="${data.houseCode}">${data.houseCode}</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%"><fmt:formatDate value="${data.cpDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%">
					<c:forEach var="item" items="${checkPointStatus}">
						<c:if test="${item.key==data.status}">${item.value }</c:if>
					</c:forEach>
				</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%">
					<c:if test="${data.status>1}">
						<c:forEach var="itemx" items="${checkResult}">
							<c:if test="${itemx.key==data.result}">${itemx.value }</c:if>
						</c:forEach>
					</c:if>
				</td>
				<td width="1%">&nbsp;</td>
				<td style="width: 10%" title="${data.chName }">${data.chName }</td>
				<td width="1%">&nbsp;</td>
				<td style="width:*%">
                    <span><a href="#" onclick="showBox('inventory.do?method=getCheckPointDetail&cpNo=${data.cpNo}','盘点详情', 600, 980);">详情</a></span>                    
                </td>
            </tr>
        </c:forEach>
        </table>
     ${pageStr} 
    </div>
</body>
</html>

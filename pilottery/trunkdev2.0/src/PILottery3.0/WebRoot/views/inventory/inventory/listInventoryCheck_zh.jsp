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
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">盘点列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
		<form action="inventory.do?method=listInventoryCheck" id="checkPointForm" method="post">
			<div class="left">
				<span>日期: 
					<input id="cpDate" class="Wdate text-normal" name="cpDate" value="${checkPointForm.cpDate }" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
				</span> 
				<span>仓库: 
					<select name="houseCode" id="houseCode" class="select-normal">         
                   		<option value="">-全部-</option>
                       <c:forEach var="wh" items="${ listwh}">
                         <option value="${wh.whcode}" <c:if test="${checkPointForm.houseCode==wh.whcode }">selected</c:if> >${wh.whname}</option>
                       </c:forEach>
                   </select>
				</span>
				<span>盘点人:
					<select name="cpAdmin" id="cpAdmin" class="select-normal">
                    	<option value="">-全部-</option>
                        <c:forEach var="user" items="${listuser}">
                          	<option value="${user.id}" <c:if test="${checkPointForm.cpAdmin==user.id }">selected</c:if> >${user.realName}</option>
                        </c:forEach>                        
                    </select>
				</span>
				<span>盘点状态:
					<select name="status" id="status" class="select-normal">
                        <option value="">-全部-</option>
                          <c:forEach var="item" items="${checkPointStatus}">
                          <option value="${item.key }" <c:if test="${checkPointForm.status==item.key }">selected</c:if>>${item.value }</option>
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
			<div class="right">
				<table width="150px" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
						<td align="right">
							<input type="button" value="新建盘点" onclick="showBox('inventory.do?method=addInit','新建盘点',400,550);" class="button-normal"></input>
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
                    <span><a href="#" onclick="showBox('inventory.do?method=getCheckPointDetail&cpNo=${data.cpNo}','盘点详情', 600, 980);">详情</a></span>                    
                     <c:if test="${data.status==1}">
                     	<span>&nbsp;|&nbsp;<a href="inventory.do?method=checkPointNext&cpNo=${data.cpNo}">盘点</a></span>
                     	<span>&nbsp;|&nbsp;<a href="inventory.do?method=checkFinsh&cpNo=${data.cpNo}">完成</a></span>
                     	<span>&nbsp;|&nbsp;<a href="#" onclick="delte('${data.cpNo}');">删除</a></span>
                    </c:if>
                  
                </td>
            </tr>
        </c:forEach>
        </table>
     ${pageStr} 
    </div>
</body>
</html>

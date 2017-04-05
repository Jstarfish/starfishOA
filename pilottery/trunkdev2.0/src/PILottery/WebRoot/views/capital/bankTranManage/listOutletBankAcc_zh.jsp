<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>站点账户列表</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
 function updateQuery() {
	 $("#outletAcctForm").submit();
}
 
function handleStatus(agencyCode,status){
	var msg = "";
	var title="";

	
	if (status == 1) {
		msg = "确定要启用吗 ?";
		title = "启用";
	} else if (status == 2) {
		msg = "确定要禁用吗 ?";
		title = "禁用";
	} else if (status == 3) {
		msg = "确定要删除吗 ?";
		title = "删除";
	} else {
		return;
	}

	showDialog("updateOutletAccStatus('" + agencyCode + "',"+status+")", title, msg);
}
	

function updateOutletAccStatus(agencyCode,status) {

	var url = "outletBank.do?method=updateOutletStatus&bankAccSeq=" + agencyCode+"&status="+status;
	$.ajax({
			url : url,
			dataType : "json",
			async : false,
			success : function(r) {
				if (r.reservedSuccessMsg != ''
						&& r.reservedSuccessMsg != null) {
					closeDialog();
					showError(decodeURI(r.reservedSuccessMsg));
				} else {
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
    <div id="title">站点银行账户</div>
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="outletBank.do?method=listOutletAcc" method="POST" id="outletAcctForm">
            <div class="left">
            	
                <span>站点编码: <input id="outletCode" name="outletCode" value="${outletAcctForm.outletCode }" class="text-normal" maxlength="10"/></span>
                <span>账户卡号: <input id="outletBankAccNo" name="outletBankAccNo" value="${outletAcctForm.outletBankAccNo }" class="text-normal" maxlength="20"/></span>
                <span>状态: 
            		<select class="select-normal" name="status"  id ="status">
            		 	<option value="0">--全部--</option>
                   	    <c:forEach var="obj" items="${outletStatus}" varStatus="plan">
                   	   		<c:if test="${obj.key == outletAcctForm.status}">
                   	   			<option value="${obj.key}" selected="selected">${obj.value}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.key != outletAcctForm.status}">
                   	   			<option value="${obj.key}">${obj.value}</option>
                   	   		</c:if>
                   	    </c:forEach>
                    </select>
            	</span>
                
                <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
                <input type="button" class="button-normal" value="新增银行账户" 
					    onclick="showBox('outletBank.do?method=addInitOutletAccount','新增银行账户',550,800)"/>
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
                            <td style="width:15%">站点编码</td>
                            <th width="1%">|</th>
                            <td style="width:15%">站点名称</td>
                            <th width="1%">|</th>
                            <td style="width:15%">所属银行</td>
                            <th width="1%">|</th>
                            <td style="width:15%">账户序号</td>
                            <th width="1%">|</th>
                            <td style="width:15%">账户卡号</td>
                            <th width="1%">|</th>
                            <td style="width:15%">账户名称</td>
                            <th width="1%">|</th>
                            <td style="width:15%">默认币种</td>
                            <th width="1%">|</th>
                            <td style="width:15%">状态</td>
                            <th width="1%">|</th>
                            <td style="width:15%">操作</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv" >
        <table class="datatable">
         <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:15%">${data.agencyCode }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%" title="${data.agencyName }">${data.agencyName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">
	                <c:choose>
					    <c:when test="${data.bankAccType == 2}">
					       Wing
					    </c:when>
					    <c:otherwise>
					      	-
					    </c:otherwise>
					</c:choose>                
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">${data.bankAccSeq }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">${data.bankAccNo }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">${data.bankAccName }</td>
                <td width="1%">&nbsp;</td>
                 <td style="width:15%">
	                <c:choose>
					    <c:when test="${data.currency == 1}">
					      	 瑞尔
					    </c:when>
					    <c:otherwise>
					      	美金
					    </c:otherwise>
					</c:choose>                
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">
                	<c:choose>
					    <c:when test="${data.status == 1}">
					      	 正常
					    </c:when>
					    <c:when test="${data.status == 2}">
					      	 停用
					    </c:when>
					    <c:otherwise>
					      	删除
					    </c:otherwise>
					</c:choose> 
  				</td>
                <td width="1%">&nbsp;</td>
                
                <td style="width:15%">
                    <span>
                    	<c:if test="${data.status == 1}">                    		
                    		<a href="#" onclick="showBox('outletBank.do?method=editOutletAccount&bankAccSeq=${data.bankAccSeq}','编辑',500,600);">编辑</a>
                    		<a href="#" onclick="handleStatus('${data.bankAccSeq }',2);">禁用</a>
                    		<a href="#" onclick="handleStatus('${data.bankAccSeq }',3);">删除</a>
                    	</c:if>
                    	<c:if test="${data.status == 2}">
							<a href="#" onclick="showBox('outletBank.do?method=editOutletAccount&bankAccSeq=${data.bankAccSeq}','编辑',500,600);">编辑</a>
							<a href="#" onclick="handleStatus('${data.bankAccSeq }',1);">启用</a>
                    		<a href="#" onclick="handleStatus('${data.bankAccSeq }',3);">删除</a>                    	
					    </c:if>
					    <c:if test="${data.status == 3}">
					    	<span>编辑</span>
					    	<span>启用</span>
					    	<span>删除</span>                   	
					    </c:if>
                    </span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body> 

</html>
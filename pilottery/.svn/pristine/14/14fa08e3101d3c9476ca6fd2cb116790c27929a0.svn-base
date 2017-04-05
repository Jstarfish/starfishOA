<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List Outlet Bank Account</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_en.js"></script>
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
		msg = "Are you sure to reused it ?";
		title = "Enable";
	} else if (status == 2) {
		msg = "Are you sure to stop it ?";
		title = "Disable";
	} else if (status == 3) {
		msg = "Are you sure to delete it ?";
		title = "Delete";
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
    <div id="title">List Outlet Bank Account</div>
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="outletBank.do?method=listOutletAcc" method="POST" id="outletAcctForm">
            <div class="left">
            	
                <span>Outlet Code: <input id="outletCode" name="outletCode" value="${outletAcctForm.outletCode }" class="text-normal" maxlength="10"/></span>
                <span>Bank Account: <input id="outletBankAccNo" name="outletBankAccNo" value="${outletAcctForm.outletBankAccNo }" class="text-normal" maxlength="20"/></span>
                <span>Status: 
            		<select class="select-normal" name="status"  id ="status">
            		 	<option value="0">--All--</option>
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
                
                <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
                <input type="button" class="button-normal" value="New" 
					    onclick="showBox('outletBank.do?method=addInitOutletAccount','New Bank Account',550,800)"/>
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
                            <td style="width:15%">Outlet Code</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Outlet Name</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Bank</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Account Sequence</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Account No.</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Account Name</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Currency</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Status</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Operation</td>
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
					      	Riel
					    </c:when>
					    <c:otherwise>
					      	USD
					    </c:otherwise>
					</c:choose>                
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">
                	<c:choose>
					    <c:when test="${data.status == 1}">
					      	Enable
					    </c:when>
					    <c:when test="${data.status == 2}">
					      	Disalbe
					    </c:when>
					    <c:otherwise>
					      	Deleted
					    </c:otherwise>
					</c:choose> 
  				</td>
                <td width="1%">&nbsp;</td>
                
                <td style="width:15%">
                    <span>
                    	<c:if test="${data.status == 1}">                    		
                    		<a href="#" onclick="showBox('outletBank.do?method=editOutletAccount&bankAccSeq=${data.bankAccSeq}','Edit',500,600);">Edit</a>
                    		<a href="#" onclick="handleStatus('${data.bankAccSeq }',2);">Enable</a>
                    		<a href="#" onclick="handleStatus('${data.bankAccSeq }',3);">Delete</a>
                    	</c:if>
                    	<c:if test="${data.status == 2}">
							<a href="#" onclick="showBox('outletBank.do?method=editOutletAccount&bankAccSeq=${data.bankAccSeq}','Edit',500,600);">Edit</a>
							<a href="#" onclick="handleStatus('${data.bankAccSeq }',1);">Disable</a>
                    		<a href="#" onclick="handleStatus('${data.bankAccSeq }',3);">Delete</a>                    	
					    </c:if>
					    <c:if test="${data.status == 3}">
					    	<span>Edit</span>
					    	<span>Enable</span>
					    	<span>Delete</span>                   	
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
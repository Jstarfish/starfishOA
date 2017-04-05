<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of OutletAccount</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
 function updateQuery() {
	 $("#outletAcctForm").submit();
}
 
function delte(agencyCode){
	var msg = "Are you sure you want to delete ?";
	showDialog("delteOutletAcct('"+agencyCode+"')","Delete",msg);
}
function delteOutletAcct(agencyCode) {

	var url="account.do?method=deleteOutletAcct&agencyCode=" + agencyCode;
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
			            if(r.reservedSuccessMsg!='' && r.reservedSuccessMsg!=null){
				            closeDialog();
			            	showError(decodeURI(r.reservedSuccessMsg));
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
    <div id="title">Outlet Accounts</div>
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="account.do?method=listOutletAccounts" method="POST" id="outletAcctForm">
            <div class="left">
            	<span>Institution: 
            		<select class="select-normal" name="orgCode" >
            		 	<option value="">--All--</option>
                   	    <c:forEach var="obj" items="${orgList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == outletAcctForm.orgCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != outletAcctForm.orgCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	    </c:forEach>
                    </select>
            	</span>
                <span>Outlet Code: <input id="agencyCode" name="agencyCode" value="${outletAcctForm.agencyCode }" class="text-normal" maxlength="10"/></span>
                <span>Outlet Name: <input id="agencyName" name="agencyName" value="${outletAcctForm.agencyName }" class="text-normal" maxlength="20"/></span>
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
                            <td style="width:15%">Outlet Code</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Outlet Name</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Credit Limit(riels)</td>
                            <th width="1%">|</th>
                            <td style="width:15%">Account Balance(riels)</td>
                            <th width="1%">|</th>
                            <td style="width:*%">Operations</td>
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
                <td style="width:15%;text-align:right; title="${data.creditLimit }"><fmt:formatNumber value="${data.creditLimit }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%;text-align:right; title="${data.accountBalance }"><fmt:formatNumber value="${data.accountBalance }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%">
                    <span>
                    	<c:if test="${applicationScope.useCompany == 2}">
                    	<a href="#" onclick="showBox('account.do?method=editOutletAccount&agencyCode=${data.agencyCode }','Edit',550,800);">Edit</a>
                    	</c:if>
                    	<c:if test="${applicationScope.useCompany == 1}">
                    	<a href="#" onclick="showBox('account.do?method=editOutletAccount&agencyCode=${data.agencyCode }','Edit',300,650);">Edit</a>
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
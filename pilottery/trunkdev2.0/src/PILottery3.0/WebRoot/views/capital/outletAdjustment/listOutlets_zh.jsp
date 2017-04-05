<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title></title>
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
 
function delte(agencyCode){
	var msg = "确定要删除吗 ?";
	showDialog("delteOutletAcct('"+agencyCode+"')","删除",msg);
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
    <div id="title">站点调账</div>
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="account.do?method=getOutletInfo&&init=0" method="POST" id="outletAcctForm">
            <div class="left">
                <span>站点编号: <input id="agencyCode" name="agencyCode" value="${outletAcctForm.agencyCode }" class="text-normal" maxlength="10"/></span>
                <span>站点名称: <input id="agencyName" name="agencyName" value="${outletAcctForm.agencyName }" class="text-normal" maxlength="20"/></span>
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
                            <td style="width:15%">站点编号</td>
                            <th width="1%">|</th>
                            <td style="width:15%">站点名称</td>
                            <th width="1%">|</th>
                            <td style="width:15%">信用额度(瑞尔)</td>
                            <th width="1%">|</th>
                            <td style="width:15%">账户余额(瑞尔)</td>
                            <th width="1%">|</th>
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
                    <span><a href="#" onclick="showBox('account.do?method=initOutletAccount&agencyCode=${data.agencyCode }','调账',400,600);">调账</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body> 

</html>
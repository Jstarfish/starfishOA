<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>站点银行提现流水</title>
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
 
function handle(agencyCode){
	var msg = "处理交易异常";
	showDialog("handleTran('"+agencyCode+"')","处理",msg);
}
function handleTran(tranFlow) {

	var url="outletBank.do?method=handlerTrans&type=2&tranFlow=" + tranFlow;
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
    <div id="title">站点银行提现流水</div>
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="outletBank.do?method=listWithdrawRecords" method="POST" id="outletAcctForm">
            <div class="left">
                <span>站点编码: <input id="outletCode" name="outletCode" value="${outletAcctForm.outletCode }" class="text-normal" maxlength="10"/></span>
                <span>账户卡号: <input id="outletBankAccNo" name="outletBankAccNo" value="${outletAcctForm.outletBankAccNo }" class="text-normal" maxlength="20"/></span>
                <span>申请日期从:
                    <input id="beginTime" name="beginTime" value="${outletAcctForm.beginTime }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                <span>到:
                    <input id="endTime" name="endTime" value="${outletAcctForm.endTime }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
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
                        	<td style="width:20%">交易流水号</td>
                            <th width="1%">|</th>
                            <td style="width:10%">站点编码</td>
                            <th width="1%">|</th>
                            <td style="width:15%">站点名称</td>
                            <th width="1%">|</th>
                            <td style="width:10%">支付卡号</td>
                            <th width="1%">|</th>
                            <td style="width:15%">账户名称</td>
                            <th width="1%">|</th>
                            <td style="width:10%">提现金额(R)</td>
                            <th width="1%">|</th>
                            <td style="width:10%">手续费用(R)</td>
                            <th width="1%">|</th>
                            <td style="width:15%">请求时间</td>
                            <th width="1%">|</th>
                            <td style="width:15%">响应时间</td>
                            <th width="1%">|</th>
                            <td style="width:10%">当前状态</td>
                            <th width="1%">|</th>
                            <td style="width:5%">操作</td>
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
                <td style="width:20%" title="${data.tranFlow }">${data.tranFlow }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%">${data.agencyCode}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%" title="${data.agencyName }">${data.agencyName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%" title="${data.bankAccNo }">${data.bankAccNo }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%" title="${data.bankAccName }">${data.bankAccName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align:right;"><fmt:formatNumber value="${data.amount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;text-align:right;"><fmt:formatNumber value="${data.fee }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">${data.applyTime }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:15%">${data.responseTime }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;" title="${data.failureReason }">
                	<c:if test="${data.status>0}">
               			<c:forEach var="itemx" items="${tranStatus}">
                             <c:if test="${itemx.key==data.status}">${itemx.value }</c:if>
               			</c:forEach>
               		</c:if>
                </td>
                <td width="1%">&nbsp;</td>
                <td style="width:5%">
                    <span>
                    	<c:if test="${data.status == 4 ||data.status == 1}">
                    		<a href="#" onclick="handle('${data.tranFlow}');">处理</a>
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
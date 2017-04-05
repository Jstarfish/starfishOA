<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Return Records</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
 function ondetail(contractNo,type){
	 if(type==1){
		 showBox('transferRecord.do?method=salesDetail&contractNo='+contractNo,'Sales Record Detail',550,1000);
	 }
	 if(type==2){
		 showBox('transferRecord.do?method=payoutRecordDetail&contractNo='+contractNo,'Payout Record Detail',550,1000);
	 }
	 if(type==3){
		 showBox('transferRecord.do?method=returnRecordDetail&contractNo='+contractNo,'Return Record Detail',550,1000);
	 }
 }

</script>

</head>
<body>
    <!-- 提现申请 -->
     <div id="title">MM Transaction Records</div>
    
    <div class="queryDiv">
        <form action="transferRecord.do?method=listMMTransferRecords" id="form" method="post">
            <div class="left">
                <span>Market Manager: <input id="marketManagerName" name="marketManagerName" value="${form.marketManagerName }" class="text-normal" maxlength="10"/></span>
                <span>Outlet Code:
                    <input id="outletCode" name="outletCode" value="${form.outletCode }" class="text-normal" maxlength="10"/>
                </span>
                <input type="submit" value="Query" class="button-normal"></input>
            </div>
            
            <div class="right">
				<table width="260" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
					</tr>
				</table>
			</div>
			
        </form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
                            <td style="width:10%">Date</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Market Manager</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Outlet Code</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Outlet Name</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Contract No</td>
                            <th width="1%">|</th>
                            <td style="width:10%">Type</td>
                            <th width="1%">|</th>
                            <td style="width:*%">Operation</td>
                        </tr>
                    </table>
                 </td>
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    <div id="bodyDiv">
        <table class="datatable">
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:10%"><fmt:formatDate value="${obj.contractDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%" title="${obj.marketManagerName}">${obj.marketManagerName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%" title="${obj.outletCode}">${obj.outletCode}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%" title="${obj.outletName}">${obj.outletName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;">${obj.contractNo}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%;">
                	<c:if test="${obj.dealType == 1}">Sales</c:if>
                	<c:if test="${obj.dealType == 2}">Pay Out</c:if>
                	<c:if test="${obj.dealType == 3}">Return</c:if>
                </td>
                <td width="1%">&nbsp;</td>
                 <td style="width:*%">
                 <a href="#" onclick="ondetail('${obj.flowNo}','${obj.dealType}')">Details</a>

            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body> 
</html>
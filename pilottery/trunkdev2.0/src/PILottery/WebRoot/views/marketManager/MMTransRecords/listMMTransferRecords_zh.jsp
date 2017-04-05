<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>交易记录</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
 function ondetail(contractNo,type){
	 if(type==1){
		 showBox('transferRecord.do?method=salesDetail&contractNo='+contractNo,'销售记录详情',550,1000);
	 }
	 if(type==2){
		 showBox('transferRecord.do?method=payoutRecordDetail&contractNo='+contractNo,'兑奖记录详情',550,1000);
	 }
	 if(type==3){
		 showBox('transferRecord.do?method=returnRecordDetail&contractNo='+contractNo,'退票记录详情',550,1000);
	 }
 }

</script>

</head>
<body>
    <!-- 提现申请 -->
     <div id="title">市场管理员交易记录</div>
    
    <div class="queryDiv">
        <form action="transferRecord.do?method=listMMTransferRecords" id="form" method="post">
            <div class="left">
                <span>市场管理员名称: <input id="marketManagerName" name="marketManagerName" value="${form.marketManagerName }" class="text-normal" maxlength="10"/></span>
                <span>站点编号:
                    <input id="outletCode" name="outletCode" value="${form.outletCode }" class="text-normal" maxlength="10"/>
                </span>
                <input type="submit" value="查询" class="button-normal"></input>
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
                            <td style="width:10%">日期</td>
                            <th width="1%">|</th>
                            <td style="width:10%">市场管理员名称</td>
                            <th width="1%">|</th>
                            <td style="width:10%">站点编号</td>
                            <th width="1%">|</th>
                            <td style="width:10%">站点名称</td>
                            <th width="1%">|</th>
                            <td style="width:10%">合同编号</td>
                            <th width="1%">|</th>
                            <td style="width:10%">类型</td>
                            <th width="1%">|</th>
                            <td style="width:*%">操作</td>
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
                	<c:if test="${obj.dealType == 1}">销售</c:if>
                	<c:if test="${obj.dealType == 2}">兑奖</c:if>
                	<c:if test="${obj.dealType == 3}">退票</c:if>
                </td>
                <td width="1%">&nbsp;</td>
                 <td style="width:*%">
                 <a href="#" onclick="ondetail('${obj.flowNo}','${obj.dealType}')">详情</a>

            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body> 
</html>
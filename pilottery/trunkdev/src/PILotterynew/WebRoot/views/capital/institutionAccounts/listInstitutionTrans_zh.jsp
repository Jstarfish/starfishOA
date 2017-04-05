<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title></title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>


<script type="text/javascript" charset="UTF-8">
function getDetails(flowNo){
	showBox('capitalRecord.do?method=getCapitalRecordDetail&flowNo='+flowNo,'交易记录详情',550,1280);
 }

</script>

</head>
<body>
    <!-- 提现申请 -->
     <div id="title">部门资金流水</div>
    
    <div class="queryDiv">
        <form action="capitalRecord.do?method=listCapitalRecords" id="form" method="post">
            <div class="left">
            	<span>部门:
            		<select class="select-normal" name="crtorg" >
            			<option value="">--所有--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == form.crtorg}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.crtorg}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
            	
            	<span>类型:
            		<select id="type" name="type" class="select-normal" >
						<option value="">--所有--</option>
						<c:forEach var="data" items="${transFlowType}" >
                         <option value="${data.key}" <c:if test="${form.type==data.key }">selected</c:if>>${data.value}</option>
                        </c:forEach> 
                       <%--  <c:forEach var="item" items="${transFlowType}">
                        <c:if test="${!empty obj }">
                        <c:if test="${obj.type==item.key }">${item.value}</c:if></c:if></c:forEach> --%>
					<!-- 	<option value="1">充值</option>
						<option value="2">提现</option>
						<option value="3">彩票调拨</option>
						<option value="4">机构佣金</option>
						<option value="12">机构退货</option>
						<option value="21">站点兑奖佣金</option>
						<option value="22">站点兑奖</option>
						<option value="23">中心兑奖佣金</option>
						<option value="24">中心兑奖</option>
						<option value="25">调拨出佣金</option> -->
					</select>
                </span>
                <span>日期:
                     <input name="beginDate" value="${form.beginDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
                    	-
                    <input name="endDate" value="${form.endDate }" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
               
                <input type="submit" value="查询" class="button-normal"></input>
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
                            <td style="width:10%">部门编号</td>
                            <th width="1%">|</th>
                            <td style="width:10%">部门名称</td>
                            <th width="1%">|</th>
                            <td style="width:10%">类型</td>
                            <th width="1%">|</th>
                            <td style="width:10%">操作前余额</td>
                            <th width="1%">|</th>
                            <td style="width:10%">操作金额</td>
                            <th width="1%">|</th>
                            <td style="width:*%">操作后金额</td>
                            <!-- <th width="1%">|</th>
                            <td style="width:*%">Operation</td> -->
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
                <td style="width:10%"><fmt:formatDate value="${obj.tradeTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%">${obj.orgCode}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%" >${obj.orgName}</td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%"><c:forEach var="item" items="${transFlowType}"><c:if test="${!empty obj }"><c:if test="${obj.type==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%; text-align: right"><fmt:formatNumber value="${obj.beforeBalance }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:10%; text-align: right"><fmt:formatNumber value="${obj.amount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%; text-align: right"><fmt:formatNumber value="${obj.afterBalance }" /></td>
                <!--<td width="1%">&nbsp;</td>
                <td style="width:*%">
                <c:if test="${obj.type == 4}">
                 	<a href="#" onclick="getDetails('${obj.flowNo}')">Details</a>
                </c:if>
                <c:if test="${obj.type != 4}">
                	<span style="color:#CDC9C9">Details</span>
                </c:if>
               </td> -->
            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body> 
</html>
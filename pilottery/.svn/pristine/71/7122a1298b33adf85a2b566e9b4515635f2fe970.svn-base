<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>

<script type="text/javascript">
function updateView(){
	$("#gameManagementForm").submit();
}
function showYue(gameCode,id){
	$().ajaxSubmit({
		type : 'POST',
		url : 'gameManagement.do?method=showYue&gameCode='+gameCode,
		success : function(data) { 
			$("#"+id).html(data);
		}
	});
}
</script>
</head>
<body>
<div id="title">奖池流水</div>
<div class="queryDiv">
	<form:form modelAttribute="gameManagementForm" action="gameManagement.do?method=poolAdj">
		<div class="left">
		  	<span>游戏名称:
		   	 	<form:select path="gamePoolHis.gameCode"  class="select-normal" onchange="showYue(this.value,'yue');">
					<c:forEach items="${games}" var="s">
						<form:option value="${s.gameCode}">${s.shortName}</form:option>
					</c:forEach>
				</form:select>
		    </span>
		   	奖池余额：<span id="yue"><fmt:formatNumber type="number" value="${gamePool.poolAmountAfter}" /></span> 
		  </div>
		   <div class="tj">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  	<span>日期区间:
		   	 	<form:input id="str_adjTime1" path="str_adjTime1" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,maxDate:\"#F{$dp.$D('str_adjTime2')}\"})"/> -
		   	 	<form:input id="str_adjTime2" path="str_adjTime2" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,minDate:\"#F{$dp.$D('str_adjTime1')}\"})"/>
		    </span>
		    <a href="#" onclick="updateView();"><button class="button-normal">查询</button></a>
		</div>
	</form:form>
</div>
<div id="headDiv">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr><td>
			<table class="datatable">
				<tr class="headRow">
					<td style="width:10px;">&nbsp;</td>
					<td width="100">奖池流水</td>
					<td width="1%">|</td>
                    <td>奖池名称</td>
                    <td width="1%">|</td>
                    <td width="300">变更类型</td>
                    <td width="1%">|</td>
                    <td>变更金额</td>
                    <td width="1%">|</td>
                    <td>变更前金额</td>
                    <td width="1%">|</td>
                    <td>变更后金额</td>
                    <td width="1%">|</td>
                    <td>调整备注</td>
                    <td width="1%">|</td>
                    <td>变更时间</td>
				</tr>
			</table>
		</td><td style="width:17px;background:#2aa1d9;"></td></tr>
	</table>
</div>
<div id="bodyDiv">
    <table class="datatable">
 	    <c:forEach var="row" items="${pageDataList}">
        <tr class="dataRow">
        	<td style="width:10px;">&nbsp;</td>
        	<td width="100">${row.hisCode}</td>
        	<td width="1%">&nbsp;</td>
        	<td>${gameInfoMap[row.gameCode]}</td>
        	<td width="1%">&nbsp;</td>
        	<td width="300">${poolChangeType[row.poolAdjType]} </td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.changeAmount}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.poolAmountBefore}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.poolAmountAfter}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td title="${row.adjReason}">${row.adjReason}</td>
        	<td width="1%">&nbsp;</td>
        	<td><fmt:formatDate value="${row.adjTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>
</body>
</html>

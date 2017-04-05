<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
function submit(){
	$("#fundManagementForm").submit();
}
</script>
</head>
<body>
<div id="title">发行费管理</div>
<div class="queryDiv">
	<form:form modelAttribute="fundManagementForm" action="fundManagement.do?method=govCommision">
      	<div class="left">
		  	<span>游戏名称:
		   	 	<form:select path="governmentCommision.gameCode"  class="select-normal">
					<c:forEach items="${games}" var="s">
						<form:option value="${s.gameCode}">${s.shortName}</form:option>
					</c:forEach>
				</form:select>
		    </span>
		    <span>日期区间:
		   	 	<form:input id="str_adjTime1" path="str_adjTime1" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,maxDate:\"#F{$dp.$D('str_adjTime2')}\"})"/> -
		   	 	<form:input id="str_adjTime2" path="str_adjTime2" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,minDate:\"#F{$dp.$D('str_adjTime1')}\"})"/>
		    </span>
		    <a href="#" onclick="submit();"><button class="button-normal">查询</button></a>
		</div>
	</form:form>
</div>
<div id="headDiv">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr><td>
			<table class="datatable">
				<tr class="headRow">
					<td style="width:10px;">&nbsp;</td>
					<td width="8%">发行费流水</td>
					<td width="1%">|</td>
                    <td width="8%">游戏名称</td>
                    <td width="1%">|</td>
                    <td width="8%">游戏期号</td>
                    <td width="1%">|</td>
                    <td width="12%">变更类型</td>
                    <td width="1%">|</td>
                    <td width="8%">变更金额</td>
                    <td width="1%">|</td>
                    <td width="8%">变更前金额</td>
                    <td width="1%">|</td>
                    <td width="8%">变更后金额</td>
                    <td width="1%">|</td>
                    <td width="10%">变更时间</td>
                    <td width="1%">|</td>
                    <td width="*%">调整备注</td>
				</tr>
			</table>
		</td><td style="width:17px;background:#2aa1d9"></td></tr>
    </table>
</div>
<div id="bodyDiv">
    <table class="datatable">
    	<c:forEach var="row" items="${pageDataList}">
        <tr class="dataRow">
        	<td style="width:10px;">&nbsp;</td>
        	<td width="8%">${row.hisCode}</td>
        	<td width="1%">&nbsp;</td>
        	<td width="8%">${gameInfoMap[row.gameCode]}</td>
        	<td width="1%">&nbsp;</td>
        	<td width="8%">${row.issueNumber}</td>
        	<td width="1%">&nbsp;</td>
        	<td width="12%">
        		<c:if test="${row.commChangeType==1}">期次开奖滚入</c:if>
				<c:if test="${row.commChangeType==2}">发行费手动拨出到奖池</c:if>
				<c:if test="${row.commChangeType==3}">发行费手动拨出到调节基金</c:if>
				<c:if test="${row.commChangeType==9}">初始化设置</c:if>
			</td>
			<td width="1%">&nbsp;</td>
        	<td width="8%" align="right"><fmt:formatNumber type="number" value="${row.adjAmount}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td width="8%" align="right"><fmt:formatNumber type="number" value="${row.adjAmountBefore}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td width="8%" align="right"><fmt:formatNumber type="number" value="${row.adjAmountAfter}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td width="10%"><fmt:formatDate value="${row.adjTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        	<td width="1%">&nbsp;</td>
        	<td width="*%" title="${row.adjReason}">${row.adjReason}</td>
        </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>
</body>
</html>
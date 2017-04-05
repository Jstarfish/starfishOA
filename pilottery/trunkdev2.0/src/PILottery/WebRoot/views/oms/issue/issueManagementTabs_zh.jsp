<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs_zh.js"></script>
<script type="text/javascript">
jQuery(document).ready(function($) { 
    $("input[type='text']").each(  
          function(){  
              $(this).keypress( function(e) {  
                      var key = window.event ? e.keyCode : e.which;  
                      if(key.toString() == "13"){  
                      	  return false;  
                      }  
              });  
    	 }
    );  
});

function updateView(){ 
    $("#issueManagementForm").submit();
}
function prompt(gameCode,issueNumber,isPublish,flag) {
	
	var msg = "你确认要"+"&nbsp;"+flag+"晚于"+issueNumber+"</br>期次的所有期次吗?";
	showDialog("deleteIssue("+gameCode+","+issueNumber+","+isPublish+")",flag+"&nbsp;"+"期次",msg);
}
function deleteIssue(gameCode,issueNumber,isPublish){ 
	$("#issueManagementForm").attr("action","issueManagement.do?method=deleteIssue&fl=confirm&gameCode="+gameCode+"&issueNumber="+issueNumber+"&isPublish="+isPublish);
	button_off("ok_button");
	$("#issueManagementForm").submit();
}
</script>
</head>
<body>
<div id="title">期次查询</div>
<div class="queryDiv">
    <form:form modelAttribute="issueManagementForm" action="issueManagement.do?method=issueManagementTabs">
        <div class="left">
            <span>游戏名称:
                <form:select path="gameCode"  class="select-normal">
                    <c:forEach items="${games}" var="s">
                        <form:option value="${s.gameCode}">${s.shortName}</form:option>
                    </c:forEach>
                </form:select>
            </span>
            <span>游戏期号:
                <form:input path="issueNumber" maxlength="12" onblur="value=value.replace(/[^0-9]/g,'')" class="text-normal"/>
            </span> 
            <span>期次状态:
                <form:select path="issueStatus"  class="select-normal">
                	<form:option value="0">--全部--</form:option>
                    <form:options items="${issueStatusMap}" />
                </form:select>
            </span> 
            <span>发布状态:
                <form:select path="isPublish" class="select-normal">
                    <form:option value="">--全部--</form:option>
                    <form:option value="1">发布</form:option>
                    <form:option value="0">未发布</form:option>
                </form:select>
            </span> 
            <span>日期:
		   	 	<form:input path="openDate" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
		    </span>
            <a href="#" onclick="updateView();"><button class="button-normal">查询</button></a>
        </div>
        <div class="right"> 
			<table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
			  <tr style="height:50px;line-height:50px">
			    <td><input type="button" class="button-normal" value="期次发布" 
			    onclick="showBox('issueManagement.do?method=issuePublish','期次发布',300,550)"/></td>
			    <td align="right">
					&nbsp;
	              	</td>
			  </tr>
			</table>
	    </div>
    </form:form>    
</div>
<div id="headDiv">
    <table width="100%"  border="0" cellpadding="0" cellspacing="0">
       <tr><td>
            <table class="datatable">
            	<tr class="headRow">
            		<td style="width:10px;">&nbsp;</td>
					<td>游戏期号</td>
					<td width="1%">|</td>
                    <td>开始时间</td>
                    <td width="1%">|</td>
                    <td>关闭时间</td>
                    <td width="1%">|</td>
                    <td>开奖时间</td>
                    <td width="1%">|</td>
                    <td>期次状态</td>
                    <td width="1%">|</td>
                    <td>销售额</td>
                    <td width="1%">|</td>
                    <td>期初奖池</td>
                    <td width="1%">|</td>
                    <td>期末奖池</td>
                    <td width="1%">|</td>
                    <td>发布状态</td>
                    <td width="1%">|</td>
                    <td width="330">操作</td>
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
        	<td>${row.issueNumber}</td>
			<c:if test="${row.issueStatus==2 || row.issueStatus==3}">
				<td title="<fmt:formatDate value="${row.realStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate value="${row.realStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				<td width="1%">&nbsp;</td>
			</c:if>
            <c:if test="${row.issueStatus!=2 && row.issueStatus!=3}">
            	<td title="<fmt:formatDate value="${row.planStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate value="${row.planStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            	<td width="1%">&nbsp;</td>
            </c:if>
       		<c:if test="${row.issueStatus>=4}">
       			<td title="<fmt:formatDate value="${row.realCloseTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate value="${row.realCloseTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
       			<td width="1%">&nbsp;</td>
       		</c:if>
            <c:if test="${row.issueStatus<4}">
            	<td title="<fmt:formatDate value="${row.planCloseTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate value="${row.planCloseTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            	<td width="1%">&nbsp;</td>
            </c:if>
			<c:if test="${row.issueStatus==13}">
				<td title="<fmt:formatDate value="${row.issueEndTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate value="${row.issueEndTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				<td width="1%">&nbsp;</td>
			</c:if>
            <c:if test="${row.issueStatus!=13}">
            	<td title="<fmt:formatDate value="${row.planRewardTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate value="${row.planRewardTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            	<td width="1%">&nbsp;</td>
            </c:if>
        	<td>${issueStatusRefMap[row.issueStatus]}</td>
        	<td width="1%">&nbsp;</td>
        	<td align="right">
        		<c:choose>
                <c:when test="${row.issueStatus==13}"><!-- 销售额（期结期次显示，未期结不显示）  -->
					<fmt:formatNumber type="number" value="${row.issueSaleAmount}" />
                </c:when>
                <c:otherwise>
                	—
                </c:otherwise>
                </c:choose>
	        </td>
	        <td width="1%">&nbsp;</td>
	        <td align="right">
	        	<c:choose>
                <c:when test="${row.issueStatus==13}"><!-- 期初奖池（期结期次显示，未期结不显示）  -->
					<fmt:formatNumber type="number" value="${row.poolStartAmount}" />
                </c:when>
                <c:otherwise>
                	—
                </c:otherwise>
                </c:choose>
	        </td>
	        <td width="1%">&nbsp;</td>
	        <td align="right">
	        	<c:choose>
                <c:when test="${row.issueStatus==13}"><!-- 期末奖池（期结期次显示，未期结不显示）  -->
					<fmt:formatNumber type="number" value="${row.poolCloseAmount}" />
                </c:when>
                <c:otherwise>
                	—
                </c:otherwise>
                </c:choose>
	        </td>
	        <td width="1%">&nbsp;</td>
        	<td>
				<c:if test="${row.isPublish==1}">发布</c:if>
                <c:if test="${row.isPublish==0}">未发布</c:if>
			</td>
			<td width="1%">&nbsp;</td>
        	<td width="330">
           	    	<a href="#" onclick="showPage('issueManagement.do?method=detail&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','详情')">详情</a> |
                	<a href="#" onclick="showPage('issueManagement.do?method=issueParam&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','期次参数')">期次参数</a> |
                <c:choose>
                <c:when test="${row.isPublish==0 && row.issueStatus==0}">
                	<a href="#" onclick="showBox('issueManagement.do?method=editPrize&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','期次奖金',400,550)">期次奖金</a> |
                </c:when>
                <c:when test="${row.issueStatus==13}">
                </c:when>
                <c:otherwise>
                	<span style="color:#CDC9C9">期次奖金</span> | 
                </c:otherwise>
                </c:choose>
                
                <c:choose>
                <c:when test="${row.isPublish==0 && row.issueStatus==0 && (row.gameCode==6 || row.gameCode==7)}">
               		<a href="#" onclick="showBox('issueManagement.do?method=editCalcWinningParam&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','算奖参数',400,550)">算奖参数</a> |
                </c:when>
                <c:when test="${row.issueStatus==13}">
                </c:when>
                <c:otherwise>
                	<span style="color:#CDC9C9">算奖参数</span> |
                </c:otherwise>
                </c:choose>

                <c:choose>
                <c:when test="${row.isPublish==0 && row.issueStatus==0}">
                	<a href="#" onclick="prompt('${row.gameCode}','${row.issueNumber}','${row.isPublish}','删除')">删除</a> |
                </c:when>
                <c:when test="${row.isPublish==1 && row.issueStatus==0}">
                	<a href="#" onclick="prompt('${row.gameCode}','${row.issueNumber}','${row.isPublish}','撤销')">撤销</a> |
                </c:when>
                <c:when test="${row.issueStatus==13}">
                </c:when>
                <c:otherwise>
                	<span style="color:#CDC9C9">删除</span> |
                </c:otherwise>
                </c:choose>
                
                <c:choose>
                <c:when test="${row.issueStatus==13 && (row.gameCode==6 || row.gameCode==7 || row.gameCode==13)}">
                	<a href="#" onclick="showPage('gameDraw.do?method=printDrawNotice&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','开奖公告')">开奖公告</a> | 
            		<a href="#" onclick="showPage('gameDraw.do?method=step3_print&type=1&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','打印报表')">打印报表</a> | 
            		<a href="#" onclick="showPage('gameDraw.do?method=step3_print&type=2&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','打印报告单')">打印报告单</a>
            	</c:when>
            	<c:when test="${row.issueStatus==13 && (row.gameCode==12 || row.gameCode==11 || row.gameCode==5)}">
                	<a href="#" onclick="showPage('gameDraw.do?method=printDrawNotice&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','开奖公告')">开奖公告</a> 
            	</c:when>
                <c:otherwise>
                	<span style="color:#CDC9C9">开奖公告</span>
                </c:otherwise>
                </c:choose>
			</td>
        </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>
</body>
</html>

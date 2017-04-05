<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>站点历史销量排行</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">站点历史销量排行</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="monitor.do?method=historyRankings" id="queryForm" method="post">
            <div class="left">
                <span>类型:
            		<select class="select-normal" name="tjType">
            			<option value="0" <c:if test="${form.tjType==0}">selected="selected"</c:if> >--全部--</option>
            			<option value="1" <c:if test="${form.tjType==1}">selected="selected"</c:if> >即开票</option>
            			<option value="2" <c:if test="${form.tjType==2}">selected="selected"</c:if> >电脑票</option>
            		</select>
            	</span>
            	<span>部门:
            		<select class="select-normal" name="orgCode" >
            			<option value="">--全部--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="status">
                   	   		<c:if test="${obj.institutionCode == form.orgCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.orgCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
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
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        	<td style="width:10px;">&nbsp;</td>
                            <td style="width:5%">序号</td>
                            <td width="1%">|</td>
                            <td style="width:13%">站点编码</td>
                            <td width="1%">|</td>
                            <td style="width:13%">站点名称</td>
                            <td width="1%">|</td>
                            <td style="width:13%">所属部门</td>  
                            <td width="1%">|</td>
                            <td style="width:13%">联系电话</td>  
                            <td width="1%">|</td>
                            <td style="width:13%">销售总额</td>
                            <td width="1%">|</td>
                            <td style="width:13%">退票金额</td>
                            <td width="1%">|</td>
                            <td style="width:*%">兑奖金额</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
        <c:forEach var="obj" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            	<td style="width:10px;">&nbsp;</td>
                <td style="width:5%">${status.index+1 }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%">${obj.agencyCode }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%">${obj.agencyName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%">${obj.orgName }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%">${obj.telephone }</td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%;text-align: right;"><fmt:formatNumber value="${obj.saleAmount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:13%;text-align: right;"><fmt:formatNumber value="${obj.returnAmount }" /></td>
                <td width="1%">&nbsp;</td>
                <td style="width:*%;text-align: right;"><fmt:formatNumber value="${obj.payoutAmount }" /></td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr}
    </div>
</body>
</html>
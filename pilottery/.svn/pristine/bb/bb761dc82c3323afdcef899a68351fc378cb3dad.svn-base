<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>比赛列表</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function deleteMatch(matchCode){
	var msg = "确认删除吗?";
	showDialog("doDelete('"+matchCode+"')","删除",msg);
}

function doDelete(matchCode) {
   
	var url="fbsGame.do?method=deleteMatch&matchCode=" + matchCode;
		$.ajax({
			url : url,
			dataType : "json",
			async : false,
			success : function(r){
		            if(r.message!='' && r.message!=null){
			            closeDialog();
		            	showError(r.message);
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
    <div id="title">比赛列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
    	<form action="fbsGame.do?method=listFbsMatch" id="queryForm" method="post">
    	<div class="left">
    		<span>期次:
            <input name="issueCode" id="issueCode" value="${form.issueCode}" class="text-normal" maxlength="10" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
            </span>
            <span>联赛名称:
	            <select name="matchComp" class="select-normal" id="matchComp">
				    <option value="">--全部--</option>
				    <c:forEach var="data" items="${competitionList}">
				     	<option value="${data.competitionCode}" <c:if test="${form.matchComp==data.competitionCode }">selected</c:if>>${data.competitionName }</option>
				    </c:forEach>
				</select>
			</span>
            
            <span>销售开始时间:
             	<input id="startQueryTime" name="startQueryTime" value="${form.startQueryTime}" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/>
            </span>
            <span>比赛状态:
                <select name="status" id="status" class="select-normal"> 
				    <option value="">--全部--</option>
					<option value="1" <c:if test="${form.status==1}">selected</c:if>>预排</option>
					<option value="2" <c:if test="${form.status==2}">selected</c:if>>开始销售</option>							       		
					<option value="3" <c:if test="${form.status==3}">selected</c:if>>销售结束</option>		
					<option value="4" <c:if test="${form.status==4}">selected</c:if>>开奖中</option>
					<option value="5" <c:if test="${form.status==5}">selected</c:if>>开奖完成</option>
		     	</select>
		    </span>
		    <input type="submit" value="查询" class="button-normal"></input>
		 </div>
    
         <div class="right">
             <table width="260" border="0" cellspacing="0" cellpadding="0">
                 <tr style="height:50px;line-height:50px">
                     <td align="right">
                         <input type="button" value="新增比赛" onclick="showBox('fbsGame.do?method=initAddMatch','新增比赛',550,800);" class="button-normal"></input>
                     </td>
                 </tr>
             </table>
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
                            <td style="width:9%">所属期号</td>
                            <td width="1%">|</td>
                            <td style="width:9%">比赛编号</td>
                            <td width="1%">|</td>
                            <td style="width:9%">联赛名称</td>
                            <td width="1%">|</td>
                            <td style="width:9%">比赛状态</td>
                            <td width="1%">|</td>
                            <td style="width:9%">销售开始时间</td>
                            <td width="1%">|</td>
                            <td style="width:9%">销售截止时间</td>
                            <td width="1%">|</td>
                            <td style="width:9%">主队名称</td>
                            <td width="1%">|</td>
                            <td style="width:9%">客队名称</td>
                            <td width="1%">|</td>
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
    <div id="bodyDiv">
        <table class="datatable">
         <c:forEach var="data" items="${matchList}" varStatus="status" >
            <tr class="dataRow">
            <td style="width:10px;">&nbsp;</td>
                <td style="width:9%">${data.fbsIssueNumber}</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:9%">${data.matchCode}</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:9%" title="${data.competitionName}">${data.competitionName }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:9%">
                	<c:choose>
                		<c:when test="${data.status==1 }">预排</c:when>
                		<c:when test="${data.status==2 }">开始销售</c:when>
                		<c:when test="${data.status==3 }">销售结束</c:when>
                		<c:when test="${data.status==4 }">开奖中</c:when>
                		<c:when test="${data.status==5 }">开奖完成</c:when>
                	</c:choose>
                </td>
                <td width="1%" >&nbsp;</td>
                <td style="width:9%"><fmt:formatDate value="${data.matchStartDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%" >&nbsp;</td>
                <td style="width:9%"><fmt:formatDate value="${data.matchEndDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td width="1%" >&nbsp;</td>
                <td style="width:9%">${data.homeTeamName }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:9%">${data.guestTeamName }</td>
                <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showBox('fbsGame.do?method=getMatchDetail&matchCode=${data.matchCode }','比赛详情',400,800)">详情</a></span>&nbsp;|
                    <span><a href="#" onclick="showBox('fbsGame.do?method=initEditMatch&matchCode=${data.matchCode }','修改比赛',550,800);">修改</a></span>&nbsp;|
                    <span><a href="#" onclick="deleteMatch('${data.matchCode }')">删除</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body>
</html>
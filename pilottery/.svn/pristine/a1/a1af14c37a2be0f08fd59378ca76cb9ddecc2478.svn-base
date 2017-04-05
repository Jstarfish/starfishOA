<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Match List</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">

function deleteMatch(matchCode){
	var msg = "Are you sure you want to delete?";
	showDialog("doDelete('"+matchCode+"')","Delete",msg);
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
    <div id="title">Match List</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
    	<form action="fbsGame.do?method=listFbsMatch" id="queryForm" method="post">
    	<div class="left">
    		<span>Issue:
            <input name="issueCode" id="issueCode" value="${form.issueCode}" class="text-normal" maxlength="10" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
            </span>
            <span>Competition:
	            <select name="matchComp" class="select-normal" id="matchComp">
				    <option value="">--All--</option>
				    <c:forEach var="data" items="${competitionList}">
				     	<option value="${data.competitionCode}" <c:if test="${form.matchComp==data.competitionCode }">selected</c:if>>${data.competitionName }</option>
				    </c:forEach>
				</select>
			</span>
            
            <span>Match Begin Date:
             	<input id="startQueryTime" name="startQueryTime" value="${form.startQueryTime}" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true})" maxlength="40"/>
            </span>
            <span>Status:
                <select name="status" id="status" class="select-normal"> 
				    <option value="">--All--</option>
					<option value="1" <c:if test="${form.status==1}">selected</c:if>>Arranged</option>
					<option value="2" <c:if test="${form.status==2}">selected</c:if>>Opened</option>							       		
					<option value="3" <c:if test="${form.status==3}">selected</c:if>>Closed</option>		
					<option value="4" <c:if test="${form.status==4}">selected</c:if>>Drawing</option>
					<option value="5" <c:if test="${form.status==5}">selected</c:if>>Completed</option>
		     	</select>
		    </span>
		    <input type="submit" value="Query" class="button-normal"></input>
		 </div>
    
         <div class="right">
             <table width="260" border="0" cellspacing="0" cellpadding="0">
                 <tr style="height:50px;line-height:50px">
                     <td align="right">
                         <input type="button" value="New Match" onclick="showBox('fbsGame.do?method=initAddMatch','New Match',550,800);" class="button-normal"></input>
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
                            <td style="width:9%">Issue</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Match No.</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Competition</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Status</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Sale Begin Time</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Sale End Time</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Home Team</td>
                            <td width="1%">|</td>
                            <td style="width:9%">Guest Team</td>
                            <td width="1%">|</td>
                            <td style="width:*%">Operation</td>
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
                		<c:when test="${data.status==1 }">Arranged</c:when>
                		<c:when test="${data.status==2 }">Opened</c:when>
                		<c:when test="${data.status==3 }">Closed</c:when>
                		<c:when test="${data.status==4 }">Drawing</c:when>
                		<c:when test="${data.status==5 }">Completed</c:when>
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
                    <span><a href="#" onclick="showBox('fbsGame.do?method=getMatchDetail&matchCode=${data.matchCode }','Match Detail',400,800)">Detail</a></span>&nbsp;|
                    <span><a href="#" onclick="showBox('fbsGame.do?method=initEditMatch&matchCode=${data.matchCode }','Edit Match',550,800);">Modify</a></span>&nbsp;|
                    <span><a href="#" onclick="deleteMatch('${data.matchCode }')">Delete</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body>
</html>
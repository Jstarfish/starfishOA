<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" type="text/css" href="${basePath}/css/issuemody.css"/>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<script type="text/javascript">
function pre(){
	var flag = true;
	var number = 0;
	if($('#beginIssue0').val()==''){
		$('#beginIssue0Notice').html("Not empty");	
		flag = false;
	}else{
		if(($('#beginIssue0').val()>999 || $('#beginIssue0').val()< 0) && $('#gameCode').val() == 12){
			$('#beginIssue0Notice').html("Range 1-999");	
			flag = false;
		}else{
			$('#beginIssue0Notice').html("");
		}
	}
	if($('#planStartHour0').val()==''){
		$('#planStartHour0Notice').html("Not empty");	
		flag = false;
	}else
		$('#planStartHour0Notice').html("");
	if($('#issueNos').val()==''){
		$('#issueNosNotice').html("Not empty");flag = false;
	}else if($('#issueNos').val()>300){
		$('#issueNosNotice').html("≤300");	flag = false;
	}else
		$('#issueNosNotice').html("");
	if(isNaN($('#issueNos').val()))
	{
		$('#issueNosNotice').html("Invalid");flag = false;		
	}
	number = parseInt($('#issueNos').val());
	var selectgame=document.getElementById('gameCode');  		  
	var selectgameindex=selectgame.selectedIndex; //序号，取当前选中选项的序号  		  
	var val = selectgame.options[selectgameindex].value;
	if(val == 6)
	{
		if(number <= 0 || (number%3 !=0))
		{		
			$('#issueNosNotice').html("Invalid");flag = false;		
		}
	}
	
	if(flag){
		$('#gameManagementForm').ajaxSubmit({
			type : 'POST',
			url : 'issueManagement.do?method=preview_qlx_tty' ,
			success : function(data) {
				$("#previewDiv").html(data);
			}
		});
	}
};
function cleanPre(){
	$("#previewDiv").html("");	
}


function saveData(){ 
	$("#gameManagementForm").attr("action","issueManagement.do?method=savePreIssue");
	button_off("nextBtn");
	$("#gameManagementForm").submit();
}

function changeGame(gameCode){
	$("#gameManagementForm").attr("action","issueManagement.do?method=pre_qlx_tty&gameCode="+gameCode);
	$("#gameManagementForm").submit();
}
</script>
</head>
<body>
<div id="title">New Issue - Templet</div>
<div id="container">
<!--排期开始-->
<div id="main1">
<div class="set">
<form:form modelAttribute="gameManagementForm" >
    <div><span>Issue Parameters Configuration</span></div>
    <div class="sj">
      <div class="cs" style="overflow-y: auto;overflow-x: hidden;height: 472px;">
      <table id="tb1" width="100%" border="0" cellspacing="0" cellpadding="0"  height="450" >
		  <tr>
		    <td width="35%" align="right"><span class="lz">Select a game：</span></td>
		    <td width="*%">&nbsp;&nbsp; 
		    	<form:select path="gameCode"  onchange="changeGame(this.value);" class="select-bigs">
					<c:forEach items="${games}" var="s">
						<form:option value="${s.gameCode}">${s.shortName}</form:option>
					</c:forEach>
				</form:select>
			</td>
		  </tr>
		  <tr>
		    <td align="right"> 
		    	<c:if test="${gameManagementForm.gameCode == 5 || gameManagementForm.gameCode == 11|| gameManagementForm.gameCode == 12}">
		    		<span class="lz">Issue Start No：</span>
		    	</c:if>
		    	<c:if test="${gameManagementForm.gameCode == 6 || gameManagementForm.gameCode == 7}">
		    		<span class="lz">Start Issue：</span>
		    	</c:if>
		    </td>
		    <td>&nbsp; &nbsp;<form:input class="input_out" id="beginIssue0" path="beginIssue" onblur="value=value.replace(/[^0-9]/g,'');" onfocus="cleanPre();"/><font color="red" size="2">&nbsp;&nbsp;<label id="beginIssue0Notice"></label></font></td>
		  </tr>
		  <tr>
		    <td align="right"><span class="lz">Begin At：</span></td>
		    <td>&nbsp; &nbsp;<form:input id="planStartHour0" path="planStartHour" class="Wdates input_out" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true});cleanPre();" /><font color="red" size="2">&nbsp;&nbsp;<label id="planStartHour0Notice"></label></font>
		    </td>
		  </tr>
		  <tr>
		    <td align="right"><span class="lz">Issues to Arrange：</span></td>
		    <td>&nbsp; &nbsp;<form:input id="issueNos" class="input_out" path="issueNos" onblur="value=value.replace(/[^0-9]/g,'');" onfocus="cleanPre();"/><font color="red" size="2">&nbsp;&nbsp;<label id="issueNosNotice"></label></font></td>
		  </tr>
		</table>
      </div>
    </div>
     <div class="clear">
        <input type="reset" class="button-normal" value="Reset" onfocus="cleanPre();"/>
        <input type="button" class="button-normal" style="float:right;" value="Preview" onclick="pre();"/>
     </div>
</form:form>
</div>
<div id="previewDiv" style="float:right"></div>
</div>
<!--排期结束-->
</div>
</body>
</html>

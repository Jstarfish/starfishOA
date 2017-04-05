<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>游戏授权</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style type="text/css">
	.datatable tr:hover, .datatable tr.hilite {
	    background-color: #2aa1d9;
	    color: #ffffff;
	}
</style>

<script type="text/javascript" charset="UTF-8" >
    function doSubmit() {
        var result = true;

        if(!mycheck()){
        	result=false;
        }
   		
        if(result) {
       	 button_off("okBtn");
         $('#form1').submit();
        }
    }
   
function mycheck(){
	var flag = true;
	if(!mycheck2('payCommissionRate'))
		flag = false;
	if(!mycheck2('saleCommissionRate'))
		flag = false;
	return flag;
}
function mycheck2(ctlname){
	 var $txt =  $("input[type='text']");
  for(var i=0;i<$txt.length;i++){
	  if($txt[i].name!='agencyCode' && $txt[i].name!='agencyName'){
	  $txt.eq(i).focus( function(){
			$(this).css("borderColor","");
			$(this).unbind("focus");
		}
	  );
	  }
  } 
  var flag = true;
  for(var i=0;i<$txt.length;i++){
	  if($txt[i].name!='agencyCode' && $txt[i].name!='agencyName'){
		if(!isValidNumber($txt[i].value,0,3)){
			$txt.eq(i).css("borderColor","red");
			flag = false;
		}
	  }
  }
  return flag;
}
function isValidNumber(str,minlen,maxlen){
	var len = str.length;
	if(len<minlen||len>maxlen){
		return false;
	}
	var charCode;
	for(var i=0;i<len;i++){ 
	    charCode = str.charCodeAt(i); 
		if(charCode<48 || charCode>57){
			return false;
		}
	}
	return true;
}
function doClose(){
	window.parent.closeBox();
}
</script>


</head>
<body>
  <form:form action="agency.do?method=gameAuthen" method="POST" id="form1"> 
	    <div class="pop-body" >
	      <table class="datatable" border="0">
		 	<tr class="headRow">
			  <td width="12%">游戏名称</td>
			  <td width="10%">游戏类型</td>
			  <!-- <td width="7%">授权</td> -->
			  <td width="12%">是否可销售</td>
			  <td width="7%">兑奖</td>
			  <td width="7%">退票</td>
			  <td width="14%">销售代销费</td>
			  <td width="14%">兑奖代销费</td>
			  <td width="*%">兑奖范围</td>
			</tr>
				<c:forEach var="game" items="${games}" varStatus="s"> 
    			<tr class="dataRow">
						<td><c:out value="${game.name}" /><input type="hidden" name="guth[${s.index}].agencyCode" value="${agencyCode}" /></td>
						<td>
						<c:choose>
							<c:when test="${game.type == 1}">
								基诺
							</c:when>
							<c:when test="${game.type == 2}">
								乐透
							</c:when>
							<c:when test="${game.type == 3}">
								数字
							</c:when>
							<c:otherwise>
								其他
							</c:otherwise>
						</c:choose>
						<input type="hidden" name="guth[${s.index}].gameCode" value="${game.gameCode}" />
						</td>
						<td>
						<c:if test="${game.flag==0}">
						  <c:choose>
							<c:when test="${game.sellStatus == 1}">
								<input type="checkbox" name="guth[${s.index}].sellStatus" value="1" checked="checked" />
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="guth[${s.index}].sellStatus"  value="1" />
							</c:otherwise>
						  </c:choose>
						  </c:if>
						  <c:if test="${game.flag==1}">
						  <input type="checkbox" name="guth[${s.index}].sellStatus"  value="1" />
						  </c:if>
						</td>
									
						<td>
						 <c:if test="${game.flag==0}">
						  <c:choose>
							<c:when test="${game.payStatus == 1}">
								<input type="checkbox" name="guth[${s.index}].payStatus" value="1" checked="checked" />
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="guth[${s.index}].payStatus"  value="1" />
							</c:otherwise>
						  </c:choose>
						  </c:if>
						  <c:if test="${game.flag==1}">
						  <input type="checkbox" name="guth[${s.index}].payStatus"  value="1" />
						  </c:if>
						</td>
						
					     <td>
					      <c:if test="${game.flag==0}">
						  <c:choose>
							<c:when test="${game.cancelStatus == 1}">
								<input type="checkbox" name="guth[${s.index}].cancelStatus" value="1" checked="checked" />
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="guth[${s.index}].cancelStatus"  value="1" />
							</c:otherwise>
						  </c:choose>
						  </c:if>
						   <c:if test="${game.flag==1}">
						    <input type="checkbox" name="guth[${s.index}].cancelStatus"  value="1" />
						   </c:if>
						</td>
					
						<td>
						 <c:if test="${game.flag==0}">
						<input type="text" name="guth[${s.index}].saleCommissionRate" id="a" class="bdinput"  style="width:50px;" value="${game.saleCommissionRate}"/>
						</c:if>
						 <c:if test="${game.flag==1}">
						 <input type="text" name="guth[${s.index}].saleCommissionRate" id="a" class="bdinput"  style="width:50px;" value="0"/>
						 </c:if>
						‰</td>
					
						<td>
						<c:if test="${game.flag==0}">
						<input type="text" name="guth[${s.index}].payCommissionRate"  class="bdinput"  style="width:50px;" value="${game.payCommissionRate}"/>
						</c:if>
						<c:if test="${game.flag==1}">
						<input type="text" name="guth[${s.index}].payCommissionRate"  class="bdinput"  style="width:50px;" value="0"/>
						</c:if>
						‰</td>
						
						<td>
						<c:if test="${game.flag==0}">
							<c:choose>
							<c:when test="${game.claimingScope == 0}">
								<select name="guth[${s.index}].claimingScope" class="select-s">				  					
				  					<option value ="0" selected="selected">中心</option>
				  					<option value="1">分公司</option>
				  					<option value="4">销售站</option>
								</select>
							</c:when>							
							<c:when test="${game.claimingScope == 1}">
								<select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" >中心</option>
				  					<option value="1" selected="selected">分公司</option>
				  					<option value="4">销售站</option>
								</select>
							</c:when>
							<c:when test="${game.claimingScope == 4}">
								<select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" >中心</option>
				  					<option value="1">分公司</option>
				  					<option value="4" selected="selected">销售站</option>
								</select>
							</c:when>
							<c:otherwise>
								<select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" selected="selected">中心</option>
				  					<option value="1">分公司</option>
				  					<option value="4">销售站</option>
								</select>
							</c:otherwise>
						  </c:choose>
						  </c:if>
						  <c:if test="${game.flag==1}">
						  		<select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" selected="selected">中心</option>
				  					<option value="1">分公司</option>
				  					<option value="4">销售站</option>
								</select>
						  </c:if>
						</td>
					</tr>
     			</c:forEach>	  
			</table>		
        </div>
        <div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="提交" onclick="doSubmit();" class="button-normal"></input></span>
            <span class="right"><input type="button" value="关闭" onclick="doClose();" class="button-normal"></input></span>
        </div>
    </form:form>
</body>
</html>
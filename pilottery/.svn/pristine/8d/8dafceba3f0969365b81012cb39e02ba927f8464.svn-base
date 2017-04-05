<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Game Authentication</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>

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
	    <div class="pop-body">
	      <table class="datatable" border="0">

		 	<tr class="headRow">
			
			  <td width="12%">Game</td>
             
			  <td width="10%">Type</td>
             
			  <!-- <td width="7%">status</td> -->
             
			  <td width="12%">Sale</td>
           
			  <td width="7%">Payout</td>
           
			  <td width="7%">Refund</td>
          
			  <td width="14%">Sales Commission</td>
       
			  <td width="14%">Payout Commission</td>
      
			  <td width="*%">Payout Scope</td>
			</tr>

				<c:forEach var="game" items="${games}" varStatus="s"> 
				
    			<tr class="dataRow">
    			
						<td><c:out value="${game.name}" /><input type="hidden" name="guth[${s.index}].agencyCode" value="${agencyCode}" /></td>
					
						<td>
						<c:choose>
							<c:when test="${game.type == 1}">
								KENO
							</c:when>
							<c:when test="${game.type == 2}">
								Lotto
							</c:when>
							<c:when test="${game.type == 3}">
								Digit
							</c:when>
							<c:otherwise>
								Other
							</c:otherwise>
						</c:choose>
						<input type="hidden" name="guth[${s.index}].gameCode" value="${game.gameCode}" />
						</td>
					
						<!-- <td>
						<c:if test="${game.flag==0}">
							<c:choose>
							<c:when test="${game.status == 1}">
								<input type="checkbox" name="guth[${s.index}].status" value="1" checked="checked" />
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="guth[${s.index}].status" value="1" />
							</c:otherwise>
							</c:choose>
							</c:if>
								<c:if test="${game.flag==1}">
								<input type="checkbox" name="guth[${s.index}].status" value="1" />
								</c:if>
					    </td> -->
					  
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
				  					<option value ="0" selected="selected">Center</option>
				  					<option value="1">1st-level Region</option>
				  					<option value="2">2nd-level Region</option>
				  					<option value="3">Agency</option>
								</select>
							</c:when>							
							<c:when test="${game.claimingScope == 1}">
								<select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" >Center</option>
				  					<option value="1" selected="selected">1st-level Region</option>
				  					<option value="2">2nd-level Region</option>
				  					<option value="3">Agency</option>
								</select>
							</c:when>
							<c:when test="${game.claimingScope == 2}">
								<select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" >Center</option>
				  					<option value="1">1st-level Region</option>
				  					<option value="2" selected="selected">2nd-level Region</option>
				  					<option value="3">Agency</option>
								</select>
							</c:when>
							<c:when test="${game.claimingScope == 3}">
								<select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" >Center</option>
				  					<option value="1">1st-level Region</option>
				  					<option value="2">2nd-level Region</option>
				  					<option value="3" selected="selected">Agency</option>
								</select>
							</c:when>
							<c:otherwise>
								<select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" selected="selected">Center</option>
				  					<option value="1">1st-level Region</option>
				  					<option value="2">2nd-level Region</option>
				  					<option value="3">Agency</option>
								</select>
							</c:otherwise>
						  </c:choose>
						  </c:if>
						  <c:if test="${game.flag==1}">
						  <select name="guth[${s.index}].claimingScope" class="select-s">					  					
				  					<option value ="0" selected="selected">Center</option>
				  					<option value="1">1st-level Region</option>
				  					<option value="2">2nd-level Region</option>
				  					<option value="3">Agency</option>
								</select>
						  </c:if>
						</td>
					</tr>
     			</c:forEach>	  
			</table>		
        </div>
        <div class="pop-footer">
            <span class="left"><input id="okBtn" type="button" value="Submit" onclick="doSubmit();" class="button-normal"></input></span>
            <span class="right"><input type="button" value="Close" onclick="doClose();" class="button-normal"></input></span>
        </div>
    </form:form>
</body>
</html>
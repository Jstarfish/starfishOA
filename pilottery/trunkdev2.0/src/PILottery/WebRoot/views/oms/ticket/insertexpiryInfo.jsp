<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<html>
<head>
<title>游戏开奖</title>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
  <script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/jquery-1.9.1.js"></script> 
<style type="text/css">

</style>
<script type="text/javascript">


function doSubmit() {
	 var result = true;
    
     if(!doCheck("name",checkName(),"Name cannot be empty")) {
 		result = false;
     }
      if(checkName())
      {
		     if(!doCheck("name",checkNameLen(),'Not longer than 500 characters')) {
		    	 result = false;
		     }
      }
    
	var bool = findObj("birthdate").value!="";
     if(!doCheck("birthdate",bool,"The date of birth can not be empty")){
    	 result = false;
        }
     var carIdbool=findObj("carId").value!="";
     if(!doCheck("carId",carIdbool,"Certificate ID cannot be empty!")){
    	 	result = false;
         }
      if(checkCardIdnotnull()){
    	  if(!doCheck("carId",/^[0-9A-Za-z]{1,36}$/,"Must be numbers or English characters")){
      	 	result = false;
           }
        }
      
     var contactbool=findObj("contact").value!="";
     if(!doCheck("contact",contactbool,"Contact cannot be empty!")){
 	 	result = false;
      }
     if(result){
    	 switch_obj("nextBtn","waitBtn");
    	 document.expirydateForm.submit();
     }
}

function checkName(){
	var name=$("#name").val();
	var flag=true;
	if(name==''){
		flag =false;
	}
	return flag;
}
function checkNameLen(){
	var auditmemo = $("#name").val();
	if(getStrlen(auditmemo)>500){
		return false;
	}
	return true;
}
function checkCardIdnotnull(){
	if($("#carId").val()==''){
		return false;
	}
	return true;
}
function getStrlen(str){
    var realLength = 0, len = str.length, charCode = -1;
    for (var i = 0; i < len; i++) {
        charCode = str.charCodeAt(i);
        if (charCode >= 0 && charCode <= 128) realLength += 1;
        else realLength += 2;
    }
    return realLength;
}
</script>
</head>

<body>
<form:form modelAttribute="expirydateForm" action="centerSelect.do?method=saveexpiryInfo" method="post" id="expirydateForm" name="expirydateForm">
 <form:hidden path="tsnquery"/>
 <form:hidden path="payagencycode"/>
<div id="title">Payout at Center </div>
<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/zxdjbj-2.png) no-repeat left top;width:850px;;">
    </div>
    <div class="xd" style="width:650px">
        <span>1.Ticket Inquiry</span>
       	<span class="zi" >2.Winning Data Entry</span>
       	<span>3.Winning Information</span>
   		<span style="margin-left: 20px;">4.Print Payout Form</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                      <c:choose>
                        <c:when test="${status==0 && isWin==2 && isPayed==0}">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                            <tr>
                                <td colspan="3" class="tit">
                                    <span style="font-size: 24px;">2. Winning Data Entry</span>
                                </td>
                            </tr>
                            
                          <tr>
							 <td width="22%" align="right">Name of Winner：</td>
						     <td width="26%">
						      	<form:input path="name" id="name"   value="" class="my_input" style="background-color:#f2f1f1"/>
						     </td>
						     <td width="52%"><span id="nameTip" class="tip_init">*</span></td>
						  </tr>
						  <tr>
						    <td align="right">Gender of Winner：</td>
						    <td>  <INPUT type="radio" name="sex"  checked value="1"/>Male
						          <INPUT type="radio" name="sex"  value="2"/>Female</td>
						    <td><span id="sexTip" class="tip_init">*</span></td>
						  </tr>
						  <tr>
						    <td align="right">Date of birth：</td>
						    <td> 
						 		<form:input path="birthdate" id="birthdate"   value="" readonly="readonly" class="my_input"  style="background-color:#f2f1f1" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						    </td>
						    <td><span id="birthdateTip" class="tip_init">*</span></td>
						  </tr>
						  <tr>
						    <td align="right">Certificate Type：</td>
						    <td>
						    <select name="cardType" id="cardType" class="select-normal">
						    		<option value="1">ID Card</option>
									<option value="2">Passport</option>
									<option value="9">Other Certificate</option>
							</select>
						    </td>
						    <td><span class="tip_init">*</span></td>
						  </tr>
						  <tr>
						    <td align="right">Certificate ID：</td>
						    <td> 
						     	<form:input path="carId" id="carId"   value="" class="my_input" maxlength="18" style="background-color:#f2f1f1" />
						    </td>
						    <td><span id="carIdTip" class="tip_init">*</span></td>
						  </tr>
						  <tr>
						    <td align="right">Contact Phone：</td>
						    <td> 
						    	<form:input path="contact" id="contact"   value="" class="my_input" maxlength="20" style="background-color:#f2f1f1" />
						    </td>
						    <td><span id="contactTip" class="tip_init">*</span></td>
						  </tr>
						  <tr></tr>
                        </table>
                        </c:when>
                        <c:when test="${status==0 && isWin==0}">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
	                        <tr>
	                            <td class="tit">
	                                <span style="font-size: 24px;">2. Winning Data Entry</span>
	                            </td>
	                        </tr>
	                        <tr height="90">
	                            <td align="center">
	                                <img id="p_img" src="<%=request.getContextPath() %>/img/kul.png" width="120" height="120" style="margin-top:50px;"/>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td align="center" height="80">
	                                <span id="msg" style="color: red">${reservedSuccessMsg}</span>
	                            </td>
	                        </tr>
	                        <tr><td></td></tr>
                        </table>
                        </c:when>
                        <c:when test="${status==0 && isWin==1}">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
	                        <tr>
	                            <td class="tit">
	                                <span style="font-size: 24px;">2. Winning Data Entry</span>
	                            </td>
	                        </tr>
	                        <tr height="90">
	                            <td align="center">
	                                <img id="p_img" src="<%=request.getContextPath() %>/img/kul.png" width="120" height="120" style="margin-top:50px;"/>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td align="center" height="80">
	                                <span id="msg" style="color: red">${reservedSuccessMsg}</span>
	                            </td>
	                        </tr>
	                        <tr><td></td></tr>
                        </table>
                        </c:when>
                      <c:when test="${status==0 && isWin==2  && isPayed==1}">
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
	                        <tr>
	                            <td class="tit">
	                                <span style="font-size: 24px;">2. Winning Data Entry</span>
	                            </td>
	                        </tr>
	                        <tr height="90">
	                            <td align="center">
	                                <img id="p_img" src="<%=request.getContextPath() %>/img/kul.png" width="120" height="120" style="margin-top:50px;"/>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td align="center" height="80">
	                                <span id="msg" style="color: red">${reservedSuccessMsg}</span>
	                            </td>
	                        </tr>
	                        <tr><td></td></tr>
                        </table>
                        </c:when>
                         <c:otherwise>
                         <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
	                        <tr>
	                            <td class="tit">
	                                <span style="font-size: 24px;">2. Winning Data Entry</span>
	                            </td>
	                        </tr>
	                        <tr height="90">
	                            <td align="center">
	                                <img id="p_img" src="<%=request.getContextPath() %>/img/kul.png" width="120" height="120" style="margin-top:50px;"/>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td align="center" height="80">
	                                <span id="msg" style="color: red">${reservedSuccessMsg}</span>
	                            </td>
	                        </tr>
	                        <tr><td></td></tr>
                        </table>
                         </c:otherwise>
                        </c:choose>
                    </div>

                </td>
                <td align="right">
           
                <c:if test="${status==0 && isWin==2 && isPayed==0}">
                    <img id="nextBtn" onclick="doSubmit()" src="views/oms/game-draw/img/right-hover.png" alt="Next"/>
                     <img id="waitBtn" style="display:none" src="views/oms/game-draw/img/wait.gif" height="60px" width="60px"/>
                </c:if>
                </td>
                
            </tr>
            <tr height="60"></tr>
        </table>
    </div>

</div>

</form:form>
</body>
</html>
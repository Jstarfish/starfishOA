<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />

<style type="text/css">
body {
	margin: 0;
	padding: 0;
	margin: 0px;
	padding: 0px;
	font: 14px/20px "微软雅黑", Arial, Helvetica, sans-serif;
	background: #f2f1f1;
	width: 100%;
	height: 100%;
}

ul {
	list-style: none;
}
a {
	text-decoration: none;
}
</style>
<script type="text/javascript">
$(document).ready(function(){
	var val=$('#planCode1').val();
	
	initSelect(val);
	  $("#planCode1").change(function() { 
		  var val=$('#planCode1').val();
			initSelect(val);
	  });
});
function initSelect(value){
	var arry= new Array();   
	 arry=value.split("@");
    
	var url="goodsReceipts.do?method=getBatchList&planCode=" + arry[0];
	  
	 
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
				
			          $("#batchNo").empty();
			          var html="";
			          for(var i = 0; i < r.length; i++) { 
			        	  
                          var option = $("<option>").val(r[i].batchNo).text(r[i].batchNo);  
                          $("#batchNo").append(option);  
                      }
			}
			});
			$("#planCode").val('');
			$("#planCode").val(arry[0]);
			$("#fullName").val('');
			$("#fullName").val(arry[1]);
			
}
function doSubmit(){
	
	    if($("#batchNo").val()=='' || $("#batchNo").val()==null){
	    	 showError("选择批次!"); 
			 return false;
	    }
	  $('#goodReceiptParamt').submit();	 
}
</script>
</head>

<body>
<form method="post" action="goodsReceipts.do?method=goodsReceiptFirst"  id="goodReceiptParamt" name="goodReceiptParamt" >
<input type="hidden" name="operType" value="1">
<input type="hidden" name="planCode" id="planCode" value="">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">批次入库</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main"> 
    <div class="jdt">
      <img src="views/inventory/goodsReceipts/images/jdt4_1.png" width="1000" height="30" />
      <div class="xd-cn"><span class="zi">1.选择货物</span><span >2.扫描货物</span><span >3.完成收货</span><span >4.汇总货物</span></div></div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><div class="tab">
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%;" valign="top">
                  <!--<tr>
                    <td  class="tit"><span>1.Goods Receipt by Batch</span></td>
                  </tr>-->
                  <tr>
                    <td><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px; ">
                        <tr>
                        <%--   <td  class="lz1">Receipt Code :</td>
                          <td>${sgrNo}</td>--%>
                          <td class="lz1">方案编码&nbsp;:</td> 
                          <td>
                            <select name="planCode1" id="planCode1" class="select-big">
                             
                              <c:forEach items ="${gameList}"  var ="gameplan">
                                   <option value="${gameplan.planCode }@${gameplan.fullName}">${gameplan.planCode }</option>
                              </c:forEach>
                            </select></td>
                             <td class="lz1">方案名称&nbsp;:</td>
                          <td ><input style="width:240px;"  class="input_out" name="fullName" id="fullName" type="text"  readonly="readonly" value="" /></td>
                        </tr>
                      
                        <tr>
                         
                           <td class="lz1">批次编码&nbsp;:</td>
                          <td>  <select name="batchNo" id="batchNo" class="select-big">
                             
                            </select></td>
                             <td  class="lz1"></td>
                          <td></td>
                        </tr>
                       <tr>
                       <td colspan="4"> 
                       <div style="margin-top:10px; float:right;">
                       <button class="gl-btn2" type="button" onclick="javascript:doSubmit()"  style="display:block">下一步</button>
                      </div></td>
                       </tr>
                      </table>
                      
                      
                      </td>
                  </tr>
                 
                </table>
              </div>
            </div></td>
        
        </tr>
      </table>
    </div>
<%-- 	<script type="text/javascript" src="${basePath}/views/inventory/goodsReceipts/js/jquery-1.8.3.min.js"></script>
   <script type="text/javascript" src="${basePath}/views/inventory/goodsReceipts/js/jquery.select.js"></script>
     --%>
  </div>
  <!--开奖结束--> 
  
</div>
</form>
</body>
</html>

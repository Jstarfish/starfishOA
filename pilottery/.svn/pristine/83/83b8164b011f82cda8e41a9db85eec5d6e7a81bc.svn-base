
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>
<%@page import="java.util.Date"%>
<% Date date=new Date(); %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
  <script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/views/inventory/goodsReceipts/js/TransCodeHandler_zh.js?d=<%=date%>"></script>
<script type="text/javascript" src="${basePath}/views/inventory/goodsReceipts/js/myJs.js"></script>
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
select {
	outline: none;
}
ul {
	list-style: none;
}
a {
	text-decoration: none;
}
</style>
<script type="text/javascript">
var trunkval=0;
var boxval=0;
var packval=0;
var totaltickts=0;
var totalvalue=0;
var rownum=0;
var planName='${planName}';
//var batchdetail='${detail}';
//alert(batchdetail);
$(document).ready(function(){

    // 初始化用户类型
    

		//  方案号planCode
	   //批次号batchNo
	   //单票金额ticketAmount
	  //批次首箱号firstTrunkBath
	  //批次总张数ticketsEveryBatch
	  //批次首本号1
      //奖组总票数ticketsEveryGroup

  SJZPrinter.initInfo('${detail.planCode}','${planName}','${detail.batchNo}','${detail.ticketAmount}','${detail.ticketsEveryGroup}');
	$('#barcode').keydown(function(e){

		if(e.keyCode==13){
		
			var obj = SJZPrinter.getPackInfo($('#barcode').val());
			  if (typeof (obj) == "undefined" || obj == null)	   
			    {
			    	return;
			    }
				if(obj.errCode != 0)
				{
					window.top.mainform.audio_play(3);
					showError(obj.errMessage);
					$('#barcode').val("");
					$("#barcode").blur();
					//$("#barcode").focus();
					return;
				}
			
			    var html=initDivhtmlzh(obj);

				var row=initRow(obj);
			setTimeout(function(){
				
				initDiv(html);
				addGame(row);
				 $('#barcode').val('');
				  $('#barcode').focus();
				  /* $('#barcode').val('');
				  $('#barcode').focus(); */
			},200);  
		
			 
			}
		})
		 $("#clearData").click(function(){  
	
			 SJZPrinter.clearObjects();
			 	$("#divBethdetail").empty();
			 	 $("#trunkhAmount").val('0');
			 	 $("#boxAmount").val('0');
			 	 $("#packageAmount").val('0');
			 	 
			      $("#tickets").val(0);
			 	 $("#amount").val(0);
			 	 trunkval=0;
			 	 boxval=0;
			 	 packval=0;
			 	 totaltickts=0;
			 	 totalvalue=0;
			 	 rownum=0;
				 $("#gameBatchInfo").empty(); 
			  }); 
		 $("#okbtn").click(function(){ 
			 if(parseInt(rownum)>0){
				 
				 switch_obj("okbtn","waitBtn");
			  $("#goodReceiptParamt").attr("action","goodsReceipts.do?method=goodsReceiptSecond");
			 $('#goodReceiptParamt').submit(); 
			 }
			 else{
				 showError("请扫描!"); 
				 return false;
			 }
			  }); 
	 
});

function findObj(id) {
	var obj = document.getElementById(id);
	return obj;
}
function switch_obj(btnId1, btnId2) {
	var btnObj1 = findObj(btnId1);
	btnObj1.style.display = "none";
	var btnObj2 = findObj(btnId2);
	btnObj2.style.display = "inline";
}


</script>
</head>

<body>
<form method="post" action=""  id="goodReceiptParamt" name="goodReceiptParamt" onkeydown="if(event.keyCode==13){return false;}">
<input  type="hidden" name="sgrNo"  id="sgrNo" value="${refNo}">
 <input type="hidden" name="planCode" id="planCode"  value="${planCode}">
 <input type="hidden" name="batchNo" id="batchNo" value="${batchNo}">
 <input type="hidden" name="trunkNo" id="trunkNo" value="${param.trunkNo}">
 <input type="hidden" name="boxNo" id="boxNo" value="${param.boxNo}">
 <input type="hidden" name="packageNo" id="packageNo" value="${param.packageNo}">
 <input type="hidden" name="operType" value="${operType}">
  <input type="hidden" name="trunkhAmount" id="trunkhAmount" value="${param.trunkhAmount}">
 <input type="hidden" name="boxAmount" id="boxAmount" value="${param.boxAmount}">
 <input type="hidden" name="packageAmount" id="packageAmount" value="${param.packageAmount}">
 
 <input type="hidden" name="tickets" id="tickets" value="${param.tickets}">
 <input type="hidden" name="amount" id="amount" value="${param.amount}">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">批次入库</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main">
  <div class="jdt">

        <img src="views/inventory/goodsReceipts/images/jdt4_2.png" width="1000" height="30" />
      <div class="xd-cn"><span class="zi">1.选择货物</span><span class="zi">2.扫描货物</span><span >3.完成收货</span><span>4.汇总货物</span></div></div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          
          <td align="center" valign="middle" ><div class="tab" >
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%" valign="top">
                 
                  <tr>
                    <td><div class="nr">
                        <div style="margin-bottom:20px;"><span class="dazit" style="font-size:18px;">方案编码 :<span class="hz1">${planCode}</span></span><span class="dazit" style="font-size:18px;">方案名称 :<span class="hz1">${planName}</span></span><span class="dazit" style="font-size:18px;">批次编号 :<span class="hz1">${batchNo}</span></span><span class="dazit" style="font-size:18px;">已经入库:<span class="hz1"><fmt:formatNumber value='${sumtickts}'  type='number'/>  张</span></span></div>
                        <div class="title-mbx">条形码</div>
                        <div >
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                               <td><input   class="edui-editor" name="barcode"  id="barcode" type="text"  value="请扫描条形码" onfocus="this.value=''" onblur="if(this.value==''){this.value='请扫描条形码'}"/></td>
                            </tr>
                          </table>
                        </div>
                      </div>
                      <div class="nr">
                        <div class="title-mbx">批次信息 </div>
                     
                      <div class="border" id="divBethdetail">
                     
                      </div>
                       </div>
                      <!--列表开始-->
                      
                      <div class="nr">
                        <div class="title-mbx">货物信息汇总</div>
                      </div>
                      <div  style="padding:0 20px; margin-top:15px; ">
                      <div style="position:relative; z-index:1000px;  ">
                       <table  class="datatable" cellpadding= "0 " cellspacing= "0 " id="table1_head" width="100%" >
                          <tr>
                            <th width="10%" >方案编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="10%" >批次编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >奖组编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >规格</th>
                            <th width="1%" >|</th>
                            <th width="10%" >标签代码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >总张数</th>
                            <th width="1%" >|</th>
                            <th width="10%" >操作</th>
                          </tr>
                        </table>
                      </div>
                      <div id="box" style="border:1px solid #ccc;">
                        <table class="datatable"  id="gameBatchInfo" cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >
                         <!-- <tr style="display:noe"></tr> -->
                        </table>
              </div>
             <!--列表结束-->
                      
                      <div style="margin-top:10px;  float:right;">
                        <button class="gl-btn2" type="button" id="clearData">清除</button>
                        <button class="gl-btn2" type="button" id="okbtn">提交</button>
                         <img id="waitBtn"  class="gl-btn2"  style="display:none" src="views/inventory/goodsReceipts/images/wait.gif" height="25px" width="35px"/>
                      </div></td>
                  </tr>
                </table>
              </div>
            </div></td>
        
        </tr>
      </table>
    </div>
   
  </div>
  <!--开奖结束--> 
  </div>
  </form>
</body>
</html>
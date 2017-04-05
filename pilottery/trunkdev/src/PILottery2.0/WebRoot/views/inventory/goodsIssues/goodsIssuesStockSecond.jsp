
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

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
  <script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/views/inventory/goodsReceipts/js/TransCodeHandler.js?d=<%=date%>"></script>
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
var batchdetail='${detail}';
$(document).ready(function(){

    // 初始化用户类型
    
	 // SJZPrinter.initInfo("J2012","00001",2000,1,1000000,'0012521');
	 //SJZPrinter.initInfo(batchdetail.planCode,batchdetail.batchNo,batchdetail.ticketAmount,batchdetail.firstTrunkBath,batchdetail.ticketsEveryBatch,'1');
		//  方案号planCode
	   //批次号batchNo
	   //单票金额ticketAmount
	  //批次首箱号firstTrunkBath
	  //批次总张数ticketsEveryBatch
	  //批次首本号1
      //奖组总票数ticketsEveryGroup
   //SJZPrinter.initInfo(batchdetail.planCode,batchdetail.batchNo,batchdetail.ticketAmount,batchdetail.firstTrunkBath,batchdetail.ticketsEveryBatch,'1',batchdetail.ticketsEveryGroup);
		var 	jsonstr
		var stbNo='';
		stbNo=$("#stbNo").val();
		if(stbNo==''){
			stbNo=$("#sgiNo").val();
			$("#stbNo").val(stbNo);
		}
	    var url='goodsIssues.do?method=getIssuseTransGameBystbNo&stbNo='+stbNo;
				$.ajax({
					url : url,
					dataType : "json",
					async : false,
					success : function(r){
						jsonstr=eval(r);    
				}
				});
		

	
		 SJZPrinter.initInfoForPlans(jsonstr);
	$('#barcode').keydown(function(e){

		if(e.keyCode==13){
			 
			//var obj = SJZPrinter.getPackInfo($('#barcode').val());
			
			
			 var barcodeval=$('#barcode').val();
	
			var val=barcodeval.replace(/[\r\n]/g,"")
			
			  var obj = SJZPrinter.getPackInfoExt(val);
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
			  
				 //  var html=initDivhtml(obj);

			var row=initRow1(obj);
			setTimeout(function(){
				initPlanHtml(obj)
				//initDiv(html);
				addGame(row);
				 $('#barcode').val('');
				  $('#barcode').focus();
				  
			},200);  
		
			 
			}
		})
		 $("#clearData").click(function(){  
			 SJZPrinter.clearObjects();
			 for(var i=0;i<rownum;i++){
				   var pval=$("#planCode"+i).val();
			
				 if($("#planCode"+i).val()==$("#planCode"+pval).text()){
					
					 if($("#packUnit"+i).val()=='Trunk'){
						 var trunkamout=parseInt(formatNum($("#plantrunkAmount"+pval).text()))-1;
							$("#plantrunkAmount"+pval).text(formatNumber(trunkamout));
						 
					 }
					 if($("#packUnit"+i).val()=='Box'){
							var boxAmount=parseInt(formatNum($("#plantrunkBox"+pval).text()))-1;
							$("#plantrunkBox"+pval).text(formatNumber(boxAmount));
						 
					 }
					if($("#packUnit"+i).val()=='Package'){
							var pkgAmount=parseInt(formatNum($("#plantrunkPkg"+pval).text()))-1;
							$("#plantrunkPkg"+pval).text(formatNumber(pkgAmount));
					}
					 var num =formatNum($("#plantrunkTickts"+pval).html());
						
						var titickts=parseInt(num)-parseInt($("#ticketNum"+i).val());
						$("#plantrunkTickts"+pval).html(formatNumber(titickts));
						 var sum=formatNum($("#sumTickets").html());
						 var total=parseInt(sum)-parseInt($("#ticketNum"+i).val());
						 $("#sumTickets").html(formatNumber(total));
				 }
			 }
			 
			
			 
		 //	$("#divBethdetail").empty();
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
			  $("#goodIssuesParamt").attr("action","goodsIssues.do?method=goodsIssuesStockSecond");
			 $('#goodIssuesParamt').submit();
		 } else{
			 showError("Please scan!"); 
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
<form method="post" action=""  id="goodIssuesParamt" name="goodIssuesParamt"  onkeydown="if(event.keyCode==13){return false;}">
 <input type="hidden" name="stbNo" id="stbNo" value="${param.stbNo}">
  <input type="hidden" name="sgiNo" id="sgiNo" value="${param.sgiNo}">
   <input type="hidden" name="refNo" id="refNo" value="${param.refNo}">
 <input type="hidden" name="operType" value="${param.operType}">
  <input type="hidden" name="trunkhAmount" id="trunkhAmount" value="${param.trunkhAmount}">
 <input type="hidden" name="boxAmount" id="boxAmount" value="${param.boxAmount}">
 <input type="hidden" name="packageAmount" id="packageAmount" value="${param.packageAmount}">
 <input type="hidden" name="receivingUnit" id="receivingUnit" value="${param.receivingUnit}" >
  <input type="hidden" name="deliveringUnit" id="deliveringUnit" value="${param.deliveringUnit}" >
 <input type="hidden" name="tickets" id="tickets" value="${param.tickets}">
 <input type="hidden" name="amount" id="amount" value="${param.amount}">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">Goods Issue by Stock Transfer</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main" >
   <div class="jdt">
      <img src="views/inventory/goodsReceipts/images/jdt4_2.png" width="1000" height="30" />
      <div class="xd"><span class="zi">1.Select Goods Issue</span><span class="zi">2.Scan Goods Issue</span><span>3.Complete Goods Issue</span><span>4.Summary Goods Issue</span></div></div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          
          <td ><div class="tab" >
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%" valign="top">
                
                  <tr>
                    <td><div class="nr">
                    <div style="margin-bottom:20px;"><span class="dazit" style="font-size:18px;">Stock Transfer :<span class="hz1">${param.stbNo}</span></span></div>
                       <div class="title-mbx">Barcode</div>
                        <div >
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                             <td><input   class="edui-editor" name="barcode"  id="barcode" type="text"  value="Please scan code or manual input bar code" onfocus="this.value=''" onblur="if(this.value==''){this.value='Please scan code or manual input bar code'}"/></td>
                            </tr>
                          </table>
                        </div>
                      </div>
                      <div class="nr">
                        <div class="title-mbx">Stock Outgoing Details</div>
                     
                       <div style="position:relative; z-index:1000px;  ">
                       <table  class="datatable" cellpadding= "0 " cellspacing= "0 " id="table1_head" width="100%" >
                          <tr>
                            <th width="10%" >Plan Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Plan</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Deliverable</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Trunk</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Box</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Package</th>
                            <th width="1%" >|</th>
                            <th width="10%" >tickets</th>
                          </tr>
                        </table>
                      </div>
                        <div id="planbox" >
                        <table class="datatable" id="planBoxTable" cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >
                          <c:forEach var="vo" items="${listvo}"  varStatus="status">
                          <tr>
                              <td width="10%" id="planCode${vo.planCode}">${vo.planCode}</td>
                              <td width="1%" >&nbsp;</td>
                               <td width="10%">${vo.planName}</td>
                              <td width="1%" >&nbsp;</td>
                              <td width="10%">${vo.actTickts}</td>
                              <td width="1%" >&nbsp;</td>
                               <td width="10%" id="plantrunkAmount${vo.planCode}">${vo.trunk}</td>
                              <td width="1%" >&nbsp;</td>
                              <td width="10%" id="plantrunkBox${vo.planCode}">${vo.box}</td>
                              <td width="1%" >&nbsp;</td>
                               <td width="10%" id="plantrunkPkg${vo.planCode}">${vo.pkg}</td>
                              <td width="1%" >&nbsp;</td>
                              <td width="10%" id="plantrunkTickts${vo.planCode}" >${vo.tickets}</td>
                            
                         </tr>
                         
                           </c:forEach>
                         
                        </table>
                        </div>
                         <div style="border:1px solid #ccc;">
                          <table class="datatable"  cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >
                          <tr>
                            <td colspan="12" style="text-align:right">Total Tickets<td>
                            <td  id="sumTickets">${sumTickets}<td>
                           </tr>
                          </table>
                         </div>
                       </div>
                      <!--列表开始-->
                      
                      <div class="nr">
                        <div class="title-mbx">Details of Goods Issue Information</div>
                      </div>
                      <div  style="padding:0 20px; margin-top:15px; ">
                      <div style="position:relative; z-index:1000px;  ">
                       <table  class="datatable" cellpadding= "0 " cellspacing= "0 " id="table1_head" width="100%" >
                          <tr>
                            <th width="10%" >Plan Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Plan</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Batch Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Prize Group Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Specification</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Tag Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Total Quantity</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Operation</th>
                          </tr>
                        </table>
                      </div>
                      <div id="box" style="border:1px solid #ccc;">
                        <table class="datatable" id="gameBatchInfo" cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >
                          
                          
                        </table>
                      </div>
              </div>
              <!--列表结束-->
                      
                      <div style="margin-top:10px;  float:right; padding:0 20px;">
                       <button class="gl-btn2" type="button" id="clearData">Clear</button>
                        <button class="gl-btn2" type="button" id="okbtn">Submit</button>
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
   
  </div>
  <!--开奖结束--> 
  </form>
</body>
</html>
>
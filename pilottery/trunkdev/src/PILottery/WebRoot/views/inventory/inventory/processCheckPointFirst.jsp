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
   
		var 	jsonstr
	        var cpNo=$("#cpNo").val();
	        var url='inventory.do?method=getGamsListCheck&cpNo='+cpNo;
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
					showError(obj.errMessage);
					$('#barcode').val("");	
					
					$("#barcode").blur();
					//$("#barcode").focus();
					return;
				}
			  
		 var html='';
			$("#divBethdetail").empty();
			
			html+='<table width="100%" border="0" cellspacing="0" cellpadding="0">';
			html+='<tr>';
			
			if(obj.packUnit=='Trunk'){
				var trunkamout=$("#trunkhAmount").val();
				
				if(trunkamout==''){
					trunkamout=0;
				}
				trunkval=parseInt(trunkamout)+1;
				
				$("#trunkhAmount").val(trunkval);
				html+='<td width="13%">Trunk :<span class="lz2">'+formatNumber(trunkval);
			}
			 if(obj.packUnit=='Box'){
				var boxAmount=$("#boxAmount").val();
				if(boxAmount==''){
					boxAmount=0;
				}
				 boxval=1+parseInt(boxAmount);
				 $("#boxAmount").val(boxval);
				html+='<td width="11%">Box :<span class="lz2" >'+formatNumber(boxval);
			}
			if(obj.packUnit=='Package'){
				var packageAmount=$("#packageAmount").val();
				if(packageAmount==''){
					packageAmount=0;
				}
				packval=parseInt(packageAmount)+1;
				$("#packageAmount").val(packval);
				html+='<td width="35%">Pack：<span class="lz2">'+formatNumber(packval);
			}
			
			html+='</span> </td>';
			 var tickets=$("#tickets").val();
			  if(tickets==''){
				  tickets=0;
			  }
			  totaltickts=parseInt(obj.ticketNum)+parseInt(tickets);
			  $("#tickets").val(totaltickts);
			html+='<td width="19%" class="hoz">Total Tickets :<span class="lz2">'+formatNumber(totaltickts);
			html+='</span> </td>';
			 var amount=$("#amount").val();
			  if(amount==''){
				  amount=0;
			  }
			 
			  totalvalue=parseInt(obj.amount)+parseInt(amount);
			  $("#amount").val(totalvalue);
			html+=' <td width="22%" align="right" class="hoz">Total Amount :<span class="lz2">'+formatNumber(totalvalue);
			html+='</span> riels</td>'; 
			html+='</tr></table>';
			
		
			 
				
			
			
			 var row='<tr><td width="10%" >'+obj.planCode;
			     row+='</td>';
			     row+='<td width="1%" >&nbsp;</td>';
			     row+='<td width="10%" >'+obj.planName;
			     row+='</td>';
			     row+=' <td width="1%" >&nbsp;</td>';
			     row+='<td width="10%" >'+obj.batchCode;
			     row+='</td>';
			     row+='<td width="1%" >&nbsp;</td>';
			     row+=' <td width="10%" >'+obj.groupCode;
			     row+='</td>';
			     row+='<td width="1%" >&nbsp;</td>';
			     row+=' <td width="10%" >'+obj.packUnit;
			     row+='</td>';
			     row+=' <td width="1%" >&nbsp;</td>';
			     row+=' <td width="10%" >'+obj.packUnitCode
			     row+='</td>';
			     row+=' <td width="1%" >&nbsp;</td>';
			     row+='<td width="10%" >'+formatNumber(obj.ticketNum);
			     row+='</td>';
			     row+=' <td width="1%" >&nbsp;</td>';
			     row+='<td width="10%"><a href="javascript:void(0)" onclick="deleteGame('+rownum+',this)" title="Delete"><img src="${basePath}/img/cross.png" alt="Delete" /></a></td>';
			     row+='<input type="hidden" name="para['+rownum+'].planCode" id="planCode'+rownum+'" value='+obj.planCode+'>';
			     row+='<input type="hidden" name="para['+rownum+'].batchCode" id="batchCode'+rownum+'" value='+obj.batchCode+'>';
			     row+='<input type="hidden" name="para['+rownum+'].packUnit" id="packUnit'+rownum+'"value='+obj.packUnit+'>';
			     row+='<input type="hidden" name="para['+rownum+'].packUnitCode" id="packUnitCode'+rownum+'" value='+obj.packUnitCode+'>';
			     row+='<input type="hidden" name="para['+rownum+'].ticketNum" id="ticketNum'+rownum+'" value='+checkNaN(obj.ticketNum)+'>';
			     row+='<input type="hidden" name="para['+rownum+'].bachamount" id="bachamount'+rownum+'" value='+checkNaN(obj.amount)+'>';
			     row+='<input type="hidden" name="para['+rownum+'].groupCode" id="groupCode'+rownum+'" value='+obj.groupCode+'>';
			     row+='<input type="hidden" name="para['+rownum+'].firstPkgCode" id="firstPkgCode'+rownum+'" value='+obj.firstPkgCode+'>';
			     row+='<input type="hidden" name="para['+rownum+'].packUnitValue" id="packUnitValue'+rownum+'" value='+obj.packUnitValue+'>';
			     
			     row+='</tr>'
			    	 rownum++; 	 
			setTimeout(function(){
				
				initDiv(html);
				addGame(row);
				 $('#barcode').val('');
				  $('#barcode').focus();
				
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
			   $("#checkPointParmat").attr("action","inventory.do?method=checkPointSecond");
				$('#checkPointParmat').submit();
		 }
		 else{
			 
			 showError("Please scan!"); 
			 return false;
		 }
		
		  }); 
	
});
function addGame(rowhtml){
	  var tb = document.getElementById("gameBatchInfo");
	  var rnum=tb.rows.length; 

	    var tb = document.getElementById("gameBatchInfo");
		  var rnum=tb.rows.length;
		  
		  if(parseInt(rnum) ==parseInt('0')){
			   $("#gameBatchInfo").append(rowhtml);    
		  }
		  if(parseInt(rnum)>0){
			  var r=parseInt(rnum)-1;
	    	   $(rowhtml).insertAfter($("#gameBatchInfo tr:eq("+r+")")); 
		  }
	    	 
	    
}

function deleteGame(rowNum,obj){
	 var del=$("#planCode"+rowNum).val()+$("#batchCode"+rowNum).val()+$("#packUnitCode"+rowNum).val();
		
	 SJZPrinter.removeObject(del);
	 var tb = document.getElementById("gameBatchInfo");  
	 var rnum=tb.rows.length;  
	 
		 
		 
			 var html='';
				$("#divBethdetail").empty();
				
				html+='<table width="100%" border="0" cellspacing="0" cellpadding="0">';
				html+='<tr>';
				  var unitype=$("#packUnit"+rowNum).val();
				
				if(unitype=='Trunk'){
					var trunkamout=$("#trunkhAmount").val();
					
					
					trunkval=parseInt(trunkamout)-1;
					
					$("#trunkhAmount").val(trunkval);
					html+='<td width="13%">Trunk :<span class="lz2">'+formatNumber(trunkval);
				}
				 if(unitype=='Box'){
					var boxAmount=$("#boxAmount").val();
					
					 boxval=parseInt(boxAmount)-1;
					 $("#boxAmount").val(boxval);
					html+='<td width="11%">Box :<span class="lz2" >'+formatNumber(boxval);
				}
				if(unitype=='Package'){
					var packageAmount=$("#packageAmount").val();
					packval=parseInt(packageAmount)-1;
					$("#packageAmount").val(packval);
					html+='<td width="35%">Pack：<span class="lz2">'+formatNumber(packval);
				}
				
				html+='</span> </td>';
				 var tickets=$("#tickets").val();
				   
				  totaltickts=parseInt(tickets)-parseInt($("#ticketNum"+rowNum).val());
				  $("#tickets").val(totaltickts);
				html+='<td width="19%" class="hoz">Total Tickets :<span class="lz2">'+formatNumber(totaltickts);
				html+='</span> </td>';
				 var amount=$("#amount").val();
				 
				  totalvalue=parseInt(amount)-parseInt($("#bachamount"+rowNum).val());
				  $("#amount").val(totalvalue);
				html+=' <td width="22%" align="right" class="hoz">Total Amount :<span class="lz2">'+formatNumber(totalvalue);
				html+='</span> riels</td>'; 
				html+='</tr></table>';
				initDiv(html);
				$(obj).parent().parent().remove(); 
		
		    	 
		    	 // rownum--;
		    if(rownum<0){
		    	
		    	rownum=0;
		    }

	 
}
function checkNaN(val){
	var value=0;
	 if(isNaN(val)){
		 value=0;
	 }
	 else{
		 value=val;
	 }
	 return value;
}
function initDiv(html){
	

	$("#divBethdetail").append(html);
	
}
function formatNumber(num, precision, separator) {
    var parts;
    // 判断是否为数字
    if (!isNaN(parseFloat(num)) && isFinite(num)) {
        // 把类似 .5, 5. 之类的数据转化成0.5, 5, 为数据精度处理做准, 至于为什么
        // 不在判断中直接写 if (!isNaN(num = parseFloat(num)) && isFinite(num))
        // 是因为parseFloat有一个奇怪的精度问题, 比如 parseFloat(12312312.1234567119)
        // 的值变成了 12312312.123456713
        num = Number(num);
        // 处理小数点位数
        num = (typeof precision !== 'undefined' ? num.toFixed(precision) : num).toString();
        // 分离数字的小数部分和整数部分
        parts = num.split('.');
        // 整数部分加[separator]分隔, 借用一个著名的正则表达式
        parts[0] = parts[0].toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1' + (separator || ','));

        return parts.join('.');
    }
    return NaN;
}

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
<form method="post" action="" id="checkPointParmat"
		name="checkPointParmat" onkeydown="if(event.keyCode==13){return false;}">
		<input type="hidden" name="trunkhAmount" id="trunkhAmount"
			value="${param.trunkhAmount}"> <input type="hidden"
			name="boxAmount" id="boxAmount" value="${param.boxAmount}"> <input
			type="hidden" name="packageAmount" id="packageAmount"
			value="${param.packageAmount}"> <input type="hidden"
			name="cpNo" id="cpNo" value="${vo.cpNo}"> <input type="hidden"
			name="tickets" id="tickets" value=""> 
			<input type="hidden"name="amount" id="amount" value="">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">Process Inventory Check</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main" >
   <div class="jdt">

					<img src="views/inventory/goodsReceipts/images/jdt3_1.png"
						width="1000" height="30" />
					<div class="xd">
						<span class="zi">1.Scan Goods Inventory</span>
						<span>2.Complete Goods Check</span>
						<span>3.Finish Goods Check</span>
					</div>
				</div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          
          <td ><div class="tab" >
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%" valign="top">
                <tr>
												<td><table width="90%" border="0" align="center"
														cellpadding="0" cellspacing="0" style="margin-top: 30px;">
														<tr>
															<td width="13%">Check Code :</td>
															<td width="23%"><span class="lz2">${vo.cpNo}</span></td>

															<td width="10%">Check Name :</td>
															<td width="20%"><span class="lz2">${vo.cpName}</span></td>
														</tr>
														<tr>
															<td>Plan code :</td>
															<td><span class="lz2">${vo.planCode}</span></td>
															<td>Plan Name :</td>
															<td><span class="lz2">${vo.planName}</span></td>
														</tr>
														<tr>
															<td>Batch :</td>
															<td><span class="lz2">${vo.batchNo}</span></td>
															<td></td>
															<td><span></span></td>
														</tr>
													</table>
												</td>

											</tr>
                  <tr>
                    <td><div class="nr">
                    <div style="margin-bottom:20px;"></div>
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
                        <div class="title-mbx">Check Incoming Details </div>
                     
                      <div class="border" id="divBethdetail">
                       
                      </div>
                       </div>
                      <!--列表开始-->
                      
                      <div class="nr">
                        <div class="title-mbx">Details of Goods Check Information</div>
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
              <!--列表结束-->
                      
                      <div style="margin-top:10px;  float:right;">
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
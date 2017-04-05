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
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>

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

 	var 	jsonstr
		var stbNo=$("#stbNo").val();
		        var url='goodsReceiptsTmp.do?method=getGameBatchInfoTemp';
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
					$('#barcode').val('');	
					$("#barcode").blur();
					//$("#barcode").focus();
					//$('#barcode').focus();	
					return;
				}
			
		
			
				var row=initRow1(obj);

			setTimeout(function(){
				
				initPlanHtml(obj);
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
					 //button_end("okbtn");
					// button_off("okbtn");
					switch_obj("okbtn","waitBtn");
					 $("#goodReceiptParamt").attr("action","goodsReceiptsTmp.do?method=goodsReceiptTempSecond");
					$('#goodReceiptParamt').submit();  
					
		          return false;
				 }
				 else{
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
<form method="post" action=""  id="goodReceiptParamt" name="goodReceiptParamt" onkeydown="if(event.keyCode==13){return false;}">
<input  type="hidden" name="sgrNo"  id="sgrNo" value="${param.sgrNo}">
 <input type="hidden" name="planCode" id="planCode"  value="${param.planCode}">
 <input type="hidden" name="batchNo" id="batchNo" value="${param.batchNo}">
 <input type="hidden" name="trunkNo" id="trunkNo" value="${param.trunkNo}">
 <input type="hidden" name="boxNo" id="boxNo" value="${param.boxNo}">
 <input type="hidden" name="packageNo" id="packageNo" value="${param.packageNo}">
 <input type="hidden" name="operType" value="${param.operType}">

<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">批次入库</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main">
  <div class="jdt">

   
      <div class="xd"></div></div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          
          <td align="center" valign="middle" ><div class="tab" >
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%" valign="top">
                 
                  <tr>
                    <td><div class="nr">
                        <div style="margin-bottom:20px;"></div>
                        <div class="title-mbx">条形码</div>
                        <div >
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              
                              <td><input   class="edui-editor" name="barcode"  id="barcode" type="text"  value="请扫描代码或手动输入条形码" onfocus="this.value=''" onblur="if(this.value==''){this.value='请扫描代码或手动输入条形码'}"/></td>
                            </tr>
                          </table>
                        </div>
                      </div>
                      <div class="nr">
                        <div class="title-mbx">收到的数量 </div>
                     
                        <div style="position:relative; z-index:1000px;  ">
                       <table  class="datatable" cellpadding= "0 " cellspacing= "0 " id="table1_head" width="100%" >
                          <tr>
                            <th width="10%" >方案编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="10%" >应入库</th>
                            <th width="1%" >|</th>
                            <th width="10%" >箱</th>
                            <th width="1%" >|</th>
                            <th width="10%" >盒</th>
                            <th width="1%" >|</th>
                            <th width="10%" >本</th>
                            <th width="1%" >|</th>
                            <th width="10%" >票</th>
                          </tr>
                        </table>
                      </div>
                        <div id="planbox" style="border:1px solid #ccc;">
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
                            <td colspan="12" style="text-align:right">总票数<td>
                            <td  id="sumTickets">${sumTickets}<td>
                           </tr>
                          </table>
                         </div>
                       </div>
                      <!--列表开始-->
                      
                      <div class="nr">
                        <div class="title-mbx">货物信息明细</div>
                      </div>
                      <div  style="padding:0 20px; margin-top:15px; ">
                      <div style="position:relative; z-index:1000px;  ">
                       <table  class="datatable" cellpadding= "0 " cellspacing= "0 " id="table1_head" width="100%" >
                          <tr>
                            <th width="10%" >方案编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="10%" >条形码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >奖组编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >规格</th>
                            <th width="1%" >|</th>
                            <th width="10%" >标签编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >总票数</th>
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
              </div>
             <!--列表结束-->
                      
                      <div style="margin-top:10px;  float:right; padding:0 20px;">
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
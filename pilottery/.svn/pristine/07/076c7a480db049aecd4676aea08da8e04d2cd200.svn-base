<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>


 <script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
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
$(document).ready(function(){
	var val=$('#stbNo').val();
	
	initData(val);
	  $("#stbNo").change(function() { 
		  var val=$('#stbNo').val();
			initData(val);
	  });
	  $("#okbtn").click(function() { 
		  if($('#stbNo').val()==''){
				showError('Choose Stock Transfer');
				
				return;
			}
	
			$('#goodIssuesParamt').submit();
	  });
});
function initData(val){
		var url="goodsReceipts.do?method=getSaltranserDitalList&stbNo=" + val;
		       
		 
				$.ajax({
					url : url,
					dataType : "json",
					async : false,
					success : function(r){
				          $("#box").empty();
				          $("#labsum").empty();
				          $("#info1").text('');
				          $("#info2").text('');
				          $("#info3").text('');
				          
				          var sum=0;
				          var html='';
				          html+='<table class="datatable"  cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >';
				          for(var i = 0; i < r.length; i++) { 
				        	  sum=sum+r[i].amount;
				        	  html+='<tr><td width="20%"  style="text-align:left">'+r[i].planCode+'</td>'; 
				        	  html+='<td width="1%" >&nbsp;</td>';
				        	  html+='<td width="20%"  style="text-align:left">'+r[i].planName+'</td>';
				        	  html+='<td width="1%">&nbsp;</td>';
				        	  html+=' <td width="20%"  style="text-align:left">'+formatNumber(r[i].tickets)+'</td>';
				        	  html+='<td width="1%">&nbsp;</td>';
				        	  html+='<td width="20%"  style="text-align:right">'+formatNumber(r[i].amount)+'</td></tr>'
				        	  
				        	 //$("#receivingUnit").val(r[i].receiveOrg);
				        	 // $("#receivingUnitName").val(r[i].receivingUnit);
				        	 // $("#deliveringUnit").val(r[i].sendOrg);
				        	 //$("#deliveringUnitName").val(r[i].deliveringUnit);
	                      }
						if(r && r.length > 0){
				          $("#info1").text('Submitted by:');
				          $("#info2").text(r[0].applyAdminName);
				          $("#info3").text(r[0].applyDate);
						}
				          
				          $("#box").html(html);
				          $("#labsum").html(formatNumber(sum));
				        
				}
				});
				
				
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
</script>
</head>

<body>
<form method="post" action="goodsIssues.do?method=goodsIssuesStockFirst"  id="goodIssuesParamt" name="goodIssuesParamt" >
<input type="hidden" name="operType" value="1">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">Goods Issue by Stock Transfer</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main"> 
  <div class="jdt">
      <img src="views/inventory/goodsReceipts/images/jdt4_1.png" width="1000" height="30" />
      <div class="xd"><span class="zi">1.Select Goods Issue</span><span>2.Scan Goods Issue</span><span>3.Complete Goods Issue</span><span>4.Summary Goods Issue</span></div></div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          
          <td ><div class="tab">
              <div class="tabn" >
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%;" valign="top">
                  
                  <tr>
                    <td style="border-bottom:1px solid #ccc; padding-bottom:10px;"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px; ">
                        <tr>
                         
                          <td  class="lz1" style="width:20%">Select Stock Transfer:</td>
                          <td  style="width:30%"><select name="stbNo" id="stbNo" class="select-big" style="width:300px;">
                               <option value=''></option>
                              <c:forEach items ="${translerList}"  var ="transter">
                                   <option value="${transter.stbNo}">${transter.stbNo} (${transter.receiveOrgName})</option>
                              </c:forEach>
                            </select></td>
                             <td class="lz1" id="info1" align="left"></td>
                             <td id="info2"></td>
                             <td id="info3"></td>
                        </tr>
                        <tr>
                          <td align="left">
                          	<input type="hidden" name="receivingUnit" id="receivingUnit" value="" >
                            <input type="hidden" name="receivingUnitName" id="receivingUnitName" class="text-big" value="" readonly="readonly">
                            <input type="hidden" name="deliveringUnit" id="deliveringUnit" value="" >
                            <input type="hidden" name="deliveringUnitName" id="deliveringUnitName" value="" class="text-big" readonly="readonly">
                          </td>
                        </tr>
                       
                      </table></td>
                  </tr>
                  <tr>
                    <td ><!--列表开始-->
                      
                      <div class="nr">
                        <div class="title-mbx">Details of Goods Stock Information</div>
                      </div>
                      <div  style="padding:0 20px; margin-top:15px; ">
                      <div  style="border:1px solid #ccc;">
                         <table  class="datatable"  id="table1_head" width="100%" >
                          <tr >
                            <th width="20%" align="left">Plan Code</th>
                            <th width="1">|</th>
                            <th   width="20%" align="left">Plan</th>
                            <th width="1">|</th>
                            <th width="20%"  align="left">Quantity(tickets)</th>
                            <th width="1">|</th>
                            <th width="20%"  align="left">Amount(riels)</th>
                            
                          </tr>
                        </table>
                      </div>
                      <div id="box" style="border:1px solid #ccc;">
                        <table class="datatable"  cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >
                          
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                       <td colspan="4"> 
                       <div style="margin:10px 20px; float:right;">
                      Total Amount :<span class="lz2" id="labsum"></span>riels
                      </div></td>
                       </tr>
                  <tr>
                       <td colspan="4"> 
                       <div style="margin:10px 20px; float:right;">
                       <button class="gl-btn2" type="button" id="okbtn" style="display:block">Next</button>
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

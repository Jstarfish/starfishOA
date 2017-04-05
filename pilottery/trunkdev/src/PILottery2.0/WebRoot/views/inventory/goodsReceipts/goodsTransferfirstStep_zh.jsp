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
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
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

	
	  $("#stbNo").change(function() { 
		  var val=$('#stbNo').val();
			initData(val);
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
				          
				
				          
				          var html='';
				          html+='<table class="datatable"  cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >';
				          for(var i = 0; i < r.length; i++) { 
				        	
				        	  html+='<tr><td  width="20%">'+r[i].planCode+'</td>'; 
				        	  html+='<td  width="1%">&nbsp;</td>';
				        	  html+='<td  width="20%" style="text-align:left">'+r[i].planName+'</td>';
				        	  html+='<td  width="1%">&nbsp;</td>';
				        	  html+=' <td  width="20%" style="text-align:left">'+formatNumber(r[i].tickets)+'</td>';
				        	  html+='<td  width="1%">&nbsp;</td>';
				        	  html+='<td  width="20%" style="text-align:right">'+formatNumber(r[i].amount)+'</td></tr>'

	 							$("#receivingUnit").val(r[i].receiveOrg);
					        	  
					        	  $("#receivingUnitName").val(r[i].receivingUnit);
					        
					        	  $("#deliveringUnit").val(r[i].sendOrg);
					        	  $("#deliveringUnitName").val(r[i].deliveringUnit);
	                      }
				          
				          
				          
				          
				         
	                 
				          $("#box").html(html);
				}
				});
				
				
}
function onSubmit(){
	 
	  
	if($('#stbNo').val()==''){
		showError('选择调拨单！');
		
		return;
	}
	$('#goodReceiptParamt').submit();	
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
<form method="post" action="goodsReceipts.do?method=goodsTransterFirst"  id="goodReceiptParamt" name="goodReceiptParamt" >
<input type="hidden" name="operType" value="1">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">调拨单入库</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main"> 
    <div class="jdt">
      <img src="views/inventory/goodsReceipts/images/jdt4_1.png" width="1000" height="30" />
      <div class="xd-cn"><span class="zi">1.选择货物</span><span >2.扫描货物</span><span >3.完成收货</span><span>4.汇总货物</span></div></div>
    <div class="bd">
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
         
          <td ><div class="tab">
              <div class="tabn" >
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%;" valign="top">
                 
              
                  
                   <tr>
                    <td style="border-bottom:1px solid #ccc; padding-bottom:10px;"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px; ">
                        <tr>
                         
                          <td  class="lz1">选择:</td>
                          <td ><select name="stbNo" id="stbNo" class="select-big">
                               <option value=""></option>
                              <c:forEach items ="${translerList}"  var ="transter">
                                   <option value="${transter.stbNo}">${transter.stbNo}</option>
                              </c:forEach>
                            </select></td>
                             <td class="lz1">调拨到:</td>
                          <td align="left">
                            <input type="hidden" name="receivingUnit" id="receivingUnit" value="" >
                            <input type="text" name="receivingUnitName" id="receivingUnitName" class="text-big" value="" readonly="readonly">
                            
                            </td>
                          
                        </tr>
                     
                        <tr>
                         
                            <td class="lz1">从调拨:</td>
                          <td align="left">
                            <input type="hidden" name="deliveringUnit" id="deliveringUnit" value="" >
                            <input type="text" name="deliveringUnitName" id="deliveringUnitName" value="" class="text-big" readonly="readonly">
                            
                            </td>
                                 <td  class="lz1"></td>
                          <td ></td>
                        </tr>
                       
                      </table></td>
                  </tr>
                  <tr>
                    <td ><!--列表开始-->
                      
                      <div class="nr" style="width:90%;">
                        <div class="title-mbx"> </div>
                      </div>
                      <div  style="padding:0 20px; margin-top:15px; ">
                     <div  style="border:1px solid #ccc;">
                         <table  class="datatable"  id="table1_head" width="100%" >
                          <tr>
                            <th width="20%"  align="left">方案编码</th>
                            <th width="1%">|</th>
                            <th width="20%"  align="left">方案名称</th>
                            <th width="1%">|</th>
                            <th  width="20%"  align="left">票数(张)</th>
                            <th width="1%" >|</th>
                            <th width="20%"  align="left">金额(瑞尔)</th>
                            
                          </tr>
                        </table>
                      </div>
                    <div id="box" style="border:1px solid #ccc;">
                        <table class="datatable"  cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >
                          
                        </table>
                    </div>
                    </div>
                    
             <!--列表结束-->
                      
                      <div style="margin-top:10px;  float:right;">
                        <button class="gl-btn2" type="button" onclick="onSubmit();">下一步</button>
                       
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

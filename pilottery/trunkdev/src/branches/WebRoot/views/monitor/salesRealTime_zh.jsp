<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="refresh" content="120;url=${basePath}/monitor.do?method=salesRealTime&planCode=${planCode}">
<title>游戏销量监控</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<script type="text/javascript" src="${basePath}/js/hightcharts/jquery.min.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/highcharts.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/drilldown.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/exporting.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>

<script type="text/javascript" charset="UTF-8">
var xTime = ['07:00','07:05','07:10','07:15','07:20','07:25','07:30','07:35','07:40','07:45','07:50','07:55',
             '08:00','08:05','08:10','08:15','08:20','08:25','08:30','08:35','08:40','08:45','08:50','08:55',
             '09:00','09:05','09:10','09:15','09:20','09:25','09:30','09:35','09:40','09:45','09:50','09:55',
             '10:00','10:05','10:10','10:15','10:20','10:25','10:30','10:35','10:40','10:45','10:50','10:55',
             '11:00','11:05','11:10','11:15','11:20','11:25','11:30','11:35','11:40','11:45','11:50','11:55',
             '12:00','12:05','12:10','12:15','12:20','12:25','12:30','12:35','12:40','12:45','12:50','12:55',
             '13:00','13:05','13:10','13:15','13:20','13:25','13:30','13:35','13:40','13:45','13:50','13:55',
             '14:00','14:05','14:10','14:15','14:20','14:25','14:30','14:35','14:40','14:45','14:50','14:55',
             '15:00','15:05','15:10','15:15','15:20','15:25','15:30','15:35','15:40','15:45','15:50','15:55',
             '16:00','16:05','16:10','16:15','16:20','16:25','16:30','16:35','16:40','16:45','16:50','16:55',
             '17:00','17:05','17:10','17:15','17:20','17:25','17:30','17:35','17:40','17:45','17:50','17:55',
             '18:00','18:05','18:10','18:15','18:20','18:25','18:30','18:35','18:40','18:45','18:50','18:55',
             '19:00','19:05','19:10','19:15','19:20','19:25','19:30','19:35','19:40','19:45','19:50','19:55',    
             '20:00','20:05','20:10','20:15','20:20','20:25','20:30','20:35','20:40','20:45','20:50','20:55'];
$(document).ready(function() {
	var width_frm = $(document.body).width();
	var height_frm = $(document.body).height()-89;
	$('#container').css("height", height_frm);
	$('#container').css("width", width_frm);
   });
 
$(window).resize(function() {
	var width_frm = $(document.body).width();
	var height_frm = $(document.body).height()-89;
	$('#container').css("height", height_frm);
	$('#container').css("width", width_frm);
});

$(function () {
	var chart1List = $.parseJSON('${chart}');
	       
    $('#container').highcharts({
     title: {
         text: 'Real-Time Sales'
     },
      xAxis: {
    	 type:"datetime",//时间轴要加上这个type，默认是linear
    	 labels:{
             step:6
         },
         categories: xTime
     }, 

     yAxis: {
     	floor:0,
         title: {
             text: '销售金额 (瑞尔)'
         },
         plotLines: [{
             value: 0,
             width: 1,
             color: '#808080'
         }]
     },
     tooltip: {
     	formatter: function () {
    	 return '<b>' + this.x +' </b> Sales <br/><b>' 
		 		+ Highcharts.numberFormat(this.y,0,'.',',') + '</b>'
		 		+'<br/><b>'+this.series.name+'</b>';
     	}
     },
     exporting:'',
     series: [{
         name: '今天',
         data: chart1List.today
     }, {
         name: '昨天',
         data: chart1List.yestoday
     }, {
         name: '上周同一时间',
         data: chart1List.dayOfLastWeek
     }]
	}); 
    
 });

function doQuery(){
	$("#salesRealTimeQueryForm").submit();
}

</script>

</head>
<body>
	<div id="title">Real-Time Sales Trendline</div>
	
	<div class="queryDiv">
		<form action="monitor.do?method=salesRealTime" method="POST" id="salesRealTimeQueryForm">
			<div class="left">
				<span>方案名称:</span>
				<span>
					<select name="planCode" id="planCode" class="select-big" onchange="doQuery();">
						<option value="">  --所有方案-- </option>
					   <c:forEach var="item" items="${planMap}">
					      <option value="${item.key}" <c:if test="${planCode==item.key }">selected</c:if>>${item.value}</option>
					   </c:forEach>
					</select>
				</span>
			</div>
		</form>
	</div>
	
	<div id="container">
	
	</div>

</body>
</html>
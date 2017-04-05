<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%-- <%@ page import="cls.pilottery.common.util.*"  %> --%>
<%@ page import="java.util.Date"%>
<%@ include file="/views/common/taglibs.jsp"%>

<html>
<head>
<title><!--终端上线占比-->终端上线占比</title>
<%@ include file="/views/common/meta.jsp" %>
<%@ include file="/views/oms/monitor/js/comm_function.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<script type="text/javascript" src="${basePath}/js/hightcharts/jquery.min.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/highcharts.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/drilldown.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/exporting.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>

<script type="text/javascript" charset="UTF-8" > 

	function drawGraph(dataList) {
		
		   var onlineCount=0;
		   var totalCount=0;
		
		   for(var i = 0; i < dataList.length; i++) {
		   	onlineCount += dataList[i].onlineCount;
		   	totalCount  += dataList[i].totalCount;
		   }
		$('#container').highcharts({
		       chart: {
		           plotBackgroundColor: null,
		           plotBorderWidth: 1,//null,
		           plotShadow: false
		       },
		       title: {
		           text: '  当前全系统终端机上线占比 ' //当前全系统终端机上线占比
		       },
		       subtitle: {
                   text: getCurrentDate()
               },
		       tooltip: {
		   	    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		       },
		       exporting: {
		            enabled: false
		        },
		       plotOptions: {
		           pie: {
		               allowPointSelect: true,
		               cursor: 'pointer',
		               dataLabels: {
		                   enabled: true,
		                   format: '<b>{point.name}</b>: {point.percentage:.1f} %',
		                   style: {
		                       color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'green'
		                   }
		             }
		           }
		       },
		       series: [{//设置每小个饼图的颜色、名称、百分比  
		           type: 'pie',  
		           name: '<br/><br/>终端机总数:'+totalCount+' 台<br/> 占比',  //终端机总数 //台<br/> 占比
		           data: [  
		               {name:'未上线数量',y:totalCount-onlineCount},  //未上线数量
		               {name: '上线数量',sliced: true,selected: true,y:onlineCount} //上线数量
		           ]  
		       }]
		   });
	};

   // 异步请求数据列表
   function getData() {
       $.ajax({
           async:true,
           type: 'get',
           url: "areaTerminal.do?method=ajax",
           timeout: 5000,
           dataType: "json",
           error: function() {
               return "error";
           },
           success: function (result) {
        	   drawGraph(result);
           }
       });
   };

   window.onload = function(){
       getData();
   };

</script>
</head>
<body>
	<div id="title">当前终端机上线占比</div>
	
	<div id="viewdata">
	  <div id="container" style="height:90%"></div>
	</div> 
	
</body>
</html>
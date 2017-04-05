<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%-- <%@ page import="cls.pilottery.oms.common.util.*"  %> --%>
<%@ page import="java.util.Date"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>终端上线折线图</title>

<%@ include file="/views/common/meta.jsp" %>
<%@ include file="/views/oms/monitor/js/comm_function.jsp"%>

<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
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
	    var rateArray = new Array;
	    var timeArray = new Array;
	
	    for(var i = 0; i < dataList.length; i++) {
	    	//rateArray[i] = (((dataList[i].onlineCount)/(dataList[i].totalCount)).toFixed(3))*100;
	    	rateArray[i] = Math.round((dataList[i].onlineCount)/(dataList[i].totalCount)*1000)/10;
	    	timeArray[i] = dataList[i].timePointText;
	    	
	    };
	    
	    $('#container').highcharts({
	        chart: {
	            zoomType: 'xy'
	        },
	        title: {
	            text: '终端机上线率记录  '//终端机上线率记录
	        },
	        subtitle: {
                text: getCurrentDate()
            },
			xAxis: {  //x轴 
	        	title: {text: '时间'}, //标题 //properties---时间
	        	labels:{
	                step:6
	            } ,
				//categories: ['8:00', '9:00', '10:00', '11:00', '12:00', '13:00','14:00', '15:00', '16:00', '17:00', '18:00', '19:00','20:00','21:00','22:00'] //x轴标签名称
	        	categories:timeArray
				}, 
			yAxis: {  //y轴 
				title: {text: '%'}, //标题 
				tickInterval:10,
				min:0,
				max:100
			}, 
			exporting: {
	            enabled: false
	        },
	
	        tooltip: {
	            shared: true
	        },
	        legend: {
	            layout: 'vertical',
	            align: 'left',
	            x: 120,
	            verticalAlign: 'top',
	            y: 100,
	            floating: true,
	            backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
	        },
	        series: [ {
	            name: '上线率',//上线率
	            type: 'line',
	            //data: [65.0,80.9,59.9,85.6,88.6,92.7,59.9,85.6,88.6,92.7,59.9,85.6,85.6,85.6],
	            data: rateArray,
	            tooltip: {
	                valueSuffix: '%'
	            }
	        }]
	    });
	};

	
	
   // 异步请求数据列表
   function getData() {

       $.ajax({
           async:true,
           type: 'get',
           url: "areaTerminal.do?method=ajaxLine",
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
	<div id="title">上线率</div>
	<div id="viewdata">
	  <div id="container" style="height:90%"></div>
	</div>
</body>
</html>
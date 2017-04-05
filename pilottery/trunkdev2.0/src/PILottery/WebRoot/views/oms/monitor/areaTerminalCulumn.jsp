<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%-- <%@ page import="cls.pilottery.oms.common.util.*"  %> --%>
<%@ page import="java.util.Date"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title><!--终端上线柱状图-->Online Terminals Histogram</title>
<%@ include file="/views/common/meta.jsp" %>
 <%@ include file="/views/oms/monitor/js/comm_function.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<script type="text/javascript" src="${basePath}/js/hightcharts/jquery.min.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/highcharts.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/drilldown.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/exporting.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" charset="UTF-8" > 

	function drawGraph(dataList) {
	    var areas = new Array();
	    var onlineCount = new Array();
	    var totalCount = new Array();

		for(var i = 0; i < dataList.length; i++) {
	    	areas[i] = dataList[i].areaName;
	    	onlineCount[i] = dataList[i].onlineCount;
	    	totalCount[i] = dataList[i].totalCount;
	    }
	    $('#container').highcharts({
	        chart: {
	            type: 'column'
	        },
	        title: {
	            text: 'Online Terminals Distribution '//终端机上线数量 
	        },
	        subtitle: {
                text: getCurrentDate()
            },
	        xAxis: {
	            categories: areas
	        },
	        yAxis: {
	        	//tickInterval:500,
	        	tickInterval:50,
	            min: 0,
	            title: {
	                text: 'Number of Terminals'//上线数量(台)
	            }
	        },
	        exporting: {
	            enabled: false
	        },
	        plotOptions: {
	            column: {
	                pointPadding: 0.2,
	                borderWidth: 0
	            }
	        },
	        series: [{
	            name: 'Total',//总量
	            data: totalCount
	        },{
	            name: 'Online',//上线数量
	            data: onlineCount
	        }]
	    });
	}

   // 异步请求数据列表
   function getData() {
       $.ajax({
           async:true,
           type: 'get',
           url: "areaTerminal.do?method=ajaxCulu",
           timeout: 9000,
           dataType: "json",
           error: function() {
               return "error";
           },
           success: function (result) {
        	   drawGraph(result);
           }
       });
   }

   window.onload = function(){
       getData();
   };

</script>
</head>
<body>
	<div id="title">Online Terminals Monitor</div>

	<div id="viewdata">
	  <div id="container" style="height:90%"></div>
	</div>
</body>
</html>
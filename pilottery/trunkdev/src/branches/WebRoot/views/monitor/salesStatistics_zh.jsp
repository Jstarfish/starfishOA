<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>月度销售监控</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/hightcharts/jquery.min.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/highcharts.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/drilldown.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/exporting.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" charset="UTF-8">
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
	var colors = Highcharts.getOptions().colors,
	categories = [],
	name = '月份',
	data = [];
    
    function setChart(name, categories, data, color) {
		chart.xAxis[0].setCategories(categories, false);
		chart.series[0].remove(false);
		chart.addSeries({
			name: name,
			data: data,
			color: color || 'white'
		}, false);
		chart.redraw();
    }
   
	
    var chart = $('#container').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: '销售记录'
        },
        subtitle: {
            text: '点击一列查看天，在点击一次返回月份'
        },
        xAxis: {
            categories: categories
        },
        yAxis: {
            title: {
                text: '销售金额(瑞尔)'
            }
        },
        plotOptions: {
            column: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function() {
                            var drilldown = this.drilldown;
                            if (drilldown) { // drill down
                                setChart(drilldown.name, drilldown.categories, drilldown.data, drilldown.color);
                            } else { // restore
                                setChart(name, categories, data);
                            }
                        }
                    }
                },
                dataLabels: {
                    enabled: true,
                    color: colors[0],
                    style: {
                        fontWeight: 'bold',
                        textShadow: '0 0 0px contrast, 0 0 0px contrast'
                    },
                    formatter: function() {
                        return toThousands(this.y) +'瑞尔';
                    }
                }
            }
        },
        tooltip: {
            formatter: function() {
                var point = this.point,
                s = this.x +' 销售金额:'+ toThousands(this.y) +' 瑞尔<br>';
                if (point.drilldown) {
                } else {
                    s += '点击返回月份';
                }
                return s;
            }
        },
        series: [{
            name: name,
            data: data,
            color: 'white'
        }],
        exporting: {
            enabled: false
        }
    })
    .highcharts(); // return chart
    
    function updateView(param){
    	$.ajax({
    	    url: "monitor.do?method=salesResponse&year="+param,
    		type: 'get',
    	    dataType: 'json',
    	    async: true,
    	    success: function(json){
    	   		for(var i=0;i<json.monthAmount.length;i++){
    	   			json.monthAmount[i]["color"] = colors[i % 10];
    	   			json.monthAmount[i]["drilldown"] = {};
    	   			json.monthAmount[i]["drilldown"]["name"]=json.monthName[i];
    	   			json.monthAmount[i]["drilldown"]["categories"]=json.dayName[i];
    	   			json.monthAmount[i]["drilldown"]["data"]=json.dayAmount[i];
    	   			json.monthAmount[i]["drilldown"]["color"]=colors[i % 10];
    	   		} 
    	   			categories = json.monthName;
        			data = json.monthAmount;
        			
        			setChart(name, categories, data);
    	   		
    	    } 
    	});
    	
    }
	
    $("#timeScale").ready(function(){
    	updateView($("#timeScale").val().split(" ")[1]);
    });
    $("#timeScale").change(function(){
    	updateView($("#timeScale").val().split(" ")[1]);
    });
   
});
//used by WdatePicker
function timeScaleChange(){
	$("#timeScale").change();
}

</script>

</head>
<body>
	<div id="title">月度销售监控</div>
	
	<div class="queryDiv">
		<form action="" method="POST" id="institutionSalesQueryForm">
			<div class="left">
				<span>时间:</span>
				<span>
				 <input name="timeScale" id="timeScale"  value="年 <%=Calendar.getInstance().get(Calendar.YEAR) %>"
					class="Wdate text-normal"
					onfocus="WdatePicker({dateFmt:'年  yyyy',readOnly:true,isShowClear:true,isShowToday:true,onpicked:timeScaleChange})" />
				</span>
			</div>
		</form>
	</div>
	
	<div id="container">
	
	</div>

</body>
</html>
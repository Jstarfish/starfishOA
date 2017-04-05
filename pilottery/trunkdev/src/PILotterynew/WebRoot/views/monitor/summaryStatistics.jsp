<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<html>
<head>
<meta http-equiv="refresh" content="120">
<title>Comprehensive Monitor</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/hightcharts/highcharts.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/drilldown.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/exporting.js"></script>
<script type="text/javascript" src="${basePath}/js/hightcharts/highcharts-3d.js"></script>
<script type="text/javascript">
var colors = Highcharts.getOptions().colors;
//var colors = [ '#4572A7', '#AA4643', '#89A54E', '#80699B', '#3D96AE', '#DB843D', '#92A8CD', '#A47D7C', '#B5CA92' ];
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
var xTime2 = ['7:00 ','8:00 ','9:00 ','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00'];
 	$(document).ready(function() {
		var width_frm = $(document.body).width()-40;
		var height_frm = $(document.body).height();
 		var width_div = width_frm/2;
		var height_div = height_frm/2;
		
		$('#line').css("height", height_div);
		$('#line').css("width", width_div);
		
		$('#column').css("height", height_div);
		$('#column').css("width", width_div);
		
		$('#pie1').css("height", height_div);
		$('#pie1').css("width", width_div);
		
		$('#pie2').css("height", height_div);
		$('#pie2').css("width", width_div);
       });
	 
	$(window).resize(function() {
		var width_frm = $(document.body).width()-40;
		var height_frm = $(document.body).height();
 		var width_div = width_frm/2;
		var height_div = height_frm/2;
		
		$('#line').css("height", height_div);
		$('#line').css("width", width_div);
		
		$('#column').css("height", height_div);
		$('#column').css("width", width_div);
		
		$('#pie1').css("height", height_div);
		$('#pie1').css("width", width_div);
		
		$('#pie2').css("height", height_div);
		$('#pie2').css("width", width_div);
	});

	
/*线型图*/
$(function () {
	   var chart1List = $.parseJSON('${chart1}');

       $('#line').highcharts({
        title: {
            text: 'Real-Time Sales'
        },
        colors : colors,
        xAxis: {
        	text: "Time",
        	labels:{
                step:12
            },
            categories: xTime
        },
        yAxis: {
        	floor:0,
            title: {
                text: 'Sales Amount (Riels)'
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
            name: 'Today',
            data: chart1List.today
        }, {
            name: 'Yesterday',
            data: chart1List.yestoday
        }, {
            name: 'Day of last week',
            data: chart1List.dayOfLastWeek
        }]
   	});
});


/*柱状图*/
$(function () {
	var chart2List = $.parseJSON('${chart2}');
	
    $('#column').highcharts({
        chart: {
            type: 'column'
        },
        colors : colors,
        title: {
            text: 'Same Period Compare'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
        	text: "Time",
            categories: xTime2,
            crosshair: true
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Sales Amount (Riels)'
            }
        },
        tooltip: {
        	shared: true,
        	useHTML: true,
        	formatter: function () {
                return  '<b>' + this.x +'</b> Sales<br/>' +
                		this.points[0].series.name+' : <b>' + Highcharts.numberFormat(this.points[0].y,0,'.',',') + '</b><br/>' +
                		this.points[1].series.name+' : <b>'+ Highcharts.numberFormat(this.points[1].y,0,'.',',')+'</b>';
            }
        },
        exporting:'',
        series: [{
            name: 'Today',
            data: chart2List.today
        }, {
            name: 'Yesterday',
            data: chart2List.yestoday
        }]
    });
});

/*饼状图1*/
$(function () {
	var colors = Highcharts.getOptions().colors;
	var json = $.parseJSON('${chart3}');
	for(var key in json){
        json[key].y = json[key].perOfsale;
        json[key].name = json[key].planName;
        json[key].color = colors[key%10];
    }
    
    $('#pie1').highcharts({
        chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        colors : colors,
        title: {
            text: 'Sales Statistics By Game'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}'
                }
            }
        },
        exporting:'',
        series: [{
            type: 'pie',
            name: 'Sales share',
            data: json
        }]
    });
});


/*饼状图2*/
$(function () {
	var colors = Highcharts.getOptions().colors;
	var json = $.parseJSON('${chart4}');
	for(var key in json){
        json[key].y = json[key].perOfsale;
        json[key].name = json[key].orgName;
        json[key].color = colors[key%10];
    }
	var orgCode = '${orgCode}';
	var title = "Sales Statistics By Institution";
	if(orgCode != '00'){
		title = "Outlet Ranking";
	}
    $('#pie2').highcharts({
        chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        colors : colors,
        title: {
            text: title
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}'
                }
            }
        },
        exporting:'',
        series: [{
            type: 'pie',
            name: 'Sales share',
            data: json
        }]
    });
});


</script>
</head>
<body>
<center>
<div>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
		<div id="line"
			style="min-width: 600px; min-height: 400px; float: right"></div>
		</td>
		<td>
		<div id="column"
			style="min-width: 600px; min-height: 400px; float: left"></div>
		</td>
	</tr>
	<tr>
		<td>
		<div id="pie1"
			style="min-width: 600px; min-height: 400px; float: right"></div>
		</td>
		<td>
		<div id="pie2"
			style="min-width: 600px; min-height: 400px; float: left"></div>
		</td>
	</tr>
</table>

</div>
</center>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Institution Sales Statistics</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
<script type="text/javascript" src="${basePath}/js/hightcharts/jquery.min.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/highcharts.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/drilldown.js"></script> 
<script type="text/javascript" src="${basePath}/js/hightcharts/exporting.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
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

	/* Demo data */
	/*
	categories = ['MSIE', 'Firefox', 'Chrome', 'Safari', 'Opera'],
	name = 'Institutions',
	data = [{
	        y: 55.11,
	        color: colors[0],
	        drilldown: {
	            name: 'MSIE versions',
	            categories: ['MSIE 6.0', 'MSIE 7.0', 'MSIE 8.0', 'MSIE 9.0'],
	            data: [10.85, 7.35, 33.06, 2.81],
	            color: colors[0]
	        }
	    }, {
	        y: 21.63,
	        color: colors[1],
	        drilldown: {
	            name: 'Firefox versions',
	            categories: ['Firefox 2.0', 'Firefox 3.0', 'Firefox 3.5', 'Firefox 3.6', 'Firefox 4.0'],
	            data: [0.20, 0.83, 1.58, 13.12, 5.43],
	            color: colors[1]
	        }
	    }, {
	        y: 11.94,
	        color: colors[2],
	        drilldown: {
	            name: 'Chrome versions',
	            categories: ['Chrome 5.0', 'Chrome 6.0', 'Chrome 7.0', 'Chrome 8.0', 'Chrome 9.0',
	                'Chrome 10.0', 'Chrome 11.0', 'Chrome 12.0'],
	            data: [0.12, 0.19, 0.12, 0.36, 0.32, 9.91, 0.50, 0.22],
	            color: colors[2]
	        }
	    }, {
	        y: 7.15,
	        color: colors[3],
	        drilldown: {
	            name: 'Safari versions',
	            categories: ['Safari 5.0', 'Safari 4.0', 'Safari Win 5.0', 'Safari 4.1', 'Safari/Maxthon',
	                'Safari 3.1', 'Safari 4.1'],
	            data: [4.55, 1.42, 0.23, 0.21, 0.20, 0.19, 0.14],
	            color: colors[3]
	        }
	    }, {
	        y: 2.14,
	        color: colors[4],
	        drilldown: {
	            name: 'Opera versions',
	            categories: ['Opera 9.x', 'Opera 10.x', 'Opera 11.x'],
	            data: [ 0.12, 0.37, 1.65],
	            color: colors[4]
	        }
	    }];
	*/
	categories = [],
	name = 'Institutions',
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
            text: 'Institution Sales Statistics'
        },
        subtitle: {
            text: 'Click the columns to view game plans. Click again to view institutions.'
        },
        xAxis: {
            categories: categories,
            labels: {
            	rotation: -45
            }
        },
        yAxis: {
            title: {
                text: 'Sales Amount (Riels)'
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
                    color: 'constrast',
                    style: {
                        fontWeight: 'normal',
                        color: 'contrast',
                        textShadow: '0 0 0px contrast, 0 0 0px contrast'
                    },
                    formatter: function() {
                        return toThousands(this.y) +' Riels';
                    }
                }
            }
        },
        tooltip: {
            formatter: function() {
                var point = this.point,
                    s = this.x +' sales amount:'+ toThousands(this.y) +' Riels<br>';
                if (point.drilldown) {
                    s += 'Click to view '+ point.category +' plans';
                } else {
                    s += 'Click to return to institutions';
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
    
    function updateSalesData(startDate, endDate)
    {
		if (!isValidDate(startDate, endDate)) {
			return;
		}
    	
	   	var url = "monitor.do?method=updateInstitutionSalesData&startDate="+startDate+"&endDate="+endDate;
    	
    	$.ajax({
    		url: url,
    		type: "GET",
    		dataType: "json",
    		async: true,
    		success: function(json) {

    			for (var i = 0; i < json.data.length; i++) {
    				json.data[i]["color"] = colors[i % 10];
    				json.data[i].drilldown["color"] = colors[i % 10];
    			}
    			categories = json.categories;
    			data = json.data;
    			
    			setChart(name, categories, data);
    		}
    	});
    }
    
	$("#startDate").change(function(){
		updateSalesData($("#startDate").val(), $("#endDate").val());
	});
	$("#endDate").change(function(){
		updateSalesData($("#startDate").val(), $("#endDate").val());
	});
	
	$("#startDate").val('${startDate}');
	$("#endDate").val('${endDate}');
	triggerStartDateChange();
});

// used by WdatePicker
function triggerStartDateChange() {
	$("#startDate").change();
}

//used by WdatePicker
function triggerEndDateChange() {
	$("#endDate").change();
}

function isValidDate(startDate, endDate) {
	if (startDate == null || startDate == undefined || startDate == '') {
		return false;
	}
	if (endDate == null || endDate == undefined || endDate == '') {
		return false;
	}
	if (toDate(startDate) > toDate(endDate)) {
		return false;
	}
	
	return true;
}

function toDate(date) {
	var parts = date.split("-");
	return new Date(parts[0], parts[1]-1, parts[2]);
}

</script>

</head>
<body>
	<div id="title">Institution Sales Statistics</div>
	
	<div class="queryDiv">
		<form action="" method="POST" id="institutionSalesQueryForm">
			<div class="left">
				<span>Start Date: <input id="startDate" name="startDate" class="Wdate text-normal" 
						onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true,onpicked:triggerStartDateChange})" maxlength="40"/></span>
				<span>End Date: <input id="endDate" name="endDate" class="Wdate text-normal" 
						onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true,onpicked:triggerEndDateChange})" maxlength="40"/></span>
			</div>
		</form>
	</div>
	
	<div id="container">
	
	</div>

</body>
</html>
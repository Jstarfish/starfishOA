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

	categories = [],
	nameSales = 'Sales Amount',
	nameIncomes = "Income",
	sales = [],
	incomes = [];
	
	function setChart(name, categories, data, color) {
		chart.xAxis[0].setCategories(categories, false);
		
		while(chart.series.length > 0) {
		    chart.series[0].remove(true);
		}
		
		chart.addSeries({
			name: name,
			data: data,
			color: color
		}, false);
		
		chart.redraw();
	}
	
	function restoreChart() {
		chart.xAxis[0].setCategories(categories, false);
		
		while(chart.series.length > 0) {
		    chart.series[0].remove(true);
		}
		
		chart.addSeries({
	        name: nameSales,
	        data: sales,
	        color: colors[0]
	    }, false);
		
		chart.addSeries({
	        name: nameIncomes,
	        data: incomes,
	        color: colors[1]
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
            	rotation: -45,
            	style: {
                    fontWeight: 'bold',
                    color: 'contrast',
                    textDecoration: 'underline'
                }
            }
        },
        yAxis: {
            title: {
                text: 'Sales Amount and Income (Riels)'
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
                            	if (this.series.name == "Sales Amount") {
                                	setChart(drilldown.name, drilldown.categories, drilldown.data, colors[0]);
                            	} else if (this.series.name == "Income") {
                            		setChart(drilldown.name, drilldown.categories, drilldown.data, colors[1]);
                            	} else {
                            		setChart(drilldown.name, drilldown.categories, drilldown.data, colors[9]);
                            	}
                            } else { // restore
                            	restoreChart();
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
        /*
        tooltip: {
            formatter: function() {
                var point = this.point;
                
                var s = null;
                if (this.series.name == "Sales Amount") {
                    s = this.x +' sales amount:'+ toThousands(this.y) +' Riels<br>';
                } else if (this.series.name == "Income") {
                	s = this.x +' income:'+ toThousands(this.y) +' Riels<br>';
                } else {
                	//do nothing
                }
                if (point.drilldown) {
                    s += 'Click to view '+ point.category +' plans';
                } else {
                    s += 'Click to return to institutions';
                }
                return s;
            }
        },*/
        series: [{
            name: nameSales,
            data: sales,
            color: colors[0]
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
    			
    			categories = json.categories;
    			sales = json.sales;
    			incomes = json.incomes;
    			
    			restoreChart();
    		}
    	});
    }
    
	$("#startDate").change(function(){
		updateSalesData($("#startDate").val(), $("#endDate").val());
	});
	$("#endDate").change(function(){
		updateSalesData($("#startDate").val(), $("#endDate").val());
	});
	
	// trigger change when the first time the page is loaded.
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
						onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true,onpicked:triggerStartDateChange})" maxlength="40"/></span>
				<span>End Date: <input id="endDate" name="endDate" class="Wdate text-normal" 
						onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true,onpicked:triggerEndDateChange})" maxlength="40"/></span>
			</div>
		</form>
	</div>
	
	<div id="container">
	
	</div>

</body>
</html>
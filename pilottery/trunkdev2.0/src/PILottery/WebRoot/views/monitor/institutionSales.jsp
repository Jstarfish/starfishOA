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
<script type="text/javascript" src="${basePath}/js/mydate.js"></script>

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
    
    function updateSalesData(startDate, endDate,orgCode)
    {
		if (!isValidDate(startDate, endDate,orgCode)) {
			return;
		}
    	
		var url = "monitor.do?method=updateInstitutionSalesData&startDate="+startDate+"&endDate="+endDate+"&orgCode="+orgCode;
    	
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
    
  //add
    $('#selDate').change(function(){
		var select = $('#selDate').val();
		if(select == 0){
			$("input[name='startDate']").val(getToday());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 1){
			$("input[name='startDate']").val(getYestoday(getToday()));
			$("input[name='endDate']").val(getYestoday(getToday()));
			
		}
		if(select == 2){
			$("input[name='startDate']").val(getWeekStartDate());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 3){
			$("input[name='startDate']").val(getLastWeekStartDate());
			$("input[name='endDate']").val(getLastWeekEndDate());
		}
		if(select == 4){
			$("input[name='startDate']").val(getMonthStartDate());
			$("input[name='endDate']").val(getToday());
		}
		if(select == 5){
			$("input[name='startDate']").val(getLastMonthStartDate());
			$("input[name='endDate']").val(getLastMonthEndDate());
		}
		updateSalesData($("#startDate").val(), $("#endDate").val(),$("#orgCode").val());
	});
    
	$("#startDate").change(function(){
		updateSalesData($("#startDate").val(), $("#endDate").val(),$("#orgCode").val());
	});
	$("#endDate").change(function(){
		updateSalesData($("#startDate").val(), $("#endDate").val(),$("#orgCode").val());
	});
	$("#orgCode").change(function(){
		updateSalesData($("#startDate").val(), $("#endDate").val(),$("#orgCode").val());
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
				<span>Institution:
					<select class="select-normal" name="orgCode" id="orgCode">
            		   <option value="">--All--</option>  
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == orgCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != orgCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
				</span>
				<span>Start Date: <input id="startDate" name="startDate" class="Wdate text-normal" 
						onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true,onpicked:triggerStartDateChange})" maxlength="40"/></span>
				<span>End Date: <input id="endDate" name="endDate" class="Wdate text-normal" 
						onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,isShowToday:true,onpicked:triggerEndDateChange})" maxlength="40"/></span>
				<span>
	              <select name="selDate" id="selDate" class="select-normal" style="width:180px" >
						<option value="0">--Please Select--</option>
						<option	value="1">Yesterday</option>
						<option	value="2" >This Week</option>
						<option	value="3">Last Week</option>
						<option	value="4">This Month</option>
						<option	value="5">Last Month</option>
					</select>
				</span>		
			</div>
		</form>
	</div>
	
	<div id="container">
	
	</div>

</body>
</html>
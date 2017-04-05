<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>Institution Sales Statistics</title>

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
	nameSales = 'Institutions Amount',
	nameIncomes='Income',
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
            text: 'Sales Statistics'
        },
        subtitle: {
            text: 'Click the columns to view day. Click again to view month.'
        },
        xAxis: {
            categories: categories,
            labels: {
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
                            	if (this.series.name == "Institutions Amount") {
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
       /*  tooltip: {
            formatter: function() {
                var point = this.point,
                s = this.x +' sales amount:'+ toThousands(this.y) +' Riels<br>';
                if (point.drilldown) {
                } else {
                    s += 'Click to return to month';
                }
                return s;
            }
        }, 
        series: [{
            name: nameSales,
            data: sales,
            color: colors[0]
        }],*/
        exporting: {
            enabled: false
        }
    })
    .highcharts(); // return chart
    
    function updateView(param){
    	$.ajax({
    	    url: "monitor.do?method=salesResponse"+param,
    		type: 'get',
    	    dataType: 'json',
    	    async: true,
    	    success: function(json){
    	   		for(var i=0;i<json.monthAmount.length;i++){
    	   			json.monthAmount[i]["color"] = colors[0];
    	   			json.monthAmount[i]["drilldown"] = {};
    	   			json.monthAmount[i]["drilldown"]["name"]=json.monthName[i];
    	   			json.monthAmount[i]["drilldown"]["categories"]=json.dayName[i];
    	   			json.monthAmount[i]["drilldown"]["data"]=json.dayAmount[i];
    	   			json.monthAmount[i]["drilldown"]["color"]=colors[0];
    	   		} 
    	   		for(var i=0;i<json.monthAmountIn.length;i++){
    	   			json.monthAmountIn[i]["color"] = colors[1];
    	   			json.monthAmountIn[i]["drilldown"] = {};
    	   			json.monthAmountIn[i]["drilldown"]["name"]=json.monthNameIn[i];
    	   			json.monthAmountIn[i]["drilldown"]["categories"]=json.dayName[i];
    	   			json.monthAmountIn[i]["drilldown"]["data"]=json.dayAmountIn[i];
    	   			json.monthAmountIn[i]["drilldown"]["color"]=colors[1];
    	   		} 
    	   			categories = json.monthName;
    	   			sales = json.monthAmount;
        			incomes = json.monthAmountIn;
        			restoreChart();
    	    } 
    	});
    	
    }
	
    $("#timeScale").ready(function(){
    	var param = "&queryYear="+$("#timeScale").val()+"&orgCode="+$("#orgCode").val();
    	updateView(param);
    });
   
});

</script>

</head>
<body>
	<div id="title">Sales Statistics</div>
	
	<div class="queryDiv">
		<form action="" method="POST" id="institutionSalesQueryForm">
			<div class="left">
				<span>Time Scale:</span>
				<span>
				 <input name="timeScale" id="timeScale"  value="${year}" class="Wdate text-normal"
					onfocus="WdatePicker({lang:'en',dateFmt:'yyyy',readOnly:true})" />
				</span>
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
				<input type="submit" value="Query" class="button-normal"></input>
			</div>
		</form>
	</div>
	
	<div id="container">
	
	</div>

</body>
</html>
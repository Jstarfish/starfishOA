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
	nameSales = '总销售额',
	nameIncomes='收入',
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
            text: '销售记录'
        },
        subtitle: {
            text: '点击一列查看天，再点击一次返回月份.'
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
                text: '销售金额和收入(瑞尔)'
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
                        return toThousands(this.y) +' 瑞尔';
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
    	   			json.monthAmountIn[i]["drilldown"]["color"]=colors[i];
    	   		} 
    	   			categories = json.monthName;
    	   			sales = json.monthAmount;
        			incomes = json.monthAmountIn;
        			restoreChart();
    	    } 
    	});
    	
    }
	
    $("#timeScale").ready(function(){
    	var param = "&queryYear="+$("#timeScale").val()+"&orgCode="+$("#orgCode").val()+"&tjType="+$("#tjType").val();
    	updateView(param);
    });
});

</script>

</head>
<body>
	<div id="title">销售记录</div>
	
	<div class="queryDiv">
		<form action="monitor.do?method=salesStatistics" method="POST" id="institutionSalesQueryForm">
			<div class="left">
				<span>年份:</span>
				<span>
				 <input name="timeScale" id="timeScale"  value="${year}" class="Wdate text-normal"
					onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy',readOnly:true})" />
				</span>
				<span>机构:
					<select class="select-normal" name="orgCode" id="orgCode">
            			<option value="">--全部--</option>
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
				<span>类型:
            		<select class="select-normal" name="tjType" id="tjType">
            			<option value="0" <c:if test="${tjType==0}">selected="selected"</c:if> >--全部--</option>
            			<option value="1" <c:if test="${tjType==1}">selected="selected"</c:if> >即开票</option>
            			<option value="2" <c:if test="${tjType==2}">selected="selected"</c:if> >电脑票</option>
            		</select>
            	</span>
				<input type="submit" value="查询" class="button-normal"></input>
			</div>
		</form>
	</div>
	
	<div id="container">
	
	</div>

</body>
</html>
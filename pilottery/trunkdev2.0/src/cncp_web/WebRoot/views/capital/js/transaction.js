$(function () {
	initTable();
	initDate();
	
	$(window).resize(function(){
		$('#transactions-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#transactions-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "capital.do?method=queryFundTransaction&random="+Math.random();
	$('#transactions-table').bootstrapTable({
		method:'POST',
		dataType:'json',
		contentType: "application/x-www-form-urlencoded",
		cache: false,
		striped: true,                      //是否显示行间隔色
		sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
		url:url,
		height: $(window).height() - 85,
		width:$(window).width(),
		showColumns:true,
		pagination:true,
		queryParams : queryParams,
		minimumCountColumns:2,
		pageNumber:1,                       //初始化加载第一页，默认第一页
        pageSize: 20,                       //每页的记录行数（*）
        pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
        uniqueId: "id",                     //每一行的唯一标识，一般为主键列
		showExport: true,                    
        exportDataType: 'all',
        exportOptions:{
        	fileName: 'Transaction'
        },
        responseHandler: responseHandler,
		columns: [
 		{
 			field:'dealerFundFlow',
            title: 'Fund No.',
            align : 'center',
			valign : 'middle',
			sortable:true
		}, {
			field : 'dealerCode',
			title : 'Dealer Code',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'dealerName',
			title : 'Dealer Name',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'flowType',
			title : 'Type',
			align : 'center',
			valign : 'middle',
			formatter:function(value,row,index){
				if(value == 1){
					return "Top Up";
				}else if(value == 2){
					return "Withdraw";
				}else if(value == 3){
					return "Adjustment";
				}else if(value == 4){
					return "Sale";
				}else if(value == 5){
					return "Sales commission";
				}else if(value == 6){
					return "Payout";
				}else {
					return "Refund";
				}
			}
		},{
			field : 'changeAmount',
			title : 'Transaction amount',
			align : 'right',
			halign :'center',
			valign : 'middle',
			sortable : true,
			formatter : function (value, row, index){
				return toThousand(value);
			}
		},{
			field : 'tradeTime',
			title : 'Date',
			align : 'center',
			valign : 'middle',
			sortable : true
		},   ]
	});
}

function initDate(){
	var start = {
            elem: '#startDate',
            format: 'YYYY-MM-DD',
            max: laydate.now(),
            istime: true,
            istoday: false,
            choose: function (datas) {
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            elem: '#endDate',
            format: 'YYYY-MM-DD',
            max: laydate.now(),
            istime: true, //是否开启时间选择
            isclear: true, //是否显示清空
            istoday: true, //是否显示今天
            issure: true, //是否显示确认
            choose: function (datas) {
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        laydate(start);
        laydate(end);
}

function queryParams(params) {
	var param = {
		dealerFundFlow:$("#dealerFundFlow").val(),
		dealerCode : $("#dealerCode").val(),
		flowType : $("#flowType").val(),
		startDate : $("#startDate").val(),
		endDate : $("#endDate").val(),
		limit : this.limit, // 页面大小
		offset : this.offset, // 页码
		pageindex : this.pageNumber,
		pageSize : this.pageSize,
		sortName : this.sortName, 
		sortOrder : this.sortOrder
	}
	return param;
} 

function responseHandler(res) {
	if (res) {
		return {
			"rows" : res.result,
			"total" : res.totalCount
		};
	} else {
		return {
			"rows" : [],
			"total" : 0
		};
	}
}
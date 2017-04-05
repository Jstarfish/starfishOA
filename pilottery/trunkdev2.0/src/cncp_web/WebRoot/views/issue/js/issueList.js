$(function () {
	initTable();
	initDate();
	
	$(window).resize(function(){
		$('#issueList-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#issueList-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "issue.do?method=issueList&random="+Math.random();
	$('#issueList-table').bootstrapTable({
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
        	fileName: 'Issue Info'
        },
        responseHandler: responseHandler,
		columns: [
		{
			field : 'gameName',
			title : 'Game',
			align : 'center',
			valign : 'middle',
		}, {
			field : 'issueNumber',
			title : 'Issue',
			align : 'center',
			valign : 'middle',
		},  {
			field : 'startSaleTime',
			title : 'Start Time',
			align : 'center',
			valign : 'middle'
		},{
			field : 'endSaleTime',
			title : 'Close Time',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'rewardTime',
			title : 'Reward Time',
			align : 'center',
			valign : 'middle'
		},{
			field : 'issueStatus',
			title : 'Issue Status',
			align : 'center',
			valign : 'middle',
			formatter:function(value,row,index){
				if(value == 0){
					return "PreSale";
				}else if(value == 1){
					return "Opened";
				}else if(value == 2){
					return "Paused";
				}else if(value == 3){
					return "Closed";
				}else if(value == 4){
					return "Draw";
				}else{
					return "Completed";
				}
			}	
		},{
			field : 'drawCode',
			title : 'Draw Numbers',
			halign :'center',
			align : 'right',
			valign : 'middle',
		},{
			field : 'saleAmount',
			title : 'Sales Amount',
			halign :'center',
			align : 'right',
			valign : 'middle',
			formatter : function (value, row, index){
				return toThousand(value);
			}
		}, {
			field : 'saleComm',
			title : 'Sales Comm',
			halign :'center',
			align : 'right',
			valign : 'middle',
			formatter : function (value, row, index){
				return toThousand(value);
			}
		}, {
			field : 'winningAmount',
			title : 'Winning Amount',
			halign :'center',
			align : 'right',
			valign : 'middle',
			formatter : function (value, row, index){
				return toThousand(value);
			}
		}, {
			field : 'paidAmount',
			title : 'Paid Amount',
			halign :'center',
			align : 'right',
			valign : 'middle',
			formatter : function (value, row, index){
				return toThousand(value);
			}
		}]
	});
}

function initDate(){
	var start = {
            elem: '#startSaleTime',
            format: 'YYYY-MM-DD',
            //max: laydate.now(),
            istime: true,
            istoday: false,
        };
        laydate(start);
}


function queryParams(params) {
	var param = {
		issueNumber : $("#issueNumber").val(),
		gameCode : $("#gameCode").val(),
		issueStatus : $("#issueStatus").val(),
		startSaleTime:$("#startSaleTime").val(),
		limit : this.limit, // 页面大小
		offset : this.offset, // 页码
		pageindex : this.pageNumber,
		pageSize : this.pageSize
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

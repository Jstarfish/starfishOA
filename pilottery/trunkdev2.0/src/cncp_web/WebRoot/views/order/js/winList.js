$(function () {
	initTable();
	initDate();
	
	$(window).resize(function(){
		$('#winList-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#winList-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "win.do?method=winList&random="+Math.random();
	$('#winList-table').bootstrapTable({
		method:'POST',
		dataType:'json',
		contentType: "application/x-www-form-urlencoded",
		cache: false,
		striped: true,                      //是否显示行间隔色
		sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
		url:url,
		height: $(window).height() - 130,
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
        	fileName: 'Win Info'
        },
        responseHandler: responseHandler,
		columns: [
 		{
			field : 'saleFlow',
			title : 'No.',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'gameName',
			title : 'Game',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'issueNumber',
			title : 'Issue',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'orderAmount',
			title : 'Order Amount',
			align : 'right',
			halign :'center',
			valign : 'middle',
			sortable : true,
			formatter : function (value, row, index){
				return toThousand(value);
			}
		}, {
			field : 'orderTime',
			title : 'Order Date',
			align : 'center',
			valign : 'middle',
			sortable : true
		},  {
			field : 'rewardAmount',
			title : 'Reward Amount',
			align : 'right',
			valign : 'middle',
			sortable : true,
			formatter : function (value, row, index){
				return toThousand(value);
			}
		},{
			field : 'isPaid',
			title : 'Status',
			align : 'center',
			valign : 'middle',
			formatter:function(value,row,index){
				if(value == 0){
					return "Not Payout";
				}else {
					return "Payout";
				}
			}
		}, {
			field : 'operate',
			title : 'Operation',
			align : 'center',
			events : operateEvents,
			formatter : operateFormatter
		} ]
	});
}

function operateFormatter(value, row, index) {
    return [
		'<a class="detail" href="javascript:void(0)" title="详情">',
		'<i class="glyphicon glyphicon glyphicon-file">&nbsp;</i>',
		'</a>  ',
		'<a class="print" href="javascript:void(0)" title="打印">',
		'<i class="glyphicon glyphicon-print">&nbsp;</i>',
		'</a>  '
    ].join('');
}
window.operateEvents = {
    'click .detail': function (e, value, row, index) {
		  layer.open({
		    		  type: 2,
		    		  title: 'Winning Info',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'win.do?method=winDetail&saleFlow='+row.saleFlow,
		    		  end : doQuery
				  });
    },
    'click .print': function (e, value, row, index) {
		  var a = layer.open({
		    		  type: 2,
		    		  title: 'Winning Info',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['1220px' , '720px'],
		    		  content: 'win.do?method=winPrint&saleFlow='+row.saleFlow,
		    		  end : doQuery
				  });
		  layer.full(a);
  }
};

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
		saleFlow : $("#saleFlow").val(),
		issueNumber : $("#issueNumber").val(),
		dealerCode : $("#dealerCode").val(),
		gameCode : $("#gameCode").val(),
		isPaid : $("#isPaid").val(),
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
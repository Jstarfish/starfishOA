$(function () {
	initTable();
	initDate();
	
	$(window).resize(function(){
		$('#order-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#order-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "order.do?method=dealerOrderList&random="+Math.random();
	$('#order-table').bootstrapTable({
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
        	fileName: '订单信息'
        },
        responseHandler: responseHandler,
		columns: [
 		{
			field : 'saleFlow',
			title : '流水号',
			align : 'center',
			valign : 'middle',
			sortable : true,
			order:'desc'    //默认排序方式
		}, {
			field : 'gameName',
			title : '游戏名称',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'issueNumber',
			title : '购买期次',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'orderAmount',
			title : '订单总额',
			align : 'right',
			halign :'center',
			valign : 'middle',
			sortable : true,
			formatter : function (value, row, index){
				return toThousand(value);
			}
		}, {
			field : 'orderTime',
			title : '订单时间',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'orderStatus',
			title : '订单状态',
			align : 'center',
			valign : 'middle',
			formatter:function(value,row,index){
				if(value == 1){
					return "已受理";
				}else if(value == 2){
					return "出票成功";
				}else {
					return "出票失败";
				}
			}
		}, {
			field : 'operate',
			title : '操作',
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
		    		  title: '订单详情',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'order.do?method=orderDetail&saleFlow='+row.saleFlow,
		    		  end : doQuery
				  });
    },
    'click .print': function (e, value, row, index) {
		 var a = layer.open({
		    		  type: 2,
		    		  title: '订单打印',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['1200px' , '720px'],
		    		  content: 'order.do?method=orderPrint&saleFlow='+row.saleFlow,
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
		orderStatus : $("#orderStatus").val(),
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

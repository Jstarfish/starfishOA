$(function () {
	initTable();
	initDate();
	
	$(window).resize(function(){
		$('#topuprecords-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#topuprecords-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "capital.do?method=topupList&random="+Math.random();
	$('#topuprecords-table').bootstrapTable({
		method:'POST',
		dataType:'json',
		contentType: "application/x-www-form-urlencoded",
		cache: false,
		striped: true,                      //是否显示行间隔色
		sidePagination: "client",           //分页方式：client客户端分页，server服务端分页（*）
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
        	fileName: '充值信息'
        },
		columns: [
 		{
 			field:'tradeFlow',
            title: '交易流水',
            align : 'center',
			valign : 'middle',
			sortable:true
		}, {
			field : 'accNo',
			title : '用户账号',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'amount',
			title : '交易金额',
			align : 'center',
			valign : 'middle',
			formatter : function (value, row, index){
				return toThousand(value);
			}
		}, {
			field : 'fee',
			title : '手续费 ',
			align : 'right',
			halign :'center',
			valign : 'middle',
			sortable : true,
			formatter : function (value, row, index){
				return toThousand(value);
			}
		},{
			field : 'totalAmount',
			title : '总金额',
			align : 'center',
			valign : 'middle',
			formatter : function (value, row, index){
				return toThousand(value);
			}
		},{
			field : 'currency',
			title : '币种',
			align : 'center',
			valign : 'middle',
			formatter : function (value, row, index){
				if(value == 1){
					return "瑞尔";
				}else if(value == 2){
					return "美元";
			}}
		},{
			field : 'tradeId',
			title : 'Wing交易ID ',
			align : 'center',
			valign : 'middle'
		},{
			field : 'tradeStatus',
			title : '交易状态',
			align : 'center',
			valign : 'middle',
			formatter : function (value, row, index){
				if(value == 1){
					return "收到请求";
				}else if(value == 2){
					return "登录";
				}else if(value == 3){
						return "校验";
				}else if(value == 4){
						return "提交";
				}else if(value == 5){
						return "失败";
				}else if(value == 6){
						return "超时";
				}}
		},{
			field : 'startTime',
			title : '交易发起时间',
			align : 'center',
			valign : 'middle'
		},{
			field : 'endTime',
			title : '交易结束时间',
			align : 'center',
			valign : 'middle'
		},{
			field : 'operate',
			title : '操作',
			align : 'center',
			events : operateEvents,
			formatter : operateFormatter
		}]
	});
}

function operateFormatter(value, row, index) {
    return [
		'<a class="detail" href="javascript:void(0)" title="详情">'+
		   '<i class="glyphicon glyphicon-file">&nbsp;</i>'+
		   '</a>  '
    ].join('');
}

window.operateEvents = {
		'click .detail': function (e, value, row, index) {
			  layer.open({
			    		  type: 2,
			    		  title: '充值详情',
			    		  maxmin: true,
			    		  shadeClose: true, //点击遮罩关闭层
			    		  area : ['800px' , '520px'],
			    		  content: 'capital.do?method=topUpDetail&tradeFlow='+row.tradeFlow,
			    		  end : doQuery
					  });
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
			accNo : $("#accNo").val(),
		tradeFlow : $("#tradeFlow").val(),
		tradeStatus : $("#tradeStatus").val(),
		startDate : $("#startDate").val(),
		endDate : $("#endDate").val(),
		limit : this.limit, // 页面大小
		offset : this.offset, // 页码
		pageindex : this.pageNumber,
		pageSize : this.pageSize
	}
	return param;
} 



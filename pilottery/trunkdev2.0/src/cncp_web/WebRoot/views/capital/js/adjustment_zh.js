$(function () {
	
	initTable();
	initDate();
	$(window).resize(function(){
		$('#adjustmentRecords-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#adjustmentRecords-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "adjustment.do?method=adjustmentList&random="+Math.random();
	$('#adjustmentRecords-table').bootstrapTable({
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
        	fileName: '调账信息'
        },
		columns: [
 		{
 			field:'fundNo',
            title: '流水号',
            align : 'center',
			valign : 'middle',
			sortable:true
		}, {
			field : 'dealerCode',
			title : '渠道编码',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'dealerName',
			title : '渠道名称',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'operAmount',
			title : '调账金额',
			align : 'right',
			halign :'center',
			valign : 'middle',
			sortable : true,
			formatter : function (value, row, index){
				return toThousand(value);
			}
		},{
			field : 'beforeAccountBalance',
			title : '调账前金额',
			align : 'right',
			halign :'center',
			valign : 'middle',
			sortable : true,
			formatter : function (value, row, index){
				return toThousand(value);
			}
		},{
			field : 'afterAccountBalance',
			title : '调账后金额',
			align : 'right',
			halign :'center',
			valign : 'middle',
			sortable : true,
			formatter : function (value, row, index){
				return toThousand(value);
			}
		},{
			field : 'operAdminName',
			title : '操作人',
			align : 'center',
			valign : 'middle'
		},{
			field : 'remark',
			title : '备注',
			align : 'center',
			valign : 'middle',
		},{
			field : 'operate',
			title : '操作',
			align : 'center',
			events : operateEvents,
			formatter : operateFormatter
		}   ]
	});
}

function operateFormatter(value, row, index) {
    return [
		'<a class="print" href="javascript:void(0)" title="打印">',
		'<i class="glyphicon glyphicon-print">&nbsp;</i>',
		'</a>  '
    ].join('');
}

window.operateEvents = {
	    'click .print': function (e, value, row, index) {
			  layer.open({
			    		  type: 2,
			    		  title: '调账凭证打印',
			    		  maxmin: true,
			    		  shadeClose: true, //点击遮罩关闭层
			    		  area : ['1200px' , '720px'],
			    		  content: 'adjustment.do?method=printCertificate&fundNo='+row.fundNo,
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
		dealerCode : $("#dealerCode").val(),
		startDate : $("#startDate").val(),
		endDate : $("#endDate").val(),
		limit : this.limit, // 页面大小
		offset : this.offset, // 页码
		pageindex : this.pageNumber,
		pageSize : this.pageSize
	}
	return param;
} 


function toAdjustment(){
	layer.open({
		  type: 2,
		  title: '调账',
		  maxmin: true,
		  shadeClose: true, //点击遮罩关闭层
		  area : ['800px' , '520px'],
		  content: 'adjustment.do?method=initAdjustment',
		  end : doQuery
	  });
}


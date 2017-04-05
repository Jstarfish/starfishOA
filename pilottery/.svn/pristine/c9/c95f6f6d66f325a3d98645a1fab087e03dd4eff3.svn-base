$(function () {
	initTable();
	
	$(window).resize(function(){
		$('#accountList-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#accountList-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "capital.do?method=listAccount&random="+Math.random();
	$('#accountList-table').bootstrapTable({
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
		minimumCountColumns:2,
		pageNumber:1,                       //初始化加载第一页，默认第一页
        pageSize: 20,                       //每页的记录行数（*）
        pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
        uniqueId: "userId",                     //每一行的唯一标识，一般为主键列
		showExport: true,                    
        exportDataType: 'all',
        exportOptions:{
        	fileName: '充值信息'
        },
		columns: [
 		{
 			field:'userId',
            title: '企业用户编号',
            align : 'center',
			valign : 'middle',
			sortable:true
		}, {
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
		}, {
			field : 'accountType',
			title : '账户类型',
			align : 'center',
			valign : 'middle',
			formatter : function (value, row, index){
				if(value == 1){
					return "Wing";
				}else if(value == 2){
					return "---";
			}}
		}, {
			field : 'accountStatus',
			title : '账户状态',
			align : 'right',
			halign :'center',
			valign : 'middle',
			formatter : function (value, row, index){
				if(value == 1){
					return "可用";
				}else if(value == 2){
					return "停用";
				}else if(value == 3){
						return "删除";
				}}
			
		},{
			field : 'accountNo',
			title : '账户编码',
			align : 'center',
			valign : 'middle',
			sortable : true
		},{
			field : 'billCode',
			title : '账户银行编号',
			align : 'center',
			valign : 'middle',
		},{
			field : 'userName',
			title : '账户银行用户名',
			align : 'center',
			valign : 'middle',
		},{
			field : 'password',
			title : '账户银行密码',
			align : 'center',
			valign : 'middle',
		},{
			field : 'accountBalance',
			title : '余额',
			align : 'center',
			valign : 'middle',
			formatter : function (value, row, index){
				return toThousand(value);
			}
		},{
			field : 'updateTime',
			title : '最近更新日期',
			align : 'center',
			valign : 'middle',
		}]
	});
}

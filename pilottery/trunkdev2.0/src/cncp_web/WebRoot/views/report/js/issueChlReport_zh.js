$(function () {
    initTable();
    $(window).resize(function () {
        $('#issueChl').bootstrapTable('refresh');
    });
});

function doQuery(params) {
    $('#issueChl').bootstrapTable('refresh');
}

function initTable() {
    var url = "report.do?method=issueChlReport&random=" + Math.random();
    $('#issueChl').bootstrapTable({
        method: 'post',
        dataType: 'json',
        contentType: "application/x-www-form-urlencoded",
        cache: false,
        striped: true,
        search: false,                 //是否显示行间隔色
        sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
        url: url,
        height: $(window).height() - 85,
        width: $(window).width(),
        showColumns: true,
        pagination: true,
        sortable:true,
        silentSort:false,
        queryParams: queryParams,
        minimumCountColumns: 2,
        pageNumber: 1,                       //初始化加载第一页，默认第一页
        pageSize: 20,                       //每页的记录行数（*）
        pageList: [10, 25, 50, 100,500,'All'],        //可供选择的每页的行数（*）
        uniqueId: "issueCode",                     //每一行的唯一标识，一般为主键列
        showExport: true,
        exportDataType: 'all',
        exportOptions: {
            fileName: '渠道商期次报表'
        },
        responseHandler: responseHandler,
        columns: [
			{
			    field: 'gameName',
			    title: '游戏',
			    align: 'center',
			    sortable: true
			},      
            {
                field: 'issueCode',
                title: '期次',
                align: 'center',
                sortable: true
            }, {
                field: 'dealerName',
                title: '渠道商名称',
                align: 'center'
            }, {
                field: 'orderCount',
                title: '订单数',
                align: 'center',
                sortable: true
            }, {
                field: 'saleAmount',
                title: '销售金额',
                halign :'center',
                align: 'right',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'bingoCount',
                title: '中奖订单数',
                align: 'center',
                sortable: true
            }, {
                field: 'bingoAmount',
                title: '中奖金额',
                halign :'center',
                align: 'right',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'rwardCount',
                title: '派奖订单数',
                align: 'center',
                sortable: true
            }, {
                field: 'rwardAmount',
                title: '派奖金额',
                align: 'right',
                halign :'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }]
    });
}

function queryParams(params) {
    var param = {
    	gameCode:$("#gameCode").val(),	
        reportIssue: $("#issueCode").val(),
        dealerCode: $("#dealerCode").val(),
        limit: this.limit, // 页面大小
        offset: this.offset, // 页码
        pageindex: this.pageNumber,
        pageSize: this.pageSize,
        sortName: this.sortName,
        sortOrder: this.sortOrder
    }
    if(param.pageSize == 'All'){
        param.pageSize = -1;
    }
    return param;
}


function responseHandler(res) {
    if (res) {
        return {
            "rows": res.result,
            "total": res.totalCount
        };
    } else {
        return {
            "rows": [],
            "total": 0
        };
    }
}
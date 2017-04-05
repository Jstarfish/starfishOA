$(function () {
    initTable();
    $(window).resize(function () {
        $('#issueSys').bootstrapTable('refresh');
    });
});

function doQuery(params) {
    $('#issueSys').bootstrapTable('refresh');
}

function initTable() {
    var url = "report.do?method=issueSysReport&random=" + Math.random();
    $('#issueSys').bootstrapTable({
        method: 'post',
        dataType: 'json',
        contentType: "application/x-www-form-urlencoded",
        cache: false,
        striped: true,
        search: false,
        sidePagination: "server",
        url: url,
        height: $(window).height() - 85,
        width: $(window).width(),
        showColumns: true,
        pagination: true,
        sortable: true,
        silentSort: false,
        queryParams: queryParams,
        minimumCountColumns: 2,
        pageNumber: 1,
        pageSize: 20,                       //每页的记录行数（*）
        pageList: [10, 25, 50, 100, 500, 'All'],        //可供选择的每页的行数（*）
        uniqueId: "issueCode",
        showExport: true,
        exportDataType: 'all',
        exportOptions: {
            fileName: '系统期次报表'
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
                field: 'issueSaleBegin',
                title: '销售开始时间',
                align: 'center',
                sortable: true
            }, {
                field: 'issueSaleEnd',
                title: '销售结束时间',
                align: 'center',
                sortable: true
            }, {
                field: 'issueStatus',
                title: '期次状态',
                align: 'center',
                formatter: function (value, row, index) {
                	if(value == 0){
    					return "预售";
    				}else if(value == 1){
    					return "开启";
    				}else if(value == 2){
    					return "暂停";
    				}else if(value == 3){
    					return "关闭";
    				}else if(value == 4){
    					return "开奖完成";
    				}else{
    					return "期结";
    				}
                }
            }, {
                field: 'awardNumber',
                title: '中奖号码',
                align: 'center'
            }, {
                field: 'rewardTime',
                title: '派奖时间',
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
                field: 'bingoAmount',
                title: '中奖金额',
                align: 'right',
                halign :'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'rwardAmount',
                title: '派奖金额',
                halign :'center',
                align: 'right',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }]
    });
}

function queryParams(params) {
    var param = {
    	gameCode: $("#gameCode").val(),	
        reportIssue: $("#issueCode").val(),
        limit: this.limit, // 页面大小
        offset: this.offset, // 页码
        pageindex: this.pageNumber,
        pageSize: this.pageSize,
        sortName: this.sortName,
        sortOrder: this.sortOrder
    }
    if (param.pageSize == 'All') {
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
$(function () {
    initDate();
    initTable();
    $(window).resize(function () {
        $('#dayReoprt').bootstrapTable('refresh');
    });
});

function doQuery(params) {
    $('#dayReoprt').bootstrapTable('refresh');
}

function initTable() {
    var url = "report.do?method=dayReport&random=" + Math.random();
    $('#dayReoprt').bootstrapTable({
        method: 'POST',
        dataType: 'json',
        contentType: "application/x-www-form-urlencoded",
        cache: false,
        striped: true,                      //是否显示行间隔色
        sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
        url: url,
        height: $(window).height() - 85,
        width: $(window).width(),
        showColumns: true,
        pagination: true,
        silentSort: false,
        sortable: true,
        queryParams: queryParams,
        minimumCountColumns: 2,
        pageNumber: 1,                       //初始化加载第一页，默认第一页
        pageSize: 20,                       //每页的记录行数（*）
        pageList: [10, 25, 50, 100, 500, 'All'],        //可供选择的每页的行数（*）
        uniqueId: "reportDate",                     //每一行的唯一标识，一般为主键列
        responseHandler: responseHandler,
        showExport: true,
        exportDataType: 'all',
        exportOptions: {
            fileName: '日结统计报表'
        },
        columns: [
            {
                field: 'reportDate',
                title: '日期',
                align: 'center',
                valign: 'middle',
                sortable: true
            }, {
                field: 'dealerName',
                title: '渠道商',
                align: 'center',
                valign: 'middle'
            }, {
                field: 'beginAmount',
                title: '期初余额',
                align: 'right',
                halign :'center',
                valign: 'middle',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'chargeAmount',
                title: '充值',
                align: 'right',
                halign :'center',
                valign: 'middle',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'withdrawAmount',
                title: '提现',
                align: 'right',
                halign :'center',
                valign: 'middle',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'saleAmount',
                title: '销售',
                align: 'right',
                halign :'center',
                valign: 'middle',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'saleCommAmount',
                title: '销售佣金',
                align: 'right',
                halign :'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'refundAmount',
                title: '退款',
                align: 'right',
                halign :'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'paidAmount',
                title: '返奖',
                align: 'right',
                halign :'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'otherTickets',
                title: '其他/调账',
                align: 'right',
                halign :'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'endAmount',
                title: '期末余额',
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
        dealerCode: $("#dealerCode").val(),
        startDate: $("#startDate").val(),
        endDate: $("#endDate").val(),
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


function initDate() {
    var start = {
        elem: '#startDate',
        format: 'YYYY-MM-DD',
        max: laydate.now(),
        istime: true,
        istoday: true,
        choose: function (datas) {
            end.min = datas; //开始日选好后，重置结束日的最小日期
            end.start = datas; //将结束日的初始值设定为开始日
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
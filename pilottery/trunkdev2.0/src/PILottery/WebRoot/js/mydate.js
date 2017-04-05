/*document.write("<script language='javascript' src='./js/mydate.js'></script>");*/
/**   
* 获取昨天、本周、本月、上月的开端日期、停止日期   
*/
var now = new Date(); //当前日期   
var nowDayOfWeek = now.getDay(); //今天本周的第几天   
var nowDay = now.getDate(); //当前日   
var nowMonth = now.getMonth(); //当前月    
var nowYear = now.getYear(); //当前年   
nowYear += (nowYear < 2000) ? 1900 : 0; //  
var lastMonthDate = new Date(); //上月日期   
lastMonthDate.setDate(1);
lastMonthDate.setMonth(lastMonthDate.getMonth() - 1);
var lastYear = lastMonthDate.getYear();
var lastMonth = lastMonthDate.getMonth();

//格局化日期：yyyy-MM-dd   
function formatDate(date) {
    var myyear = date.getFullYear();
    var mymonth = date.getMonth() + 1;
    var myweekday = date.getDate();

    if (mymonth < 10) {
        mymonth = "0" + mymonth;
    }
    if (myweekday < 10) {
        myweekday = "0" + myweekday;
    }
    return (myyear + "-" + mymonth + "-" + myweekday);
}

//获取当前日期
function getToday(){
	var nowDate = new Date();
	return formatDate(nowDate);
}

//获取昨天日期
function getYestoday(){ 
	var nowDate = new Date();
    var yesterday_milliseconds=nowDate.getTime()-1000*60*60*24;        
    var yesterday = new Date();        
    yesterday.setTime(yesterday_milliseconds); 
    return formatDate(yesterday);
  } 


//获得本周的开端日期   
function getWeekStartDate() {
    var weekStartDate = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek);
    return formatDate(weekStartDate);
}

//获得本周的停止日期   
function getWeekEndDate() {
    var weekEndDate = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek));
    return formatDate(weekEndDate);
}

//获取上周的开始时间
function getLastWeekStartDate(){
	var lastWeekStart = new Date(nowYear,nowMonth,nowDay -nowDayOfWeek -7 );
	return formatDate(lastWeekStart);
}

//获取上周的结束时间
function getLastWeekEndDate(){
	var lastWeekEndDate = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek - 7));
	return formatDate(lastWeekEndDate);
}
//获得某月的天数   
function getMonthDays(myMonth) {
    var monthStartDate = new Date(nowYear, myMonth, 1);
    var monthEndDate = new Date(nowYear, myMonth + 1, 1);
    var days = (monthEndDate - monthStartDate) / (1000 * 60 * 60 * 24);
    return days;
}

//获得本月的开端日期   
function getMonthStartDate() {
    var monthStartDate = new Date(nowYear, nowMonth, 1);
    return formatDate(monthStartDate);
}

//获得本月的停止日期   
function getMonthEndDate() {
    var monthEndDate = new Date(nowYear, nowMonth, getMonthDays(nowMonth));
    return formatDate(monthEndDate);
}

//获得上月开端时候   
function getLastMonthStartDate() {
    var lastMonthStartDate = new Date(nowYear, lastMonth, 1);
    return formatDate(lastMonthStartDate);
}

//获得上月停止时候   
function getLastMonthEndDate() {
    var lastMonthEndDate = new Date(nowYear, lastMonth, getMonthDays(lastMonth));
    return formatDate(lastMonthEndDate);
}
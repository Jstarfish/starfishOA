package cls.pilottery.webncp.common.constants;

import java.util.HashMap;
import java.util.Map;

public class WebncpErrorMessage {

	public static final Map<Integer, String> errorMap = new HashMap<Integer, String>();
	
	public static final int SUCCESS = 5000;
	/*没有定义指令码*/
    public static final int ERR_NOCOMMAND = 1;
    /*参数格式错误*/
    public static final int ERR_PARAM_FOMAT = 2;
    /*纪录不存在*/
    public static final int ERR_RECORD_NOTEXSIT = 500101;
    /*服务功能函数执行异常*/
    public static final int ERR_EXCEPTION = 500102;
    /*过程表中没有升级记录(no record in proc table)*/
    public static final int ERR_PROC_RECORD_NOTEXSIT = 500103;
    /*时间未到，不需要执行任何操作(nothing to do just waiting)*/
    public static final int ERR_NOT_CORRECT_TIME = 500104;
    /*日期格式错误*/
    public static final int ERR_DATE_TYPE_ERROR = 500105;
    /*销售站编码错误*/
    public static final int AGENCY_CODE_ERROR = 500106;
    /*不是今天期次*/
    public static final int IS_NOT_TODAY_ISSUE_NUM = 500107;
    /*期次参数有误或长度不够*/
    public static final int ERROR_ISSUE_NUM = 500108;
    /*期次存在，结果数据不存在*/
    public static final int ERR_ISSUE_EXIST_RESULT_NOTEXSIT = 500109;
    /*期次不存在*/
    public static final int ERR_ISSUE_NOTEXSIT = 500110;
    
    /*新增计划指定的新版本和终端机目前版本一致*/
    public static final int ERR_SAME_VERSION = 500109;

	static{
		errorMap.put(5000, "Success");
		errorMap.put(1, "Failure");
		errorMap.put(2, "Parameter format error");
		errorMap.put(500101, "No data exist");
		errorMap.put(500102, "Query exception occurs");
		errorMap.put(500103, "No record in proc table");
		errorMap.put(500104, "Nothing to do just waiting");
		errorMap.put(500105, "Date formate error");
		errorMap.put(500106, "Outlet code error");
		errorMap.put(500107, "Issue not today");
		errorMap.put(500108, "Issue number error");
		errorMap.put(500109, "Issue exist, but no data exist for this issue");
		errorMap.put(500110, "The issue does not exist");
		
		errorMap.put(800101,"缴款专员不存在");
		errorMap.put(800102,"登陆密码不正确");
		errorMap.put(800103,"未授权站点登陆");
		errorMap.put(800104,"站点不存在");
		errorMap.put(800105,"站点已清退");
		errorMap.put(800106,"超出限额");
		errorMap.put(800107,"超出信用额度");
		errorMap.put(800110,"缴款专员已禁用或删除");
		errorMap.put(800111,"非关联销售站");
		errorMap.put(800201,"缴款专员不存在");
		errorMap.put(800202,"交易密码不正确");
		errorMap.put(800203,"未授权站点登陆");
		errorMap.put(800204,"站点不存在");
		errorMap.put(800205,"站点已清退");
		errorMap.put(800206,"超出限额");
		errorMap.put(800207,"超出信用额度");
		errorMap.put(800208,"校验码不正确");
		errorMap.put(800209,"校验码超时");
		errorMap.put(800210,"缴款专员已禁用或删除");
		errorMap.put(800211,"非关联销售站");
	}


	public static String getMsg(Integer errorCode) {
		return errorMap.get(errorCode);
	}
	
}

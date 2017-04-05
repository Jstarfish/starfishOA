package cls.pilottery.oms.common.utils;

public class ResustConstant {
	public static int OMS_RESULT_SUCCESS = 0; // 系统返回成功
	public static int OMS_RESULT_FAILURE = 1; // 系统返回失败
	public static int OMS_RESULT_TICKET_NOT_FOUND_ERR = 2; // 查无此票
	public static int OMS_RESULT_TICKET_TSN_ERR = 3;// TSN错误
	public static int OMS_RESULT_BUSY_ERR = 4; // 正在处理OMS消息中
	public static int OMS_RESULT_GAME_DISABLE_ERR = 5; // 游戏不可用
	public static int OMS_RESULT_GAME_SERVICETIME_OUT_ERR = 6; // 当前不是彩票交易时段
	public static int OMS_RESULT_AGENCY_TYPE_ERR = 7; // 销售站类型错误
	public static int OMS_RESULT_PAY_DISABLE_ERR = 8; // 游戏不可兑奖
	public static int OMS_RESULT_PAY_PAYING_ERR = 9; // 彩票正在兑奖中
	public static int OMS_RESULT_PAY_NOT_DRAW_ERR = 10; // 彩票期还没有开奖
	public static int OMS_RESULT_PAY_WAIT_DRAW_ERR = 11; // 彩票期等待开奖完成
	public static int OMS_RESULT_PAY_DAYEND_ERR = 12; // 兑奖日期已截止
	public static int OMS_RESULT_PAY_TRAINING_TICKET_ERR = 13; // 销售员兑培训票
	public static int OMS_RESULT_PAY_NOT_WIN_ERR = 14; // 彩票未中奖
	public static int OMS_RESULT_PAY_MULTI_ISSUE_ERR = 15; // 多期票未完结
	public static int OMS_RESULT_PAY_PAID_ERR = 16; // 彩票已兑奖
	public static int OMS_RESULT_PAY_MONEY_LIMIT_ERR = 17; // 兑奖超出限额
	public static int OMS_RESULT_CANCEL_DISABLE_ERR = 18; // 游戏不可取消
	public static int OMS_RESULT_CANCEL_AGAIN_ERR = 19; // 彩票已退票
	public static int OMS_RESULT_CANCEL_CANCELING_ERR = 20; // 彩票退票中
	public static int OMS_RESULT_CANCEL_ISSUE_ERR = 21; // 退票期次类错误
	public static int OMS_RESULT_T_CANCEL_TRAINING_TICKET_ERR = 22; // 销售员退培训票
	public static int OMS_RESULT_CANCEL_TIME_END_ERR = 23; // 超过退票时间
	public static int OMS_RESULT_CANCEL_MONEY_LIMIT_ERR = 24; // 退票超出限额
	public static int OMS_RESULT_PAY_ERR=25;//不符合兑奖范围
	public static int OMS_TICK_CURRENTERR=41;//彩票没有当前期 
}

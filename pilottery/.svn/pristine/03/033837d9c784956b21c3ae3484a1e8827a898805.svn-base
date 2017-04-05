#ifndef GL_TYPE_DEF_H_INCLUDED
#define GL_TYPE_DEF_H_INCLUDED


//gl 通用结构定义文件


//游戏玩法定义
const int32 MAX_SUBTYPE_COUNT = 16;
//最大中奖规则记录数目
const int32 MAX_DIVISION_COUNT = 40;   //应该要比  MAX_SUBTYPE_COUNT  大
//最大奖等奖级记录数目
const int32 MAX_PRIZE_COUNT = 40;

//单行最大投注(未乘倍数)
const int32 MAX_BETS_COUNT  = 65535;

//游戏投注方式定义
const int32 MAX_BETTYPE_COUNT = 10;


//不能从0开始
typedef enum _BETTYPE
{
    BETTYPE_DS   = 1,  //单式
    BETTYPE_FS   = 2,  //复式
    BETTYPE_DT   = 3,  //胆拖
    BETTYPE_BD   = 4,  //包胆
    BETTYPE_HZ   = 5,  //和值
    BETTYPE_BC   = 6,  //包串
    BETTYPE_BH   = 7,  //包号
    BETTYPE_YXFS = 8,  //有序复式
    BETTYPE_FW = 9,    //范围(TTY)
} BETTYPE;

typedef enum _MODE
{
    MODE_JC = 1,  //紧凑模式
    MODE_FD = 2,  //分段模式
    MODE_YS = 3,  //原始模式
    MODE_JS = 4,  //计算模式
} MODE;




typedef struct _ANNOUNCE_AGENCY {
    uint64 agency_code;
	uint32 winner_count;
}ANNOUNCE_AGENCY;

typedef struct _ANNOUNCE_HIGH_PRIZE {
	uint8 prize_level;
    uint32 agency_count;
	ANNOUNCE_AGENCY agency[MAX_AGENCY_NUMBER];
}ANNOUNCE_HIGH_PRIZE;


typedef struct _ANNOUNCE_PRIZE_DATA
{
    uint8   prize_level;
    uint8   is_high_prize;
    uint32  prize_num;
    money_t prize_amount;
    money_t prize_after_tax_amount;
    money_t prize_tax_amount;
}ANNOUNCE_PRIZE_DATA;

//存储winner.local winner.confirm 信息的结构体
typedef struct _ANNOUNCE_DATA {
	uint8   game_code;
	uint64  issue_number;
	char    drawCodesStr[MAX_GAME_RESULTS_STR_LEN];
	money_t sale_total_amount;
	money_t prize_total_amount;
	money_t pool_amount;//期初金额(OM要求加)
	money_t pool_left_amount;

    uint8 prize_count; //下面 prizeArray 数组中使用的数量
    ANNOUNCE_PRIZE_DATA prizeArray[MAX_PRIZE_COUNT];

    ANNOUNCE_HIGH_PRIZE a_high_prize[MAX_PRIZE_COUNT];
} ANNOUNCE_DATA;


//期次的实际数据统计
typedef struct _ISSUE_REAL_STAT
{
    uint32  sale_tickets_count; //本期实际销售的票数 ( 不含 退票 和 培训票 )
    uint32  sale_bet_count;      //本期实际的销售注数 ( 多期票只计算在本期的销售注数 )
    money_t sale_money_amount;  //本期实际的销售金额 ( 多期票只计算在本期的销售额 )
    uint32  cancel_tickets_count; //本期实际退票的票数 ( 不含 培训票 )
    uint32  cancel_bet_count;     //本期实际的退票注数 ( 多期票只计算在本期的销售注数 )
    money_t cancel_money_amount;  //本期实际的退票金额 ( 多期票只计算在本期的销售额 )
    uint32  prize_stat[MAX_PRIZE_COUNT];

    //高等奖中奖信息 ( 含agency信息)
    ANNOUNCE_HIGH_PRIZE a_high_prize[MAX_PRIZE_COUNT];
} ISSUE_REAL_STAT;


typedef struct _VALUE_TRIPLE {
    uint32 code;
    uint32 value;
}VALUE_TRIPLE;




#endif //GL_TYPE_DEF_H_INCLUDED


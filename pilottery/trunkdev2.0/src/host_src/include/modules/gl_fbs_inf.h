#ifndef GL_FBS_H_INCLUDED
#define GL_FBS_H_INCLUDED


// Home Team 主队
// Away Team 客队

// WINNER (胜平负)
// HANDICAP (让分 胜负)
// TOTAL (总进球)
// SCORE (比分)
// HALF TIME / FULL TIME DOUBLE 半全场
// OUOD  总进球 大小盘 Total over/under
// OUOD  总进球 单数 odd number  双数 even number


//---------------------------------------------------------------------------
//define subtype code
// 定义玩法枚举
enum {
    FBS_SUBTYPE_WIN       = 1,    //Winner pool
    FBS_SUBTYPE_HCP       = 2,    //Handicap pool
    FBS_SUBTYPE_TOT       = 3,    //Totals pool
    FBS_SUBTYPE_SCR       = 4,    //Score pool
    FBS_SUBTYPE_HFT       = 5,    //Half time / Full time pool
    FBS_SUBTYPE_OUOD      = 6,    //total goals  (over/under)  (odd/even)

    /*
    FBS_SUBTYPE_MRF       = 7,    //Margin full time pool
    FBS_SUBTYPE_MRH       = 8,    //Margin half time pool
    FBS_SUBTYPE_FSC       = 9,    //First scorer pool
    FBS_SUBTYPE_LSC       = 10,   //Last scorer pool
    FBS_SUBTYPE_FPT       = 11,   //First points pool
    FBS_SUBTYPE_WN2       = 12,   //Winner double pool
    FBS_SUBTYPE_WN3       = 13,   //Winner treble pool
    FBS_SUBTYPE_MR2       = 14,   //Margin double pool
    FBS_SUBTYPE_PWN       = 15,   //Pick winner pool
    FBS_SUBTYPE_PMR       = 16,   //Pick margin_pool
    */
};


// ------- 胜平负(让球)  定义玩法的赛果枚举 --------------------------------------
// (胜3  平1  负0)
enum
{
    FBS_WIN_HomeTeam      = 1,    // Home team win  主队胜
    FBS_WIN_Draw          = 2,    // draw  平
    FBS_WIN_AwayTeam      = 3,    // Away team win  主队负(客队胜)
    FBS_WIN_All           = 4,    // 比赛取消 (赛果字符串使用，永远用不到)
};
//定义此玩法的赛果最大值
#define FBS_SUBTYPE_WIN_SEL    (4+1)    //select option count, select 0 hasn't be used


// ------- 胜负(让球)    定义玩法的赛果枚举 -------------------------------------
// (让分的范围从 1/2 分到 1 1/2 , 2 1/2, 3 1/2, 4 1/2 等等)
enum
{
    FBS_HCP_HomeTeam      = 1,    // Home team win  主队胜
    FBS_HCP_AwayTeam      = 2,    // Away team win  主队负(客队胜)
    FBS_HCP_All           = 3,    // 比赛取消 (赛果字符串使用，永远用不到)
};
#define FBS_SUBTYPE_HCP_SEL    (3+1)    //select option count, select 0 hasn't be used


// ------- 总进球数    定义玩法的赛果枚举 --------------------------------------
// (0球 1球 2球 3球 4球 5球 6球 7球或更多)
enum
{
    FBS_TOT_0      = 1,      // 0 goals
    FBS_TOT_1      = 2,      // 1 goals
    FBS_TOT_2      = 3,      // 2 goals
    FBS_TOT_3      = 4,      // 3 goals
    FBS_TOT_4      = 5,      // 4 goals
    FBS_TOT_5      = 6,      // 5 goals
    FBS_TOT_6      = 7,      // 6 goals
    FBS_TOT_7_More = 8,      // 7 goals or more
    FBS_TOT_All    = 9,      // 比赛取消 (赛果字符串使用，永远用不到)
};
#define FBS_SUBTYPE_TOT_SEL    (9+1)    //select option count, select 0 has be used


// ------- 比分    定义玩法的赛果枚举 -------------------------------------------
//主胜 (1-0  2-0  2-1  3-0  3-1  3-2  4-0  4-1  4-2  胜其他)
//平   (0-0  1-1  2-2  3-3 平其他)
//主负 (0-1  0-2  1-2  0-3  1-3  2-3  0-4  1-4  2-4  负其他)
enum
{
    FBS_SCR_1_0 = 1,           // Score 1-0
    FBS_SCR_2_0 = 2,           // Score 2-0
    FBS_SCR_2_1 = 3,           // Score 2-1
    FBS_SCR_3_0 = 4,           // Score 3-0
    FBS_SCR_3_1 = 5,           // Score 3-1
    FBS_SCR_3_2 = 6,           // Score 3-2
    FBS_SCR_4_0 = 7,           // Score 4-0
    FBS_SCR_4_1 = 8,           // Score 4-1
    FBS_SCR_4_2 = 9,           // Score 4-2
    FBS_SCR_HomeWinOther = 10, // Score Home team win other score
    FBS_SCR_0_0 = 11,          // Score 0-0
    FBS_SCR_1_1 = 12,          // Score 1-1
    FBS_SCR_2_2 = 13,          // Score 2-2
    FBS_SCR_3_3 = 14,          // Score 3-3
    FBS_SCR_DrawOther = 15,    // Score Draw other score
    FBS_SCR_0_1 = 16,          // Score 0-1
    FBS_SCR_0_2 = 17,          // Score 0-2
    FBS_SCR_1_2 = 18,          // Score 1-2
    FBS_SCR_0_3 = 19,          // Score 0-3
    FBS_SCR_1_3 = 20,          // Score 1-3
    FBS_SCR_2_3 = 21,          // Score 2-3
    FBS_SCR_0_4 = 22,          // Score 0-4
    FBS_SCR_1_4 = 23,          // Score 1-4
    FBS_SCR_2_4 = 24,          // Score 2-4
    FBS_SCR_AwayWinOther = 25, // Score Away team win other score
    FBS_SCR_All = 26,          // 比赛取消 (赛果字符串使用，永远用不到)
};
#define FBS_SUBTYPE_SCR_SEL   (26+1)    //select option count, select 0 hasn't be used


// ------- 半全场 胜平负    定义玩法的赛果枚举 ---------------------------------------
// (主队 ->  胜-胜  胜-平  胜-负  平-胜  平-平  平-负  负-胜  负-平  负-负)
enum
{
    FBS_HFT_Home_Home = 1,   // home win - home win
    FBS_HFT_Home_Draw = 2,   // home win - draw
    FBS_HFT_Home_Away = 3,   // home win - away win
    FBS_HFT_Draw_Home = 4,   // draw - home win
    FBS_HFT_Draw_Draw = 5,   // draw - draw
    FBS_HFT_Draw_Away = 6,   // draw - away win
    FBS_HFT_Away_Home = 7,   // away win - home win
    FBS_HFT_Away_Draw = 8,   // away win - draw
    FBS_HFT_Away_Away = 9,   // away win - away win
    FBS_HFT_All_All   = 10,  // 比赛取消 (赛果字符串使用，永远用不到)
};
#define FBS_SUBTYPE_HFT_SEL    (10+1)    //select option count, select 0 hasn't be used


// ------- 全场总进球 (猜大小 猜单双数) ---------------------
// 总进球 猜大小盘 Total over/under
// 总进球 猜单数/双数   单数-odd number  双数-even number
enum
{
    FBS_OUOD_Over_Odd   = 1,   // Total  Over and Odd
    FBS_OUOD_Over_Even  = 2,   // Total  Over and Even
    FBS_OUOD_Under_Odd  = 3,   // Total  Under and Odd
    FBS_OUOD_Under_Even = 4,   // Total  Under and Even
    FBS_OUOD_All_ALL    = 5,   // 比赛取消  (赛果字符串使用，永远用不到)
};
#define FBS_SUBTYPE_OUOD_SEL   (5+1)    //select option count, select 0 hasn't be used



// ------- FBS_SUBTYPE_MRF ----------------------------------------
// Margin full time pool
enum {};
#define FBS_SUBTYPE_MRF_SEL    (5+1)    //select option count, select 0 hasn't be used

// ------- FBS_SUBTYPE_MRH ----------------------------------------
// Margin half time pool
enum {};
#define FBS_SUBTYPE_MRH_SEL    (5+1)    //select option count, select 0 hasn't be used

// ------- FBS_SUBTYPE_FSC ----------------------------------------
// First scorer pool
enum {};
#define FBS_SUBTYPE_FSC_SEL    (25+1)   //select option count, select 0 hasn't be used

// ------- FBS_SUBTYPE_LSC ----------------------------------------
// Last scorer pool
enum {};
#define FBS_SUBTYPE_LSC_SEL    (25+1)   //select option count, select 0 hasn't be used

// ------- FBS_SUBTYPE_FPT ----------------------------------------
// First points pool
enum {};
#define FBS_SUBTYPE_FPT_SEL    (3+1)    //select option count, select 0 hasn't be used

// ------- FBS_SUBTYPE_WN2 ----------------------------------------
// Winner double pool
enum {};
#define FBS_SUBTYPE_WN2_SEL    (9+1)    //select option count, select 0 hasn't be used

// ------- FBS_SUBTYPE_WN3 ----------------------------------------
// Winner treble pool
enum {};
#define FBS_SUBTYPE_WN3_SEL    (27+1)   //select option count, select 0 hasn't be used

// ------- FBS_SUBTYPE_MR2 ----------------------------------------
// Margin double pool
enum {};
#define FBS_SUBTYPE_MR2_SEL    (13+1)   // fake

// ------- FBS_SUBTYPE_PWN ----------------------------------------
// Pick winner pool
enum {};
#define FBS_SUBTYPE_PWN_SEL    (14+1)   //fake

// ------- FBS_SUBTYPE_PMR ----------------------------------------
// Pick margin_pool
enum {};
#define FBS_SUBTYPE_PMR_SEL    (15+1)   //fake


#define FBS_DRAW_All 99 //定义如果比赛取消，所有投注均中奖的特殊赛果


//过关方式(投注方式)
enum {
    BET_0 = 0,
    BET_1C1 = 1,
    BET_2C1,
    BET_2C3,
    BET_3C1,
    BET_3C4,
    BET_3C7,
    BET_4C1,
    BET_4C5,
    BET_4C11,
    BET_4C15,
    BET_5C1,
    BET_5C6,
    BET_5C16,
    BET_5C26,
    BET_5C31,
    BET_6C1,
    BET_6C7,
    BET_6C22,
    BET_6C42,
    BET_6C57,
    BET_6C63,
    BET_7C1,
    BET_8C1,
    BET_9C1,
    BET_10C1,
    BET_11C1,
    BET_12C1,
    BET_13C1,
    BET_14C1,
    BET_15C1, //30
};
extern const char *BetTypeString[BET_15C1+1];

//term
typedef enum _MATCH_TERM
{
	M_HOME_TERM = 1, //主队
    M_AWAY_TERM = 2  //客队
} MATCH_TERM;

//match state
typedef enum _MATCH_STATE
{
	M_STATE_ARRANGE = 1, //比赛排期
    M_STATE_OPEN    = 2, //begin sale
	M_STATE_CLOSE   = 3, //stop sale
	M_STATE_RESULT  = 4, //input match result (输入开奖结果)
    M_STATE_DRAW    = 5, //draw complete (算奖完成)
    M_STATE_CONFIRM = 6, //draw confirm (开奖结果确认，开奖完成)
} MATCH_STATE;

//match result
enum
{
	M_WIN_HOME = 1, //主胜
    M_WIN_DRAW = 2, //平
	M_WIN_AWAY = 3  //主负(客胜)
};

//联赛枚举
enum
{
	M_CMPT_EnglishPremierLeague = 1, // English Premier League 英格兰超级联赛
    M_CMPT_EnglishFACup = 2,  // English FA Cup 英格兰足总杯
	M_CMPT_ItalianSerieALeague = 3  //Italian Serie A League 意大利甲级联赛
};




//四舍五入取整
#define rounding(x) (int64)(x+0.5)

#define rounddown(x) (int64)(x)


#pragma pack(1)

// FBS 数据结构定义

//玩法规则参数
typedef struct _FBS_SUBTYPE_PARAM
{
    uint8  used; //是否被使用
    uint8  code; //游戏玩法编号
    char   abbr[10]; //游戏玩法标识
    char   name[ENTRY_NAME_LEN]; //游戏玩法名称
    uint8  status; // 1 ENABLED / 2 DISABLED  仅用于销售控制
    uint16 singleAmount; //玩法下的单注金额(瑞尔)
} FBS_SUBTYPE_PARAM;

////联赛信息
//typedef struct _COMPETITION
//{
//    bool   used; //是否被使用
//
//    uint32 code; //联赛编码
//    char   name[256]; //联赛名称
//    char   abbr[64]; //联赛名称缩写
//}COMPETITION;

//比赛的赛果赔率信息
typedef struct _M_RESULT_ODDS
{
    bool    used; //是否被使用

    money_t amount; //此场比赛，指定玩法的投注金额
    money_t single_amount; //单关投注金额
    money_t multiple_amount; //多关(过关)投注金额
    uint32  sp;     //参考sp值 (实际的值需要 除以 1000) (保留小数点后3位)
    uint32  sp_old; //上一个参考sp (实际的值需要 除以 1000) (保留小数点后3位)
    uint32  odds;   //参考赔率 (实际的值需要 除以 1000) (保留小数点后3位)
    uint32  odds_old; //上一个参考赔率 (实际的值需要 除以 1000) (保留小数点后3位)
}M_RESULT_ODDS;

//比赛赔率信息
typedef struct _M_ODDS
{
    bool    used; //是否被使用

    money_t bet_amount; //此玩法的投注金额
    money_t single_amount; //单关投注金额
    money_t multiple_amount; //多关(过关)投注金额
    M_RESULT_ODDS odds[FBS_SUBTYPE_MAX_SEL_NUM]; //每个赛果的投注信息
}M_ODDS;

typedef struct _FBS_MATCH
{
    bool   used; //是否被使用
    int32  idx;

    uint32 match_code; //match code  全局唯一 150930999
    uint32 seq; //match sequence number in one issue  在一期里面唯一
    uint8  status; // enabled or disabled
    uint8  subtype_status[FBS_SUBTYPE_NUM]; //针对这场比赛是否启用这个玩法 value 0,1

    uint32 competition; //联赛信息 (M_CMPT_EnglishPremierLeague / M_CMPT_ItalianSerieALeague ...)
    char   competition_abbr[64]; //联赛名称缩写
    uint32 round; //联赛第几轮
    uint32 home_code;
    //char   home_term[256]; //主队名称
    uint32 away_code;
    //char   away_term[256]; //客队名称
	uint32 date; //比赛日期 20130312
	char   venue[256]; //match address 比赛地点
	uint32 match_time; //match start time 比赛时间
	uint32 result_time; //get result time 得到比赛结果时间
	uint32 draw_time; //draw complete time 比赛开奖完成时间

	uint32 sale_time; //begin sale time 开始销售时间
	uint32 close_time; //stop sale time 截止销售时间

    uint8  state; //比赛状态  (MATCH_STATE)
    uint8  localState;

    //mathc home team handicap result sets
    int32  home_handicap; //胜平负 (主队让球数) 正数为主队让球数 负数为客队让球数
    int32  home_handicap_point5; //胜负 (主队让球数 0.5 1.5 2.5 -0.5 -1.5 -2.5) 正数为主队让球数 负数为客队让球数   (这个数 除以 10 才是实际值)

    // sp 和 odds赔率信息
    M_ODDS odds_array[FBS_SUBTYPE_NUM]; //不同玩法的赔率信息

    //------- match result -------
    //match first half time result sets
	uint32 fht_win_result;  //上半场比赛结果 M_WIN_HOME, M_WIN_DRAW, M_WIN_AWAY
	uint32 fht_home_goals;  //上半场主队进球数
	uint32 fht_away_goals;  //上半场客队进球数
	uint32 fht_total_goals; //上半场总进球数

    //match second half time result sets
    uint32 sht_win_result;  //下半场比赛结果 M_WIN_HOME, M_WIN_DRAW, M_WIN_AWAY
	uint32 sht_home_goals;  //下半场主队进球数
	uint32 sht_away_goals;  //下半场客队进球数
	uint32 sht_total_goals; //下半场总进球数

	//match full time result sets
	uint32 ft_win_result;   //全场比赛结果 M_WIN_HOME, M_WIN_DRAW, M_WIN_AWAY
	uint32 ft_home_goals;   //全场主队进球数
	uint32 ft_away_goals;   //全场客队进球数
	uint32 ft_total_goals;  //全场总进球数

	uint32 first_goal;      //那个队伍先进球  M_HOME_TERM or M_AWAY_TERM

    //赛果
    uint8  fbs_result[FBS_SUBTYPE_NUM];
} FBS_MATCH;

typedef struct _FBS_ISSUE
{
    bool   used; //是否被使用
    int32  idx;

    uint32 issue_number; //期次编号(2016001)
    uint32 issue_date;   //(20160427)
    uint32 publish_time; //期次发布时间 (时间戳)
    //money_t bet_amount;  //本期销售额（不需要删除）
    uint8  state;        //期次状态  (ISSUE_STATE_OPENED, ISSUE_STATE_CLOSED)
    FBS_MATCH match_array[FBS_MAX_ISSUE_MATCH]; //一期比赛数组
} FBS_ISSUE;


//k-debug:
//球队信息
typedef struct _FBS_TEAM {
    bool   used; //是否被使用
    int32  idx;

    uint32  team_code; //球队编码
    char    country[256]; //国家
    char    name[256]; //球队名称
    char    abbr[64]; //球队名称缩写
} FBS_TEAM;



//分玩法的算奖结构 <INM_TYPE_FBS_DRAW_INPUT_RESULT>
typedef struct _SUB_RESULT {
    uint8   code; //游戏玩法编号
    money_t amount; //玩法投注金额
    money_t single_amount; //单关玩法投注金额
    money_t multiple_amount; //过关玩法投注金额
    uint8   result; //赛果枚举
    money_t result_amount; //投中赛果的投注额
    money_t single_result_amount; //单关玩法投中赛果的投注金额
    money_t multiple_result_amount; //过关玩法投中赛果的投注金额
    uint32  final_sp; //此赛果的最终SP
    money_t win_amount; //中奖金额
    money_t single_win_amount; //单关玩法中奖金额
    money_t multiple_win_amount; //过关玩法中奖金额
} SUB_RESULT;


// ------- FBS-OTL  START ----------------------------------------

typedef struct _DB_FBS_COMPETITION
{
    int    code;
    char   name[256];
    char   abbr[64];
}DB_FBS_COMPETITION;

typedef struct _DB_FBS_TEAM
{
    int    teamCode;
    int    countryCode;
    char   name[256];
    char   abbr[64];
}DB_FBS_TEAM;

typedef struct _DB_FBS_ISSUE
{
    uint32 issue_number;
    uint32 issue_date;
    uint32 publish_time;
}DB_FBS_ISSUE;

typedef struct _DB_FBS_MATCH
{
    uint32 issue_number;
    uint32 match_code;
    uint32 seq;
    uint8  is_sale;
    uint32 competition;
    uint32 round;
    int    home_code;
    //char   home_team_name[256];
    int    away_code;
    //char   away_team_name[256];
    time_t match_date;
    char   venue[256];
    time_t match_start_time;
    time_t match_end_time;

    time_t begin_sale_time;
    time_t end_sale_time;

    time_t reward_time;

    uint32 match_status;

    int32  home_handicap;
    int32  home_handicap_point5;

}DB_FBS_MATCH;



//比赛赔率信息
typedef struct _DB_FBS_ODDS
{
    uint16  subtype_code;
    money_t bet_amount;
    money_t single_amount;
    money_t multiple_amount;

    uint64  match_result_code;
    money_t re_amount;
    money_t re_single_amount;
    money_t re_multiple_amount;
    float  sp;
    float  sp_old;
    float  odds;
    float  odds_old;
}DB_FBS_ODDS;

typedef struct _GIDB_FBS_MATCH_INFO
{
    uint32 issue_number; //日期 期号
    uint32 match_code; //match code  全局唯一 150930999
    uint32 seq; //match sequence number in one issue  在一期里面唯一
    uint32 home_code;
    uint32 away_code;
    time_t draw_time; //draw complete time 比赛开奖完成时间
    uint32 state; //比赛状态  (MATCH_STATE)
} GIDB_FBS_MATCH_INFO;

// ------- FBS-OTL  END ----------------------------------------




//取消指定对齐，恢复缺省对齐
#pragma pack ()


#endif //GL_FBS_H_INCLUDED


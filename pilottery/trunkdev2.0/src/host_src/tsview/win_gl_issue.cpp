#include "tsview.h"
#include "gl_inf.h"

bool gl_issue_init_flag = false;

#define gl_issue_win_top_line       4
#define gl_issue_win_buttom_line    (MAIN_WIN_STATUS_LINE-2)

#define gl_issue_win_lins  (gl_issue_win_buttom_line-gl_issue_win_top_line+1)



bool gl_issue_error_flag = false;
GAME_PLUGIN_INTERFACE *game_plugins_handle = NULL;



typedef enum _GL_ISSUE_DISPALY_TYPE
{
    GL_DISPLAY_EMPTY = 0,
    GL_DISPLAY_GAME_LIST,
    GL_DISPLAY_GAME_DETAIL,
    GL_DISPLAY_GAME_ISSUE_LIST,
    GL_DISPLAY_GAME_ISSUE_DETAIL,
}GL_ISSUE_DISPALY_TYPE;

static GL_ISSUE_DISPALY_TYPE gl_display_type = GL_DISPLAY_EMPTY;
static GL_ISSUE_DISPALY_TYPE gl_display_type_keep = GL_DISPLAY_EMPTY;



//在可移动的行上 或 单独的页面上  定义用户的自定义数据
typedef struct _list_gl_info
{
    GL_ISSUE_DISPALY_TYPE enter_type;
    int enter_index;                //定义回车键的将显示的数组索引
    uint64 enter_index_0;                //定义回车键的将显示的数组索引
    GL_ISSUE_DISPALY_TYPE escapt_type;
}list_gl_info;


//GL_DISPLAY_FIRST_LIST    first page 页面的数据
typedef struct _display_game_list_data
{
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_gl_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_game_list_data;

typedef struct _display_game_detail_data
{
    int game_code;

    list_gl_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_game_detail_data;

typedef struct _display_game_issue_list_data
{
    int game_code;
    unsigned int current_display_page;      //当前需要显示那一页
    unsigned int page_start_index;          //当前页显示的agency索引的起始
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_gl_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_game_issue_list_data;


typedef struct _display_game_issue_detail_data
{
    int game_code;
    uint64 issue_number;

    list_gl_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_game_issue_detail_data;


//定义页面显示的变量数据
static display_game_list_data game_list_data;
static display_game_detail_data game_detail_data;
static display_game_issue_list_data game_issue_list_data;
static display_game_issue_detail_data game_issue_detail_data;


/////////////////////////  PLUGIN  //////////////////////////////////
#pragma pack(1)

//玩法规则参数
typedef struct _SUBTYPE_PARAM_SSQ
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    //uint8 A_hasOrder; //有序选号(A区)
    //uint8 A_hasRepeat; //允许重复(A区)
    uint8 A_selectCount; //选号个数(A区)
    uint8 A_selectMaxCount; //复式最大选号个数(A区)
    uint8 B_selectBegin; //号码集合(B区)   起始号码
    uint8 B_selectEnd; //号码集合(B区)   结束号码
    uint8 B_selectCount; //选号个数(B区)
    uint8 B_selectMaxCount; //复式最大选号个数(B区)
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM_SSQ;

//匹配规则参数
typedef struct _DIVISION_PARAM_SSQ
{
    bool used; //是否被使用
    uint8 divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8 prizeCode;  //奖级编号
    uint8 subtypeCode; //玩法编号
    uint8 A_matchCount; //匹对个数(A区)
    uint8 B_matchCount; //匹对个数(B区)
} DIVISION_PARAM_SSQ;

//玩法规则参数
typedef struct _SUBTYPE_PARAM_3D
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM_3D;

//匹配规则参数
typedef struct _DIVISION_PARAM_3D
{
    bool used; //是否被使用
    uint8  divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8  prizeCode;  //奖级编号
    uint8  subtypeCode; //玩法编号
    uint32 A_distribute; //号码分布(A区)
    //bool A_hasOrder; //有序匹对(A区)
} DIVISION_PARAM_3D;

//玩法规则参数
typedef struct _SUBTYPE_PARAM_SSC
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM_SSC;

//匹配规则参数
typedef struct _DIVISION_PARAM_SSC
{
    bool used; //是否被使用
    uint8  divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8  prizeCode;  //奖级编号
    uint8  subtypeCode; //玩法编号
    uint32 A_distribute; //号码分布(A区)
    uint8 A_baseBegin; //基本起始(A区) 开奖号
    uint8 A_baseEnd; //基本结束(A区)
    //bool A_hasOrder; //有序匹对(A区)
    uint8 mutex;      //匹配规则之间互斥  0:不启用  1~255
} DIVISION_PARAM_SSC;


//玩法规则参数
typedef struct _SUBTYPE_PARAM_KOCKENO
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    uint8 A_selectCount; //选号个数(A区)
    uint8 A_selectMaxCount; //复式最大选号个数(A区)
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM_KOCKENO;

//匹配规则参数
typedef struct _DIVISION_PARAM_KOCKENO
{
    bool used; //是否被使用
    uint8 divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8 prizeCode;  //奖级编号
    uint8 subtypeCode; //玩法编号
    uint8 A_matchCount; //匹对个数(A区)
} DIVISION_PARAM_KOCKENO;

//玩法规则参数
typedef struct _SUBTYPE_PARAM_KOCK2
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    uint8 A_selectCount; //选号个数(A区)
    uint8 A_selectMaxCount; //复式最大选号个数(A区)
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM_KOCK2;

//匹配规则参数
typedef struct _DIVISION_PARAM_KOCK2
{
    bool used; //是否被使用
    uint8 divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8 prizeCode;  //奖级编号
    uint8 subtypeCode; //玩法编号
    uint8 A_baseBegin; //基本起始(A区)
    uint8 A_baseEnd; //基本结束(A区)
    uint8 A_matchCount; //匹对个数(A区)
} DIVISION_PARAM_KOCK2;

//玩法规则参数
typedef struct _SUBTYPE_PARAM_KOC7LX
{
    bool   used; //是否被使用
    uint8  subtypeCode; //游戏玩法编号
    char   subtypeAbbr[10]; //游戏玩法标识
    char   subtypeName[ENTRY_NAME_LEN]; //游戏玩法名称
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8  status;  //1 ENABLED / 2 DISABLED  仅用于销售控制
    uint8  A_selectBegin; //号码集合(A区)   起始号码
    uint8  A_selectEnd; //号码集合(A区)   结束号码
    uint8  A_selectCount; //选号个数(A区)
    uint8  A_selectMaxCount; //复式最大选号个数(A区)
    uint16 singleAmount; //玩法下的单注金额(瑞尔)
} SUBTYPE_PARAM_KOC7LX;

//匹配规则参数
typedef struct _DIVISION_PARAM_KOC7LX
{
    bool  used; //是否被使用
    uint8 divisionCode;
    char  divisionName[ENTRY_NAME_LEN];
    uint8 prizeCode;  //奖等编号 enum PRIZE
    uint8 subtypeCode; //玩法编号
    uint8 A_matchCount; //匹对个数(A区)
    uint8 specialNumberMatch; //特别号码匹对值(0未匹对1匹对)
} DIVISION_PARAM_KOC7LX;

//玩法规则参数
typedef struct _SUBTYPE_PARAM_KOCTTY
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8  status;  //1 ENABLED / 2 DISABLED  仅用于销售控制
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM_KOCTTY;

//匹配规则参数
typedef struct _DIVISION_PARAM_KOCTTY
{
    bool used; //是否被使用
    uint8  divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8  prizeCode;  //奖级编号
    uint8  subtypeCode; //玩法编号
    bool  distribute; //号码分布
    uint8  matchCount; //匹配个数
    uint8  specWinFlag;  //启用特殊中将规则标志

} DIVISION_PARAM_KOCTTY;

//玩法规则参数
typedef struct _SUBTYPE_PARAM_KOC11X5
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8  status;  //1 ENABLED / 2 DISABLED  仅用于销售控制
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM_KOC11X5;

//匹配规则参数
typedef struct _DIVISION_PARAM_KOC11X5
{
    bool used; //是否被使用
    uint8  divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8  prizeCode;  //奖级编号
    uint8  subtypeCode; //玩法编号
    bool  distribute; //号码分布
    uint8  matchCount; //匹配个数

} DIVISION_PARAM_KOC11X5;

//玩法规则参数
typedef struct _SUBTYPE_PARAM_FBS
{
    uint8  used; //是否被使用
    uint8  code; //游戏玩法编号
    char   abbr[10]; //游戏玩法标识
    char   name[ENTRY_NAME_LEN]; //游戏玩法名称
    uint8  status; // 1 ENABLED / 2 DISABLED  仅用于销售控制
    uint16 singleAmount; //玩法下的单注金额(瑞尔)
} SUBTYPE_PARAM_FBS;

//匹配规则参数
typedef struct _DIVISION_PARAM_FBS
{
    bool used; //是否被使用

} DIVISION_PARAM_FBS;


typedef struct _G_DETAIL
{
	char  sub_used[10];
	char  subtypeCode[10];
	char  subtypeAbbr[10];
	char  subtypeStatus[10];
	char  div_used[10];
	char  divisionCode[10];
	char  divisionName[ENTRY_NAME_LEN];
	char  div_prizeCode[10];
	char  div_subtypeCode[10];
	char  prize_used[10];
	char  prizeCode[10];
	char  prizeName[ENTRY_NAME_LEN];
	char  prizeType[5];
	char  prizeAmount[20];
	char  poolAmount[20];
} G_DETAIL;

#pragma pack()

int (*pluginParam)(WINDOW_TYPE win_type, uint8 game_code);
int pluginParam_ssq(WINDOW_TYPE win_type, uint8 game_code)
{
	char tmp[256] = {0};
	int ln = 1;
	G_DETAIL g_detail;
	int maxCnt = MAX_SUBTYPE_COUNT;
	if (maxCnt < MAX_DIVISION_COUNT) {
		maxCnt = MAX_DIVISION_COUNT;
	}

	SUBTYPE_PARAM_SSQ *subParam = (SUBTYPE_PARAM_SSQ*)game_plugins_handle[game_code].get_subtypeTable(NULL);
	DIVISION_PARAM_SSQ *divParam = (DIVISION_PARAM_SSQ*)game_plugins_handle[game_code].get_divisionTable(NULL,0);
	POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();
	PRIZE_PARAM *prizeParam = NULL;
	ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
	if (issue_ptr != NULL)
	{
		prizeParam = game_plugins_handle[game_code].get_prizeTable(issue_ptr->issueNumber);
	}


	for (int i = 0; i < maxCnt; i++) {
		memset(&g_detail, 0, sizeof(g_detail));
		if (i < MAX_SUBTYPE_COUNT)
		{
			sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
			sprintf(g_detail.subtypeCode, "%d", (subParam + i)->subtypeCode);
			sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->subtypeAbbr);
		}

		if (i < MAX_DIVISION_COUNT)
		{
			sprintf(g_detail.div_used, "%d", (divParam + i)->used);
			sprintf(g_detail.divisionCode, "%d", (divParam + i)->divisionCode);
			sprintf(g_detail.divisionName, "%s", (divParam + i)->divisionName);
			sprintf(g_detail.div_prizeCode, "%d", (divParam + i)->prizeCode);
			sprintf(g_detail.div_subtypeCode, "%d", (divParam + i)->subtypeCode);
		}

		if ((i < MAX_PRIZE_COUNT) && (prizeParam != NULL))
		{
			sprintf(g_detail.prize_used, "%d", (prizeParam + i)->used);
			sprintf(g_detail.prizeCode, "%d", (prizeParam + i)->prizeCode);
			sprintf(g_detail.prizeType, "%d", (prizeParam + i)->assignType);
			sprintf(g_detail.prizeAmount, "%lld", (prizeParam + i)->fixedPrizeAmount);
			sprintf(g_detail.prizeName, "%s", (prizeParam + i)->prizeName);
		}


		if (1 == ln) {
			sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
		}

		sprintf(tmp, "%-3d%-5s%-8s%-10s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
					ln,
					g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr,
					g_detail.div_used, g_detail.divisionCode, g_detail.div_prizeCode, g_detail.div_subtypeCode, g_detail.divisionName,
					g_detail.prize_used, g_detail.prizeCode, g_detail.prizeType, g_detail.prizeAmount, g_detail.prizeName,
					g_detail.poolAmount);

		print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
		ln++;
	}

	return 0;
}

int pluginParam_3D(WINDOW_TYPE win_type, uint8 game_code)
{
	char tmp[256] = {0};
	int ln = 1;
	G_DETAIL g_detail;
	int maxCnt = MAX_SUBTYPE_COUNT;
	if (maxCnt < MAX_DIVISION_COUNT) {
		maxCnt = MAX_DIVISION_COUNT;
	}

	SUBTYPE_PARAM_3D *subParam = (SUBTYPE_PARAM_3D*)game_plugins_handle[game_code].get_subtypeTable(NULL);
	DIVISION_PARAM_3D *divParam = (DIVISION_PARAM_3D*)game_plugins_handle[game_code].get_divisionTable(NULL,0);
	POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();
	PRIZE_PARAM *prizeParam = NULL;
	ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
	if (issue_ptr != NULL)
	{
		prizeParam = game_plugins_handle[game_code].get_prizeTable(issue_ptr->issueNumber);
	}


	for (int i = 0; i < maxCnt; i++) {
		memset(&g_detail, 0, sizeof(g_detail));
		if (i < MAX_SUBTYPE_COUNT)
		{
			sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
			sprintf(g_detail.subtypeCode, "%d", (subParam + i)->subtypeCode);
			sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->subtypeAbbr);
		}

		if (i < MAX_DIVISION_COUNT)
		{
			sprintf(g_detail.div_used, "%d", (divParam + i)->used);
			sprintf(g_detail.divisionCode, "%d", (divParam + i)->divisionCode);
			sprintf(g_detail.divisionName, "%s", (divParam + i)->divisionName);
			sprintf(g_detail.div_prizeCode, "%d", (divParam + i)->prizeCode);
			sprintf(g_detail.div_subtypeCode, "%d", (divParam + i)->subtypeCode);
		}

		if ((i < MAX_PRIZE_COUNT) && (prizeParam != NULL))
		{
			sprintf(g_detail.prize_used, "%d", (prizeParam + i)->used);
			sprintf(g_detail.prizeCode, "%d", (prizeParam + i)->prizeCode);
			sprintf(g_detail.prizeType, "%d", (prizeParam + i)->assignType);
			sprintf(g_detail.prizeAmount, "%lld", (prizeParam + i)->fixedPrizeAmount);
			sprintf(g_detail.prizeName, "%s", (prizeParam + i)->prizeName);
		}


		if (1 == ln) {
			sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
		}

		sprintf(tmp, "%-3d%-5s%-8s%-10s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
					ln,
					g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr,
					g_detail.div_used, g_detail.divisionCode, g_detail.div_prizeCode, g_detail.div_subtypeCode, g_detail.divisionName,
					g_detail.prize_used, g_detail.prizeCode, g_detail.prizeType, g_detail.prizeAmount, g_detail.prizeName,
					g_detail.poolAmount);

		print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
		ln++;
	}

	return 0;
}

int pluginParam_ssc(WINDOW_TYPE win_type, uint8 game_code)
{
	char tmp[256] = {0};
	int ln = 1;
	G_DETAIL g_detail;
	int maxCnt = MAX_SUBTYPE_COUNT;
	if (maxCnt < MAX_DIVISION_COUNT)
	{
		maxCnt = MAX_DIVISION_COUNT;
	}

	SUBTYPE_PARAM_SSC *subParam = (SUBTYPE_PARAM_SSC*)game_plugins_handle[game_code].get_subtypeTable(NULL);
	DIVISION_PARAM_SSC *divParam = (DIVISION_PARAM_SSC*)game_plugins_handle[game_code].get_divisionTable(NULL,0);
	POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();
	PRIZE_PARAM *prizeParam = NULL;
	ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
	if (issue_ptr != NULL)
	{
		prizeParam = game_plugins_handle[game_code].get_prizeTable(issue_ptr->issueNumber);
	}


	for (int i = 0; i < maxCnt; i++) {
		memset(&g_detail, 0, sizeof(g_detail));
		if (i < MAX_SUBTYPE_COUNT)
		{
			sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
			sprintf(g_detail.subtypeCode, "%d", (subParam + i)->subtypeCode);
			sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->subtypeAbbr);
		}

		if (i < MAX_DIVISION_COUNT)
		{
			sprintf(g_detail.div_used, "%d", (divParam + i)->used);
			sprintf(g_detail.divisionCode, "%d", (divParam + i)->divisionCode);
			sprintf(g_detail.divisionName, "%s", (divParam + i)->divisionName);
			sprintf(g_detail.div_prizeCode, "%d", (divParam + i)->prizeCode);
			sprintf(g_detail.div_subtypeCode, "%d", (divParam + i)->subtypeCode);
		}

		if ((i < MAX_PRIZE_COUNT) && (prizeParam != NULL))
		{
			sprintf(g_detail.prize_used, "%d", (prizeParam + i)->used);
			sprintf(g_detail.prizeCode, "%d", (prizeParam + i)->prizeCode);
			sprintf(g_detail.prizeType, "%d", (prizeParam + i)->assignType);
			sprintf(g_detail.prizeAmount, "%lld", (prizeParam + i)->fixedPrizeAmount);
			sprintf(g_detail.prizeName, "%s", (prizeParam + i)->prizeName);
		}


		if (1 == ln) {
			sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
		}

		sprintf(tmp, "%-3d%-5s%-8s%-10s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
					ln,
					g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr,
					g_detail.div_used, g_detail.divisionCode, g_detail.div_prizeCode, g_detail.div_subtypeCode, g_detail.divisionName,
					g_detail.prize_used, g_detail.prizeCode, g_detail.prizeType, g_detail.prizeAmount, g_detail.prizeName,
					g_detail.poolAmount);

		print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
		ln++;
	}

	return 0;
}

int pluginParam_kockeno(WINDOW_TYPE win_type, uint8 game_code)
{
	char tmp[256] = {0};
	int ln = 1;
	G_DETAIL g_detail;
	int maxCnt = MAX_SUBTYPE_COUNT;
	if (maxCnt < MAX_DIVISION_COUNT)
	{
		maxCnt = MAX_DIVISION_COUNT;
	}

	SUBTYPE_PARAM_KOCKENO *subParam = (SUBTYPE_PARAM_KOCKENO*)game_plugins_handle[game_code].get_subtypeTable(NULL);
	DIVISION_PARAM_KOCKENO *divParam = (DIVISION_PARAM_KOCKENO*)game_plugins_handle[game_code].get_divisionTable(NULL,0);
	POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();
	PRIZE_PARAM *prizeParam = NULL;
	ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
	if (issue_ptr != NULL)
	{
		prizeParam = game_plugins_handle[game_code].get_prizeTable(issue_ptr->issueNumber);
	}


	for (int i = 0; i < maxCnt; i++) {
		memset(&g_detail, 0, sizeof(g_detail));
		if (i < MAX_SUBTYPE_COUNT)
		{
			sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
			sprintf(g_detail.subtypeCode, "%d", (subParam + i)->subtypeCode);
			sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->subtypeAbbr);
		}

		if (i < MAX_DIVISION_COUNT)
		{
			sprintf(g_detail.div_used, "%d", (divParam + i)->used);
			sprintf(g_detail.divisionCode, "%d", (divParam + i)->divisionCode);
			sprintf(g_detail.divisionName, "%s", (divParam + i)->divisionName);
			sprintf(g_detail.div_prizeCode, "%d", (divParam + i)->prizeCode);
			sprintf(g_detail.div_subtypeCode, "%d", (divParam + i)->subtypeCode);
		}

		if ((i < MAX_PRIZE_COUNT) && (prizeParam != NULL))
		{
			sprintf(g_detail.prize_used, "%d", (prizeParam + i)->used);
			sprintf(g_detail.prizeCode, "%d", (prizeParam + i)->prizeCode);
			sprintf(g_detail.prizeType, "%d", (prizeParam + i)->assignType);
			sprintf(g_detail.prizeAmount, "%lld", (prizeParam + i)->fixedPrizeAmount);
			sprintf(g_detail.prizeName, "%s", (prizeParam + i)->prizeName);
		}


		if (1 == ln) {
			sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
		}

		sprintf(tmp, "%-3d%-5s%-8s%-10s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
					ln,
					g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr,
					g_detail.div_used, g_detail.divisionCode, g_detail.div_prizeCode, g_detail.div_subtypeCode, g_detail.divisionName,
					g_detail.prize_used, g_detail.prizeCode, g_detail.prizeType, g_detail.prizeAmount, g_detail.prizeName,
					g_detail.poolAmount);

		print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
		ln++;
	}

	return 0;
}

int pluginParam_kock2(WINDOW_TYPE win_type, uint8 game_code)
{
	char tmp[256] = {0};
	int ln = 1;
	G_DETAIL g_detail;
	int maxCnt = MAX_SUBTYPE_COUNT;
	if (maxCnt < MAX_DIVISION_COUNT)
	{
		maxCnt = MAX_DIVISION_COUNT;
	}

	SUBTYPE_PARAM_KOCK2 *subParam = (SUBTYPE_PARAM_KOCK2*)game_plugins_handle[game_code].get_subtypeTable(NULL);
	DIVISION_PARAM_KOCK2 *divParam = (DIVISION_PARAM_KOCK2*)game_plugins_handle[game_code].get_divisionTable(NULL,0);
	POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();
	PRIZE_PARAM *prizeParam = NULL;
	ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
	if (issue_ptr != NULL)
	{
		prizeParam = game_plugins_handle[game_code].get_prizeTable(issue_ptr->issueNumber);
	}


	for (int i = 0; i < maxCnt; i++) {
		memset(&g_detail, 0, sizeof(g_detail));
		if (i < MAX_SUBTYPE_COUNT)
		{
			sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
			sprintf(g_detail.subtypeCode, "%d", (subParam + i)->subtypeCode);
			sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->subtypeAbbr);
		}

		if (i < MAX_DIVISION_COUNT)
		{
			sprintf(g_detail.div_used, "%d", (divParam + i)->used);
			sprintf(g_detail.divisionCode, "%d", (divParam + i)->divisionCode);
			sprintf(g_detail.divisionName, "%s", (divParam + i)->divisionName);
			sprintf(g_detail.div_prizeCode, "%d", (divParam + i)->prizeCode);
			sprintf(g_detail.div_subtypeCode, "%d", (divParam + i)->subtypeCode);
		}

		if ((i < MAX_PRIZE_COUNT) && (prizeParam != NULL))
		{
			sprintf(g_detail.prize_used, "%d", (prizeParam + i)->used);
			sprintf(g_detail.prizeCode, "%d", (prizeParam + i)->prizeCode);
			sprintf(g_detail.prizeType, "%d", (prizeParam + i)->assignType);
			sprintf(g_detail.prizeAmount, "%lld", (prizeParam + i)->fixedPrizeAmount);
			sprintf(g_detail.prizeName, "%s", (prizeParam + i)->prizeName);
		}


		if (1 == ln) {
			sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
		}

		sprintf(tmp, "%-3d%-5s%-8s%-10s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
					ln,
					g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr,
					g_detail.div_used, g_detail.divisionCode, g_detail.div_prizeCode, g_detail.div_subtypeCode, g_detail.divisionName,
					g_detail.prize_used, g_detail.prizeCode, g_detail.prizeType, g_detail.prizeAmount, g_detail.prizeName,
					g_detail.poolAmount);

		print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
		ln++;
	}

	return 0;
}

int pluginParam_koc7lx(WINDOW_TYPE win_type, uint8 game_code)
{
	char tmp[256] = {0};
	int ln = 1;
	G_DETAIL g_detail;
	int maxCnt = MAX_SUBTYPE_COUNT;
	if (maxCnt < MAX_DIVISION_COUNT)
	{
		maxCnt = MAX_DIVISION_COUNT;
	}

	SUBTYPE_PARAM_KOC7LX *subParam = (SUBTYPE_PARAM_KOC7LX*)game_plugins_handle[game_code].get_subtypeTable(NULL);
	DIVISION_PARAM_KOC7LX *divParam = (DIVISION_PARAM_KOC7LX*)game_plugins_handle[game_code].get_divisionTable(NULL,0);
	POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();
	PRIZE_PARAM *prizeParam = NULL;
	ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
	if (issue_ptr != NULL)
	{
		prizeParam = game_plugins_handle[game_code].get_prizeTable(issue_ptr->issueNumber);
	}


	for (int i = 0; i < maxCnt; i++) {
		memset(&g_detail, 0, sizeof(g_detail));
		if (i < MAX_SUBTYPE_COUNT)
		{
			sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
			sprintf(g_detail.subtypeCode, "%d", (subParam + i)->subtypeCode);
			sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->subtypeAbbr);
			sprintf(g_detail.subtypeStatus, "%d", (subParam + i)->status);
		}

		if (i < MAX_DIVISION_COUNT)
		{
			sprintf(g_detail.div_used, "%d", (divParam + i)->used);
			sprintf(g_detail.divisionCode, "%d", (divParam + i)->divisionCode);
			sprintf(g_detail.divisionName, "%s", (divParam + i)->divisionName);
			sprintf(g_detail.div_prizeCode, "%d", (divParam + i)->prizeCode);
			sprintf(g_detail.div_subtypeCode, "%d", (divParam + i)->subtypeCode);
		}

		if ((i < MAX_PRIZE_COUNT) && (prizeParam != NULL))
		{
			sprintf(g_detail.prize_used, "%d", (prizeParam + i)->used);
			sprintf(g_detail.prizeCode, "%d", (prizeParam + i)->prizeCode);
			sprintf(g_detail.prizeType, "%d", (prizeParam + i)->assignType);
			sprintf(g_detail.prizeAmount, "%lld", (prizeParam + i)->fixedPrizeAmount);
			sprintf(g_detail.prizeName, "%s", (prizeParam + i)->prizeName);
		}


		if (1 == ln) {
			sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
		}

		sprintf(tmp, "%-3d%-5s%-8s%-10s%-3s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
					ln,
					g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr, g_detail.subtypeStatus,
					g_detail.div_used, g_detail.divisionCode, g_detail.div_prizeCode, g_detail.div_subtypeCode, g_detail.divisionName,
					g_detail.prize_used, g_detail.prizeCode, g_detail.prizeType, g_detail.prizeAmount, g_detail.prizeName,
					g_detail.poolAmount);

		print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
		ln++;
	}

	return 0;
}

int pluginParam_koctty(WINDOW_TYPE win_type, uint8 game_code)
{
	char tmp[256] = {0};
	int ln = 1;
	G_DETAIL g_detail;
	int maxCnt = MAX_SUBTYPE_COUNT;
	if (maxCnt < MAX_DIVISION_COUNT)
	{
		maxCnt = MAX_DIVISION_COUNT;
	}

	SUBTYPE_PARAM_KOCTTY *subParam = (SUBTYPE_PARAM_KOCTTY*)game_plugins_handle[game_code].get_subtypeTable(NULL);
	DIVISION_PARAM_KOCTTY *divParam = (DIVISION_PARAM_KOCTTY*)game_plugins_handle[game_code].get_divisionTable(NULL,0);
	POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();
	PRIZE_PARAM *prizeParam = NULL;
	ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
	if (issue_ptr != NULL)
	{
		prizeParam = game_plugins_handle[game_code].get_prizeTable(issue_ptr->issueNumber);
	}


	for (int i = 0; i < maxCnt; i++) {
		memset(&g_detail, 0, sizeof(g_detail));
		if (i < MAX_SUBTYPE_COUNT)
		{
			sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
			sprintf(g_detail.subtypeCode, "%d", (subParam + i)->subtypeCode);
			sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->subtypeAbbr);
			sprintf(g_detail.subtypeStatus, "%d", (subParam + i)->status);
		}

		if (i < MAX_DIVISION_COUNT)
		{
			sprintf(g_detail.div_used, "%d", (divParam + i)->used);
			sprintf(g_detail.divisionCode, "%d", (divParam + i)->divisionCode);
			sprintf(g_detail.divisionName, "%s", (divParam + i)->divisionName);
			sprintf(g_detail.div_prizeCode, "%d", (divParam + i)->prizeCode);
			sprintf(g_detail.div_subtypeCode, "%d", (divParam + i)->subtypeCode);
		}

		if ((i < MAX_PRIZE_COUNT) && (prizeParam != NULL))
		{
			sprintf(g_detail.prize_used, "%d", (prizeParam + i)->used);
			sprintf(g_detail.prizeCode, "%d", (prizeParam + i)->prizeCode);
			sprintf(g_detail.prizeType, "%d", (prizeParam + i)->assignType);
			sprintf(g_detail.prizeAmount, "%lld", (prizeParam + i)->fixedPrizeAmount);
			sprintf(g_detail.prizeName, "%s", (prizeParam + i)->prizeName);
		}


		if (1 == ln) {
			sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
		}

		sprintf(tmp, "%-3d%-5s%-8s%-10s%-3s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
					ln,
					g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr, g_detail.subtypeStatus,
					g_detail.div_used, g_detail.divisionCode, g_detail.div_prizeCode, g_detail.div_subtypeCode, g_detail.divisionName,
					g_detail.prize_used, g_detail.prizeCode, g_detail.prizeType, g_detail.prizeAmount, g_detail.prizeName,
					g_detail.poolAmount);

		print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
		ln++;
	}

	return 0;
}

int pluginParam_koc11X5(WINDOW_TYPE win_type, uint8 game_code)
{
    char tmp[256] = {0};
    int ln = 1;
    G_DETAIL g_detail;
    int maxCnt = MAX_SUBTYPE_COUNT;
    if (maxCnt < MAX_DIVISION_COUNT)
    {
        maxCnt = MAX_DIVISION_COUNT;
    }

    SUBTYPE_PARAM_KOC11X5 *subParam = (SUBTYPE_PARAM_KOC11X5*)game_plugins_handle[game_code].get_subtypeTable(NULL);
    DIVISION_PARAM_KOC11X5 *divParam = (DIVISION_PARAM_KOC11X5*)game_plugins_handle[game_code].get_divisionTable(NULL,0);
    POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();
    PRIZE_PARAM *prizeParam = NULL;
    ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
    if (issue_ptr != NULL)
    {
        prizeParam = game_plugins_handle[game_code].get_prizeTable(issue_ptr->issueNumber);
    }


    for (int i = 0; i < maxCnt; i++) {
        memset(&g_detail, 0, sizeof(g_detail));
        if (i < MAX_SUBTYPE_COUNT)
        {
            sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
            sprintf(g_detail.subtypeCode, "%d", (subParam + i)->subtypeCode);
            sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->subtypeAbbr);
            sprintf(g_detail.subtypeStatus, "%d", (subParam + i)->status);
        }

        if (i < MAX_DIVISION_COUNT)
        {
            sprintf(g_detail.div_used, "%d", (divParam + i)->used);
            sprintf(g_detail.divisionCode, "%d", (divParam + i)->divisionCode);
            sprintf(g_detail.divisionName, "%s", (divParam + i)->divisionName);
            sprintf(g_detail.div_prizeCode, "%d", (divParam + i)->prizeCode);
            sprintf(g_detail.div_subtypeCode, "%d", (divParam + i)->subtypeCode);
        }

        if ((i < MAX_PRIZE_COUNT) && (prizeParam != NULL))
        {
            sprintf(g_detail.prize_used, "%d", (prizeParam + i)->used);
            sprintf(g_detail.prizeCode, "%d", (prizeParam + i)->prizeCode);
            sprintf(g_detail.prizeType, "%d", (prizeParam + i)->assignType);
            sprintf(g_detail.prizeAmount, "%lld", (prizeParam + i)->fixedPrizeAmount);
            sprintf(g_detail.prizeName, "%s", (prizeParam + i)->prizeName);
        }


        if (1 == ln) {
            sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
        }

        sprintf(tmp, "%-3d%-5s%-8s%-10s%-3s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
                    ln,
                    g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr, g_detail.subtypeStatus,
                    g_detail.div_used, g_detail.divisionCode, g_detail.div_prizeCode, g_detail.div_subtypeCode, g_detail.divisionName,
                    g_detail.prize_used, g_detail.prizeCode, g_detail.prizeType, g_detail.prizeAmount, g_detail.prizeName,
                    g_detail.poolAmount);

        print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
        ln++;
    }

    return 0;
}

int pluginParam_fbs(WINDOW_TYPE win_type, uint8 game_code)
{
	char tmp[256] = {0};
	int ln = 0;
	G_DETAIL g_detail;
	int maxCnt = MAX_SUBTYPE_COUNT;
	if (maxCnt < MAX_DIVISION_COUNT) {
		maxCnt = MAX_DIVISION_COUNT;
	}

	SUBTYPE_PARAM_FBS *subParam = (SUBTYPE_PARAM_FBS*)game_plugins_handle[game_code].get_subtypeTable(NULL);
	POOL_PARAM *poolParam = (POOL_PARAM*)game_plugins_handle[game_code].get_poolParam();

	for (int i = 0; i < maxCnt; i++) {
		memset(&g_detail, 0, sizeof(g_detail));
		if (i < MAX_SUBTYPE_COUNT)
		{
			sprintf(g_detail.sub_used, "%d", (subParam + i)->used);
			sprintf(g_detail.subtypeCode, "%d", (subParam + i)->code);
			sprintf(g_detail.subtypeAbbr, "%s", (subParam + i)->abbr);
		}

		if (1 == ln) {
			;//sprintf(g_detail.poolAmount, "%lld", poolParam->poolAmount);
		}

		sprintf(tmp, "%-3d%-5s%-8s%-10s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
					ln,
					g_detail.sub_used, g_detail.subtypeCode, g_detail.subtypeAbbr,
					" ", " ", " ", " ", " ",
					" ", " ", " ", " ", " ",
					g_detail.poolAmount);

		print_tbl_line_str(win_type, ln+gl_issue_win_top_line, 2, tmp);
		ln++;
	}

	return 0;
}



/////////////////////////  PLUGIN END  //////////////////////////////////




char *ts_getDateFormat(time_t tt,char *now)
{
  struct tm *ttime;
  ttime = localtime(&tt);
  strftime(now,64,"%Y-%m-%d %H:%M:%S",ttime);
  return now;
}

int init_win_gl_issue(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (gl_issue_init_flag)
        return 0;

    if(!gl_init())
    {
        logit("gl shm attach failed.");
        return false;
    }

    if (gl_game_plugins_init()!=0)
    {
        logit("gl_game_plugins_init failed.");
        return false;
    }
    game_plugins_handle = gl_plugins_handle();

    memset(&game_list_data, 0, sizeof(display_game_list_data));
    memset(&game_detail_data, 0, sizeof(display_game_detail_data));
    memset(&game_issue_list_data, 0, sizeof(display_game_issue_list_data));
    memset(&game_issue_detail_data, 0, sizeof(display_game_issue_detail_data));

    game_list_data.currentSel = 0;

    gl_display_type = GL_DISPLAY_GAME_LIST;
    gl_issue_init_flag = true;
    return true;
}

int close_win_gl_issue( WINDOW_TYPE win_type )
{
    ts_notused(win_type);

    gl_issue_init_flag = false;
    //gl_close();
    return true;
}

int draw_game_i_list( WINDOW_TYPE win_type)
{
    //输出列表
    game_list_data.lineNum = 0;

    GAME_DATA *ptr = NULL;
    char tmp[512] = {0};
    int i;

    if (gl_issue_error_flag)
        return true;

    //输出列表
    int ln = 1;

    sprintf(tmp, "%5s%-16s%-16s%-10s%-28s%-21s%-21s", "     ", "gameCode", "currentIssue", "sequence", "state", "open time", "close time");
    print_tbl_header(win_type, tmp);

    for(i=0;i<MAX_GAME_NUMBER;i++)
    {
        ptr = gl_getGameData(i);
        if(ptr->used)
        {
            uint8 game_code = ptr->gameEntry.gameCode;
            char s_time[64];
            char c_time[64];
            ISSUE_INFO* issue_ptr = game_plugins_handle[game_code].get_currIssue();
            if (issue_ptr!=NULL)
            {
                ts_getDateFormat(issue_ptr->startTime, s_time);
                ts_getDateFormat(issue_ptr->closeTime, c_time);
                memset(tmp,0,sizeof(tmp));
                sprintf(tmp, "%-3d [ %2d %4s ]     %-16lld%-10d%-28s%-21s%-21s",
                    ln, ptr->gameEntry.gameCode,ptr->gameEntry.gameAbbr,
                    issue_ptr->issueNumber, issue_ptr->serialNumber, ISSUE_STATE_STR_S(issue_ptr->curState), s_time, c_time);
            }
            else
            {
                memset(tmp,0,sizeof(tmp));
                sprintf(tmp, "%-3d [ %2d %4s ]", ln, ptr->gameEntry.gameCode,ptr->gameEntry.gameAbbr);
            }
            ln++;

            if (game_list_data.currentSel==game_list_data.lineNum)
            {
                game_list_data.data[game_list_data.currentSel].escapt_type = GL_DISPLAY_EMPTY;
                game_list_data.data[game_list_data.currentSel].enter_type = GL_DISPLAY_GAME_ISSUE_LIST;
                game_list_data.data[game_list_data.currentSel].enter_index = (int)ptr->gameEntry.gameCode;
                print_tbl_line_str_reverse(win_type, game_list_data.lineNum+gl_issue_win_top_line, 2, tmp);
            }
            else
            {
                print_tbl_line_str(win_type, game_list_data.lineNum+gl_issue_win_top_line, 2, tmp);
            }
            game_list_data.lineNum++;
        }
    }
    return true;
}

int draw_game_i_datail( WINDOW_TYPE win_type)
{
    char tmp[256] = {0};
    uint8 game_code = game_detail_data.game_code;
    GAME_DATA *ptr = gl_getGameData(game_code);
    if ((ptr==NULL) || !ptr->used)
    {
        sprintf(tmp, "Game[ %d : %s] is not exist.", game_code, ptr->gameEntry.gameAbbr);
        print_tbl_header(win_type, tmp);
        return 0;
    }

    //输出table的标题
    sprintf(tmp, "Game[ %d : %s] parameter", ptr->gameEntry.gameCode, ptr->gameEntry.gameAbbr);
    print_tbl_header(win_type, tmp);

    //输出玩法 匹配 奖池规则参数表
	sprintf(tmp, "%-3s%-5s%-8s%-10s%-3s%-5s%-8s%-6s%-6s%-20s%-5s%-6s%-6s%-10s%-20s%-10s",
			"  ",
			"used", "subCode", "subAbbr", "s",
			"used", "divCode", "pCode", "sCode", "divName",
			"used", "pCode", "pType","pAmount", "pName",
			"poolAmount");
	print_tbl_line_str(win_type, gl_issue_win_top_line, 2, tmp);

	switch(game_code) {
	case GAME_SSQ:
		pluginParam = pluginParam_ssq;
		break;
	case GAME_3D:
		pluginParam = pluginParam_3D;
		break;
	case GAME_SSC:
		pluginParam = pluginParam_ssc;
		break;
	case GAME_KOCKENO:
		pluginParam = pluginParam_kockeno;
		break;
	case GAME_KOCK2:
		pluginParam = pluginParam_kock2;
		break;
	case GAME_KOC7LX:
		pluginParam = pluginParam_koc7lx;
		break;
	case GAME_KOCTTY:
		pluginParam = pluginParam_koctty;
		break;
	case GAME_FBS:
		pluginParam = pluginParam_fbs;
		break;
	case GAME_KOC11X5:
	    pluginParam = pluginParam_koc11X5;
	    break;
	}
	pluginParam(win_type, game_code);


    return true;
}

static int display_game_issue_list(WINDOW_TYPE win_type)
{
	char tmp[1024] = {0};
	int opage, page, sumpages, start_idx, maxIssueCnt;

    uint8 game_code = game_issue_list_data.game_code;
    GAME_DATA *gameData = gl_getGameData(game_code);
    if ((gameData==NULL) || !gameData->used)
    {
        sprintf(tmp, "Game[ %d : %s] is not exist.", game_code, gameData->gameEntry.gameAbbr);
        print_tbl_header(win_type, tmp);
        return 0;
    }

    maxIssueCnt = game_plugins_handle[game_code].get_issueMaxCount();

    if (game_code == GAME_FBS) {
        int j = 0;
        FBS_ISSUE *ptr_fbs = game_plugins_handle[game_code].fbs_get_issueTable();
        for (int i = 0; i < FBS_MAX_ISSUE_NUM; i++)
        {
            if(!ptr_fbs[i].used) {
                continue;
            }

            FBS_MATCH *match = ptr_fbs[i].match_array;
            for (int m = 0; m < FBS_MAX_ISSUE_MATCH; m++)
            {
                if (!match->used) {
                    match++;
                    continue;
                }
                match++;
                j++;
            }
        }

        //场次个数
        maxIssueCnt = j;

    }


    //输出table的标题
    sprintf(tmp, "%-6s%-13s%-13s%-28s%-21s%-21s%-21s", "INDEX", "SEQ/MATCH", "ISSUE_NUMBER", "CURRENT_STATUS",
            "START_TIME", "CLOSED_TIME", "AWARD_TIME");
    print_tbl_header(win_type, tmp);

    opage = game_issue_list_data.current_display_page;
    page = game_issue_list_data.current_display_page;

    start_idx = getStartIndexByPage(&page, &sumpages, maxIssueCnt, gl_issue_win_lins);
    game_issue_list_data.current_display_page = page;
    game_issue_list_data.page_start_index = start_idx;
    if (opage!=page) {
    	game_issue_list_data.currentSel = 0;
    }

    memset(tmp, 0, sizeof(tmp));
    for (int i = 0; i < gl_issue_win_lins; i++) {
    	print_tbl_line_str(win_type, i+gl_issue_win_top_line, 2, tmp);
    }

    //输出table 的明细
    game_issue_list_data.lineNum = 0;

    struct ISSUE_TMP{
        bool used;
        uint32 serialNumber;
        uint64 issueNumber;
        uint8 curState;
        time_type startTime;
        time_type closeTime;
        time_type drawTime;
        uint32 match_code;

    };
    ISSUE_TMP issue_tmp[256];
    memset(issue_tmp, 0, sizeof(issue_tmp));

    ISSUE_TMP *ptr = issue_tmp;
    if (game_code == GAME_FBS) {
        int j = 0;
        FBS_ISSUE *ptr_fbs = game_plugins_handle[game_code].fbs_get_issueTable();
        for (int i = 0; i < FBS_MAX_ISSUE_NUM; i++)
        {
            if(!ptr_fbs[i].used) {
                continue;
            }

            FBS_MATCH *match = ptr_fbs[i].match_array;
            for (int m = 0; m < FBS_MAX_ISSUE_MATCH; m++)
            {
                if (!match->used) {
                    match++;
                    continue;
                }
                ptr[j].used = true;
                ptr[j].issueNumber = ptr_fbs[i].issue_number;
                ptr[j].match_code = match->match_code;
                ptr[j].startTime = match->sale_time;
                ptr[j].closeTime = match->close_time;
                ptr[j].drawTime = match->draw_time;
                ptr[j].curState = match->state;
                match++;
                j++;
            }
        }

        //场次个数
        //maxIssueCnt = j;

    } else {
        int j = 0;
        ISSUE_INFO *ptr_other = game_plugins_handle[game_code].get_issueTable();
        for (int i = 0; i < maxIssueCnt; i++)
        {
            if(!ptr_other[i].used) {
                continue;
            }
            ptr[j].used = true;
            ptr[j].serialNumber = ptr_other[i].serialNumber;
            ptr[j].issueNumber = ptr_other[i].issueNumber;
            ptr[j].curState = ptr_other[i].curState;
            ptr[j].startTime = ptr_other[i].startTime;
            ptr[j].closeTime = ptr_other[i].closeTime;
            ptr[j].drawTime = ptr_other[i].drawTime;
            j++;
        }
    }

    //start_idx = getStartIndexByPage(&page, &sumpages, maxIssueCnt, gl_issue_win_lins);
    //game_issue_list_data.page_start_index = start_idx;

    ptr = issue_tmp + (page - 1) * gl_issue_win_lins;
    for (int i = game_issue_list_data.page_start_index; i < maxIssueCnt; i++) {
        if (!ptr->used) {
        	ptr++;
        	continue;
        }
    	if (game_issue_list_data.lineNum >= gl_issue_win_lins) {
            continue;
        } else {
    		memset(tmp, 0, sizeof(tmp));
            char s_time[64];
            char c_time[64];
            char a_time[64];

        	if (game_code == GAME_FBS) {
        		sprintf(tmp, "%-6d%-13d%-13lld%-28s%-21s%-21s%-21s",
						i,
						ptr->match_code,
						ptr->issueNumber,
						ISSUE_STATE_STR_S_FBS(ptr->curState),
						ts_getDateFormat(ptr->startTime, s_time),
						ts_getDateFormat(ptr->closeTime, c_time),
						ts_getDateFormat(ptr->drawTime, a_time));
        	} else {
				sprintf(tmp, "%-6d%-13d%-13lld%-28s%-21s%-21s%-21s",
						i,
						ptr->serialNumber,
						ptr->issueNumber,
                        ISSUE_STATE_STR_S(ptr->curState),
						ts_getDateFormat(ptr->startTime, s_time),
						ts_getDateFormat(ptr->closeTime, c_time),
						ts_getDateFormat(ptr->drawTime, a_time));
        	}

            if (game_issue_list_data.currentSel==game_issue_list_data.lineNum) {
            	game_issue_list_data.data[game_issue_list_data.currentSel].escapt_type = GL_DISPLAY_GAME_LIST;
            	game_issue_list_data.data[game_issue_list_data.currentSel].enter_type = GL_DISPLAY_GAME_ISSUE_DETAIL;
            	game_issue_list_data.data[game_issue_list_data.currentSel].enter_index_0 = ptr->issueNumber;
                print_tbl_line_str_reverse(win_type, game_issue_list_data.lineNum+gl_issue_win_top_line, 2, tmp);
            } else {
                print_tbl_line_str(win_type, game_issue_list_data.lineNum+gl_issue_win_top_line, 2, tmp);
            }
            game_issue_list_data.lineNum++;
            ptr++;
        }
    }

    //输出分页的信息
    sprintf(tmp, "- pages[%d] curpage[%d] -", sumpages, page );
    print_tbl_page_info(win_type, tmp);

    return true;
}

static int display_game_issue_detail(WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};
    int count = 0;

    uint8 game_code = game_issue_detail_data.game_code;
    uint64 issue_number = game_issue_detail_data.issue_number;
    GAME_DATA *ptr = gl_getGameData(game_code);
    if ((ptr==NULL) || !ptr->used)
    {
        sprintf(tmp, "Game[ %d : %s] is not exist.", game_code, ptr->gameEntry.gameAbbr);
        print_tbl_header(win_type, tmp);
        return 0;
    }

    struct ISSUE_TMP{
        uint32 serialNumber;
        uint64 issueNumber;
        uint8 curState;
        uint8 localState;
        time_type startTime;
        time_type closeTime;
        time_type drawTime;
        uint32 match_code;
        uint32 payEndDay;
        bool willSaleFlagGl;
        char drawCodeStr[MAX_GAME_RESULTS_STR_LEN];
        money_t issueSaleAmount;
        uint32 issueSaleCount;
        uint32 issueSaleBetCount;
        money_t issueCancelAmount;
        uint32 issueCancelCount;
        uint32 issueCancelBetCount;
        money_t issueRefuseAmount;
        uint32 issueRefuseCount;
    };
    ISSUE_TMP issue_tmp[256];
    memset(issue_tmp, 0, sizeof(issue_tmp));

    ISSUE_TMP *ptrTmp = issue_tmp;

    ISSUE_INFO *issue_ptr = NULL;
    FBS_ISSUE *issue_fbs_ptr = NULL;
    if (game_code == GAME_FBS) {
        issue_fbs_ptr = game_plugins_handle[game_code].fbs_get_issue(issue_number);
        if ( (issue_ptr==NULL) || (!issue_ptr->used) )
        {
            sprintf(tmp, "Game[ %d : %s ] Issue[ %lld ]is not exist or not used.", game_code, ptr->gameEntry.gameAbbr, issue_number);
            print_tbl_header(win_type, tmp);
            return 0;
        }

        return 0;

//        int j = 0;
//        for (int i = 0; i < FBS_MAX_ISSUE_NUM; i++)
//        {
//            if(!ptr_fbs[i].used) {
//                continue;
//            }
//
//            FBS_MATCH *match = ptr_fbs->match_array;
//            for (int m = 0; m < FBS_MAX_ISSUE_MATCH; m++)
//            {
//                if (!match->used) {
//                    match++;
//                    continue;
//                }
//                ptr[j].used = true;
//                ptr[j].issueNumber = ptr_fbs[i].issue_number;
//                ptr[j].match_code = match->match_code;
//                ptr[j].startTime = match->sale_time;
//                ptr[j].closeTime = match->close_time;
//                ptr[j].drawTime = match->draw_time;
//                ptr[j].curState = match->state;
//                j++;
//            }
//        }
//
//        FBS_MATCH *match = game_plugins_handle[game_code].fbs_get_match();
//        ptrTmp->serialNumber = issue_fbs_ptr->;
//        ptrTmp->startTime = issue_ptr->startTime;
//        ptrTmp->closeTime = issue_ptr->closeTime;
//        ptrTmp->drawTime = issue_ptr->drawTime;
//        ptrTmp->curState = issue_ptr->curState;
//        ptrTmp->localState = issue_ptr->localState;
//        ptrTmp->payEndDay = issue_ptr->payEndDay;
//        ptrTmp->willSaleFlagGl = issue_ptr->willSaleFlagGl;
//        memcpy(ptrTmp->drawCodeStr, issue_ptr->drawCodeStr, MAX_GAME_RESULTS_STR_LEN);
//        ptrTmp->issueSaleAmount = issue_ptr->stat.issueSaleAmount;
//        ptrTmp->issueSaleCount = issue_ptr->stat.issueSaleCount;
//        ptrTmp->issueSaleBetCount = issue_ptr->stat.issueSaleBetCount;
//        ptrTmp->issueCancelAmount = issue_ptr->stat.issueCancelAmount;
//        ptrTmp->issueCancelCount = issue_ptr->stat.issueCancelCount;
//        ptrTmp->issueCancelBetCount = issue_ptr->stat.issueCancelBetCount;
//        ptrTmp->issueRefuseAmount = issue_ptr->stat.issueRefuseAmount;
//        ptrTmp->issueRefuseCount = issue_ptr->stat.issueRefuseCount;

    } else {
        issue_ptr = game_plugins_handle[game_code].get_issueInfo(issue_number);
        if ( (issue_ptr==NULL) || (!issue_ptr->used) )
        {
            sprintf(tmp, "Game[ %d : %s ] Issue[ %lld ]is not exist or not used.", game_code, ptr->gameEntry.gameAbbr, issue_number);
            print_tbl_header(win_type, tmp);
            return 0;
        }

        ptrTmp->serialNumber = issue_ptr->serialNumber;
        ptrTmp->startTime = issue_ptr->startTime;
        ptrTmp->closeTime = issue_ptr->closeTime;
        ptrTmp->drawTime = issue_ptr->drawTime;
        ptrTmp->curState = issue_ptr->curState;
        ptrTmp->localState = issue_ptr->localState;
        ptrTmp->payEndDay = issue_ptr->payEndDay;
        ptrTmp->willSaleFlagGl = issue_ptr->willSaleFlagGl;
        memcpy(ptrTmp->drawCodeStr, issue_ptr->drawCodeStr, MAX_GAME_RESULTS_STR_LEN);
        ptrTmp->issueSaleAmount = issue_ptr->stat.issueSaleAmount;
        ptrTmp->issueSaleCount = issue_ptr->stat.issueSaleCount;
        ptrTmp->issueSaleBetCount = issue_ptr->stat.issueSaleBetCount;
        ptrTmp->issueCancelAmount = issue_ptr->stat.issueCancelAmount;
        ptrTmp->issueCancelCount = issue_ptr->stat.issueCancelCount;
        ptrTmp->issueCancelBetCount = issue_ptr->stat.issueCancelBetCount;
        ptrTmp->issueRefuseAmount = issue_ptr->stat.issueRefuseAmount;
        ptrTmp->issueRefuseCount = issue_ptr->stat.issueRefuseCount;
    }

    //输出table的标题
    sprintf(tmp, "  GAME[ %d : %s] ISSUE[ %lld ] INFORMATION", game_code, ptr->gameEntry.gameAbbr, issue_number);
    print_tbl_header(win_type, tmp);


    snprintf(tmp, sizeof(tmp), "issueNum [ %lld ]   issueSeqNumber [ %d ]", issue_number, ptrTmp->serialNumber);
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;

    snprintf(tmp, sizeof(tmp), "state [ %s ]   local state [ %s ]", ISSUE_STATE_STR_S(ptrTmp->curState), ISSUE_STATE_STR_S(ptrTmp->localState));
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;

    char s_time[64];
    char c_time[64];
    char d_time[64];
    ts_getDateFormat(ptrTmp->startTime, s_time);
    ts_getDateFormat(ptrTmp->closeTime, c_time);
    ts_getDateFormat(ptrTmp->drawTime, d_time);
    snprintf(tmp, sizeof(tmp), "start time [ %s ]   local state [ %s ]   draw time [ %s ]", s_time, c_time, d_time);
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;

    snprintf(tmp, sizeof(tmp), "Pay end day [ %d ]", ptrTmp->payEndDay);
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;

    snprintf(tmp, sizeof(tmp), "willSaleFlagGl [ %s ]", (ptrTmp->willSaleFlagGl==true)?"true":"false");
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;
    count++;

    snprintf(tmp, sizeof(tmp), "drawCodeStr [ %s ]", ptrTmp->drawCodeStr);
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;
    count++;

    snprintf(tmp, sizeof(tmp), "Issue statistics ------------------------------");
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;
    count++;

    snprintf(tmp, sizeof(tmp), "SALE      ->   Amount [ %12lld ]   TicketCount [ %8d ]   BetCount [ %8d ]",
            ptrTmp->issueSaleAmount, ptrTmp->issueSaleCount, ptrTmp->issueSaleBetCount);
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;

    snprintf(tmp, sizeof(tmp), "CANCEL    ->   Amount [ %12lld ]   TicketCount [ %8d ]   BetCount [ %8d ]",
            ptrTmp->issueCancelAmount, ptrTmp->issueCancelCount, ptrTmp->issueCancelBetCount);
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;

    snprintf(tmp, sizeof(tmp), "RK_REFUSE ->   Amount [ %12lld ]   TicketCount [ %8d ]",
            ptrTmp->issueRefuseAmount, ptrTmp->issueRefuseCount);
    print_tbl_line_str(win_type, count+gl_issue_win_top_line, 2, tmp);
    count++;

    return true;
}

int draw_win_gl_issue( WINDOW_TYPE win_type )
{
    if (gl_display_type != gl_display_type_keep)
    {
        //清除windows内容
        clear_tbl_win(win_type);

        //输出当前模块名
        print_tbl_module_name(win_type);

        gl_display_type_keep = gl_display_type;
    }

    if (gl_issue_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            draw_game_i_list(win_type);
            break;
        }
        case GL_DISPLAY_GAME_DETAIL:
        {
            draw_game_i_datail(win_type);
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_LIST:
        {
            display_game_issue_list(win_type);
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_DETAIL:
        {
            display_game_issue_detail(win_type);
            break;
        }
        default:
        {
            //log_error("gl display type error!!");
            break;
        }
    }
    refresh_tbl_win(win_type);

    return true;
}

//-------自定义函数-----------------------------------------------------------

int gl_issue_handle_key_left( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_issue_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            break;
        }
        case GL_DISPLAY_GAME_DETAIL:
        {
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_LIST:
        {
            game_issue_list_data.current_display_page--;
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_DETAIL:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_issue_handle_key_right( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_issue_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            break;
        }
        case GL_DISPLAY_GAME_DETAIL:
        {
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_LIST:
        {
            game_issue_list_data.current_display_page++;
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_DETAIL:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}


int gl_issue_handle_key_up( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_issue_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            game_list_data.currentSel--;
            if (game_list_data.currentSel<0)
                game_list_data.currentSel = game_list_data.lineNum-1;
            break;
        }
        case GL_DISPLAY_GAME_DETAIL:
        {
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_LIST:
        {
        	game_issue_list_data.currentSel--;
        	if (game_issue_list_data.currentSel<0) {
        		game_issue_list_data.currentSel = game_issue_list_data.lineNum-1;}
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_DETAIL:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_issue_handle_key_down( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_issue_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            game_list_data.currentSel++;
            if (game_list_data.currentSel>=game_list_data.lineNum)
                game_list_data.currentSel = 0;
            break;
        }
        case GL_DISPLAY_GAME_DETAIL:
        {
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_LIST:
        {
        	game_issue_list_data.currentSel++;
        	if (game_issue_list_data.currentSel >= game_issue_list_data.lineNum) {
        		game_issue_list_data.currentSel = 0;}
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_DETAIL:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_issue_handle_key_enter( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_issue_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            if (game_list_data.data[game_list_data.currentSel].enter_type!=GL_DISPLAY_EMPTY)
            {
                gl_display_type = game_list_data.data[game_list_data.currentSel].enter_type;
                //game_detail_data.game_code = game_list_data.data[game_list_data.currentSel].enter_index;
                game_issue_list_data.game_code = game_list_data.data[game_list_data.currentSel].enter_index;
            }
            break;
        }
        case GL_DISPLAY_GAME_DETAIL:
        {
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_LIST:
        {
            if (game_issue_list_data.data[game_issue_list_data.currentSel].enter_type!=GL_DISPLAY_EMPTY)
            {
                gl_display_type = game_issue_list_data.data[game_issue_list_data.currentSel].enter_type;
                game_issue_detail_data.game_code = game_issue_list_data.game_code;
                game_issue_detail_data.issue_number = game_issue_list_data.data[game_issue_list_data.currentSel].enter_index_0;
            }
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_DETAIL:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_issue_handle_key_escape( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_issue_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            break;
        }
        case GL_DISPLAY_GAME_DETAIL:
        {
            gl_display_type = GL_DISPLAY_GAME_LIST;
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_LIST:
        {
            gl_display_type = GL_DISPLAY_GAME_LIST;
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_DETAIL:
        {
            gl_display_type = GL_DISPLAY_GAME_ISSUE_LIST;
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_issue_handle_key_i(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_issue_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            if (game_list_data.data[game_list_data.currentSel].enter_type!=GL_DISPLAY_EMPTY)
            {
                gl_display_type = GL_DISPLAY_GAME_DETAIL;
                game_detail_data.game_code = game_list_data.data[game_list_data.currentSel].enter_index;
            }
            break;
        }
        case GL_DISPLAY_GAME_DETAIL:
        {
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_LIST:
        {
            break;
        }
        case GL_DISPLAY_GAME_ISSUE_DETAIL:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_issue_handle_key_h(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    //输出本窗口的帮助信息，再按一次'h'消失
    return true;
}

int handle_win_gl_issue( WINDOW_TYPE win_type, int ch )
{
    if (gl_issue_error_flag)
        return false;

    switch(ch)
    {
        case KEY_UP:
            gl_issue_handle_key_up(win_type);
            break;
        case KEY_DOWN:
            gl_issue_handle_key_down(win_type);
            break;
        case KEY_LEFT:
            gl_issue_handle_key_left(win_type);
            break;
        case KEY_RIGHT:
            gl_issue_handle_key_right(win_type);
            break;
        case 10:     //enter
            gl_issue_handle_key_enter(win_type);
            break;
        case 27:    //escapt
        case 96:    //`
            gl_issue_handle_key_escape(win_type);
            break;
        case 'i':
            gl_issue_handle_key_i(win_type);
            break;
        case 'h':
            gl_issue_handle_key_h(win_type);
            break;
        default:
            break;
    }
    draw_win_gl_issue(win_type);

    return true;
}

int command_win_gl_issue( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);
    if (gl_issue_error_flag)
        return false;

    return true;
}

int refresh_win_gl_issue( WINDOW_TYPE win_type)
{
    if (gl_issue_error_flag)
        return false;

    draw_win_gl_issue(win_type);
    return true;
}



#ifndef BI_INC_H_INCLUDED
#define BI_INC_H_INCLUDED


//系统部署编号，每套系统必须不一样
#define DEFAULT_SITE_ID     (0)


//定义系统的共享内存key值
#define BQ_SHM_KEY              1
#define NCPC_SHM_KEY            2
#define TMS_SHM_KEY             3
#define TFE_SHM_KEY             4
#define SYSDB_SHM_KEY           5
#define GL_SHM_KEY              10


//定义系统的SEM key值
#define TFE_SEM_KEY             181      // 181 ~ 190
#define TFE_SEM_KEY2            182


//定义系统的MSG Queue key值
#define NOTIFY_MSG_KEY          240


//定义系统常量
#define MAX_NCP_NUMBER          8

#define MAX_AGENCY_NUMBER       5000
#define MAX_TERMINAL_NUMBER     6000
#define MAX_TELLER_NUMBER       6000


//系统支持的游戏最大数目
#define MAX_GAME_NUMBER                16

//单个电子开奖游戏的最大RNG数目

#define MAX_RNG_NUMBER                 4

#define MAX_ISSUE_NUMBER               128

//投注字符串的最大长度
#define MAX_BET_STRING_LENGTH          (4096)

//游戏开奖结果字符串的最大长度
#define MAX_GAME_RESULTS_STR_LEN       128


#define MAX_TERM_FLOWNUMBER            999999
#define DEFAULT_TELLER_PASSWORD        111111



//FBS ------------
#define FBS_SUBTYPE_NUM                (6+1)  //定义玩法最大值
#define FBS_SUBTYPE_MAX_SEL_NUM        (26+1) //定义赛果选择最大值
#define FBS_MAX_TICKET_MATCH           20     //一张票场次最大值 (此参数是个定值，但单票最大场次数量是复用游戏交易控制参数里的maxBetLinePerTicket)
#define FBS_MAX_ISSUE_NUM              90     //主机内存保留的最大期数
#define FBS_MAX_ISSUE_MATCH            256    //一期中最大比赛数目
//#define MAX_FBS_COMPETITION_NUM        16     //最多的联赛数目





//通用宏定义
#define TSN_LENGTH                     (24+1)  //交易流水号的字符串长度，最后一个字节为字符串结束符'\0'

//TSN长度截取
#define D15                            100000000000000
#define D10                            1000000000


#define IDENTITY_CARD_LENGTH           18        //身份证号码长度
#define LOYALTY_CARD_LENGTH            20        //会员卡长度

#define MAX_DLL_URL_LENGTH             128       //最长下载URL长度

#define MAX_GAME_NAME_LENGTH           32
#define MAX_ORGANIZATION_NAME_LENGTH   128
#define ENTRY_NAME_LEN                 64

#define MAX_PATH_LENGTH                255

#define PATH_MAX_ME                    1024

#define INM_MSG_BUFFER_LENGTH          (1024*16)

#define CRC_SIZE                       2



#define PWD_MD5_LENGTH                 32

#define TIMER_INTERVAL                 5     //闹钟信号间隔时间(秒)

#define TICKET_SLOGAN_LENGTH           1024 //票面宣传语最大长度
#define AGENCY_ADDRESS_LENGTH          512  //销售站地址最大长度

#define APPLYFLOW_STRING_LENGTH        12  //审批编号长度


#endif


#ifndef _TMS_INF_H_INCLUDED
#define _TMS_INF_H_INCLUDED


/*=============================================================================
 模块名：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2006.09.12                           Tommy        Create File

 ============================================================================*/

/*=============================================================================
 * 包含系统文件
 * Includes System Files
 ============================================================================*/


/*=============================================================================
 * 包含本地文件
 * Include Files
 ============================================================================*/



/*=============================================================================
 * 常量定义，并对所定义的常量进行说明
 * Constant / Define Declarations
 ============================================================================*/
#pragma pack (1)

//for test
//#define MASK_CID(cid)  cid^0x12ff98ef
#define MASK_CID(cid)  cid


/******************************************************************************
**                 终端表结构体
**
******************************************************************************/
#define TERMINAL_MODEL_POS (50)
typedef struct _TMS_TERMINAL_RECORD
{
    bool   used;
    int32  index;
    uint64 token;
    uint32 token_last_update;

    uint64 termCode;
    uint64 agencyCode;
    uint32 areaCode;
    uint8  szMac[6];                //终端机标识码MAC
    uint8  workStatus;              //teller登录工作状态
    uint32 tellerCode;
    uint64 flowNumber;              //交易流水号

    int32  ncpIdx;                  //当前连接的NCP下标

    uint32 lastCommTime;            //终端最近交易时间

    bool   isBusy;                  //Busy标志
    uint32 msn;                     //通信消息序号

    uint32 timeStamp;               //网络延迟报告时间戳
    uint32 delayMilliSeconds;       //网络延迟时间(第一次收到报告为0)
    uint32 beginOnline;             //在线开始计算的时间戳
    uint32 spTimeStamp;

    uint32 retryCount;              //重试数量
    char   last_response[256];      //(售票、兑奖、退票)最后一笔业务响应消息
    uint16 last_crc;                //(售票、兑奖、退票)最后一笔业务请求消息CRC
}TMS_TERMINAL_RECORD;

typedef struct _TMS_DATABASE
{
    uint32 termCount;
    TMS_TERMINAL_RECORD     arrayTerm[MAX_TERMINAL_NUMBER];
    uint64 sequence; //用于生成流水，每晚切换session时重置
}TMS_DATABASE;

typedef TMS_DATABASE * TMS_DATABASE_PTR;

#pragma pack ()

struct TMS
{
    //共享内存的描述符
    int m_shm_id;
    //共享内存的地址
    void *m_shm_ptr;

    TMS()
    {
        m_shm_id=0;
        m_shm_ptr=NULL;
    }

    //创建tms共享内存，初始化共享内存的数据区
    bool TMSCreate();
    //释放tms
    bool TMSDestroy();
    //挂接共享内存
    bool TMSInit();
    //断开共享内存
    bool TMSClose();

    TMS_DATABASE_PTR getDatabasePtr() { return (TMS_DATABASE_PTR)m_shm_ptr; }

    void initTMSData();

    // Terminal --------------------------------------------------
    //通过索引值获得终端机
    TMS_TERMINAL_RECORD* getTermByIndex(int32 index);
    uint64 generate_token(int32 index);
    TMS_TERMINAL_RECORD* verify_token(uint64 token);
    //获得共享内存中在用终端机的数量
    uint32 getTermCount();
    //终端机认证成功(认证成功后添加)
    TMS_TERMINAL_RECORD* authTerm(uint64 termCode, uint64 agencyCode, uint32 areaCode, uint8 *mac, int32 ncpIdx);
    void clearTerm(int32 index);
    void resetTerm(int32 index);
    //登录成功后更新内存
    int32 signinTerm(int32 index, uint32 tellerCode, uint64 flow);
    //签退后更新内存
    int32 signoutTerm(int32 index);
    uint64 getSequence();
    void resetSequence();
    void setAllTermNoBusy();
};

//获取tms实例,并初始化tms的函数指针。如果是第一次使用，需要调用函数指针:createTMS ; 系统退出时需要调用函数指针:destoryTMS
//使用方式:第一步调用 getInstance_TMS，获取tms，第二步调用函数指针initTMS，第三步:调用函数指针closeTMS(断开共享内存)
TMS *tms_mgr();


int32 notify_agency_sale_bigAmount(uint64 agency_code, uint8 game_code, uint64 issue_number, money_t sale_amount, money_t available_amount);
int32 notify_agency_pay_bigAmount(uint64 agency_code, uint8 game_code, uint64 issue_number, money_t pay_amount, money_t available_amount);
int32 notify_agency_cancel_bigAmount(uint64 agency_code, uint8 game_code, uint64 issue_number, money_t cancel_amount, money_t available_amount);

#endif  //_TMS_INF_H_INCLUDED


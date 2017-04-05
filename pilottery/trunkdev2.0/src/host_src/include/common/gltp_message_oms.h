#ifndef GLTP_MESSAGE_OMS_H_INCLUDED
#define GLTP_MESSAGE_OMS_H_INCLUDED


//OMSר����Ӧ״̬��
typedef enum _OMS_RESULT_TYPE
{
    OMS_RESULT_SUCCESS                       = 0,   // ϵͳ���سɹ�
    OMS_RESULT_FAILURE                       = 1,   // ϵͳ����ʧ��

    OMS_RESULT_TICKET_NOT_FOUND_ERR          = 2,   // ���޴�Ʊ
    OMS_RESULT_TICKET_TSN_ERR                = 3,   // TSN����
    OMS_RESULT_BUSY_ERR                      = 4,   // ���ڴ���OMS��Ϣ��

    OMS_RESULT_GAME_DISABLE_ERR              = 5,   //��Ϸ������
    OMS_RESULT_GAME_SERVICETIME_OUT_ERR      = 6,   //��ǰ���ǲ�Ʊ����ʱ��

    OMS_RESULT_AGENCY_TYPE_ERR               = 7,   //����վ���ʹ���

    OMS_RESULT_PAY_DISABLE_ERR               = 8,   //��Ϸ���ɶҽ�
    OMS_RESULT_PAY_PAYING_ERR                = 9,   //��Ʊ���ڶҽ���
    OMS_RESULT_PAY_NOT_DRAW_ERR              = 10,  //��Ʊ�ڻ�û�п���
    OMS_RESULT_PAY_WAIT_DRAW_ERR             = 11,  //��Ʊ�ڵȴ��������
    OMS_RESULT_PAY_DAYEND_ERR                = 12,  //�ҽ������ѽ�ֹ
    OMS_RESULT_PAY_TRAINING_TICKET_ERR       = 13,  //����Ա����ѵƱ
    OMS_RESULT_PAY_NOT_WIN_ERR               = 14,  //��Ʊδ�н�
    OMS_RESULT_PAY_MULTI_ISSUE_ERR           = 15,  //����Ʊδ���
    OMS_RESULT_PAY_PAID_ERR                  = 16,  //��Ʊ�Ѷҽ�
    OMS_RESULT_PAY_MONEY_LIMIT_ERR           = 17,  //�ҽ������޶�

    OMS_RESULT_CANCEL_DISABLE_ERR            = 18,  //��Ϸ����ȡ��
    OMS_RESULT_CANCEL_AGAIN_ERR              = 19,  //��Ʊ����Ʊ
    OMS_RESULT_CANCEL_CANCELING_ERR          = 20,  //��Ʊ��Ʊ��
    OMS_RESULT_CANCEL_ISSUE_ERR              = 21,  //��Ʊ�ڴ������
    OMS_RESULT_CANCEL_TRAINING_TICKET_ERR    = 22,  //����Ա����ѵƱ
    OMS_RESULT_CANCEL_TIME_END_ERR           = 23,  //������Ʊʱ��
    OMS_RESULT_CANCEL_MONEY_LIMIT_ERR        = 24,  //��Ʊ�����޶�
    OMS_RESULT_CLAIMING_SCOPE_ERR            = 25,  //�����϶ҽ���Χ
    OMS_RESULT_LACK_AMOUNT_ERR               = 26,  //����վ�ֽ�����
    OMS_RESUTL_PAY_FORBID                    = 27,  //�����Ĳ������ҽ�
    OMS_RESUTL_CANCEL_FORBID                 = 28,  //�����Ĳ�������Ʊ
    OMS_RESUTL_CANCEL_NOT_ACCEPT             = 29,  //�������йر�,��������Ʊ
}OMS_RESULT_TYPE;

//------------------------------------------------------------------------------
// OMS��Ϣ����(����GLTP��Ϣͷ�е�func�ֶ�)
//------------------------------------------------------------------------------
typedef enum _GLTP_MESSAGE_OMS_TYPE
{
    //����
    GLTP_O_HB                               = 0,

    //ECHO
    GLTP_O_ECHO_REQ                         = 1,
    GLTP_O_ECHO_RSP                         = 2,

    //ϵͳ��--------------------------------------------------------------------
    //��ѯϵͳ����״̬
    GLTP_O_INQUIRY_SYSTEM_REQ               = 1001,
    GLTP_O_INQUIRY_SYSTEM_RSP               = 1002,

    //��Ϸ��--------------------------------------------------------------------
    //�޸���Ϸ���߲���
    GLTP_O_GL_POLICY_PARAM_REQ              = 2001,
    GLTP_O_GL_POLICY_PARAM_RSP              = 2002,

    //�޸���Ϸ��ͨ�������
    GLTP_O_GL_RULE_PARAM_REQ                = 2003,
    GLTP_O_GL_RULE_PARAM_RSP                = 2004,

    //�޸���Ϸ���Ʋ���
    GLTP_O_GL_CTRL_PARAM_REQ                = 2005,
    GLTP_O_GL_CTRL_PARAM_RSP                = 2006,

    //�޸���Ϸ���տ��Ʋ���
    GLTP_O_GL_RISK_CTRL_PARAM_REQ           = 2009,
    GLTP_O_GL_RISK_CTRL_PARAM_RSP           = 2010,

    //��Ϸ���ۿ���
    GLTP_O_GL_SALE_CTRL_REQ                 = 2011,
    GLTP_O_GL_SALE_CTRL_RSP                 = 2012,

    //��Ϸ�ҽ�����
    GLTP_O_GL_PAY_CTRL_REQ                  = 2013,
    GLTP_O_GL_PAY_CTRL_RSP                  = 2014,

    //��Ϸ��Ʊ����
    GLTP_O_GL_CANCEL_CTRL_REQ               = 2015,
    GLTP_O_GL_CANCEL_CTRL_RSP               = 2016,

    //��Ϸ�Զ���������
    GLTP_O_GL_AUTO_DRAW_REQ                 = 2017,
    GLTP_O_GL_AUTO_DRAW_RSP                 = 2018,

    //��Ϸ����ʱ������
    GLTP_O_GL_SERVICE_TIME_REQ              = 2019,
    GLTP_O_GL_SERVICE_TIME_RSP              = 2020,

    //��Ϸ�澯��ֵ����
    GLTP_O_GL_WARN_THRESHOLD_REQ            = 2021,
    GLTP_O_GL_WARN_THRESHOLD_RSP            = 2022,

    //�ڴ���--------------------------------------------------------------------
    //�����ڴ�
    GLTP_O_GL_ISSUE_DELETE_REQ              = 3001,
    GLTP_O_GL_ISSUE_DELETE_RSP              = 3002,

    //�ڴ����¿���(���ο���)
    GLTP_O_GL_ISSUE_SECOND_DRAW_REQ         = 3003,
    GLTP_O_GL_ISSUE_SECOND_DRAW_RSP         = 3004,

    //�ڽ� -> ��������¼��
    GLTP_O_GL_ISSUE_INPUT_DRAW_RESULT_REQ   = 3005,
    GLTP_O_GL_ISSUE_INPUT_DRAW_RESULT_RSP   = 3006,

    //�ڽ� -> ��Ϸ���ز��� (Ŀǰδʵ��)
    GLTP_O_GL_ISSUE_INPUT_POOL_REQ          = 3007,
    GLTP_O_GL_ISSUE_INPUT_POOL_RSP          = 3008,

    //�ڽ� -> ��������¼��
    GLTP_O_GL_ISSUE_INPUT_PRIZE_REQ         = 3009,
    GLTP_O_GL_ISSUE_INPUT_PRIZE_RSP         = 3010,

    //�ڽ� -> �ַ���������ժҪ
    GLTP_O_GL_ISSUE_FILE_MD5SUM_REQ         = 3011,
    GLTP_O_GL_ISSUE_FILE_MD5SUM_RSP         = 3012,

    //�ڽ� -> ����ȷ��
    GLTP_O_GL_ISSUE_DRAW_CONFIRM_REQ        = 3013,
    GLTP_O_GL_ISSUE_DRAW_CONFIRM_RSP        = 3014,

    //�ڽ� -> ���¿���(�������ο������̣����ڴ���Ҫ���¿���)
    GLTP_O_GL_ISSUE_REDO_DRAW_REQ           = 3015,
    GLTP_O_GL_ISSUE_REDO_DRAW_RSP           = 3016,

    //�����ڴ�֪ͨ��Ϣ
    GLTP_O_GL_ISSUE_ADD_NFY_REQ             = 3017,
    GLTP_O_GL_ISSUE_ADD_NFY_RSP             = 3018,

    //��Ʊ��--------------------------------------------------------------------
    //��Ʊ��ѯ
    GLTP_O_TICKET_INQUIRY_REQ               = 4001,
    GLTP_O_TICKET_INQUIRY_RSP               = 4002,
    //��Ʊ�ҽ�
    GLTP_O_TICKET_PAY_REQ                   = 4003,
    GLTP_O_TICKET_PAY_RSP                   = 4004,
    //��Ʊ��Ʊ
    GLTP_O_TICKET_CANCEL_REQ                = 4005,
    GLTP_O_TICKET_CANCEL_RSP                = 4006,

    //������--------------------------------------------------------------------
    //��������
    GLTP_O_AREA_ADD_REQ                     = 5001,
    GLTP_O_AREA_ADD_RSP                     = 5002,
    //�޸�����
    GLTP_O_AREA_MDY_REQ                     = 5003,
    GLTP_O_AREA_MDY_RSP                     = 5004,
    //ɾ������
    GLTP_O_AREA_DELETE_REQ                  = 5005,
    GLTP_O_AREA_DELETE_RSP                  = 5006,

    //��������վ��Ϸ��Ȩ
    GLTP_O_AREA_AGENCY_GAMECTRL_REQ         = 5007,
    GLTP_O_AREA_AGENCY_GAMECTRL_RSP         = 5008,
    //ǩ���ն�/����Ա
    GLTP_O_AREA_RESET_REQ                   = 5009,
    GLTP_O_AREA_RESET_RSP                   = 5010,
    //������Ϸ��Ȩ
    GLTP_O_AREA_GAME_REQ                    = 5011,
    GLTP_O_AREA_GAME_RSP                    = 5012,

    //����վ��-------------------------------------------------------------------
    //��������վ
    GLTP_O_AGENCY_ADD_REQ                   = 6001,
    GLTP_O_AGENCY_ADD_RSP                   = 6002,
    //�޸�����վ
    GLTP_O_AGENCY_MDY_REQ                   = 6003,
    GLTP_O_AGENCY_MDY_RSP                   = 6004,
    //����վ״̬����
    GLTP_O_AGENCY_STATUS_CTRL_REQ           = 6005,
    GLTP_O_AGENCY_STATUS_CTRL_RSP           = 6006,
    //�޸�����վ���ö��
    GLTP_O_AGENCY_MARGINALCREDIT_REQ        = 6007,
    GLTP_O_AGENCY_MARGINALCREDIT_RSP        = 6008,
    //��������վ
    GLTP_O_AGENCY_CLR_REQ                   = 6009,
    GLTP_O_AGENCY_CLR_RSP                   = 6010,

    //�ն���--------------------------------------------------------------------
    //�����ն�
    GLTP_O_TERM_ADD_REQ                     = 7001,
    GLTP_O_TERM_ADD_RSP                     = 7002,
    //�޸��ն�
    GLTP_O_TERM_MDY_REQ                     = 7003,
    GLTP_O_TERM_MDY_RSP                     = 7004,
    //�ն�״̬����
    GLTP_O_TERM_STATUS_CTRL_REQ             = 7005,
    GLTP_O_TERM_STATUS_CTRL_RSP             = 7006,

    //����Ա��-------------------------------------------------------------------
    //��������Ա
    GLTP_O_TELLER_ADD_REQ                   = 8001,
    GLTP_O_TELLER_ADD_RSP                   = 8002,
    //�޸�����Ա
    GLTP_O_TELLER_MDY_REQ                   = 8003,
    GLTP_O_TELLER_MDY_RSP                   = 8004,
    //����Ա״̬����
    GLTP_O_TELLER_STATUS_CTRL_REQ           = 8005,
    GLTP_O_TELLER_STATUS_CTRL_RSP           = 8006,
    //����Ա��������
    GLTP_O_TELLER_RESET_PWD_REQ             = 8007,
    GLTP_O_TELLER_RESET_PWD_RSP             = 8008,

    //�ʽ���--------------------------------------------------------------------
    //�ֹ��ɿ�
    //GLTP_O_AGNECY_DEPOSITAMOUNT_REQ         = 9001,
    //GLTP_O_AGNECY_DEPOSITAMOUNT_RSP         = 9002,

    //�汾��--------------------------------------------------------------------
    //����������
    GLTP_O_VERSION_ADD_REQ                  = 10001,
    GLTP_O_VERSION_ADD_RSP                  = 10002,
    //�޸�������
    GLTP_O_VERSION_MDY_REQ                  = 10003,
    GLTP_O_VERSION_MDY_RSP                  = 10004,
    //����������״̬
    GLTP_O_VERSION_STATUS_CTRL_REQ          = 10005,
    GLTP_O_VERSION_STATUS_CTRL_RSP          = 10006,

    //����---------------------------------------------------------------------
    //������֪ͨ��Ϣ
    GLTP_O_AREA_MESSAGE_REQ                 = 11001,
    GLTP_O_AREA_MESSAGE_RSP                 = 11002,
    //���²�ƱƱ�����
    GLTP_O_UPDATE_TICKET_SLOGAN_REQ         = 11003,
    GLTP_O_UPDATE_TICKET_SLOGAN_RSP         = 11004,
    //TMS��ֵ�趨
    GLTP_O_UPDATE_TMS_LIMITS_REQ            = 11005,
    GLTP_O_UPDATE_TMS_LIMITS_RSP            = 11006,


    //FBS ��Ϸ��---------------------------------------------------------------

    //��������֪ͨ��Ϣ
    GLTP_O_FBS_ADD_MATCH_NFY_REQ            = 12007,
    GLTP_O_FBS_ADD_MATCH_NFY_RSP            = 12008,

//    //��������
//    GLTP_O_FBS_DELETE_MATCH_REQ             = 12009,
//    GLTP_O_FBS_DELETE_MATCH_RSP             = 12010,

    //����/ͣ�ñ���
    GLTP_O_FBS_MATCH_STATUS_CTRL_REQ        = 12011,
    GLTP_O_FBS_MATCH_STATUS_CTRL_RSP        = 12012,

    //�޸ı����ر�ʱ��
    GLTP_O_FBS_MDY_MATCH_TIME_REQ           = 12013,
    GLTP_O_FBS_MDY_MATCH_TIME_RSP           = 12014,

    //�������� -> �������¼��
    GLTP_O_FBS_DRAW_INPUT_RESULT_REQ        = 12021,
    GLTP_O_FBS_DRAW_INPUT_RESULT_RSP        = 12022,

    //�������� -> �������ȷ����Ϣ
    GLTP_O_FBS_DRAW_CONFIRM_REQ             = 12023,
    GLTP_O_FBS_DRAW_CONFIRM_RSP             = 12024,



}GLTP_MESSAGE_OMS_TYPE;


#if 0

//ָ����1�ֽڶ���
#pragma pack (1)



//---------------------------------------------------------------------------------------------------
// FBS ��Ϣ����
//---------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ��Ʊ��ѯ(����/��Ӧ)
// ������Ϣ���� GLTP_O_FBS_TICKET_INQUIRY_REQ(12001)
// ��Ӧ��Ϣ���� GLTP_O_FBS_TICKET_INQUIRY_RSP(12002)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_INQUIRY_TICKET_REQ
{
    GLTP_MSG_O_HEADER  header;
    char   rspfn_ticket[TSN_LENGTH];
}GLTP_MSG_O_FBS_INQUIRY_TICKET_REQ;

//------------------------------------------------------------------------------
//��Ʊ�н���Ϣ�ṹ��
//------------------------------------------------------------------------------
//��Ʊʱ����ʾ���н�����Ϣ
typedef struct _GL_FBS_WIN_ORDER_INFO
{
    uint16    ord_no;                          //�𵥱��

    money_t   winningAmountWithTax;            //�н����
    int32     winningCount;                    //�н�ע��

    uint32    win_match_code;                  //����һ�������Ŀ����������н�
}GL_FBS_WIN_ORDER_INFO;
typedef struct _GLTP_MSG_O_FBS_INQUIRY_TICKET_RSP
{
    GLTP_MSG_O_HEADER header;
    uint32  status;                         //�ɹ�(0)

    char    rspfn_ticket[TSN_LENGTH];
    uint8   gameCode;                       //��Ϸ����
    char    gameName[MAX_GAME_NAME_LENGTH]; //��Ϸ����

    uint8   from_sale;                      //Ʊ��Դ

    uint64  issueNumber;                    //�����ں�

    uint64  ticketAmount;                   //Ʊ����

    uint8   isTrain;                        //�Ƿ���ѵģʽ: ��(0)/��(1)
    uint8   isCancel;                       //�Ƿ�����Ʊ:����Ʊ(1)
    uint8   isWin;                          //�Ƿ��н�:δ����(0) δ�н�(1) �н�(2)
    uint8   isBigPrize;                     //�Ƿ��Ǵ�

    uint64  amountBeforeTax;                //�н����(˰ǰ)
    uint64  taxAmount;                      //˰��
    uint64  amountAfterTax;                 //�н����(˰��)

    uint64  sale_termCode;                  //��Ʊ�ն˱���
    uint32  sale_tellerCode;                //��Ʊ����Ա����
    uint32  sale_time;                      //��Ʊʱ��

    uint8   isPayed;                        //�Ƿ��Ѷҽ�:δ�ҽ�(0) �Ѷҽ�(1)
    uint64  pay_termCode;                   //�ҽ��ն˱���
    uint32  pay_tellerCode;                 //�ҽ�����Ա����
    uint32  pay_time;                       //�ҽ�ʱ��
    uint32  issueNumber_pay;                //�ҽ�����ʱ����Ϸ�ں�

    uint64  cancel_termCode;                //��Ʊ�ն˱���
    uint32  cancel_tellerCode;              //��Ʊ����Ա����
    uint32  cancel_time;                    //��Ʊʱ��

    char    customName[ENTRY_NAME_LEN];     //��������
    uint8   cardType;                       //֤������:����֤(1)����(2)����֤(3)ʿ��֤(4)����֤(5)����֤��(9)
    char    cardCode[IDENTITY_CARD_LENGTH]; //֤������

    uint16  betStringLen;                   //Ͷע�ַ�������
    char    betString[];                    //Ͷע�ַ���

    //uint16  orderCount;                   //�𵥵�����
    //GL_FBS_WIN_ORDER_INFO orderArray[];
}GLTP_MSG_O_FBS_INQUIRY_TICKET_RSP;


//------------------------------------------------------------------------------
// ��Ʊ�ҽ�(����/��Ӧ)
// ������Ϣ���� GLTP_O_FBS_TICKET_PAY_REQ(12003)
// ��Ӧ��Ϣ���� GLTP_O_FBS_TICKET_PAY_RSP(12004)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_PAY_TICKET_REQ
{
    GLTP_MSG_O_HEADER header;

    char    rspfn_ticket[TSN_LENGTH];

    char    reqfn_ticket_pay[TSN_LENGTH]; //�ҽ���������ˮ��
    uint64  payAgencyCode;                //�ҽ���������վ����
}GLTP_MSG_O_FBS_PAY_TICKET_REQ;

typedef struct _GLTP_MSG_O_FBS_PAY_TICKET_RSP
{
    GLTP_MSG_O_HEADER header;
    uint32  status;

    char    rspfn_ticket_pay[TSN_LENGTH]; //�ҽ���Ӧ������ˮ��

    char    rspfn_ticket[TSN_LENGTH];
    char    reqfn_ticket[TSN_LENGTH];   //����������ˮ��

    uint64  payAgencyCode;              //�ҽ���������վ����
    uint8   gameCode;
    uint64  issueNumber;                //��ʼ���ں�
    uint32  saleTime;                   //����ʱ��

    money_t winningAmountWithTax;       //�н����(˰ǰ)
    money_t taxAmount;                  //˰��
    money_t winningAmount;              //�н����˰��
    uint32  transTimeStamp;             //����ʱ��

    uint16  betStringLen;               //Ͷע�ַ�������
    char    betString[];                //Ͷע�ַ���

    //uint16  orderCount;               //�𵥵�����
    //GL_FBS_WIN_ORDER_INFO orderArray[];
}GLTP_MSG_O_FBS_PAY_TICKET_RSP;


//------------------------------------------------------------------------------
// ��Ʊ��Ʊ(����/��Ӧ)
// ������Ϣ���� GLTP_O_FBS_TICKET_CANCEL_REQ(12005)
// ��Ӧ��Ϣ���� GLTP_O_FBS_TICKET_CANCEL_RSP(12006)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_CANCEL_TICKET_REQ
{
    GLTP_MSG_O_HEADER header;

    char    rspfn_ticket[TSN_LENGTH];

    char    reqfn_ticket_cancel[TSN_LENGTH]; //��Ʊ��������ˮ��
    uint64  cancelAgencyCode;                //��Ʊ��������վ����
}GLTP_MSG_O_FBS_CANCEL_TICKET_REQ;

typedef struct _GLTP_MSG_O_FBS_CANCEL_TICKET_RSP
{
    GLTP_MSG_O_HEADER header;
    uint32  status;

    char    rspfn_ticket_cancel[TSN_LENGTH]; //��Ʊ��Ӧ������ˮ��

    char    rspfn_ticket[TSN_LENGTH];
    char    reqfn_ticket[TSN_LENGTH];   //����������ˮ��

    uint64  cancelAgencyCode;           //��Ʊ����վ�����
    uint8   gameCode;
    uint64  issueNumber;                //�����ں�
    uint32  saleTime;                   //����ʱ��

    uint64  saleAgencyCode;             //��Ʊվ�����
    money_t cancelAmount;               //ȡ�����
    uint32  transTimeStamp;             //����ʱ��
    money_t commissionAmount;           //����Ӷ��
}GLTP_MSG_O_FBS_CANCEL_TICKET_RSP;



//------------------------------------------------------------------------------
// ��������֪ͨ��Ϣ
// ������Ϣ���� GLTP_O_FBS_ADD_MATCH_NFY_REQ(12007)
// ��Ӧ��Ϣʹ�ù���OMS������Ϣ, ��Ϣ����Ϊ GLTP_O_FBS_ADD_MATCH_NFY_RSP(12008)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_ADD_MATCH_NFY_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
}GLTP_MSG_O_FBS_ADD_MATCH_NFY_REQ;


//------------------------------------------------------------------------------
// ��������
// ������Ϣ���� GLTP_O_FBS_DELETE_MATCH_REQ(12009)
// ��Ӧ��Ϣʹ�ù���OMS������Ϣ, ��Ϣ����Ϊ GLTP_O_FBS_DELETE_MATCH_RSP(12010)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_DELETE_MATCH_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
    uint32  issueNumber;  //�ں�(���� 151025)
    uint32  matchCode; //ɾ���˳�����������б��� (�Ƚϱ�������Ĵ�С)
}GLTP_MSG_O_FBS_DELETE_MATCH_REQ;


//------------------------------------------------------------------------------
// ����/ͣ�ñ���
// ������Ϣ���� GLTP_O_FBS_MATCH_STATUS_CTRL_REQ(12011)
// ��Ӧ��Ϣʹ�ù���OMS������Ϣ, ��Ϣ����Ϊ GLTP_O_FBS_MATCH_STATUS_CTRL_RSP(12012)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_MATCH_STATUS_CTRL_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
    uint32  issueNumber;  //�ں�(���� 151025)
    uint32  matchCode; //ɾ���˳�����������б��� (�Ƚϱ�������Ĵ�С)
    uint8   enable;
}GLTP_MSG_O_FBS_MATCH_STATUS_CTRL_REQ;


//------------------------------------------------------------------------------
// ����������¼��������
// ������Ϣ���� GLTP_O_FBS_DRAW_INPUT_RESULT_REQ(12021)
// ��Ӧ��Ϣʹ�ù���OMS������Ϣ, ��Ϣ����Ϊ GLTP_O_FBS_DRAW_INPUT_RESULT_RSP(12022)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
    uint32  issueNumber;  //�ں�(���� 151025)
    uint32  matchCode;
    uint8   drawResults[FBS_SUBTYPE_NUM]; //���淨�Ŀ������ö��ֵ
    uint8   matchResult[8]; //�������,���ݸ�ʽ��������
                            // matchResult[0]  ->  fht_win_result (�ϰ볡�������  M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                            // matchResult[1]  ->  fht_home_goals (�ϰ볡���ӽ�����)
                            // matchResult[2]  ->  fht_away_goals (�ϰ볡�Ͷӽ�����)
                            // matchResult[3]  ->  sht_win_result (�°볡�������  M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                            // matchResult[4]  ->  sht_home_goals (�°볡���ӽ�����)
                            // matchResult[5]  ->  sht_away_goals (�°볡�Ͷӽ�����)
                            // matchResult[6]  ->  ft_win_result  (ȫ���������    M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                            // matchResult[7]  ->  first_goal     (�Ǹ������Ƚ���  M_TERM_HOME->1  or  M_TERM_AWAY->2)
}GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ;


//------------------------------------------------------------------------------
// �����������������ȷ����Ϣ
// ������Ϣ���� GLTP_O_FBS_DRAW_CONFIRM_REQ(12023)
// ��Ӧ��Ϣʹ�ù���OMS������Ϣ, ��Ϣ����Ϊ GLTP_O_FBS_DRAW_CONFIRM_RSP(12024)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_DRAW_CONFIRM_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
    uint32  issueNumber;  //�ں�(���� 151025)
    uint32  matchCode;
}GLTP_MSG_O_FBS_DRAW_CONFIRM_REQ;



//ȡ��ָ�����룬�ָ�ȱʡ����
#pragma pack ()

#endif

#endif //GLTP_MESSAGE_OMS_H_INCLUDED

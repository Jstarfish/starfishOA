#ifndef GLTP_MESSAGE_NOTIFY_H_INCLUDED
#define GLTP_MESSAGE_NOTIFY_H_INCLUDED

// NOTIFY�ĵȼ�
#define   _INFO   ((uint8)1)
#define   _WARN   ((uint8)2)
#define   _ERROR  ((uint8)3)
#define   _FATAL  ((uint8)4)


//------------------------------------------------------------------------------
// NOTIFY��Ϣ����(����GLTP��Ϣͷ�е�func�ֶ�)
//------------------------------------------------------------------------------
typedef enum _GLTP_MESSAGE_NOTIFY_TYPE
{
    // SYS NOTIFY ---------------------------------
    GLTP_NTF_SYS_TASK_FAULT                 = 7011,       //ϵͳ�����쳣
    GLTP_NTF_DB_EXCEPTION                   = 7012,       //���ݿ�����ʧ��
    GLTP_NTF_DB_DEAL_FALSE                  = 7013,       //���ݿ�ҵ��ִ��ʧ��

    // BQNET NOTIFY -------------------------------
    GLTP_NTF_BQ_BUFFER_NOTENOUGH            = 7021,       //BQueues Buffer���㱨���¼�
    GLTP_NTF_BQ_LINK_STATUS                 = 7022,       //BQueues��·״̬���

    // TFE NOTIFY ---------------------------------
    //703*

    // NCP NOTIFY  --------------------------------
    GLTP_NTF_NCP_STATUS                     = 7041,       //NCP����״̬�ı��¼�
    GLTP_NTF_NCP_LINK_STATUS                = 7042,       //NCP��·״̬�ı��¼�

    // GL NOTIFY ----------------------------------
    GLTP_NTF_GL_SALE_MONEY_WARN             = 7101,       //��Ʊ������۸澯
    GLTP_NTF_GL_PAY_MONEY_WARN              = 7102,       //��Ʊ���ҽ��澯
    GLTP_NTF_GL_CANCEL_MONEY_WARN           = 7103,       //��Ʊ���ȡ���澯

    GLTP_NTF_GL_CONTROL_GAME                = 7104,       //��Ϸ״̬�仯(�Ƿ�����ۡ��Ƿ�ɶҽ����Ƿ����Ʊ)
    GLTP_NTF_GL_ISSUE_STATUS                = 7105,       //�ڴ�״̬�仯
    GLTP_NTF_GL_ISSUE_FLOW_ERR              = 7107,       //�ڽ���̳��ִ���
    GLTP_NTF_GL_ISSUE_AUTO_DRAW             = 7108,       //��Ϸ�ڴ��Զ�����״̬�仯(�Զ�������Ϸ���Զ�������Ǹı�)

    GLTP_NTF_GL_RISK_CTRL                   = 7109,       //���տ��ƾ���
    GLTP_NTF_GL_ADJUST_RISK                 = 7110,       //���տ���������

    GLTP_NTF_GL_RNG_STATUS                  = 7111,       //RNG����״̬�仯
    GLTP_NTF_GL_RNG_WORK_STATUS             = 7112,       //RNG��·״̬�仯

    GLTP_NTF_GL_POLICY_PARAM                = 7113,       //�޸���Ϸ���߲���
    GLTP_NTF_GL_RULE_PARAM                  = 7114,       //�޸���Ϸ��ͨ�������
    GLTP_NTF_GL_CTRL_PARAM                  = 7115,       //�޸���Ϸ���Ʋ���
    //GLTP_NTF_GL_PRIZE_POOL                = 7116,       //�޸���Ϸ���ؽ��
    GLTP_NTF_GL_RISK_CTRL_PARAM             = 7117,       //�޸���Ϸ���տ��Ʋ���

    // FBS
    GLTP_NTF_GL_FBS_DRAW_ERR                = 7150,       //FBS�����������̳��ִ���
    GLTP_NTF_GL_FBS_DRAW_CONFIRM            = 7151,       //FBS��������ȷ�����

    // TMS NOTIFY  --------------------------------
    GLTP_NTF_TMS_AREA_ADD                   = 7201,       //��������
    GLTP_NTF_TMS_AREA_MODIFY                = 7202,       //�޸�����
    GLTP_NTF_TMS_AREA_STATUS                = 7203,       //�������״̬���
    GLTP_NTF_TMS_AREA_CTRL_GAME             = 7204,       //������Ȩ��Ϸ�������
    GLTP_NTF_TMS_AREA_CTRL_AGENCY_GAME      = 7205,       //��������վ��Ȩ��Ϸ�������

    GLTP_NTF_TMS_AGENCY_ADD                 = 7206,       //��������վ
    GLTP_NTF_TMS_AGENCY_MODIFY              = 7207,       //�޸�����վ
    GLTP_NTF_TMS_AGENCY_STATUS              = 7208,       //����վ����״̬
    GLTP_NTF_TMS_AGENCY_DEPOSIT             = 7210,       //����վ�ɿ�
    GLTP_NTF_TMS_AGENCY_CREDIT_LIMIT        = 7211,       //����վ���ö�ȱ��
    GLTP_NTF_TMS_AGENCY_PAY_TICKET_WARN     = 7212,       //����վÿ�նҽ�����(���߽��)������ֵ�澯
    GLTP_NTF_TMS_AGENCY_CANCEL_TICKET_WARN  = 7213,       //����վÿ����Ʊ����(���߽��)������ֵ�澯

    GLTP_NTF_TMS_TERM_ADD                   = 7214,       //�����ն˻�
    GLTP_NTF_TMS_TERM_MODIFY                = 7215,       //�޸��ն˻�
    GLTP_NTF_TMS_TERM_STATUS                = 7216,       //�ն˻�����״̬
    //GLTP_NTF_TMS_TERM_LINK_STATUS           = 7217,       //�ն˻���·״̬
    //GLTP_NTF_TMS_TERM_SIGN_STATUS           = 7218,       //�ն˻���¼/ǩ���¼�
    GLTP_NTF_TMS_TERM_MSN_ERR               = 7219,       //�ն˻�MSN����
    GLTP_NTF_TMS_TERM_BUSY_ERR              = 7220,       //�ն˻�BUSY����

    GLTP_NTF_TMS_TELLER_ADD                 = 7221,       //��������Ա�¼�
    GLTP_NTF_TMS_TELLER_MODIFY              = 7222,       //�޸�����Ա�¼�
    GLTP_NTF_TMS_TELLER_STATUS              = 7223,       //����Ա����״̬�¼�

    GLTP_NTF_TMS_VERSION_ADD                = 7224,       //���Ӱ汾��Ϣ�¼�
    GLTP_NTF_TMS_VERSION_MODIFY             = 7225,       //�޸İ汾��Ϣ�¼�
    GLTP_NTF_TMS_VERSION_STATUS             = 7226,       //�汾����״̬�¼�

}GLTP_MESSAGE_NOTIFY_TYPE;



//ָ����1�ֽڶ���
#pragma pack (1)



//------------------------------------------------------------------------------
// GLTP-NOTIFY��Ϣͷ(����GLTP��Ϣͷ�ֶ�)
// �����Ϣʱ, type�ֶ���GLTP_MSG_TYPE_NOTIFY(7), func�ֶ���NOTIFY��Ϣ����.
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_NTF_HEADER
{
    //GLTP_MSG_HEADER
    uint16  length;        //��Ϣ����
    uint8   type;          //��Ϣ����  OMS(0),����վ-�ն�(1),������(2)
    uint16  func;          //��Ϣ����
    uint32  when;          //ʱ���(����)

    uint8   level;         //NOTIFY�ĵȼ�

    char data[];
}GLTP_MSG_NTF_HEADER;
#define GLTP_MSG_NTF_HEADER_LEN sizeof(GLTP_MSG_NTF_HEADER)



//------------------------------------------------------------------------------
// SYS NOTIFY
//------------------------------------------------------------------------------

//����״̬���<�쳣����> GLTP_NTF_SYS_TASK_FAULT(7011)
typedef struct _GLTP_MSG_NTF_SYS_TASK_FAULT
{
    char  taskName[64];                     //��������
}GLTP_MSG_NTF_SYS_TASK_FAULT;

//���ݿ�����ʧ�� GLTP_NTF_DB_EXCEPTION(7012)
typedef struct _GLTP_MSG_NTF_DB_EXCEPTION
{
    uint8 db_type;                          //OMS(1),MIS(2)
}GLTP_MSG_NTF_DB_EXCEPTION;

//���ݿ�ҵ��ִ��ʧ�� GLTP_NTF_DB_DEAL_FALSE(7013)
typedef struct _GLTP_MSG_NTF_DB_DEALFALSE
{
    char dealFalse[256];                  //����oracle����ʧ�ܵĽӿ�����
}GLTP_MSG_NTF_DB_DEALFALSE;

//------------------------------------------------------------------------------
// BQ NOTIFY
//------------------------------------------------------------------------------

//BQ Buffer���㱨���¼� GLTP_NTF_BQ_BUFFER_NOTENOUGH(7021)
typedef struct _GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH
{
    uint8    bufferType;                    //Buffer����
    uint32   remainBuffNum;                 //��ǰʣ��Buffer��Ŀ
}GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH;

//BQueues��·״̬��� GLTP_NTF_BQ_LINK_STATUS(7022)
typedef struct _GLTP_MSG_NTF_BQ_LINK_STATUS
{
    char   AModIP[16];                       //Aģ��IP
    char   BModIP[16];                       //Bģ��IP
    uint8  linkState;                        //��·״̬  �Ͽ�(0),����(1)
}GLTP_MSG_NTF_BQ_LINK_STATUS;



//------------------------------------------------------------------------------
// TFE NOTIFY
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// NCP NOTIFY
//------------------------------------------------------------------------------

//NCP����״̬�ı��¼� GLTP_NTF_NCP_STATUS(7041)
typedef struct _GLTP_MSG_NTF_NCP_STATUS
{
    uint32  ncpCode;                        //NCP����
    uint8   type;                           //NCP����
    char    ipaddr[16];                     //IP��ַ
    uint8   status;                         //NCP����״̬ enum STATUS_TYPE
}GLTP_MSG_NTF_NCP_STATUS;

//NCP��·״̬�ı��¼� GLTP_NTF_NCP_LINK_STATUS(7042)
typedef struct _GLTP_MSG_NTF_NCP_LINK
{
    uint32  ncpCode;                        //NCP����
    uint8   type;                           //NCP����
    char    ipaddr[16];                     //IP��ַ
    uint8   connect;                        //��·״̬ ����(0),�Ͽ�(1)
}GLTP_MSG_NTF_NCP_LINK;



//------------------------------------------------------------------------------
// GL NOTIFY
//------------------------------------------------------------------------------

//��Ʊ�������۸澯 GLTP_NTF_GL_SALE_MONEY_WARN(7101)
typedef struct _GLTP_MSG_NTF_GL_SALE_MONEY_WARN
{
    uint8   gameCode;                       //��Ϸ����
    uint64  issueNumber;                    //��Ʊ�ں�
    uint64  agencyCode;                     //����վ����
    money_t salesAmount;                    //Ʊ���۽��
    money_t availableCredit;                //�˻����
}GLTP_MSG_NTF_GL_SALE_MONEY_WARN;

//��Ʊ���ҽ��澯 GLTP_NTF_GL_PAY_MONEY_WARN(7102)
typedef struct _GLTP_MSG_NTF_GL_PAY_MONEY_WARN
{
    uint8   gameCode;                       //��Ϸ����
    uint64  issueNumber;                    //��Ʊ��Ʊʱ���ں�
    uint64  agencyCode;                     //����վ����
    money_t payAmount;                      //Ʊ�ҽ����
    money_t availableCredit;                //�˻����
}GLTP_MSG_NTF_GL_PAY_MONEY_WARN;

//��Ʊ���ȡ���澯 GLTP_NTF_GL_CANCEL_MONEY_WARN(7103)
typedef struct _GLTP_MSG_NTF_GL_CANCEL_MONEY_WARN
{
    uint8   gameCode;                       //��Ϸ����
    uint64  issueNumber;                    //��Ʊ��Ʊʱ���ں�
    uint64  agencyCode;                     //����վ����
    money_t cancelAmount;                   //Ʊȡ�����
    money_t availableCredit;                //�˻����
}GLTP_MSG_NTF_GL_CANCEL_MONEY_WARN;

//��Ϸ״̬�仯(�Ƿ�����ۡ��Ƿ�ɶҽ����Ƿ����Ʊ) GLTP_NTF_GL_CONTROL_GAME(7104)
typedef struct _GLTP_MSG_NTF_GL_CONTROL_GAME
{
    uint8   gameCode;                       //��Ϸ����
    uint8   flag;                           //�������� ����(1),�ҽ�(2),ȡ��(3)
    uint8   status;                         //�޸ĺ��״̬ ������(0),����(1)
}GLTP_MSG_NTF_GL_CONTROL_GAME;

//�ڴ�״̬�仯 GLTP_NTF_GL_ISSUE_STATUS(7105)
typedef struct _GLTP_MSG_NTF_GL_ISSUE_STATUS
{
    uint8   gameCode;                       //��Ϸ����
    uint32  issueNumber;                    //�ڴα��
    uint8   nowStatus;                      //�ڴε�ǰ״̬
    uint32  nowtime;                        //��ǰʱ��
}GLTP_MSG_NTF_GL_ISSUE_STATUS;

//�ڽ���̳��ִ��� GLTP_NTF_GL_ISSUE_FLOW_ERR(7107)
typedef struct _GLTP_MSG_NTF_GL_ISSUE_FLOW_ERR
{
    uint8   gameCode;                       //��Ϸ����
    uint32  issueNumber;                    //�ڴα��
    uint8   issueStatus;                    //�ڴ�״̬
    uint8   error;                          //�ڴδ�����
}GLTP_MSG_NTF_GL_ISSUE_FLOW_ERR;

//��Ϸ�ڴ��Զ�����״̬�仯(�Զ�������Ϸ���Զ�������Ǹı�) GLTP_NTF_GL_ISSUE_AUTO_DRAW(7108)
typedef struct _GLTP_MSG_NTF_GL_ISSUE_AUTO_DRAW
{
    uint8   gameCode;                       //��Ϸ����

    uint8   status;                         //�޸ĺ��״̬ ������(0),����(1)
}GLTP_MSG_NTF_GL_ISSUE_AUTO_DRAW;

//���տ��ƾ��� GLTP_NTF_GL_RISK_CTRL(7109)
typedef struct _GLTP_MSG_NTF_GL_RISK_CTRL
{
    uint8   gameCode;                       //��Ϸ����

    uint32  issueNumber;                    //�ڴα��
    uint8   subType;                        //��Ϸ�淨
    char    betNumber[32];                  //Ͷע�����ַ���
}GLTP_MSG_NTF_GL_RISK_CTRL;

//���տ��������� GLTP_NTF_GL_ADJUST_RISK(7110)
typedef struct _GLTP_MSG_NTF_GL_ADJUST_RISK
{
    uint8   gameCode;                       //��Ϸ����

    uint8   subType;                        //��Ϸ�淨
    uint32  adjustStep;                     //��������
}GLTP_MSG_NTF_GL_ADJUST_RISK;

//RNG����״̬�ı��¼� GLTP_NTF_GL_RNG_STATUS(7111)
typedef struct _GLTP_MSG_NTF_GL_RNG_STATUS
{
    uint32  rngId;                          //RNG�����ڴ�����ֵ

    uint8   status;                         //RNG����״̬ enum STATUS_TYPE
    uint8   mac[6];                         //RNG MAC��ַ
    char    ipaddr[16];                     //RNG IP��ַ
}GLTP_MSG_NTF_GL_RNG_STATUS;

//RNG��·״̬�ı��¼� GLTP_NTF_GL_RNG_WORK_STATUS(7112)
typedef struct _GLTP_MSG_NTF_GL_RNG_WORK_STATUS
{
    uint32  rngId;                          //RNG�����ڴ�����ֵ

    uint8   workStatus;                     //RNG ����״̬ 0=δ����  1=������ 2=��������
    uint8   mac[6];                         //RNG MAC��ַ
    char    ipaddr[16];                     //RNG IP��ַ
}GLTP_MSG_NTF_GL_RNG_WORK_STATUS;

//�޸���Ϸ���߲��� GLTP_NTF_GL_POLICY_PARAM(7113)
typedef struct _GLTP_MSG_NTF_GL_POLICY_PARAM
{
    uint8   gameCode;                       //��Ϸ����

    uint16  publicFundRate;                 //��������
    uint16  adjustmentFundRate;             //���ڻ������
    uint16  returnRate;                     //���۷�����
    uint64  taxStartAmount;                 //��˰������(��λ:��)
    uint16  taxRate;                        //��˰ǧ�ֱ�
    uint16  payEndDay;                      //�ҽ���
}GLTP_MSG_NTF_GL_POLICY_PARAM;

//�޸���Ϸ��ͨ������� GLTP_NTF_GL_RULE_PARAM(7114)
typedef struct _GLTP_MSG_NTF_GL_RULE_PARAM
{
    uint8   gameCode;                       //��Ϸ����

    uint32  maxTimesPerBetLine;             //���������<=99
    uint32  maxBetLinePerTicket;            //��Ʊ���Ͷע����<=10
    uint32  maxAmountPerTicket;             //��Ʊ��������޶�(��)<=2000000
}GLTP_MSG_NTF_GL_RULE_PARAM;

//�޸���Ϸ���Ʋ��� GLTP_NTF_GL_CTRL_PARAM(7115)
typedef struct _GLTP_MSG_NTF_GL_CTRL_PARAM
{
    uint8   gameCode;                       //��Ϸ����

    uint32  cancelTime;                     //������Ʊʱ��
    uint32  countDownTimes;                 //��Ϸ�ڹر�����ʱ��(��)

}GLTP_MSG_NTF_GL_CTRL_PARAM;

//�޸���Ϸ���տ��Ʋ��� GLTP_NTF_GL_RISK_CTRL_PARAM(7117)
typedef struct _GLTP_MSG_NTF_GL_RISK_CTRL_PARAM
{
    uint8   gameCode;                       //��Ϸ����
    uint8   riskCtrl;
    uint32  strLength;                      //���տ����ַ�������
    char    riskCtrlStr[512];               //���տ����ַ���
}GLTP_MSG_NTF_GL_RISK_CTRL_PARAM;



//------------------------------------------------------------------------------
// FBS Draw NOTIFY
//------------------------------------------------------------------------------

//FBS �����������̳��ִ��� GLTP_NTF_GL_FBS_DRAW_ERR(7150)
typedef struct _GLTP_MSG_NTF_GL_FBS_DRAW_ERR
{
    uint8   gameCode;                       //��Ϸ����
    uint32  issueNumber;                    //�ڴα��
    uint32  matchCode;                      //�������
    uint8   matchStatus;                    //����״̬
    uint8   error;                          //�ڴδ�����
}GLTP_MSG_NTF_GL_FBS_DRAW_ERR;

//FBS ����������� GLTP_NTF_GL_FBS_DRAW_CONFIRM(7151)
typedef struct _GLTP_MSG_NTF_GL_FBS_DRAW_CONFIRM
{
    uint8   gameCode;                       //��Ϸ����
    uint32  issueNumber;                    //�ڴα��
    uint32  matchCode;                      //�������
}GLTP_MSG_NTF_GL_FBS_DRAW_CONFIRM;



//------------------------------------------------------------------------------
// TMS NOTIFY
//------------------------------------------------------------------------------

//�ն˻�MSN���� GLTP_NTF_TMS_TERM_MSN_ERR(7219)
typedef struct _GLTP_MSG_NTF_TMS_TERM_MSN_ERR
{
    uint64  termCode;                       //�ն˻�����

    uint8   szTermMac[6];                   //�ն˻�MAC��ַ
    uint8   recvMsn;                        //�ն˻������MSN
    uint8   msn;                            //ϵͳ������ն˻�MSN
}GLTP_MSG_NTF_TMS_TERM_MSN_ERR;

//�ն˻�BUSY���� GLTP_NTF_TMS_TERM_BUSY_ERR(7220)
typedef struct _GLTP_MSG_NTF_TMS_TERM_BUSY_ERR
{
    uint64  termCode;                       //�ն˻�����

    uint8   szTermMac[6];                   //�ն˻�MAC��ַ
}GLTP_MSG_NTF_TMS_TERM_BUSY_ERR;




//ȡ��ָ�����룬�ָ�ȱʡ����
#pragma pack ()


#endif //GLTP_MESSAGE_NOTIFY_H_INCLUDED




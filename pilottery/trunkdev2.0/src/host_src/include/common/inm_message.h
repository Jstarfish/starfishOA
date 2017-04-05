#ifndef INM_MESSAGE_H_INCLUDED
#define INM_MESSAGE_H_INCLUDED


//------------------------------------------------------------------------------
// INM ��Ϣ����
//------------------------------------------------------------------------------
typedef enum _INM_MSG_TYPE {
    INM_TYPE_NULL                           = 0,

    // ncp ---------------------------------------------------------------------
    INM_TYPE_N_HB                           = 1,
    INM_TYPE_N_ECHO                         = 2,

    // terminal ----------------------------------------------------------------
    INM_TYPE_T_ECHO                         = 3,
    INM_TYPE_T_AUTH                         = 4,     //Terminal��֤��Ϣ
    INM_TYPE_T_VERSION_INQUIRY              = 5,     //�汾��֤��Ϣ
    INM_TYPE_T_SELL_TICKET                  = 6,     //(TF) Terminal��Ʊ����
    INM_TYPE_T_PAY_TICKET                   = 7,     //(TF) Terminal��Ʊ�ҽ�
    INM_TYPE_T_CANCEL_TICKET                = 8,     //(TF) Terminal��Ʊȡ��

    INM_TYPE_T_SIGNIN                       = 9,     //(TF) Terminal����Ա��¼��Ϣ
    INM_TYPE_T_SIGNOUT                      = 10,    //(TF) Terminal����Աǩ����Ϣ
    INM_TYPE_T_CHANGE_PWD                   = 11,    //(TF) Terminal����Ա�޸�����

    INM_TYPE_T_AGENCY_BALANCE               = 12,    //��ѯ����վ���

    INM_TYPE_T_INQUIRY_TICKET_DETAIL        = 13,    //��ѯ��Ʊ��ϸ
    INM_TYPE_T_GAME_INFO                    = 14,    //������Ϸ��Ϣ

    INM_TYPE_T_GAME_DRAW_ANNOUNCE           = 15,    //������Ϸ��������

    INM_TYPE_T_OPEN_GAME_UNS                = 16,    //��Ϸ�ڴο���
    INM_TYPE_T_CLOSE_SECONDS_UNS            = 17,    //��Ϸ�ڴμ����ر�
    INM_TYPE_T_CLOSE_GAME_UNS               = 18,    //��Ϸ�ڴιر�
    INM_TYPE_T_DRAW_ANNOUNCE_UNS            = 19,    //��Ϸ�ڴο�������

    INM_TYPE_T_RESET_UNS                    = 20,    //ǩ���ն˻�(����Ա)
    INM_TYPE_T_MESSAGE_UNS                  = 21,    //�ն˻�֪ͨ��Ϣ

    // AccessProcider (AP) -----------------------------------------------------

    INM_TYPE_AP_INQUIRY_TICKET              = 22,    //AP��ѯ��Ʊ��Ʊ״̬
    INM_TYPE_AP_INQUIRY_ISSUE               = 25,    //AP��ѯ��Ϸ��ǰ��
    INM_TYPE_AP_ISSUE_STATE                 = 26,    //AP��ѯ��Ϸ����Ԥ����

    INM_TYPE_AP_ECHO                        = 30,

    // zot ---------------------------------------------------------------------
    //tfe
    INM_TYPE_TFE_CHECK_POINT                = 31,    //(TF) CheckPoint��¼

    //system
    INM_TYPE_SYS_SWITCH_SESSION             = 32,    //(TF) �ս���л���¼

    //system
    INM_TYPE_SYS_BUSINESS_STATE             = 33,    //(TF) ϵͳ����״̬�л���BUSINESS�ļ�¼

    //rng status change message
    INM_TYPE_RNG_STATUS                     = 35,    //(TF) RNG״̬�ı���Ϣ

    //game issue state
    INM_TYPE_ISSUE_STATE_PRESALE            = 36,    //(TF) Issue�����Ϸ�ڴο�Ԥ��
    INM_TYPE_ISSUE_STATE_OPEN               = 37,    //(TF) Issue�����Ϸ��ǰ�ڴ�
    INM_TYPE_ISSUE_STATE_CLOSING            = 38,    //(TF) Issue�ڼ����ر�
    INM_TYPE_ISSUE_STATE_CLOSED             = 39,    //(TF) Issue��Ϸ�ڹر�   �����Ϸ��ʼ����Ϊֹͣ
    INM_TYPE_ISSUE_STATE_SEALED             = 40,    //(TF) Issue���ݷ�����
    INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED    = 41,    //(TF) Issue����������¼��
    INM_TYPE_ISSUE_STATE_MATCHED            = 42,    //(TF) Issue�����Ѿ�ƥ��
    INM_TYPE_ISSUE_STATE_FUND_INPUTED       = 43,    //(TF) Issue�ߵȽ����ܶ������ܶ���ڻ����ܶ���л����ܶ�   ��¼��
    INM_TYPE_ISSUE_STATE_LOCAL_CALCED       = 44,    //(TF) Issue�����㽱���
    INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED     = 45,    //(TF) Issue�����������
    INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED    = 46,    //(TF) Issue����ȷ��
    INM_TYPE_ISSUE_STATE_DB_IMPORTED        = 47,    //(TF) Issue�н�������¼�����ݿ�
    INM_TYPE_ISSUE_STATE_ISSUE_END          = 48,    //(TF) Issue�ڽ�ȫ�����

    INM_TYPE_ISSUE_SALE_FILE_MD5SUM         = 49,    // �ַ���������ժҪ
    INM_TYPE_ISSUE_DRAW_REDO                = 50,    //(TF) Issue�����ڽ�����  (���¿���)
    INM_TYPE_ISSUE_SECOND_DRAW              = 51,    //(TF) �ڴ����¿���(���ο���)


    // OMS ---------------------------------------------------------------------
    INM_TYPE_O_HB                           = 52,
    INM_TYPE_O_ECHO                         = 53,
    INM_TYPE_O_COMMON                       = 54,    //OMS INM��Ϣ,ֻ����ͷ����Ϣ

    INM_TYPE_O_INQUIRY_SYSTEM               = 55,    //(��ѯϵͳ����״̬)

    INM_TYPE_O_GL_POLICY_PARAM              = 56,    //(TF) OMS�޸���Ϸ���߲���
    INM_TYPE_O_GL_RULE_PARAM                = 57,    //(TF) OMS�޸���Ϸ��ͨ�������
    INM_TYPE_O_GL_CTRL_PARAM                = 58,    //(TF) OMS�޸���Ϸ���Ʋ���
    INM_TYPE_O_GL_RISK_CTRL_PARAM           = 59,    //(TF) OMS�޸���Ϸ���տ��Ʋ���
    INM_TYPE_O_GL_SALE_CTRL                 = 60,    //(TF) OMS��Ϸ���ۿ���
    INM_TYPE_O_GL_PAY_CTRL                  = 61,    //(TF) OMS��Ϸ�ҽ�����
    INM_TYPE_O_GL_CANCEL_CTRL               = 62,    //(TF) OMS��Ϸ��Ʊ����
    INM_TYPE_O_GL_AUTO_DRAW                 = 63,    //(TF) OMS��Ϸ�Զ���������
    INM_TYPE_O_GL_SERVICE_TIME              = 64,    //(TF) OMS��Ϸ����ʱ������
    INM_TYPE_O_GL_WARN_THRESHOLD            = 65,    //(TF) OMS��Ϸ�澯��ֵ����

    INM_TYPE_O_GL_ISSUE_ADD_NFY             = 66,    //(TF) OMS�����ڴ�֪ͨ
    INM_TYPE_O_GL_ISSUE_DEL                 = 67,    //(TF) OMSɾ���ڴ�

    INM_TYPE_O_PAY_TICKET                   = 68,    //OMS��Ʊ�ҽ�
    INM_TYPE_O_CANCEL_TICKET                = 69,    //OMS��Ʊȡ��
    INM_TYPE_O_INQUIRY_TICKET               = 70,    //OMS��Ʊ��ѯ

    INM_TYPE_T_MESSAGE_ERR                  = 100,   //�ն˻�������Ϣ
    INM_TYPE_T_GAME_ISSUE                   = 110,   //������Ϸ��ǰ�ڴ���Ϣ

    //retry message
    INM_TYPE_T_RETRY                        = 111,   //�ڲ�retry��Ϣ��¼

    INM_TYPE_T_INQUIRY_WIN                  = 112,   //��ѯ�н���Ʊ��ϸ

    //fbs message for terminal
    INM_TYPE_FBS_MATCH_INFO                 = 150,   //��ѯ������Ϣ
    INM_TYPE_FBS_SELL_TICKET                = 151,   //��Ʊ
    INM_TYPE_FBS_PAY_TICKET                 = 152,   //�ҽ�
    INM_TYPE_FBS_CANCEL_TICKET              = 153,   //��Ʊ
    INM_TYPE_FBS_INQUIRY_TICKET             = 154,   //��ѯ��Ʊ��ϸ
    INM_TYPE_FBS_INQUIRY_WIN_TICKET         = 155,   //��ѯ�н���Ʊ��ϸ

    //fbs message for OMS
    INM_TYPE_O_FBS_PAY_TICKET               = 161,   //OMS��Ʊ�ҽ�
    INM_TYPE_O_FBS_CANCEL_TICKET            = 162,   //OMS��Ʊȡ��
    INM_TYPE_O_FBS_INQUIRY_TICKET           = 163,   //OMS��Ʊ��ѯ

    INM_TYPE_O_FBS_ADD_MATCH_NTY            = 164,   //��������֪ͨ��Ϣ
    INM_TYPE_O_FBS_DEL_MATCH                = 165,   //ɾ������
    INM_TYPE_O_FBS_MATCH_STATUS_CTRL        = 166,   //����/ͣ�ñ���

    INM_TYPE_O_FBS_MATCH_OPEN               = 167,   //������������
    INM_TYPE_O_FBS_MATCH_CLOSE              = 168,   //������ֹ����
    INM_TYPE_O_FBS_DRAW_INPUT_RESULT        = 169,   //¼��������
    INM_TYPE_O_FBS_DRAW_CONFIRM             = 170,   //�����������ȷ�ϲ����
    INM_TYPE_O_FBS_MATCH_TIME               = 171,   //�޸ı����ر�ʱ��

    INM_TYPE_COMMOM_ERR                     = 172,   //ͨ�ô�������

    INM_TYPE_AP_AUTODRAW                    = 173,   //AP�Զ��ҽ�
    INM_TYPE_AP_AUTODRAW_OVER               = 174,   //AP�Զ��ҽ����
    INM_TYPE_AP_SELL_TICKET                 = 175,   //AP��Ʊ

}INM_MSG_TYPE;


//ָ����1�ֽڶ���
#pragma pack (1)



//�ڲ���Ϣͷ
typedef struct _INM_MSG_HEADER {
    uint16  length;             //��Ϣ����
    uint32  version;            //tfe��¼�汾��
    uint8   type;               //��Ϣ���� (INM_MSG_TYPE)
    uint32  when;               //ʱ���(����)
    uint16  status;             //ҵ�����������Ϣ����ֵ(������� OMS_RESULT_TYPE)

    uint32  socket_idx;         //NCPC_DATABASE��ncpArray���±�

    uint8   gltp_type;          //��Ϣ����(�ڲ���������Ϣ��ʹ�ô��ֶ�,Ĭ���� 0)
    uint16  gltp_func;          //��Ϣ����(�ڲ���������Ϣ��ʹ�ô��ֶ�,Ĭ���� 0)
    uint8   gltp_from;          //��Ϣ��Դ  TICKET_FROM_TYPE (�ڲ���������Ϣ��ʹ�ô��ֶ�,Ĭ���� 0)

    uint32  tfe_file_idx;       //��Ҫ����TF�־û��ļ�¼ʹ�ô��ֶ�(��TFģ����д)
    uint32  tfe_offset;         //��Ҫ����TF�־û��ļ�¼ʹ�ô��ֶ�(��TFģ����д)
    uint32  tfe_when;           //��Ҫ����TF�־û��ļ�¼ʹ�ô��ֶ�(��TFģ����д)

    char data[];
}INM_MSG_HEADER;

#define INM_MSG_HEADER_LEN sizeof(INM_MSG_HEADER)



//ȡ��ָ�����룬�ָ�ȱʡ����
#pragma pack ()



#include "inm_message_ncp.h"
#include "inm_message_oms.h"
#include "inm_message_terminal.h"
#include "inm_message_zot.h"
#include "inm_message_ap.h"


static inline void DUMP_INMMSG(char *inm_buf)
{
    static char dump_type_buf[64];
    static char dump_buf[1024];

    //����Ҫ���ݵ���Ϣ���ֽ�����ʹ֮����ӡ
    dump_buf[0] = '\0';
    INM_MSG_HEADER *header = (INM_MSG_HEADER *)inm_buf;
    switch (header->type)
    {
        // ncp -----------------------------------------------------------------
        case INM_TYPE_N_HB:
            return;
            //sprintf(dump_type_buf, "%s", "INM_TYPE_N_HB");
            //break;
        case INM_TYPE_N_ECHO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_N_ECHO");
            break;
        // terminal ------------------------------------------------------------
        case INM_TYPE_T_ECHO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_ECHO");
            break;
        case INM_TYPE_T_AUTH:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_AUTH");
            break;
        case INM_TYPE_T_VERSION_INQUIRY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_VERSION_INQUIRY");
            break;
        case INM_TYPE_T_SELL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_SELL_TICKET");
            break;
        case INM_TYPE_T_PAY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_PAY_TICKET");
            break;
        case INM_TYPE_T_CANCEL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_CANCEL_TICKET");
            break;
        case INM_TYPE_T_SIGNIN:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_SIGNIN");
            break;
        case INM_TYPE_T_SIGNOUT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_SIGNOUT");
            break;
        case INM_TYPE_T_CHANGE_PWD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_CHANGE_PWD");
            break;
        case INM_TYPE_T_AGENCY_BALANCE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_AGENCY_BALANCE");
            break;
        case INM_TYPE_T_INQUIRY_TICKET_DETAIL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_INQUIRY_TICKET_DETAIL");
            break;
        case INM_TYPE_T_GAME_INFO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_GAME_INFO");
            break;
        case INM_TYPE_T_GAME_DRAW_ANNOUNCE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_GAME_DRAW_ANNOUNCE"); //��ѯ��������
            break;
        case INM_TYPE_T_GAME_ISSUE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_GAME_ISSUE");
            break;

        case INM_TYPE_T_OPEN_GAME_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_OPEN_GAME_UNS");
            break;
        case INM_TYPE_T_CLOSE_SECONDS_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_CLOSE_SECONDS_UNS");
            break;
        case INM_TYPE_T_CLOSE_GAME_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_CLOSE_GAME_UNS");
            break;
        case INM_TYPE_T_DRAW_ANNOUNCE_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_DRAW_ANNOUNCE_UNS"); //��������㲥
            break;

        case INM_TYPE_T_RESET_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_RESET_UNS");
            break;
        case INM_TYPE_T_MESSAGE_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_MESSAGE_UNS");
            break;
        case INM_TYPE_T_MESSAGE_ERR:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_MESSAGE_ERR");
            break;
        case INM_TYPE_T_INQUIRY_WIN:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_INQUIRY_WIN");
            break;
        //retry message
        case INM_TYPE_T_RETRY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_RETRY");
            break;
        // AccessProcider (AP) -------------------------------------------------
        case INM_TYPE_AP_ECHO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_AP_ECHO");
            break;
        case INM_TYPE_AP_INQUIRY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_AP_INQUIRY_TICKET");
            break;
        case INM_TYPE_AP_INQUIRY_ISSUE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_AP_INQUIRY_ISSUE");
            break;
        case INM_TYPE_AP_ISSUE_STATE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_AP_ISSUE_STATE");
            break;

        // FBS  -------------------------------------------------
        case INM_TYPE_FBS_MATCH_INFO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_MATCH_INFO");
            break;
        case INM_TYPE_FBS_SELL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_SELL_TICKET");
            break;
        case INM_TYPE_FBS_PAY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_PAY_TICKET");
            break;
        case INM_TYPE_FBS_CANCEL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_CANCEL_TICKET");
            break;

        case INM_TYPE_O_FBS_PAY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_PAY_TICKET");
            break;
        case INM_TYPE_O_FBS_CANCEL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_CANCEL_TICKET");
            break;
        case INM_TYPE_O_FBS_INQUIRY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_INQUIRY_TICKET");
            break;

        case INM_TYPE_O_FBS_ADD_MATCH_NTY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_ADD_MATCH_NTY");
            break;
        case INM_TYPE_O_FBS_DEL_MATCH:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_DEL_MATCH");
            break;
        case INM_TYPE_O_FBS_MATCH_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_MATCH_STATUS_CTRL");
            break;
        case INM_TYPE_O_FBS_MATCH_OPEN:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_MATCH_OPEN");
            break;
        case INM_TYPE_O_FBS_MATCH_CLOSE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_MATCH_CLOSE");
            break;
        case INM_TYPE_O_FBS_DRAW_INPUT_RESULT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_DRAW_INPUT_RESULT");
            break;
        case INM_TYPE_O_FBS_DRAW_CONFIRM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_DRAW_CONFIRM");
            break;

        // zot -----------------------------------------------------------------
        //tfe
        case INM_TYPE_TFE_CHECK_POINT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_TFE_CHECK_POINT");
            break;
        //system business state
        case INM_TYPE_SYS_BUSINESS_STATE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_SYS_BUSINESS_STATE");
            break;
        //system
        case INM_TYPE_SYS_SWITCH_SESSION:
            sprintf(dump_type_buf, "%s", "INM_TYPE_SYS_SWITCH_SESSION");
            break;
        //rng ״̬�ı���Ϣ
        case INM_TYPE_RNG_STATUS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_RNG_STATUS");
            break;

        //game issue state
        case INM_TYPE_ISSUE_STATE_PRESALE:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_PRESALE");
            INM_MSG_ISSUE_PRESALE *pInm = (INM_MSG_ISSUE_PRESALE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_OPEN:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_OPEN");
            INM_MSG_ISSUE_OPEN *pInm = (INM_MSG_ISSUE_OPEN *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        /*
        case INM_TYPE_ISSUE_STATE_CLOSING:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_CLOSING");
            INM_MSG_ISSUE_CLOSING *pInm = (INM_MSG_ISSUE_CLOSING *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        */
        case INM_TYPE_ISSUE_STATE_CLOSED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_CLOSED");
            INM_MSG_ISSUE_CLOSE *pInm = (INM_MSG_ISSUE_CLOSE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_SEALED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_SEALED");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED");
            INM_MSG_ISSUE_DRAWNUM_INPUTE *pInm = (INM_MSG_ISSUE_DRAWNUM_INPUTE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_MATCHED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_MATCHED");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_FUND_INPUTED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_FUND_INPUTED");
            INM_MSG_ISSUE_FUND_INPUTE *pInm = (INM_MSG_ISSUE_FUND_INPUTE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_LOCAL_CALCED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_LOCAL_CALCED");
            INM_MSG_ISSUE_WLEVEL *pInm = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED");
            INM_MSG_ISSUE_WLEVEL *pInm = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_DB_IMPORTED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_DB_IMPORTED");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_ISSUE_END:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_ISSUE_END");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_SALE_FILE_MD5SUM:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_SALE_FILE_MD5SUM");
            INM_MSG_ISSUE_SALE_FILE_MD5SUM *pInm = (INM_MSG_ISSUE_SALE_FILE_MD5SUM *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_DRAW_REDO:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_DRAW_REDO");
            INM_MSG_ISSUE_DRAW_REDO *pInm = (INM_MSG_ISSUE_DRAW_REDO *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_SECOND_DRAW:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_SECOND_DRAW");
            INM_MSG_ISSUE_SECOND_DRAW *pInm = (INM_MSG_ISSUE_SECOND_DRAW *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }


        // OMS -----------------------------------------------------------------
        case INM_TYPE_O_HB:
            return;
            //sprintf(dump_type_buf, "%s", "INM_TYPE_O_HB");
            //break;
        case INM_TYPE_O_ECHO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_ECHO");
            break;
        case INM_TYPE_O_COMMON:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_COMMON");
            break;

        case INM_TYPE_O_GL_POLICY_PARAM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_POLICY_PARAM");
            break;
        case INM_TYPE_O_GL_RULE_PARAM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_RULE_PARAM");
            break;
        case INM_TYPE_O_GL_CTRL_PARAM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_CTRL_PARAM");
            break;
        case INM_TYPE_O_GL_RISK_CTRL_PARAM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_RISK_CTRL_PARAM");
            break;
        case INM_TYPE_O_GL_SALE_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_SALE_CTRL");
            break;
        case INM_TYPE_O_GL_PAY_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_PAY_CTRL");
            break;
        case INM_TYPE_O_GL_CANCEL_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_CANCEL_CTRL");
            break;
        case INM_TYPE_O_GL_AUTO_DRAW:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_AUTO_DRAW");
            break;
        case INM_TYPE_O_GL_SERVICE_TIME:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_SERVICE_TIME");
            break;
        case INM_TYPE_O_GL_WARN_THRESHOLD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_WARN_THRESHOLD");
            break;

        case INM_TYPE_O_GL_ISSUE_ADD_NFY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_ISSUE_ADD_NFY");
            break;
        case INM_TYPE_O_GL_ISSUE_DEL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_ISSUE_DEL");
            break;

        case INM_TYPE_O_PAY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_PAY_TICKET");
            break;
        case INM_TYPE_O_CANCEL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_CANCEL_TICKET");
            break;
        case INM_TYPE_O_INQUIRY_TICKET:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_INQUIRY_TICKET");
            INM_MSG_O_INQUIRY_TICKET *pInm = (INM_MSG_O_INQUIRY_TICKET *)inm_buf;
            sprintf(dump_buf, "status [%hu] tsn [%s]", pInm->header.inm_header.status, pInm->rspfn_ticket);
            break;
        }

        /*
        case INM_TYPE_O_TMS_AREA_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_ADD");
            break;
        case INM_TYPE_O_TMS_AREA_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_MDY");
            break;
        case INM_TYPE_O_TMS_AREA_DELETE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_DELETE");
            break;
        case INM_TYPE_O_TMS_AREA_AGENCY_GAMECTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_AGENCY_GAMECTRL");
            break;
        case INM_TYPE_O_TMS_AREA_RESET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_RESET");
            break;
        case INM_TYPE_O_TMS_AREA_GAME:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_GAME");
            break;
        case INM_TYPE_O_TMS_AREA_MESSAGE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_MESSAGE");
            break;

        case INM_TYPE_O_TMS_AGENCY_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_ADD");
            break;
        case INM_TYPE_O_TMS_AGENCY_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_MDY");
            break;
        case INM_TYPE_O_TMS_AGENCY_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_STATUS_CTRL");
            break;
        case INM_TYPE_O_TMS_AGENCY_MARGINALCREDIT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_MARGINALCREDIT");
            break;
        case INM_TYPE_O_TMS_AGENCY_CLR:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_CLR");
            break;

        case INM_TYPE_O_TMS_TERM_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TERM_ADD");
            break;
        case INM_TYPE_O_TMS_TERM_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TERM_MDY");
            break;
        case INM_TYPE_O_TMS_TERM_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TERM_STATUS_CTRL");
            break;

        case INM_TYPE_O_TMS_TELLER_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TELLER_ADD");
            break;
        case INM_TYPE_O_TMS_TELLER_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TELLER_MDY");
            break;
        case INM_TYPE_O_TMS_TELLER_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TELLER_STATUS_CTRL");
            break;
        case INM_TYPE_O_TMS_TELLER_RESET_PWD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TELLER_RESET_PWD");
            break;

        case INM_TYPE_O_TMS_AGNECY_DEPOSITAMOUNT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGNECY_DEPOSITAMOUNT");
            break;

        case INM_TYPE_O_TMS_VERSION_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_VERSION_ADD");
            break;
        case INM_TYPE_O_TMS_VERSION_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_VERSION_MDY");
            break;
        case INM_TYPE_O_TMS_VERSION_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_VERSION_STATUS_CTRL");
            break;
			
		*/

        //FBS
        case INM_TYPE_FBS_INQUIRY_WIN_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_INQUIRY_WIN_TICKET");
            break;


        default:
            sprintf(dump_type_buf, "%s", "Unknown_INM_TYPE");
            break;
    }
    static char when[64];
    fmt_time_t(header->tfe_when, DATETIME_FORMAT_EX_EN, when);
    log_debug("Inm Message -> %s <%d> File[%d] Offset[%d] When[%s] [%s]",
        dump_type_buf, header->type, header->tfe_file_idx, header->tfe_offset, when, dump_buf);
}



#endif //INM_MESSAGE_H_INCLUDED


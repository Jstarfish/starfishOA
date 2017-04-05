#ifndef INM_MESSAGE_OMS_H_INCLUDED
#define INM_MESSAGE_OMS_H_INCLUDED



//ָ����1�ֽڶ���
#pragma pack (1)



typedef struct _INM_MSG_O_HEADER
{
    INM_MSG_HEADER   inm_header;

    uint64 token;
    uint32 sequence;//ͨ�����к�

    char    data[];
}INM_MSG_O_HEADER;
#define INM_MSG_O_HEADER_LEN sizeof(INM_MSG_O_HEADER)


//------------------------------------------------------------------------------
// system ϵͳ��
//------------------------------------------------------------------------------

//���� <INM_TYPE_O_HB>
typedef struct _INM_MSG_O_HB
{
    INM_MSG_O_HEADER header;
}INM_MSG_O_HB;

//ECHO <INM_TYPE_O_ECHO>
typedef struct _INM_MSG_O_ECHO {
    INM_MSG_O_HEADER  header;
    uint32            echo_len;
    char              echo_str[];
}INM_MSG_O_ECHO;

//��ѯ��������״̬ <INM_TYPE_O_INQUIRY_SYSTEM>
typedef struct _INM_MSG_O_INQUIRY_SYSTEM
{
    INM_MSG_O_HEADER  header;
    uint8             run_status;           //�������е�״̬
}INM_MSG_O_INQUIRY_SYSTEM;



//-------------------------------------------------------------
// GL ��Ϸ��
//-------------------------------------------------------------



//----------------------------------------------------------
// issue �ڴ���
//----------------------------------------------------------

//OMS�����ڴ�֪ͨ��Ϣ <INM_TYPE_O_GL_ISSUE_ADD_NFY>
typedef struct _INM_MSG_O_GL_ISSUE_ADD_NFY {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
}INM_MSG_O_GL_ISSUE_ADD_NFY;

//��Ϸ�����ڴ� <INM_TYPE_O_GL_ISSUE_DEL>
typedef struct _INM_MSG_O_GL_ISSUE_DEL {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint64            issueNumber;          //�ں�(����������ʼ��֮�������ڴΣ��������ڴ�)
}INM_MSG_O_GL_ISSUE_DEL;


//-----------------------------------------------------------
// ticket ��Ʊ��
//-----------------------------------------------------------

//��Ʊ��ѯ <INM_TYPE_O_INQUIRY_TICKET>
//��Ʊʱ����ʾ���н���Ϣ
typedef struct _GL_WIN_PRIZE_INFO
{
    uint8   prizeCode;                      //�������
    char    prizeName[ENTRY_NAME_LEN];
    uint32  betCount;                       //�н�ע��
    uint64  prizeAmount;                    //�������
}GL_WIN_PRIZE_INFO;

typedef struct _INM_MSG_O_INQUIRY_TICKET
{
    INM_MSG_O_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];
    uint64  unique_tsn;

    //��������
    uint8   gameCode;
    char    gameName[MAX_GAME_NAME_LENGTH];

    uint8   from_sale;                      //Ʊ��Դ

    uint32  startIssueSerial;               //���
    uint64  startIssueNumber;               //�ں�
    uint32  lastIssueSerial;                //���
    uint64  lastIssueNumber;
    uint32  issueCount;

    money_t ticketAmount;

    uint8   isTrain;                        //�Ƿ���ѵģʽ: ��(0)/��(1)
    uint8   isCancel;                       //�Ƿ�����Ʊ  1=����Ʊ
    uint8   isWin;                          //�Ƿ��н� 0=δ�������(��������Ʊ�������ڴ�), 1=δ�н�, 2=�н�(�����ڴο������)
    uint8   isBigPrize;                     //�Ƿ��Ǵ�

    money_t amountBeforeTax;                //�н����(˰ǰ)
    money_t taxAmount;                      //˰��
    money_t amountAfterTax;                 //�н����˰��

    uint64  sale_termCode;                  //���۴�Ʊ���ն˱���
    uint32  sale_tellerCode;                //���۴�Ʊ������Ա����
    uint32  sale_time;                      //����ʱ��

    uint8   isPayed;                        //�Ƿ��Ѷҽ� 0=δ�ҽ�, 1=�Ѷҽ�
    uint64  pay_termCode;                   //�ҽ���Ʊ���ն˱���
    uint32  pay_tellerCode;                 //�ҽ���Ʊ������Ա����
    uint32  pay_time;                       //�ҽ�ʱ��

    uint64  cancel_termCode;                //��Ʊ��Ʊ���ն˱���
    uint32  cancel_tellerCode;              //��Ʊ��Ʊ������Ա����
    uint32  cancel_time;                    //��Ʊʱ��

    char    customName[ENTRY_NAME_LEN];     //�ҽ��û�����
    uint8   cardType;                       //֤������
    char    cardCode[IDENTITY_CARD_LENGTH]; //֤������

    uint16  betStringLen;                   //Ͷע�ַ�������
    char    betString[MAX_BET_STRING_LENGTH]; //Ͷע�ַ���

    uint8   prizeCount;                     //�н��Ľ�������
    GL_WIN_PRIZE_INFO winprizes[];    
}INM_MSG_O_INQUIRY_TICKET;

//��Ʊ�ҽ� <INM_TYPE_O_PAY_TICKET>
typedef struct _INM_MSG_O_PAY_TICKET
{
    INM_MSG_O_HEADER  header;

    uint8    flag;  // 0: long tsn    1: short digit tsn

    char     reqfn_ticket_pay[TSN_LENGTH];  //�ҽ�����������ˮ��
    char     rspfn_ticket_pay[TSN_LENGTH];  //�ҽ�������Ӧ��ˮ��
    uint64   unique_tsn_pay;

    char     rspfn_ticket[TSN_LENGTH];      //��Ʊ������ˮ��
    uint64   unique_tsn;
    char     reqfn_ticket[TSN_LENGTH];      //����������ˮ��

    uint64   issueNumber_pay;               //�ҽ�����ʱ����Ϸ�ں�

    uint8    gameCode;                      //��Ϸ����
    uint64   saleStartIssue;                //������ʼ�ں�
    uint32   saleStartIssueSerial;          //������ʼ�����
    uint64   saleLastIssue;
    uint8    issueCount;                    //������������

    uint32   saleTime;                      //��Ʊ����ʱ��

    money_t  ticketAmount;

    uint8    isTrain;                       //�Ƿ���ѵģʽ: ��(0)/��(1)

    uint8    isBigWinning;                  //�Ƿ��Ǵ�
    money_t  winningAmountWithTax;          //�н����(˰ǰ)
    money_t  taxAmount;                     //˰��
    money_t  winningAmount;                 //�н����˰��

    int16    payCommissionRate;             //�ҽ�Ӷ�𷵻�����
    money_t  commissionAmount;              //�ҽ�Ӷ�𷵻����

    uint16   totalBets;                     //��ע��
    uint32   winningCount;                  //�н���ע��
    money_t  hd_winning;                    //�ߵȽ��ҽ����
    uint32   hd_count;                      //�ߵȽ��ҽ�ע��
    money_t  ld_winning;                    //�͵Ƚ��ҽ����
    uint32   ld_count;                      //�͵Ƚ��ҽ�ע��

    char     loyaltyNum[LOYALTY_CARD_LENGTH];       //��Ա����
    uint8    identityType;                          //֤������
    char     identityNumber[IDENTITY_CARD_LENGTH];  //֤������
    char     name[LOYALTY_CARD_LENGTH];             //����

    uint32   areaCode_pay;                  //���Ķҽ��������
    money_t  availableCredit;               //�˻����

    //Ʊ��Ϣ
    uint64   saleAgencyCode;                        //��Ʊվ�����
    uint16   betStringLen;                          //Ͷע�ַ�������
    char     betString[MAX_BET_STRING_LENGTH];      //Ͷע�ַ���

    uint8         prizeCount;             //�н�������Ŀ
    PRIZE_DETAIL  prizeDetail[];          //�н���ϸ
}INM_MSG_O_PAY_TICKET;


//��Ʊ <INM_TYPE_O_CANCEL_TICKET>
typedef struct _INM_MSG_O_CANCEL_TICKET
{
    INM_MSG_O_HEADER  header;

    uint8    flag;  // 0: long tsn    1: short digit tsn

    char     reqfn_ticket_cancel[TSN_LENGTH];    //��Ʊ����������ˮ��
    char     rspfn_ticket_cancel[TSN_LENGTH];    //��Ʊ������Ӧ��ˮ��
    uint64   unique_tsn_cancel;

    char     rspfn_ticket[TSN_LENGTH];           //��Ʊ������ˮ��
    uint64   unique_tsn;
    char     reqfn_ticket[TSN_LENGTH];           //����������ˮ��

    uint8    gameCode;                           //��Ϸ����
    uint64   saleStartIssue;                     //�������ʼ�ں�    
    uint32   saleStartIssueSerial;               //�������ʼ�ڴ����
    uint8    issueCount;                         //������������

    uint32   saleTime;                           //��Ʊ����ʱ��

    uint8    isTrain;                            //�Ƿ���ѵģʽ: ��(0)/��(1)

    money_t  cancelAmount;                       //Ʊ��ȡ�����
    uint32   betCount;                           //Ʊ��Ͷע��

    money_t  commissionAmount;                   //��ƱӶ�𷵻����

    uint32   areaCode_cancel;                    //������Ʊ�������
    money_t  availableCredit;                    //�˻����
    uint64   saleAgencyCode;                     //��Ʊվ�����
    money_t  saleAgencyAvailableCredit;          //��Ʊ����Ʊ����վ���˻����

    char     loyaltyNum[LOYALTY_CARD_LENGTH];    //��Ա����

    TICKET   ticket; //�䳤�ֶ�
}INM_MSG_O_CANCEL_TICKET;



//------------------------------------------------------------------------------
// FBS
//------------------------------------------------------------------------------

//��Ʊʱ����ʾ���н�����Ϣ
typedef struct _GL_FBS_WIN_ORDER_INFO
{
    uint16    ord_no;                          //�𵥱��
    money_t   winningAmountWithTax;            //�н����
    int32     winningCount;                    //�н�ע��
    uint32    win_match_code;                  //����һ�������Ŀ����������н�
}GL_FBS_WIN_ORDER_INFO;

//��Ʊ��ѯ <INM_TYPE_O_FBS_INQUIRY_TICKET>
typedef struct _INM_MSG_O_FBS_INQUIRY_TICKET
{
    INM_MSG_O_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];
    uint64  unique_tsn;

    uint8   from_sale;                      //Ʊ��Դ

    uint32  saleTime;                       //��Ʊ����ʱ��
    uint8   gameCode;
    char    gameName[MAX_GAME_NAME_LENGTH];
    uint32  issue_number;                   //�����ں�
    uint8   sub_type;                       //�淨
    uint8   bet_type;                       //���ط�ʽ(Ͷע��ʽ)
    money_t ticketAmount;                   //��Ʊ���
    uint32  totalBets;                      //��ע��
    uint16  matchCount;                     //ѡ��ĳ�������

    uint8   isTrain;                        //�Ƿ���ѵģʽ: ��(0)/��(1)
    uint8   isCancel;                       //�Ƿ�����Ʊ  1=����Ʊ
    uint8   isWin;                          //�Ƿ��н� 0=δ�������(��������Ʊ�������ڴ�), 1=δ�н�, 2=�н�(�����ڴο������)
    uint8   isBigPrize;                     //�Ƿ��Ǵ�

    money_t amountBeforeTax;                //�н����(˰ǰ)
    money_t taxAmount;                      //˰��
    money_t amountAfterTax;                 //�н����˰��

    uint64  sale_termCode;                  //���۴�Ʊ���ն˱���
    uint32  sale_tellerCode;                //���۴�Ʊ������Ա����
    uint32  sale_time;                      //����ʱ��

    uint8   isPayed;                        //�Ƿ��Ѷҽ� 0=δ�ҽ�, 1=�Ѷҽ�
    uint64  pay_termCode;                   //�ҽ���Ʊ���ն˱���
    uint32  pay_tellerCode;                 //�ҽ���Ʊ������Ա����
    uint32  pay_time;                       //�ҽ�ʱ��

    uint64  cancel_termCode;                //��Ʊ��Ʊ���ն˱���
    uint32  cancel_tellerCode;              //��Ʊ��Ʊ������Ա����
    uint32  cancel_time;                    //��Ʊʱ��

    char    customName[ENTRY_NAME_LEN];     //�ҽ��û�����
    uint8   cardType;                       //֤������
    char    cardCode[IDENTITY_CARD_LENGTH]; //֤������

    uint16  betStringLen;                   //Ͷע�ַ�������
    char    betString[MAX_BET_STRING_LENGTH]; //Ͷע�ַ���

    uint32  matchCode[FBS_MAX_TICKET_MATCH];
}INM_MSG_O_FBS_INQUIRY_TICKET;

//��Ʊ�ҽ� <INM_TYPE_O_FBS_PAY_TICKET>
typedef struct _INM_MSG_O_FBS_PAY_TICKET
{
    INM_MSG_O_HEADER  header;

    char     reqfn_ticket_pay[TSN_LENGTH];  //�ҽ�����������ˮ��
    char     rspfn_ticket_pay[TSN_LENGTH];  //�ҽ�������Ӧ��ˮ��
    uint64   unique_tsn_pay;

    char     rspfn_ticket[TSN_LENGTH];      //��Ʊ������ˮ��
    uint64   unique_tsn;
    char     reqfn_ticket[TSN_LENGTH];      //����������ˮ��

    uint32   issueNumber_pay;               //�ҽ�����ʱ����Ϸ�ں�

    uint8    from_sale;                     //Ʊ��Դ

    uint32   saleTime;                      //��Ʊ����ʱ��
    uint8    gameCode;
    uint32   issueNumber;                   //�����ں�
    uint8    subType;                       //�淨
    uint8    betType;                       //���ط�ʽ(Ͷע��ʽ)
    money_t  ticketAmount;                  //��Ʊ���
    uint16   matchCount;                    //ѡ��ĳ�������

    uint8    isTrain;                       //�Ƿ���ѵģʽ: ��(0)/��(1)

    uint8    isBigWinning;                  //�Ƿ��Ǵ�
    money_t  winningAmountWithTax;          //�н����(˰ǰ)
    money_t  taxAmount;                     //˰��
    money_t  winningAmount;                 //�н����˰��

    int16    payCommissionRate;             //�ҽ�Ӷ�𷵻�����
    money_t  commissionAmount;              //�ҽ�Ӷ�𷵻����

    uint16   totalBets;                     //��ע��
    uint32   winningCount;                  //�н���ע��

    uint8    claimingScope;                 //��Ϸ�ҽ���Χ, enum AREA_LEVEL

    char     loyaltyNum[LOYALTY_CARD_LENGTH];       //��Ա����
    uint8    identityType;                          //֤������
    char     identityNumber[IDENTITY_CARD_LENGTH];  //֤������
    char     name[LOYALTY_CARD_LENGTH];             //����

    uint32   agencyIdx;
    uint32   areaCode_pay;                  //���Ķҽ��������
    money_t  availableCredit;               //�˻����

    //Ʊ��Ϣ
    uint64   saleAgencyCode;                        //��Ʊվ�����
    uint16   betStringLen;                          //Ͷע�ַ�������
    char     betString[MAX_BET_STRING_LENGTH];      //Ͷע�ַ���

    uint32  matchCode[FBS_MAX_TICKET_MATCH];

    uint16   orderCount;                     //�𵥵�����
    GL_FBS_WIN_ORDER_INFO orderArray[];
}INM_MSG_O_FBS_PAY_TICKET;


//��Ʊ <INM_TYPE_O_FBS_CANCEL_TICKET>
typedef struct _INM_MSG_O_FBS_CANCEL_TICKET
{
    INM_MSG_O_HEADER  header;

    char     reqfn_ticket_cancel[TSN_LENGTH];    //�ҽ�����������ˮ��
    char     rspfn_ticket_cancel[TSN_LENGTH];    //�ҽ�������Ӧ��ˮ��
    uint64   unique_tsn_cancel;

    char     rspfn_ticket[TSN_LENGTH];           //��Ʊ������ˮ��
    uint64   unique_tsn;
    char     reqfn_ticket[TSN_LENGTH];           //����������ˮ��

    uint8    gameCode;                           //��Ϸ����
    uint32   issueNumber;                        //�����ں�

    uint64   cancelAgencyCode;                   //��Ʊ����վ�����
    uint32   saleTime;                           //��Ʊ����ʱ��

    uint8    isTrain;                            //�Ƿ���ѵģʽ: ��(0)/��(1)

    money_t  cancelAmount;                       //Ʊ��ȡ�����
    uint32   betCount;                           //Ʊ��Ͷע��

    int16    saleCommissionRate;                 //��ƱӶ�𷵻�����
    money_t  commissionAmount;                   //��ƱӶ�𷵻����

    uint8    claimingScope;                      //��Ϸ�ҽ���Χ, enum AREA_LEVEL

    uint32   agencyIdx;
    uint32   areaCode_cancel;                    //������Ʊ�������
    money_t  availableCredit;                    //�˻����
    int32    saleAgencyIdx;                      //��Ʊվ�����
    uint64   saleAgencyCode;                     //��Ʊվ�����
    money_t  saleAgencyAvailableCredit;          //��Ʊ����Ʊ����վ���˻����

    char     loyaltyNum[LOYALTY_CARD_LENGTH];    //��Ա����

    uint8    matchCount;
    uint32   matchCode[FBS_MAX_TICKET_MATCH];

    FBS_TICKET   ticket; //�䳤�ֶ�
}INM_MSG_O_FBS_CANCEL_TICKET;



//OMS��������֪ͨ��Ϣ <INM_TYPE_O_FBS_ADD_MATCH_NTY>
typedef struct _INM_MSG_O_FBS_ADD_MATCH_NFY {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
}INM_MSG_O_FBS_ADD_MATCH_NFY;

//��Ϸ�����ڴ� <INM_TYPE_O_FBS_DEL_MATCH>
typedef struct _INM_MSG_O_FBS_DEL_MATCH {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint32            issueNumber;  //�ں�(���� 151025)
    uint32            matchCode; //ɾ���˳�����������б��� (�Ƚϱ�������Ĵ�С)
}INM_MSG_O_FBS_DEL_MATCH;

//����/ͣ�ñ��� <INM_TYPE_O_FBS_MATCH_STATUS_CTRL>
typedef struct _INM_MSG_O_FBS_MATCH_STATUS_CTRL {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint32            issueNumber;  //�ں�(���� 151025)
    uint32            matchCode;
    uint8             status;
}INM_MSG_O_FBS_MATCH_STATUS_CTRL;

//�޸ı����ر�ʱ�� <INM_TYPE_O_FBS_MATCH_TIME>
typedef struct _INM_MSG_O_FBS_MATCH_TIME {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint32            issueNumber;  //�ں�(���� 151025)
    uint32            matchCode;
    uint32            time;
}INM_MSG_O_FBS_MATCH_TIME;


//���±�����״̬ <INM_TYPE_O_FBS_MATCH_OPEN>  <INM_TYPE_O_FBS_MATCH_CLOSE>
typedef struct _INM_MSG_O_FBS_MATCH_STATE {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint32            issueNumber;  //�ں�(���� 151025)
    uint32            matchCode;
    uint8             state; //enum MATCH_STATE
}INM_MSG_O_FBS_MATCH_STATE;


//¼�볡�ο������ <INM_TYPE_O_FBS_DRAW_INPUT_RESULT>
typedef struct _INM_MSG_O_FBS_DRAW_INPUT_RESULT
{
    INM_MSG_O_HEADER header;

    uint8            gameCode;
    uint32           issueNumber;
    uint32           matchCode;
    uint8            drawResults[FBS_SUBTYPE_NUM]; //���淨�Ŀ������ö��ֵ
    uint8            matchResult[8]; //�������,���ݸ�ʽ����μ�  GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ�Ľṹ����
                                     // matchResult[0]  ->  fht_win_result (�ϰ볡�������  M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                                     // matchResult[1]  ->  fht_home_goals (�ϰ볡���ӽ�����)
                                     // matchResult[2]  ->  fht_away_goals (�ϰ볡�Ͷӽ�����)
                                     // matchResult[3]  ->  sht_win_result (�°볡�������  M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                                     // matchResult[4]  ->  sht_home_goals (�°볡���ӽ�����)
                                     // matchResult[5]  ->  sht_away_goals (�°볡�Ͷӽ�����)
                                     // matchResult[6]  ->  ft_win_result  (ȫ���������    M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                                     // matchResult[7]  ->  first_goal     (�Ǹ������Ƚ���  M_TERM_HOME->1  or  M_TERM_AWAY->2)
}INM_MSG_O_FBS_DRAW_INPUT_RESULT;

//���ο������ȷ�� <INM_TYPE_O_FBS_DRAW_CONFIRM>
typedef struct _INM_MSG_O_FBS_DRAW_CONFIRM
{
    INM_MSG_O_HEADER header;

    uint8            gameCode;
    uint32           issueNumber;
    uint32           matchCode;
}INM_MSG_O_FBS_DRAW_CONFIRM;




//ȡ��ָ�����룬�ָ�ȱʡ����
#pragma pack ()



#endif //INM_MESSAGE_OMS_H_INCLUDED




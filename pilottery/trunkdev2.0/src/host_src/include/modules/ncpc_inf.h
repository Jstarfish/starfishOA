#ifndef NCPC_INF_H_INCLUDED
#define NCPC_INF_H_INCLUDED



//�ڴ�NCP��¼����
typedef struct _NCP_RECORD
{
    bool    used;
    int32   index;
    uint32  ncpCode;
    char    name[64];
    uint8   type;       //0: terminal ncp  1:ap ncp  2:oms
    char    ipAddr[16];
    bool    connect;
    uint32  connectNum; //terminal connect number, AP connect number
    uint64  sendPkgNum;
    uint64  recvPkgNum;
    uint64  abnormalPkgNum;
}NCP_RECORD;

//�ڴ�NCPC���ݿ�
typedef struct _NCPC_DATABASE
{
    NCP_RECORD  ncpArray[MAX_NCP_NUMBER];
}NCPC_DATABASE;

typedef NCPC_DATABASE *NCPC_DATABASE_PTR;


//���������ڴ�
bool ncpc_create();

//ɾ�������ڴ�
bool ncpc_destroy();

//ӳ�乲���ڴ���
bool ncpc_init();

//�رչ����ڴ�����ӳ��
bool ncpc_close();


//for view
NCPC_DATABASE_PTR ncpc_getDatabasePtr();


//-------------------------------------------------------
// NCPC �ӿ�

NCP_RECORD *ncpc_getNcpRecord(int32 idx);

//����ncp
//�ɹ� ���ر�� ʧ�� ����-1(���ߴ�����)
int32 ncpc_addNcpRecord(NCP_RECORD *pNcpRec);

//����TCP���ӵ�NCP��IP��ַУ�����
//���� -1 У��ʧ�� ���򷵻� ������
int32 ncpc_verifyTcpNcp(uint32 ipaddr);
//����HTTP���ӵ�NCP��IP��ַУ�����
//���� -1 У��ʧ�� ���򷵻� ������
int32 ncpc_verifyHttpNcp(uint32 ipaddr);

//ncp������״̬
void ncpc_setConnectStatus(int32 idx, bool connect);
bool ncpc_getConnectionStatus(int32 idx);

//�õ�ncp����
uint8 ncpc_getType(int32 idx);

//����ncp���ӵ�(�ն�/AP)��Ŀ
void ncpc_updConnectedNumber(int32 idx, uint32 termcnt);

//����ncp���͵ı�����Ŀ
void ncpc_updSendPkgNumber(int32 idx);

//����ncp���յı�����Ŀ
void ncpc_updRecvPkgNumber(int32 idx);

//����ncp������쳣������Ŀ
void ncpc_updAbnormalPkgNumber(int32 idx);

void ncp_connect_set_false();

#endif


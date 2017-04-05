#include "global.h"
#include "gl_inf.h"
#include "gl_koc7lx_db.h"

static GL_KOC7LX_DRAWNUM koc7lx_drawnum;

// ���ɲ����濪�������bitmap
int gl_koc7lx_createDrawnum(const uint8 xcode[], uint8 len)
{
    log_debug("enter gl_koc7lx_createDrawnum xcodeLen[%d]", len);

    if (len != 7)
    {
        log_error("koc7lx_drawnum len error, len[%d] not equal to 7", len);
        return -1;
    }

    for (int idx = 0; idx < len; idx++)
    {
        log_debug("xcode[%d]:[%d]", idx, xcode[idx]);
    }

    memset(&koc7lx_drawnum, 0, sizeof(koc7lx_drawnum));

    //��xcode�е�ǰ6������浽GL_KOC7LX_DRAWNUM�ṹ���drawA�ֶ���
    num2bit(xcode, 6, (uint8 *)koc7lx_drawnum.drawA, 0, 1);

    //��xcode�еĵ�7������浽GL_KOC7LX_DRAWNUM�ṹ���specialNumber�ֶ���
    koc7lx_drawnum.specialNumber = xcode[6];

    return 0;
}

// ����Ͷע��betline�����ж��ٸ����룬��Ϊ����Ͷע������㵨�����������ж��ٸ�����
int gl_koc7lx_betlineSelect(
        const BETLINE *betline,
        GL_KOC7LX_SELECTNUM &selNum)
{
    //log_debug("enter gl_koc7lx_betlineSelect");

    GL_BETPART *bpA = GL_BETPART_A(betline);
    switch (GL_BETTYPE_A(betline))
    {
        case BETTYPE_DS:
        case BETTYPE_FS:
            selNum.ACnt = bitCount(bpA->bitmap, 0, bpA->size);
            //log_debug("gl_koc7lx_betlineCount A DS FS count[%d]", selNum.ACnt);
            break;
        case BETTYPE_DT:
            selNum.ACnt = bitCount(bpA->bitmap, 0, bpA->size/2);
            selNum.ATCnt = bitCount(bpA->bitmap, bpA->size/2, bpA->size/2);
            //log_debug("gl_koc7lx_betlineSelect A DT d_count[%d] t_count[%d]", selNum.ACnt, selNum.ATCnt);
            break;
    }

    return 0;
}

int gl_koc7lx_FSPartMatch(
        const GL_BETPART *bp,
        const GL_KOC7LX_DRAWNUM *drawnum,
        GL_KOC7LX_MATCHNUM &matchNum)
{
    //log_debug("enter gl_koc7lx_FSPartMatch");
    uint8 andRet[64];

    if (bp->mode == MODE_JC)
    {
        //��Ͷע��A��bitmap�뿪������A��bitmapƥ�䣬�������ͨ�����ƥ�����
        memset(andRet, 0, sizeof(andRet));
        bitAnd((uint8 *)drawnum->drawA, 0, bp->bitmap, 0, bp->size, andRet);
        matchNum.ACnt = bitCount(andRet, 0, bp->size);

        //�鿴Ͷע��bitmap���Ƿ�����ر���룬����ڣ���specialMatched��Ϊ1��������Ϊ0
        uint8 base = 1;
        uint8 quot = (drawnum->specialNumber - base) / 8;
        uint8 remd = (drawnum->specialNumber - base) % 8;
        if ((bp->bitmap[quot] & (1 << remd)) != 0)
        {
            matchNum.specialMatched = 1;
        }
        else
        {
            matchNum.specialMatched = 0;
        }

        //log_debug("gl_koc7lx_FSPartMatch A [%d] S[%d]", matchNum.ACnt, matchNum.specialMatched);
    }

    return 0;
}

int gl_koc7lx_DTPartMatch(
        const GL_BETPART *bp,
        const GL_KOC7LX_DRAWNUM *drawnum,
        GL_KOC7LX_MATCHNUM &matchNum)
{
    //log_debug("enter gl_koc7lx_DTPartMatch");
    uint8 andRet[64];

    if (bp->mode == MODE_JC)
    {
        //��ƥ�����
        memset(andRet, 0, sizeof(andRet));
        bitAnd((uint8 *)drawnum->drawA, 0, bp->bitmap, 0, bp->size/2, andRet);
        matchNum.ACnt = bitCount(andRet, 0, bp->size/2);
        //log_debug("gl_koc7lx_DTPartMatch A d_match[%d]", matchNum.ACnt);

        //��ƥ�����
        memset(andRet, 0, sizeof(andRet));
        bitAnd((uint8 *)drawnum->drawA, 0, bp->bitmap, bp->size/2, bp->size/2, andRet);
        matchNum.ATCnt = bitCount(andRet, 0, bp->size/2);
        //log_debug("gl_koc7lx_DTPartMatch A t_match[%d]", matchNum.ATCnt);

        //�鿴Ͷע��bitmap�ĵ������������Ƿ�����ر����
        //(�ر����δ�������浨ƥ���������ƥ�������)
        uint8 base = 1;
        uint8 quot = (drawnum->specialNumber - base) / 8;
        uint8 remd = (drawnum->specialNumber - base) % 8;
        //�ر�����ڵ�������
        if ((bp->bitmap[quot] & (1 << remd)) != 0)
        {
            matchNum.specialMatched = 1;
        }
        else
        {
            matchNum.specialMatched = 0;
        }
        //�ر��������������
        if ((bp->bitmap[bp->size/2 + quot] & (1 << remd)) != 0)
        {
            matchNum.specialTMatched = 1;
        }
        else
        {
            matchNum.specialTMatched = 0;
        }

        //���ԣ��ر���벻���ڵ���������ͬʱ����
        if (matchNum.specialMatched == 1 && matchNum.specialTMatched == 1)
        {
            log_error("gl_koc7lx_DTPartMatch special number matched in both bank and tow");
        }

        //log_debug("gl_koc7lx_DTPartMatch A [%d] AT [%d] S[%d] ST[%d]", matchNum.ACnt, matchNum.ATCnt,
        //        matchNum.specialMatched, matchNum.specialTMatched);
    }

    return 0;
}

int gl_koc7lx_betpartMatch(
        uint8 bettype,
        const GL_BETPART *bp,
        const GL_KOC7LX_DRAWNUM *drawnum,
        GL_KOC7LX_MATCHNUM &matchNum)
{
    //log_debug("enter gl_koc7lx_betpartMatch");

    switch (bettype)
    {
        case BETTYPE_DS:
        case BETTYPE_FS:
        {
            gl_koc7lx_FSPartMatch(bp, drawnum, matchNum);
            break;
        }
        case BETTYPE_DT:
        {
            gl_koc7lx_DTPartMatch(bp, drawnum, matchNum);
            break;
        }
    }

    return 0;
}

int gl_koc7lx_betlineMatch(
        SUBTYPE_PARAM *subtype,
        DIVISION_PARAM *division,
        const BETLINE *betline,
        uint32 matchRet[])
{
    //��¼ѡ��ĺ������
    GL_KOC7LX_SELECTNUM selNum;
    memset(&selNum, 0, sizeof(selNum));
    gl_koc7lx_betlineSelect(betline, selNum);

    //��¼ƥ��ĺ������
    GL_KOC7LX_MATCHNUM matchNum;
    memset(&matchNum, 0, sizeof(matchNum));
    gl_koc7lx_betpartMatch(GL_BETTYPE_A(betline), GL_BETPART_A(betline), &koc7lx_drawnum, matchNum);

    //����淨����
    SUBTYPE_PARAM *subParam = subtype + betline->subtype;

    //ѭ�����н������鿴Ͷע���ڸ��������н�����ע
    DIVISION_PARAM *divParam;
    //��¼һ��Ͷע����һ���������н�ע��
    uint32 ACnt;
    for (uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
    {
        divParam = division + jdx;

        // �ý���������ұ�ʹ��
        if (divParam == NULL || !divParam->used) continue;
        // �ý�����֧��Ͷע�е��淨
        if (betline->subtype != divParam->subtypeCode) continue;

        switch (GL_BETTYPE_A(betline))
        {
            case BETTYPE_DS:
            case BETTYPE_FS:
            {
                //���������ʽ�����ã��˽���ƥ��ע��Ϊ0
                //�����ر��������1��Ͷע���ر��������0
                if (divParam->specialNumberMatch == 1 && matchNum.specialMatched == 0)
                    continue;

                //S: ��ʽѡ�Ÿ���
                //G: ��ע������� (6)
                //M: ��������ƥ�����
                //Ms: �ر����ƥ�����(0��1)
                //D: ������������ƥ�����
                //Ds: �����ر����ƥ�����(0��1)
                //���ڸý����¸�ʽ���н�ע�� = comb(M,D)*comb(S-M-Ms,G-D-Ds)
                ACnt = mathc(matchNum.ACnt, divParam->A_matchCount) *
                       mathc(selNum.ACnt - matchNum.ACnt - matchNum.specialMatched,
                             subParam->A_selectCount - divParam->A_matchCount - divParam->specialNumberMatch);
                break;
            }
            case BETTYPE_DT:
            {
                //�������������ʽ�����ã��˽���ƥ��ע��Ϊ0
                //�����ر��������0��Ͷע�е������ر����ƥ�䣬����û���ر����ƥ��
                if (divParam->specialNumberMatch == 0 && matchNum.specialMatched == 1 && matchNum.specialTMatched == 0)
                    continue;
                //�����ر��������1��Ͷע�е�����������û���ر����ƥ��
                if (divParam->specialNumberMatch == 1 && matchNum.specialMatched == 0 && matchNum.specialTMatched == 0)
                    continue;
                //�����ر��������1��Ͷע�е��������������ر����ƥ��(ͨ����֤��Ͷע�в�Ӧ���������)
                if (divParam->specialNumberMatch == 1 && matchNum.specialMatched == 1 && matchNum.specialTMatched == 1)
                {
                    log_error("warning: special number matched in both bank and tow");
                    continue;
                }
                //�����ر��������0��Ͷע�е��������������ر����ƥ��(ͨ����֤��Ͷע�в�Ӧ���������)
                if (divParam->specialNumberMatch == 0 && matchNum.specialMatched == 1 && matchNum.specialTMatched == 1)
                {
                    log_error("warning: special number matched in both bank and tow");
                    continue;
                }

                //Sd: ����ѡ�Ÿ���
                //St: ����ѡ�Ÿ���
                //G: ��ע�������(6)
                //Md: ��������ƥ�����
                //Mt: ��������ƥ�����
                //Msd: �����ر����ƥ�����(0��1)
                //Mst: �����ر����ƥ�����(0��1)
                //D: ������������ƥ�����
                //Ds: �����ر����ƥ�����(0��1)
                //���ڸý����µ��ϵ��н�ע�� = comb(Mt,D-Md)*comb(St-Mst-Mt,G-Ds-(Sd-Msd)-(D-Md))
                ACnt = mathc(matchNum.ATCnt, divParam->A_matchCount - matchNum.ACnt) *
                       mathc(selNum.ATCnt - matchNum.specialTMatched - matchNum.ATCnt,
                             subParam->A_selectCount - divParam->specialNumberMatch -
                             (selNum.ACnt - matchNum.specialMatched) - (divParam->A_matchCount - matchNum.ACnt));
                break;
            }
        }

        // ��¼��Ͷע����prizeCode���ȵ���ע��
        matchRet[divParam->prizeCode] += ACnt * betline->betTimes;
        //log_debug("gl_koc7lx_betlineMatch divCode[%d] prizeRet[%d]:[%d]",
        //        jdx, divParam->prizeCode, matchRet[divParam->prizeCode]);
    }

    return 0;
}

// ƥ��һ��ticket���������betline�Ľ���
int gl_koc7lx_ticketMatch(
        const TICKET *ticket,
        const char *subtype,
        const char *division,
        uint32 matchRet[])
{
    memset(matchRet, 0, sizeof(uint32) * MAX_PRIZE_COUNT);

    //log_debug("gl_koc7lx_ticketMatch gameCode[%d] issueCnt[%d] betlineCnt[%d] tmoney[%lld]",
    //        ticket->gameCode, ticket->issueCount, ticket->betlineCount, ticket->amount);

    char tmp[512] = {0};
    snprintf(tmp, ticket->betStringLen, "%s", ticket->betString);
    //log_debug("ticket bet string is [%s]", tmp);

    BETLINE *betline;
    for (int idx = 0; idx < ticket->betlineCount; idx++)
    {
        if (idx == 0)
        {
            betline = (BETLINE *)GL_BETLINE(ticket);
        }
        else
        {
            betline = (BETLINE *)GL_BETLINE_NEXT(betline);
        }
        // ƥ��ÿһ��Ͷע��
        gl_koc7lx_betlineMatch((SUBTYPE_PARAM *)subtype, (DIVISION_PARAM *)division, betline, matchRet);
    }

    for (uint16 jdx = 0; jdx < MAX_PRIZE_COUNT; jdx++)
    {
        if (matchRet[jdx] > 0)
        {
            return 1; //��Ʊ�����н���ע
        }
    }

    return 0; //��Ʊδ�н�
}




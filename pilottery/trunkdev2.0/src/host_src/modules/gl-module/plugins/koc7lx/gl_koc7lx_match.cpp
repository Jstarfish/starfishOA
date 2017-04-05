#include "global.h"
#include "gl_inf.h"
#include "gl_koc7lx_db.h"

static GL_KOC7LX_DRAWNUM koc7lx_drawnum;

// 生成并保存开奖号码的bitmap
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

    //将xcode中的前6个号码存到GL_KOC7LX_DRAWNUM结构体的drawA字段中
    num2bit(xcode, 6, (uint8 *)koc7lx_drawnum.drawA, 0, 1);

    //将xcode中的第7个号码存到GL_KOC7LX_DRAWNUM结构体的specialNumber字段中
    koc7lx_drawnum.specialNumber = xcode[6];

    return 0;
}

// 计算投注行betline包含有多少个号码，若为胆拖投注，则计算胆区和拖区各有多少个号码
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
        //将投注行A区bitmap与开奖号码A区bitmap匹配，计算出普通号码的匹配个数
        memset(andRet, 0, sizeof(andRet));
        bitAnd((uint8 *)drawnum->drawA, 0, bp->bitmap, 0, bp->size, andRet);
        matchNum.ACnt = bitCount(andRet, 0, bp->size);

        //查看投注行bitmap中是否存在特别号码，如存在，则将specialMatched置为1，否则置为0
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
        //胆匹配个数
        memset(andRet, 0, sizeof(andRet));
        bitAnd((uint8 *)drawnum->drawA, 0, bp->bitmap, 0, bp->size/2, andRet);
        matchNum.ACnt = bitCount(andRet, 0, bp->size/2);
        //log_debug("gl_koc7lx_DTPartMatch A d_match[%d]", matchNum.ACnt);

        //拖匹配个数
        memset(andRet, 0, sizeof(andRet));
        bitAnd((uint8 *)drawnum->drawA, 0, bp->bitmap, bp->size/2, bp->size/2, andRet);
        matchNum.ATCnt = bitCount(andRet, 0, bp->size/2);
        //log_debug("gl_koc7lx_DTPartMatch A t_match[%d]", matchNum.ATCnt);

        //查看投注行bitmap的胆区和拖区中是否存在特别号码
        //(特别号码未计在上面胆匹配个数和拖匹配个数中)
        uint8 base = 1;
        uint8 quot = (drawnum->specialNumber - base) / 8;
        uint8 remd = (drawnum->specialNumber - base) % 8;
        //特别号码在胆区存在
        if ((bp->bitmap[quot] & (1 << remd)) != 0)
        {
            matchNum.specialMatched = 1;
        }
        else
        {
            matchNum.specialMatched = 0;
        }
        //特别号码在拖区存在
        if ((bp->bitmap[bp->size/2 + quot] & (1 << remd)) != 0)
        {
            matchNum.specialTMatched = 1;
        }
        else
        {
            matchNum.specialTMatched = 0;
        }

        //调试：特别号码不能在胆区和拖区同时存在
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
    //记录选择的号码个数
    GL_KOC7LX_SELECTNUM selNum;
    memset(&selNum, 0, sizeof(selNum));
    gl_koc7lx_betlineSelect(betline, selNum);

    //记录匹配的号码个数
    GL_KOC7LX_MATCHNUM matchNum;
    memset(&matchNum, 0, sizeof(matchNum));
    gl_koc7lx_betpartMatch(GL_BETTYPE_A(betline), GL_BETPART_A(betline), &koc7lx_drawnum, matchNum);

    //获得玩法参数
    SUBTYPE_PARAM *subParam = subtype + betline->subtype;

    //循环所有奖级，查看投注行在各奖级各中奖多少注
    DIVISION_PARAM *divParam;
    //记录一个投注行在一个奖级的中奖注数
    uint32 ACnt;
    for (uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
    {
        divParam = division + jdx;

        // 该奖级须存在且被使用
        if (divParam == NULL || !divParam->used) continue;
        // 该奖级须支持投注行的玩法
        if (betline->subtype != divParam->subtypeCode) continue;

        switch (GL_BETTYPE_A(betline))
        {
            case BETTYPE_DS:
            case BETTYPE_FS:
            {
                //下面情况公式不适用，此奖级匹配注数为0
                //奖级特别号码中数1，投注行特别号码中数0
                if (divParam->specialNumberMatch == 1 && matchNum.specialMatched == 0)
                    continue;

                //S: 复式选号个数
                //G: 单注号码个数 (6)
                //M: 基本号码匹配个数
                //Ms: 特别号码匹配个数(0或1)
                //D: 奖级基本号码匹配个数
                //Ds: 奖级特别号码匹配个数(0或1)
                //则在该奖级下复式的中奖注数 = comb(M,D)*comb(S-M-Ms,G-D-Ds)
                ACnt = mathc(matchNum.ACnt, divParam->A_matchCount) *
                       mathc(selNum.ACnt - matchNum.ACnt - matchNum.specialMatched,
                             subParam->A_selectCount - divParam->A_matchCount - divParam->specialNumberMatch);
                break;
            }
            case BETTYPE_DT:
            {
                //下面四种情况公式不适用，此奖级匹配注数为0
                //奖级特别号码中数0，投注行胆区有特别号码匹配，拖区没有特别号码匹配
                if (divParam->specialNumberMatch == 0 && matchNum.specialMatched == 1 && matchNum.specialTMatched == 0)
                    continue;
                //奖级特别号码中数1，投注行胆区和拖区都没有特别号码匹配
                if (divParam->specialNumberMatch == 1 && matchNum.specialMatched == 0 && matchNum.specialTMatched == 0)
                    continue;
                //奖级特别号码中数1，投注行胆区和拖区都有特别号码匹配(通过验证的投注行不应发生此情况)
                if (divParam->specialNumberMatch == 1 && matchNum.specialMatched == 1 && matchNum.specialTMatched == 1)
                {
                    log_error("warning: special number matched in both bank and tow");
                    continue;
                }
                //奖级特别号码中数0，投注行胆区和拖区都有特别号码匹配(通过验证的投注行不应发生此情况)
                if (divParam->specialNumberMatch == 0 && matchNum.specialMatched == 1 && matchNum.specialTMatched == 1)
                {
                    log_error("warning: special number matched in both bank and tow");
                    continue;
                }

                //Sd: 胆区选号个数
                //St: 拖区选号个数
                //G: 单注号码个数(6)
                //Md: 胆区号码匹配个数
                //Mt: 拖区号码匹配个数
                //Msd: 胆区特别号码匹配个数(0或1)
                //Mst: 拖区特别号码匹配个数(0或1)
                //D: 奖级基本号码匹配个数
                //Ds: 奖级特别号码匹配个数(0或1)
                //则在该奖级下胆拖的中奖注数 = comb(Mt,D-Md)*comb(St-Mst-Mt,G-Ds-(Sd-Msd)-(D-Md))
                ACnt = mathc(matchNum.ATCnt, divParam->A_matchCount - matchNum.ACnt) *
                       mathc(selNum.ATCnt - matchNum.specialTMatched - matchNum.ATCnt,
                             subParam->A_selectCount - divParam->specialNumberMatch -
                             (selNum.ACnt - matchNum.specialMatched) - (divParam->A_matchCount - matchNum.ACnt));
                break;
            }
        }

        // 记录该投注行中prizeCode奖等的总注数
        matchRet[divParam->prizeCode] += ACnt * betline->betTimes;
        //log_debug("gl_koc7lx_betlineMatch divCode[%d] prizeRet[%d]:[%d]",
        //        jdx, divParam->prizeCode, matchRet[divParam->prizeCode]);
    }

    return 0;
}

// 匹配一张ticket里面的所有betline的奖等
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
        // 匹配每一个投注行
        gl_koc7lx_betlineMatch((SUBTYPE_PARAM *)subtype, (DIVISION_PARAM *)division, betline, matchRet);
    }

    for (uint16 jdx = 0; jdx < MAX_PRIZE_COUNT; jdx++)
    {
        if (matchRet[jdx] > 0)
        {
            return 1; //彩票存在中奖的注
        }
    }

    return 0; //彩票未中奖
}




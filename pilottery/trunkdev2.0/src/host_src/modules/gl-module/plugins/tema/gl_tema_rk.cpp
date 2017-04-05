#include "global.h"
#include "gl_inf.h"
#include "gl_tema_rk.h"
#include "gl_tema_db.h"



GAME_RISK_TEMA_ISSUE_DATA *rk_tema_issueData = NULL;


ISSUE_INFO *tema_issue_info = NULL;
int totalIssueCount = 0;


#define TEMA_SEG_UNIT 2
#define WIN_RETURN_RATEBASE 1000


#define issueBeUsed(issue)                          tema_issue_info[issue].used
#define issueState(issue)                           tema_issue_info[issue].curState

#define issueStatRefuseMoney(issue)                 tema_issue_info[issue].stat.issueRefuseAmount
#define issueStatRefuseCount(issue)                 tema_issue_info[issue].stat.issueRefuseCount

#define winReturnRate(issue)                        rk_tema_issueData[issue].returnRate
#define riskValue(issue)                            rk_tema_issueData[issue].riskValue
#define maxPay(issue)                               rk_tema_issueData[issue].maxPay

#define subWinMoney(issue,subtype)                  rk_tema_issueData[issue].winMoney[subtype - 1]

#define BetCountTema(issue,subtype,number)          rk_tema_issueData[issue].bets[subtype - 1].betCount[number]
#define BetCountCommitTema(issue,subtype,number)    rk_tema_issueData[issue].bets[subtype - 1].betCountCommit[number]

#define saleMoney(issue)                            rk_tema_issueData[issue].totalSaleMoney
#define saleMoneyCommit(issue)                      rk_tema_issueData[issue].totalSaleMoneyCommit

#define maxWINMoney(issue)                          rk_tema_issueData[issue].currMaxWin
#define currPAYMoney(issue)                         rk_tema_issueData[issue].currPay

static uint8 rptSubtype;
static char rptNumber[32]; //Notify betNumber String

uint8 rk_getTemaJJfromDg(uint8 betNum)
{
    if (betNum <= 10)
        return 1;
    if ((betNum > 10) && (betNum <= 20))
        return 2;
    if ((betNum > 20) && (betNum <= 30))
        return 3;
    else
        return 4;
}

uint8 rk_getBetNumberIndex(BETLINE *line,uint8 dindex[])
{
	uint8 bet = 0;
	GL_BETPART *betpart = GL_BETPART_A(line);

	//bitToUint8(betpart->bitmap,dindex,betpart->size,1);

	bit2num(betpart->bitmap,betpart->size,dindex,1);

	for(int i = 0; i < TEMA_MAX_BALLNUM; i++)
	{
		if(dindex[i] > 0)
			bet++;
	}
    return bet;
}


void rk_verifyFunAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint8 dindex[TEMA_MAX_BALLNUM] = {0};
	int betNumIndexCount = rk_getBetNumberIndex(line,dindex);

	if(commitFlag)
        for(int jdx=0;jdx < betNumIndexCount;jdx++)
	    {
        	BetCountCommitTema(issue,line->subtype,dindex[jdx]) += line->betTimes;
	    }
	else
        for(int jdx=0;jdx < betNumIndexCount;jdx++)
	    {
    	    BetCountTema(issue,line->subtype,dindex[jdx]) += line->betTimes;
	    }
}
void rk_verifyFunRollback(BETLINE *line,int issue,bool commitFlag)
{
	uint8 dindex[TEMA_MAX_BALLNUM] = {0};
	int betNumIndexCount = rk_getBetNumberIndex(line,dindex);

	if(commitFlag)
        for(int jdx=0;jdx < betNumIndexCount;jdx++)
	    {
        	BetCountCommitTema(issue,line->subtype,dindex[jdx]) -= line->betTimes;
	    }
	else
        for(int jdx=0;jdx < betNumIndexCount;jdx++)
	    {
    	    BetCountTema(issue,line->subtype,dindex[jdx]) -= line->betTimes;
	    }
}


int rk_get_tema_issueIndexBySeq(uint32 issueSeq)
{
	ISSUE_INFO *allIssueInfo = gl_tema_getIssueTable();
	if(allIssueInfo == NULL)
	{
		log_error("gl_tema_getIssueTable return NULL");
		return -1;
	}

	for(int i = 0; i < totalIssueCount ; i++)
	{
		if(allIssueInfo[i].used)
		{
			if(allIssueInfo[i].serialNumber == issueSeq)
				return i;
		}
	}
	log_error("gl_tema_getIssueTable seq[%d] return -1",issueSeq);
	return -1;
}


bool rk_getNumRestrictFlag(BETLINE *line)
{
	ts_notused(line);
	return false;
}

money_t  getMatchMaxWin(uint8 subtype,uint8 betNumber,int issue)
{
    if (subtype == SUBTYPE_DG)
    {
        uint8 jj = rk_getTemaJJfromDg(betNumber);
        return BetCountTema(issue, SUBTYPE_WH, jj) * subWinMoney(issue, SUBTYPE_WH);
    }
    else
    {
        uint16 bets = 0;
        uint8 sn = betNumber * 10 - 9;
        for (; sn <= betNumber * 10; sn++)
        {
            bets = (BetCountTema(issue, SUBTYPE_DG, sn) > bets) ? BetCountTema(issue, SUBTYPE_DG, sn) : bets;
        }
        return bets * subWinMoney(issue, SUBTYPE_DG);
    }
}

money_t  getMatchMaxWinCommit(uint8 subtype,uint8 betNumber,int issue)
{
    if (subtype == SUBTYPE_DG)
    {
        uint8 jj = rk_getTemaJJfromDg(betNumber);
        return BetCountCommitTema(issue, SUBTYPE_WH, jj) * subWinMoney(issue, SUBTYPE_WH);
    }
    return 0;
}

bool rk_verifyCommFun(BETLINE *line,int issue,money_t ticketAmount)
{

	if(saleMoney(issue) + ticketAmount <= riskValue(issue))
	{
		rk_verifyFunAdder(line,issue, false);
		return true;
	}

	uint8 dindex[TEMA_MAX_BALLNUM] = {0};
	int betNumIndexCount = rk_getBetNumberIndex(line,dindex);

    for(int jdx=0;jdx < betNumIndexCount;jdx++)
	{
       	money_t matchMaxWin = getMatchMaxWin(line->subtype,dindex[jdx],issue);

    	money_t totalWinMoney = (line->betTimes + BetCountTema(issue, line->subtype, dindex[jdx])) * subWinMoney(issue, line->subtype) + matchMaxWin;

    	money_t currPayMoney = totalWinMoney  - (saleMoney(issue) + ticketAmount) * winReturnRate(issue) / WIN_RETURN_RATEBASE;

    	if(currPayMoney > maxPay(issue))
    	{
    		rptSubtype = line->subtype;
    		memset(rptNumber,0,sizeof(rptNumber));
    		sprintf(rptNumber,"%d",dindex[jdx]);
			log_info("rk_verifyCommFun no pass line->subtype[%d] verify  \
    				  line->betCount[%d] line->betTimes[%d] num[%d] currentBetCount[%d]  \
					  myWinMoney[%lld] matchMaxWin[%lld] totalWinMoney[%lld]  saleMoney[%lld] currPayMoney[%lld] maxPay[%lld] ",\
    				  line->subtype,line->betCount,line->betTimes,dindex[jdx], BetCountTema(issue, line->subtype, dindex[jdx]),
                subWinMoney(issue, line->subtype),matchMaxWin, totalWinMoney,saleMoney(issue), currPayMoney, maxPay(issue) );

			for(int ndx = 0; ndx < jdx; ndx++)
			{
				BetCountTema(issue,line->subtype,dindex[ndx]) -= line->betTimes;
			}
			return false;
    	}
   		BetCountTema(issue,line->subtype,dindex[jdx]) += line->betTimes;

	}
	return true;
}


void rk_updateReportData(BETLINE *line,int issue)
{
	money_t lineMoney = line->betCount * line->betTimes * line->singleAmount;

	uint8 dindex[TEMA_MAX_BALLNUM] = {0};
	int betNumIndexCount = rk_getBetNumberIndex(line,dindex);

    for(int jdx=0;jdx < betNumIndexCount;jdx++)
	{
       	money_t matchMaxWin = getMatchMaxWinCommit(line->subtype,dindex[jdx],issue);

    	money_t totalWinMoney = (line->betTimes + BetCountCommitTema(issue, line->subtype, dindex[jdx])) * subWinMoney(issue, line->subtype) + matchMaxWin;

    	money_t currPayMoney = totalWinMoney  - (saleMoneyCommit(issue) + lineMoney) * winReturnRate(issue) / WIN_RETURN_RATEBASE;

    	if(totalWinMoney > maxWINMoney(issue) )
    	{
    		maxWINMoney(issue) = totalWinMoney;
    		currPAYMoney(issue) = currPayMoney;
    	}
	}
	return;
}


void rk_saleDataRelease(BETLINE *line,int issue)
{
    saleMoney(issue) -= line->betCount * line->betTimes * line->singleAmount;
}


void rk_saleDataReleaseCommit(BETLINE *line,int issue)
{
    saleMoneyCommit(issue) -= line->betCount * line->betTimes * line->singleAmount;
}

void rk_saleMoneyAdder(int issue, bool commitFlag, money_t tamount)
{
    if (commitFlag)
    {
        saleMoneyCommit(issue) += tamount;
    }
    else
    {
        saleMoney(issue) += tamount;
    }
}



//  风险控制验证接口
bool riskVerify(	TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;

    if(!commitFlag)
    {
	    for(int acount = 0; acount < pTicket->issueCount; acount++)
	    {
		    issueIndex = rk_get_tema_issueIndexBySeq( pTicket->issueSeq + acount);
		    if(issueIndex < 0)
		    {
			    log_info("riskVerify issue_seq[%d] acount[%d] not find!",pTicket->issueSeq , acount);
                continue;
		    }
		    BETLINE *line =  (BETLINE *)GL_BETLINE(pTicket);
            for(int aline = 0;aline < pTicket->betlineCount; aline++)
            {
                if(rk_getNumRestrictFlag( line))
                {
                    log_info("riskVerify rk_getNumRestrictFlag! ");
                    return false;
                }
                if(!rk_verifyCommFun(line,issueIndex, pTicket->amount))
                {
                	issueStatRefuseMoney(issueIndex) += pTicket->amount;
                	issueStatRefuseCount(issueIndex)++;
                    for(int rcount = 0; rcount < acount+1; rcount++)
                    {
                    	issueIndex = rk_get_tema_issueIndexBySeq( pTicket->issueSeq + rcount);
                    	line = (BETLINE *)GL_BETLINE(pTicket);
                    	int backline = (rcount == acount)? aline : pTicket->betlineCount;
                        for(int rline = 0;rline < backline; rline++)
                        {
                        	//rk_saleDataRelease(line,issueIndex);
                        	rk_verifyFunRollback(line,issueIndex, commitFlag);
                            line = (BETLINE *) GL_BETLINE_NEXT(line);
                        }
                    }
                    send_rkNotify(pTicket->gameCode, pTicket->issue,rptSubtype, rptNumber);
                    log_info("tema rk no pass issue[%lld] subtype[%d] commit[%d]",\
                    		pTicket->issue,line->subtype,commitFlag?1:0);
                    return false;
                }

				//rk_verifyFunAdder(line,issueIndex, commitFlag);
                line = (BETLINE *) GL_BETLINE_NEXT(line);
            }
            rk_saleMoneyAdder(issueIndex, commitFlag,pTicket->amount);
	    }
    }
    else
    {
		for(int acount = 0; acount < pTicket->issueCount; acount++)
		{
			issueIndex = rk_get_tema_issueIndexBySeq( pTicket->issueSeq + acount);
			if(issueIndex < 0)
			{
				log_info("riskVerify issue_seq[%d] acount[%d] not find!",pTicket->issueSeq , acount);
				continue;
			}
			BETLINE *line =  (BETLINE *)GL_BETLINE(pTicket);
			for(int aline = 0;aline < pTicket->betlineCount; aline++)
			{
				rk_verifyFunAdder(line,issueIndex, commitFlag);
				rk_updateReportData(line,issueIndex);
				line = (BETLINE *) GL_BETLINE_NEXT(line);
			}
            rk_saleMoneyAdder(issueIndex, commitFlag, pTicket->amount);
		}
    }

    log_info("tema rk pass issue[%lld] commit[%d]",\
    		pTicket->issue,commitFlag?1:0);
    return true;
}


// 退票风险控制参数回滚接口
void riskRollback(TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;

    for(int acount = 0; acount < pTicket->issueCount; acount++)
    {
    	issueIndex = rk_get_tema_issueIndexBySeq( pTicket->issueSeq + acount);
        BETLINE *line = (BETLINE *)GL_BETLINE(pTicket);
        for(int i=0;i<pTicket->betlineCount;i++)
        {
        	if(commitFlag)
        	    rk_saleDataReleaseCommit(line,issueIndex);
        	else
        		rk_saleDataRelease(line,issueIndex);
            rk_verifyFunRollback(line,issueIndex, commitFlag);
            line = (BETLINE *) GL_BETLINE_NEXT(line);
        }
    }
}

bool gl_tema_rk_mem_get_meta( int *length)
{
	ts_notused(length);
    return true;
}

bool gl_tema_rk_mem_save( void *buf, int *length)
{
	ts_notused(buf);
	ts_notused(length);
    return true;
}

bool gl_tema_rk_mem_recovery( void *buf, int length)
{
	ts_notused(buf);
	ts_notused(length);
    return true;
}

void gl_tema_rk_reinitData(void)
{
	int num;
	for(int issue=0;issue < totalIssueCount;issue++)
    {
		for(num = 0;num < TEMA_MAX_BALLNUM; num++)
		{
			BetCountTema(issue,SUBTYPE_DG,num) = BetCountCommitTema(issue,SUBTYPE_DG,num);
			BetCountTema(issue,SUBTYPE_WH,num) = BetCountCommitTema(issue,SUBTYPE_WH,num);
		}

        saleMoney(issue) = saleMoneyCommit(issue);
    }

    return;
}

bool gl_tema_sale_rk_verify(TICKET* pTicket)
{
	if( riskVerify(pTicket, false))
	{
		return true;
	}
	return false;
}


void gl_tema_sale_rk_commit(TICKET* pTicket)
{
	 riskVerify(pTicket, true);
}


void gl_tema_cancel_rk_rollback(TICKET* pTicket)
{
	riskRollback(pTicket, false);
}

void gl_tema_cancel_rk_commit(TICKET* pTicket)
{
	riskRollback(pTicket, true);
}


////////////////////////////////////////////////////////////////



void get_tema_winMoney(uint64 issueNumber, int issue)
{
	PRIZE_PARAM *prizeParam = gl_tema_getPrizeTable(issueNumber);

	for(int i = 0; i < MAX_PRIZE_COUNT; i++)
	{
		switch(prizeParam[i].prizeCode)
		{
		case PRIZE_1:
            subWinMoney(issue, SUBTYPE_DG) = prizeParam[i].fixedPrizeAmount;
			break;
		case PRIZE_2:
			subWinMoney(issue,SUBTYPE_WH) = prizeParam[i].fixedPrizeAmount;
		}
	}
	return;
}


void rk_clear_issue_betsData(int issue)
{

	for(uint8 subtype = SUBTYPE_DG; subtype <= SUBTYPE_WH; subtype++)
	{
		for(int num = 0;num <= TEMA_MAX_BALLNUM; num++)
		{
			BetCountTema(issue,subtype,num) = 0;
			BetCountCommitTema(issue,subtype,num) = 0;
		}
	}
	saleMoney(issue) = saleMoneyCommit(issue) = 0;
	currPAYMoney(issue) = 0;
	maxWINMoney(issue) = 0;
    return;
}
/*
#define issueBeUsed(issue)                        d3_issue_info[issue].used
#define issueState(issue)                         d3_issue_info[issue].curState
*/
// load issue param when add issue by gl_drive , no need init ,need empty bets data
bool load_tema_issue_rkdata(uint32 startIssueSeq,int issue_count, char *rkStr)
{

    money_t f;
    money_t p;

    const char *format="%lld:%lld#";

    sscanf(rkStr,format,&f,&p);

    POLICY_PARAM* policyParam = gl_getPolicyParam(GAME_TEMA);

	uint32 issueSeq = startIssueSeq;
    for(int issue_idx = 0; issue_idx < issue_count; issue_idx++)
    {
    	int issue = rk_get_tema_issueIndexBySeq(issueSeq);
    	if (issue > -1)
    	{
    	    if( issueBeUsed(issue) )
		    {
   	        	winReturnRate(issue) = policyParam->returnRate;
		        riskValue(issue) = f;
		        maxPay(issue) = p;
		        ISSUE_INFO *issueInfo = gl_tema_get_issueInfoByIndex(issue);
		        get_tema_winMoney( issueInfo->issueNumber,issue);
   	    	    rk_clear_issue_betsData( issue);
		    }
    	    issueSeq++;
    	}
    }
	return true;
}

void gl_tema_rk_issueData2File(const char *filePath,void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName,"%s/tema_rk.snapshot", filePath);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
    	log_error("open %s error!",fileName);
    	return;
    }

    ssize_t ret = write( fp, buf, sizeof(GL_TEMA_RK_CHKP_ISSUE_DATA));
    if(ret < 0)
    {
    	log_error("write %s error errno[%d]",fileName,errno);
    }
    close(fp);

}

bool gl_tema_rk_issueFile2Data(const char *filePath,void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName,"%s/tema_rk.snapshot", filePath);
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
    	log_error("open %s error!",fileName);
    	return false;
    }

    ssize_t ret = read( fp, buf, sizeof(GL_TEMA_RK_CHKP_ISSUE_DATA));
    if(ret < 0)
    {
    	log_error("read %s error errno[%d]",fileName,errno);
    	return false;
    }
    close(fp);
    return true;
}

bool gl_tema_rk_saveData(const char *filePath)
{
	int count = 0;
	GL_TEMA_RK_CHKP_ISSUE_DATA rkIssueData;
	memset((void *)&rkIssueData, 0 ,sizeof(rkIssueData));
	ISSUE_INFO *issueInfo = gl_tema_getIssueTable();
	for(int i = 0; i < totalIssueCount; i++)
	{
		if(issueInfo[i].used)
		{
			if((issueInfo[i].curState >= ISSUE_STATE_PRESALE) && (issueInfo[i].curState < ISSUE_STATE_CLOSED))
			{
				int issue = rk_get_tema_issueIndexBySeq(issueInfo[i].serialNumber);


				rkIssueData.rkData[count].issueSeq = issueInfo[i].serialNumber;

				for(int num = 0;num < TEMA_MAX_BALLNUM; num++)
				{
					rkIssueData.rkData[count].betCountCommitJC[num] = BetCountCommitTema(issue,SUBTYPE_DG,num);
					rkIssueData.rkData[count].betCountCommit4T[num] = BetCountCommitTema(issue,SUBTYPE_WH,num);
				}

				rkIssueData.rkData[count].totalSaleMoneyCommit = saleMoneyCommit(issue);
				count++;
			}
		}
	}
	gl_tema_rk_issueData2File(filePath,(void *)&rkIssueData);
    return true;
}

bool gl_tema_rk_restoreData(const char *filePath)
{
	GL_TEMA_RK_CHKP_ISSUE_DATA rkIssueData;
	memset((void *)&rkIssueData, 0 ,sizeof(rkIssueData));
	if(gl_tema_rk_issueFile2Data(filePath,(void *)&rkIssueData))
	{
		for(int count = 0; count < MAX_ISSUE_NUMBER; count++)
		{
			if(rkIssueData.rkData[count].issueSeq > 0)
			{
				int issue = rk_get_tema_issueIndexBySeq(rkIssueData.rkData[count].issueSeq);

				if(issue >= 0)
				{
					for(int num = 0;num < TEMA_MAX_BALLNUM; num++)
					{
						BetCountCommitTema(issue,SUBTYPE_DG,num) = rkIssueData.rkData[count].betCountCommitJC[num];
						BetCountCommitTema(issue,SUBTYPE_DG,num) = rkIssueData.rkData[count].betCountCommit4T[num];
					}

					saleMoneyCommit(issue) = rkIssueData.rkData[count].totalSaleMoneyCommit;

				}
				count++;
			}
		}
		return true;
	}
	else
        return false;

    return true;
}

bool gl_tema_rk_getReportData(uint32 issueSeq,void *currMaxPay)
{
    int issue = rk_get_tema_issueIndexBySeq( issueSeq);
    if(issue < 0)
    {
	    log_info("gl_tema_rk_getReportData issue_seq[%d]  not find!",issueSeq);
        return false;
    }

    // *((money_t *)currMaxPay) = currPAYMoney(issue);

    sprintf((char *)currMaxPay,"%lld,%lld",currPAYMoney(issue),maxPay(issue));

    return true;
}




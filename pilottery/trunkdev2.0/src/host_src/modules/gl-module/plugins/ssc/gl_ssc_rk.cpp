#include "global.h"
#include "gl_inf.h"
#include "gl_ssc_rk.h"
#include "gl_ssc_db.h"


GAME_SSCRISK_PTR rk_ssc_db_ptr = NULL;
GAME_RISK_SSC_ISSUE_DATA *rk_ssc_issueData = NULL;


ISSUE_INFO *ssc_issue_info = NULL;
int totalIssueCount = 0;

#define MAX_GAME_BETTYPE 16

#define SSC_SEG_UNIT 2

const uint8 NUM_TYPE_DIRECT = 0;
const uint8 NUM_TYPE_ASS3 = 1;
const uint8 NUM_TYPE_ASS6 = 2;


typedef enum  _SSC_DXDS_TYPE {
	DADA = 0,
    DAXI,
    DADAN,
    DASH,

    XIDA,
    XIXI,
    XIDAN,
    XISH,

    DANDA,
    DANXI,
    DANDAN,
    DANSH,

    SHDA,
    SHXI,
    SHDAN,
    SHSH
}SSC_DXDS_TYPE;


#define issueBeUsed(issue)                          ssc_issue_info[issue].used
#define issueState(issue)                           ssc_issue_info[issue].curState

#define issueStatRefuseMoney(issue)                 ssc_issue_info[issue].stat.issueRefuseAmount
#define issueStatRefuseCount(issue)                 ssc_issue_info[issue].stat.issueRefuseCount

#define winPercentBet(issue)                        rk_ssc_issueData[issue].winPercent

#define initBetLimit(issue,subtype)                 rk_ssc_issueData[issue].riskCtrl[subtype].initLimit
#define winMoney(issue,subtype)                     rk_ssc_issueData[issue].riskCtrl[subtype].unitBetWin


#define SubDirect2Star(sub)                         rk_ssc_db_ptr->sumSubIndex.Sub2StarDirect[sub]
#define SubDirect3Star(sub)                         rk_ssc_db_ptr->sumSubIndex.Sub3StarDirect[sub]
#define SubPort2Star(sub)                           rk_ssc_db_ptr->sumSubIndex.Sub2StarPort[sub]
#define SubPort3Star(sub)                           rk_ssc_db_ptr->sumSubIndex.Sub3StarPort[sub]
#define SumDirect2Star(sum)                         rk_ssc_db_ptr->sumSubIndex.Sum2StarDirect[sum]
#define SumPort2Star(sum)                           rk_ssc_db_ptr->sumSubIndex.Sum2StarPort[sum]
#define SumDirect3Star(sum)                         rk_ssc_db_ptr->sumSubIndex.Sum3StarDirect[sum]
#define SumPort3Star(sum)                           rk_ssc_db_ptr->sumSubIndex.Sum3StarPort[sum]
#define BaoOneDan3Star(sum)                         rk_ssc_db_ptr->sumSubIndex.BaoOneDan3Star[sum]
#define BaoTwoDan3Star(sum)                         rk_ssc_db_ptr->sumSubIndex.BaoTwoDan3Star[sum]
#define FiveStarWholeIndex(number)                  rk_ssc_db_ptr->index5StarWhole[number]
#define FiveStarNumIndex(n1,n2,n3,n4,n5)            rk_ssc_db_ptr->FiveStarNum[n1][n2][n3][n4][n5]

#define OneStarBet(issue,number)                    rk_ssc_issueData[issue].betData.ssc1star[number]
#define TwoStarBet(issue,number)                    rk_ssc_issueData[issue].betData.ssc2star[number]
#define ThreeStarBet(issue,number)                  rk_ssc_issueData[issue].betData.ssc3star[number]
#define FiveStarBet(issue,number)                   rk_ssc_issueData[issue].betData.ssc5star[number]
#define DxdsStarBet(issue,number)                   rk_ssc_issueData[issue].betData.sscDxds[number]



#define currentBetCount(subtype,issue)              rk_ssc_issueData[issue].salesData[subtype].currentBetCount
#define currRestrictBetCount(subtype,issue)         rk_ssc_issueData[issue].salesData[subtype].currRestrictBetCount
#define saleMoney(subtype,issue)                    rk_ssc_issueData[issue].salesData[subtype].saleMoneyBySubtype
#define numberMaxBetCount(subtype,issue)            rk_ssc_issueData[issue].salesData[subtype].numberMaxBetCount
#define firstBetCount(subtype,issue)                rk_ssc_issueData[issue].salesData[subtype].firstBetCount
#define firstBetFlag(subtype,issue)                 rk_ssc_issueData[issue].salesData[subtype].firstBetFlag
#define firstBetNumber(subtype,issue)               rk_ssc_issueData[issue].salesData[subtype].firstNumberGetLimit


#define currentBetCountCommit(subtype,issue)        rk_ssc_issueData[issue].salesDataCommit[subtype].currentBetCount
#define currRestrictBetCountCommit(subtype,issue)   rk_ssc_issueData[issue].salesDataCommit[subtype].currRestrictBetCount
#define saleMoneyCommit(subtype,issue)              rk_ssc_issueData[issue].salesDataCommit[subtype].saleMoneyBySubtype
#define numberMaxBetCountCommit(subtype,issue)      rk_ssc_issueData[issue].salesDataCommit[subtype].numberMaxBetCount
#define firstBetCountCommit(subtype,issue)          rk_ssc_issueData[issue].salesDataCommit[subtype].firstBetCount
#define firstBetFlagCommit(subtype,issue)           rk_ssc_issueData[issue].salesDataCommit[subtype].firstBetFlag
#define firstBetNumberCommit(subtype,issue)         rk_ssc_issueData[issue].salesDataCommit[subtype].firstNumberGetLimit


void (*rk_verifyFunAdder[MAX_FUN_KEY])(BETLINE *line,int issue,bool commitFlag);
void (*rk_verifyFunRollback[MAX_FUN_KEY])(BETLINE *line,int issue,bool commitFlag);
void (*rk_getMaxBetNumber[MAX_FUN_KEY])(BETLINE *line,int issue,bool commitFlag);



static const int SSC_RK_SUBCODE[] =
{

SUBTYPE_1ZX,SUBTYPE_2ZX,SUBTYPE_2ZUX,

SUBTYPE_3ZX,SUBTYPE_3Z3,SUBTYPE_3Z6,SUBTYPE_5ZX,

SUBTYPE_5TX,SUBTYPE_DXDS,

-1

};


int rk_get_ssc_issueIndexBySeq(uint32 issueSeq)
{
	ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();
	if(allIssueInfo == NULL)
	{
		log_error("gl_ssc_getIssueTable return NULL");
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

	return -1;
}

uint32 * numCurrentBetCount(uint8 subtype,uint32 issue,uint32 index)
{
	switch(subtype)
	{
    	case SUBTYPE_1ZX:
    		return &(OneStarBet(issue,index).betCount);
    	case SUBTYPE_2ZX:
    		return &(TwoStarBet(issue,index).betCount);
    	case SUBTYPE_2ZUX:
    		return &(TwoStarBet(issue,index).betCountPort);
    	case SUBTYPE_3ZX:
    		return &(ThreeStarBet(issue,index).betCount);
    	case SUBTYPE_3Z3:
    		return &(ThreeStarBet(issue,index).betCountAss3);
    	case SUBTYPE_3Z6:
    		return &(ThreeStarBet(issue,index).betCountAss6);
    	case SUBTYPE_5ZX:
    		return &(FiveStarBet(issue,index).betCount);
    	case SUBTYPE_5TX:
    		return &(FiveStarBet(issue,index).betCountWhole);
    	case SUBTYPE_DXDS:
    		return &(DxdsStarBet(issue,index).betCount);
        default:
            return NULL;
	}
}

uint32 * numCurrentBetCountCommit(uint8 subtype,uint32 issue,uint32 index)
{
	switch(subtype)
	{
    	case SUBTYPE_1ZX:
    		return &(OneStarBet(issue,index).betCountCommit);
    	case SUBTYPE_2ZX:
    		return &(TwoStarBet(issue,index).betCountCommit);
    	case SUBTYPE_2ZUX:
    		return &(TwoStarBet(issue,index).betCountPortCommit);
    	case SUBTYPE_3ZX:
    		return &(ThreeStarBet(issue,index).betCountCommit);
    	case SUBTYPE_3Z3:
    		return &(ThreeStarBet(issue,index).betCountAss3Commit);
    	case SUBTYPE_3Z6:
    		return &(ThreeStarBet(issue,index).betCountAss6Commit);
    	case SUBTYPE_5ZX:
    		return &(FiveStarBet(issue,index).betCountCommit);
    	case SUBTYPE_5TX:
    		return &(FiveStarBet(issue,index).betCountWholeCommit);
    	case SUBTYPE_DXDS:
    		return &(DxdsStarBet(issue,index).betCountCommit);
        default:
            return NULL;
	}
}

bool rk_checkNumberIsCombine6(int num)
{
	int a = num / 100;
	int b = (num - (a * 100))/10;
	int c = num - a * 100 - b * 10;

	if( (a < b) && ( b < c) )
		return true;
	return false;
}

bool rk_getNumRestrictFlag(BETLINE *line)
{
	ts_notused(line);
	return false;
}

uint16  rk_get1StarDirectNumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
    uint16 bet = 0;
    uint8 andret[64];
	GL_BETPART *betpart = GL_BETPART_A(line);
    for(int i=0;i<10;i++)
    {
        memset(andret, 0, sizeof(andret));
        bitAnd((uint8 *)&(OneStarBet(issue,i).betCompact), 0, betpart->bitmap, 0, betpart->size, andret);
        if( bitCount(andret, 0, 64) == 1)
        {
            dindex[bet] = i;
            bet++;
        }
    }
    return bet;
}

uint16  rk_get2StarDirectNumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
    uint16 bet = 0;
    uint8 count = 0;
    uint8 andret[64];
	GL_BETPART *betpart = GL_BETPART_A(line);
	switch(GL_BETTYPE_A(line))
	{
    	case BETTYPE_DS:
    	case BETTYPE_YXFS:
    	    for(int i=0;i<100;i++)
    	    {
    	        count = 0;
    	        for(int j=0;j<2;j++)
    	        {
    	            memset(andret, 0, sizeof(andret));
    	            bitAnd((uint8 *)&(TwoStarBet(issue,i).betNumMap[j]), 0,(uint8 *)(betpart->bitmap), j*2, 2, andret);
    	            count += bitCount(andret, 0, 64);
    	        }
    	        if(count == 2)
    	        {
    	            dindex[bet] = i;
    	            bet++;
    	        }
    	    }

    		break;
    	case BETTYPE_HZ:
    	    for(int i=0;i<SumDirect2Star(betpart->bitmap[0]).count;i++)
    	    {
    	        dindex[i] = SumDirect2Star(betpart->bitmap[0]).index[i];
    	    }
    	    bet = SumDirect2Star(betpart->bitmap[0]).count;
    		break;
    	/*
		case BETTYPE_SSC_KUADU:
    	    for(int i=0;i<SubDirect2Star(betpart->map[0]).count;i++)
    	    {
    	        dindex[i] = SubDirect2Star(betpart->map[0]).index[i];
    	    }
    	    bet = SubDirect2Star(betpart->map[0]).count;
    	*/
        default:
            log_error("rk_get2StarDirectNumberIndex() bettype[%d] error", GL_BETTYPE_A(line));
            return -1;
	}
	return bet;
}

uint16  rk_get2StarPortNumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
	int i=0;
	int j=0;
	int n=0;
    uint16 bet = 0;
    uint8 count = 0;
    uint8 andret[64];
	GL_BETPART *betpart = GL_BETPART_A(line);
	switch(GL_BETTYPE_A(line))
	{
	case BETTYPE_DS:
	case BETTYPE_FS:
	    for( i=0;i<100;i++)
	    {
	    	//uint8 numcount = bitCount((uint8 *)&(TwoStarBet(issue,i).betCompact), 0, 2);
	        memset(andret, 0, sizeof(andret));
	        bitAnd((uint8 *)&(TwoStarBet(issue,i).betCompact), 0, betpart->bitmap, 0, betpart->size, andret);
	        if( bitCount(andret, 0, 64) == 2)
	        {
	            dindex[bet] = i;
	            bet++;
	        }
	    }
		break;
	case BETTYPE_YXFS:
	    for( i=0;i<100;i++)
	    {
	        count = 0;
	        for( j=0;j<2;j++)
	        {
	            memset(andret, 0, sizeof(andret));
	            bitAnd((uint8 *)&(TwoStarBet(issue,i).betNumMap[j]), 0,(uint8 *)(betpart->bitmap), j*2, 2, andret);
	            count += bitCount(andret, 0, 64);
	        }
	        if(count == 2)
	        {
	            dindex[bet] = i;
	            bet++;
	        }
	    }
		break;
	case BETTYPE_HZ:
	    for(i=0;i<SumPort2Star(betpart->bitmap[0]).count;i++)
	    {
	        dindex[i] = SumPort2Star(betpart->bitmap[0]).index[i];
	    }
	    bet = SumPort2Star(betpart->bitmap[0]).count;
		break;
		/*
	case BETTYPE_SSC_KUADU:
	    for(i=0;i<SubPort2Star(betpart->map[0]).count;i++)
	    {
	        dindex[i] = SubPort2Star(betpart->map[0]).index[i];
	    }
	    bet = SubPort2Star(betpart->map[0]).count;
	    break;
	    */
	case BETTYPE_BD: //每个胆对应10注，但计入betCountPort为19注,重复对子只计一个
		//betpart->map
		memset(andret, 0 ,sizeof(andret));
        bitToUint8((uint8*) betpart->bitmap , andret, SSC_SEG_UNIT, 0);
        int dan = andret[0];
		for(i=0;i<10;i++)
		{
			dindex[i] = i*10 + dan;
		}
		for(j=i,n=0;n<10;n++)
		{
			if(n != dan)
			{
				dindex[j] = dan *10 + n;
				j++;
			}
		}
		bet = j;
	}
	return bet;
}

int rk_get2StarCompNumber(BETLINE *line, int issue)
{
    //uint16 bet = 0;
    uint8 count = 0;
    //uint16 dindex[2] = {0};
    uint8 andret[64];
	GL_BETPART *betpart = GL_BETPART_A(line);
    for(int i=0;i<100;i++)
    {
        count = 0;
        for(int j=0;j<2;j++)
        {
            memset(andret, 0, sizeof(andret));
            bitAnd((uint8 *)&(TwoStarBet(issue,i).betNumMap[j]), 0,(uint8 *)(betpart->bitmap), j*2, 2, andret);
            count += bitCount(andret, 0, 64);
        }
        if(count == 2)
        {
            //dindex[bet] = i;
            //bet++;
        	return i;
        }
    }
	//return dindex[0]*10 + dindex[1];
    return -1;
}

uint16 rk_get2StarCompNumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
	int number = rk_get2StarCompNumber(line,issue);
	dindex[0] = number%10;
	dindex[1] = number;
	return 2;
}

int rk_get5StarSegNumber(BETLINE *line) //注意区分raws的数字位置，个位，十位 顺序
{
	uint8 num[5] = {0};
    uint8 tmp[100];
	GL_BETPART *betpart = GL_BETPART_A(line);
	for(int idx=0;idx<5;idx++)
	{
		memset(tmp,0,sizeof(tmp));
		bitToUint8((uint8*)betpart->bitmap + SSC_SEG_UNIT * idx, tmp, SSC_SEG_UNIT, 0);
		num[idx] = tmp[0];
	}
	return num[0]*10000 + num[1]*1000 + num[2]*100 + num[3]*10 + num[4];
}

int rk_get3StarCompNumber(BETLINE *line)
{
	uint8 num[3] = {0};
    uint8 tmp[100];
	GL_BETPART *betpart = GL_BETPART_A(line);
	for(int idx=0;idx<3;idx++)
	{
		memset(tmp,0,sizeof(tmp));
		bitToUint8((uint8*)betpart->bitmap + SSC_SEG_UNIT * idx, tmp, SSC_SEG_UNIT, 0);
		num[idx] = tmp[0];
	}
	return num[0]*100 + num[1]*10 + num[2];
}

uint16 rk_get3StarCompNumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
	ts_notused(issue);
	int number = rk_get3StarCompNumber(line);
	dindex[0] = number%10;
	dindex[1] = number%100;
	dindex[2] = number;
	return 3;
}

/*
uint16 rk_get5StarDirectSegIndex(char raws[],uint16 dindex[],int issue)
{
    uint16 bet = 0;
    uint8 count = 0;
    uint8 andret[64];
    for(int number=0;number<100000;number++)
    {
        count = 0;
        for(int j=0;j<5;j++)
        {
            memset(andret, 0, sizeof(andret));
            bitAnd((uint8 *)&(FiveStarBet(issue,number).betNumMap[j]), 0,(uint8 *)raws, j*2, 2, andret);
            count += bitCount(andret, 0, 64);
        }
        if(count == 5)
        {
            dindex[bet] = number;
            bet++;
        }
    }
    return bet;
}
*/

uint16 rk_get5StarDirectSegIndex(uint8 raws[],uint16 dindex[],int issue)
{
	ts_notused(issue);
    uint16 bet = 0;

    uint8 n1num[10] = {0};
    uint8 n2num[10] = {0};
    uint8 n3num[10] = {0};
    uint8 n4num[10] = {0};
    uint8 n5num[10] = {0};

    uint8 n1count = bitToUint8((uint8 *)raws, n1num, 2, 0);
    uint8 n2count = bitToUint8((uint8 *)(raws+2), n2num, 2, 0);
    uint8 n3count = bitToUint8((uint8 *)(raws+4), n3num, 2, 0);
    uint8 n4count = bitToUint8((uint8 *)(raws+6), n4num, 2, 0);
    uint8 n5count = bitToUint8((uint8 *)(raws+8), n5num, 2, 0);

    for(int n1 = 0; n1 < n1count; n1++)
    {
        for(int n2 = 0; n2 < n2count; n2++)
        {
            for(int n3 = 0; n3 < n3count; n3++)
            {
                for(int n4 = 0; n4 < n4count; n4++)
                {
                    for(int n5 = 0; n5 < n5count; n5++)
                    {
                    	dindex[bet] = FiveStarNumIndex(n1num[n1],n2num[n2],n3num[n3],n4num[n4],n5num[n5]);
                    	bet++;
                    }
                }
            }
        }
    }
    return bet;
}

uint16 rk_get5StarCompNumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
	ts_notused(issue);
    uint8 raws[2] = { 0 };
    uint8 num[5] = {0};
    GL_BETPART *betpart = GL_BETPART_A(line);


   	for (int idx = 0; idx < betpart->size / SSC_SEG_UNIT; idx++)
  	{
        memset(raws, 0 ,sizeof(raws));
        bitToUint8((uint8*) betpart->bitmap + idx * SSC_SEG_UNIT, raws, SSC_SEG_UNIT, 0);
        num[idx] = raws[0];
   	}

	dindex[0] = num[4];
	dindex[1] = num[3]*10 + num[4];
	dindex[2] = num[2]*100 + num[3]*10 + num[4];
	dindex[3] = num[0]*10000 + num[1]*1000 + num[2]*100 + num[3]*10 + num[4];
    return 4;
}

SSC_DXDS_TYPE  rk_getDxdsType(uint8 map[],int issue)
{
	uint8 dxdsBet =(uint8)( (map[0] << 4) | map[2]);
	for(int index=0;index < 16; index++)
	{
		if(DxdsStarBet(issue,index).betRaws == dxdsBet)
			return (SSC_DXDS_TYPE)index;
	}
    log_error("rk_getDxdsType() error. dxdsBet[%d], issue[%d]", dxdsBet, issue);
    return (SSC_DXDS_TYPE)-1;
}

uint8  rk_get3StarPortNumberType(int num)
{
	uint8 a = num/100;
	uint8 b = (num - (a * 100))/10;
	uint8 c = num%10;

	if((a == b) && (b == c))
	{
		return NUM_TYPE_DIRECT;
	}
	if((a == b) || (b == c) || (a == c))
	{
		return NUM_TYPE_ASS3;
	}
	return NUM_TYPE_ASS6;
}

uint16  rk_get3StarPortBaoDanNumberIndex(uint16 dindex[],uint8 dan,uint8 danNum[])
{
	int i=0;
	int bet = 0;
	if(dan == 1)
	{
		bet = BaoOneDan3Star(danNum[0]).count;
	    for(i=0;i<bet;i++)
	    {
	        dindex[i] = BaoOneDan3Star(danNum[0]).index[i];
	    }
	}
	else
	{
		int index = (danNum[0] < danNum[1])?(danNum[0]*10 + danNum[1]):(danNum[1]*10 + danNum[0]);
		bet = BaoTwoDan3Star(index).count;
	    for(i=0;i<bet;i++)
	    {
	        dindex[i] = BaoTwoDan3Star(index).index[i];
	    }
	}
	return bet;
}

uint16  rk_get3StarPortNumberIndex(BETLINE *line, uint16 dindex[])
{
	int idx = 0;
	uint16 ret = 0;
    uint8 tmp[100];
    uint8 dan = 0;
    uint8 danNum[2] = {0};
	GL_BETPART *betpart = GL_BETPART_A(line);
	uint8 bettype = GL_BETTYPE_A(line);
	switch(bettype)
	{
	case BETTYPE_HZ:
		ret = SumPort3Star(betpart->bitmap[0]).count;
		for(idx=0;idx < ret;idx++)
		{
			dindex[idx] =  SumPort3Star(betpart->bitmap[0]).index[idx];
		}
		break;
	case BETTYPE_BD:
		dan = bitCount((uint8 *)(betpart->bitmap), 0, betpart->size);
		for(idx=0;idx < dan ;idx++)
		{
			memset(tmp,0,sizeof(tmp));
			bitToUint8((uint8*)betpart->bitmap + SSC_SEG_UNIT * idx, tmp, SSC_SEG_UNIT, 0);
			danNum[idx] = tmp[0];
		}
		ret = rk_get3StarPortBaoDanNumberIndex(dindex,dan,danNum);
		/*
		break;
	case BETTYPE_SSC_KUADU:
		ret = SubDirect2Star(betpart->map[0]).count;
		for(idx=0;idx < ret;idx++)
		{
			dindex[idx] =  SubDirect2Star(betpart->map[0]).index[idx];
		}
		break;
		*/
	}
	return ret;
}


uint16  rk_get3StarAss6NumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
    uint16 bet = 0;
    uint8 count = 0;
    uint8 andret[64];
	GL_BETPART *betpart = GL_BETPART_A(line);
    for(int i=0;i<1000;i++)
    {
    	if(rk_checkNumberIsCombine6(i))
    	{
            memset(andret, 0, sizeof(andret));
            bitAnd((uint8 *)&(ThreeStarBet(issue,i).betCompact), 0, \
        		betpart->bitmap, 0, betpart->size, andret);
            count = bitCount(andret, 0, betpart->size);

            if(count == 3)
            {
                dindex[bet] = i;
                bet++;
            }
    	}
    }
    return bet;
}

uint16  rk_get3StarAss3NumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
    uint16 bet = 0;
    uint8 count = 0;
    uint8 andret[64];
	GL_BETPART *betpart = GL_BETPART_A(line);
	switch(GL_BETTYPE_A(line))
	{
    	case BETTYPE_DS:
    		for(int i=0;i<1000;i++)
    		{
    			count = 0;
    			for(int j=0;j<2;j++)
    			{
    				memset(andret, 0, sizeof(andret));
    				bitAnd((uint8 *)&(ThreeStarBet(issue,i).betNumMapAss3[j]), 0,\
    						(uint8 *)(betpart->bitmap), j*2, 2, andret);
    				count += bitCount(andret, 0, 64);
    			}
    			if(count == 2)
    			{
    				dindex[bet] = i;
    				bet++;
    			}
    		}
    		break;
    	case BETTYPE_FS:
    		for(int i=0;i<1000;i++)
    		{
    			uint8 num1 = i/100;
    			uint8 num2 = (i - num1 * 100)/10;
    			uint8 num3 = i%10;
    			if((num1 == num2) && (num1 != num3)) // "xxy"
    			{
    				count = 0;
    				memset(andret, 0, sizeof(andret));
    				bitAnd((uint8 *)&(ThreeStarBet(issue,i).betCompact), 0,\
    							(uint8 *)(betpart->bitmap), 0,betpart->size , andret);
    				count += bitCount(andret, 0, 64);

    				if(count == 2)
    				{
    					dindex[bet] = i;
    					bet++;
    				}
    			}
    		}
			break;
        default:
            log_error("rk_get3StarAss3NumberIndex() bettype[%d] error", GL_BETTYPE_A(line));
            return -1;
	}
    return bet;
}

uint16  rk_get3StarDirectNumberIndex(BETLINE *line, uint16 dindex[],int issue)
{
	int i = 0;
    uint16 bet = 0;
    uint8 count = 0;
    uint8 andret[64];
	GL_BETPART *betpart = GL_BETPART_A(line);
	switch(GL_BETTYPE_A(line))
	{
	case BETTYPE_DS:
	case BETTYPE_YXFS:
	    for( i=0;i<1000;i++)
	    {
	        count = 0;
	        for(int j=0;j<3;j++)
	        {
	            memset(andret, 0, sizeof(andret));
	            bitAnd((uint8 *)&(ThreeStarBet(issue,i).betNumMap[j]), 0,(uint8 *)(betpart->bitmap), j*2, 2, andret);
	            count += bitCount(andret, 0, 64);
	        }
	        if(count == 3)
	        {
	            dindex[bet] = i;
	            bet++;
	        }
	    }

		break;
	case BETTYPE_HZ:
	    for(i=0;i<SumDirect3Star(betpart->bitmap[0]).count;i++)
	    {
	        dindex[i] = SumDirect3Star(betpart->bitmap[0]).index[i];
	    }
	    bet = SumDirect3Star(betpart->bitmap[0]).count;
		break;
		/*
	case BETTYPE_SSC_KUADU:
	    for(i=0;i<SubDirect3Star(betpart->map[0]).count;i++)
	    {
	        dindex[i] = SubDirect3Star(betpart->map[0]).index[i];
	    }
	    bet = SubDirect3Star(betpart->map[0]).count;
	    break;
	    */
	case BETTYPE_BC:
	    for( i=0;i<1000;i++)
	    {
	    	uint8 numcount = bitCount((uint8 *)&(ThreeStarBet(issue,i).betCompact), 0, 2);
	        memset(andret, 0, sizeof(andret));
	        bitAnd((uint8 *)&(ThreeStarBet(issue,i).betCompact), 0, betpart->bitmap, 0, betpart->size, andret);
	        if( bitCount(andret, 0, 64) == numcount)
	        {
	            dindex[bet] = i;
	            bet++;
	        }
	    }
	}
	return bet;
}

uint8 rk_getUnitSubtype(uint8 subType,uint8 subtype[])
{
	uint8 subIndex = 0;
	switch(subType)
	{
	case SUBTYPE_1ZX:
	case SUBTYPE_2ZX:
	case SUBTYPE_2ZUX:
	case SUBTYPE_3ZX:
	case SUBTYPE_3Z3:
	case SUBTYPE_3Z6:
	case SUBTYPE_5ZX:
	case SUBTYPE_5TX:
	case SUBTYPE_DXDS:
		subIndex = 1;
		subtype[0] = subType;
		break;

	case SUBTYPE_2FX:
		subIndex = 2;
		subtype[0] = SUBTYPE_1ZX;
		subtype[1] = SUBTYPE_2ZX;
		break;

	case SUBTYPE_3FX:
		subIndex = 3;
		subtype[0] = SUBTYPE_1ZX;
		subtype[1] = SUBTYPE_2ZX;
		subtype[2] = SUBTYPE_3ZX;
		break;

	case SUBTYPE_3ZUX:
		subIndex = 3;
		subtype[0] = SUBTYPE_3ZX;
		subtype[1] = SUBTYPE_3Z3;
		subtype[2] = SUBTYPE_3Z6;
		break;

	case SUBTYPE_5FX:
		subIndex = 4;
		subtype[0] = SUBTYPE_1ZX;
		subtype[1] = SUBTYPE_2ZX;
		subtype[2] = SUBTYPE_3ZX;
		subtype[3] = SUBTYPE_5ZX;
		break;
	}
	return subIndex;
}

void rk_setReleaseSubtype(uint8 subtypeCode,bool boolSubtype[])
{
	uint8 tmpSub[MAX_SUBTYPE_COUNT] = {0};
	uint8 count = rk_getUnitSubtype(subtypeCode,tmpSub);
	for(int idx=0;idx < count;idx++)
	{
		boolSubtype[tmpSub[idx]] = true;
	}
}


uint16 rk_getBetNumberIndex(BETLINE *line,uint16 dindex[])
{
	GL_BETPART *betpart = NULL;
	switch(line->subtype)
	{
    	case SUBTYPE_1ZX:
    		return rk_get1StarDirectNumberIndex(line, dindex,0);

    	case SUBTYPE_2ZX:
    		return rk_get2StarDirectNumberIndex(line, dindex,0);

    	case SUBTYPE_2ZUX:
    		return rk_get2StarPortNumberIndex(line, dindex,0);

    	case SUBTYPE_2FX:
    		return rk_get2StarCompNumberIndex(line, dindex,0);

    	case SUBTYPE_3ZX:
    		return rk_get3StarDirectNumberIndex(line, dindex,0);

    	case SUBTYPE_3Z3:
    		return rk_get3StarAss3NumberIndex(line, dindex,0);

    	case SUBTYPE_3Z6:
    		return rk_get3StarAss6NumberIndex(line, dindex,0);

    	case SUBTYPE_3FX:
    		return rk_get3StarCompNumberIndex(line, dindex,0);

    	case SUBTYPE_3ZUX:
    		return rk_get3StarPortNumberIndex(line, dindex);

    	case SUBTYPE_5ZX:
    	case SUBTYPE_5TX:
    		betpart = GL_BETPART_A(line);
    		return rk_get5StarDirectSegIndex(betpart->bitmap, dindex,0);

    	case SUBTYPE_5FX:
    		return rk_get5StarCompNumberIndex(line, dindex,0);

    	case SUBTYPE_DXDS:// not support FS
    	{
    		betpart = GL_BETPART_A(line);
    		SSC_DXDS_TYPE mytype = rk_getDxdsType(betpart->bitmap,0);
    		dindex[0] = (uint16)mytype;
    		return 1;
    	}

        default:
            log_error("rk_getBetNumberIndex() subtype[%d] error", line->subtype);
            return -1;
	}
}
bool rk_verifyCommFun(BETLINE *line,int issue)
{
	uint8 subtype[MAX_SUBTYPE_COUNT] = {0};
	uint16 dindex[MAX_BETS_COUNT] = {0};
	int betNumIndexCount = 0;

	uint8 subIndexCount = rk_getUnitSubtype(line->subtype, subtype);
	betNumIndexCount = rk_getBetNumberIndex(line,dindex);
	switch(line->subtype)
	{
	    case SUBTYPE_3ZUX:
		    for(int idx=0; idx < betNumIndexCount; idx++)
    		{
    		    uint8 mytype = rk_get3StarPortNumberType(dindex[idx]);

    		    switch(mytype)
    		    {
    		    case NUM_TYPE_DIRECT:
    			if(line->betTimes + *(numCurrentBetCount(SUBTYPE_3ZX,issue,dindex[idx])) > currRestrictBetCount(SUBTYPE_3ZX,issue))
    			{
    				log_info("rk_verifyCommFun no pass SUBTYPE_3ZX verify  \
    						  line->betTimes[%d] num[%d] currentBetCount[%d] currRestrictBetCount[%d]",\
    						  line->betTimes,dindex[idx],*numCurrentBetCount(SUBTYPE_3ZX,issue,dindex[idx]),\
    						  currRestrictBetCount(SUBTYPE_3ZX,issue));
    				return false;
    			}
    			break;
    		    case NUM_TYPE_ASS3:
    				if(line->betTimes + *(numCurrentBetCount(SUBTYPE_3Z3,issue,dindex[idx])) > currRestrictBetCount(SUBTYPE_3Z3,issue))
    				{
    					log_info("rk_verifyCommFun no pass SUBTYPE_3ZX verify  \
    							  line->betTimes[%d] num[%d] currentBetCount[%d] currRestrictBetCount[%d]",\
    							  line->betTimes,dindex[idx],*numCurrentBetCount(SUBTYPE_3Z3,issue,dindex[idx]),\
    							  currRestrictBetCount(SUBTYPE_3Z3,issue));
    					return false;
    				}
    			break;
    		    case NUM_TYPE_ASS6:
    				if(line->betTimes + *(numCurrentBetCount(SUBTYPE_3Z6,issue,dindex[idx])) > currRestrictBetCount(SUBTYPE_3Z6,issue))
    				{
    					log_info("rk_verifyCommFun no pass SUBTYPE_3ZX verify  \
    							  line->betTimes[%d] num[%d] currentBetCount[%d] currRestrictBetCount[%d]",\
    							  line->betTimes,dindex[idx],*numCurrentBetCount(SUBTYPE_3Z6,issue,dindex[idx]),\
    							  currRestrictBetCount(SUBTYPE_3Z6,issue));
    					return false;
    				}
    			break;
    		    }
    		}
            break;
    	case SUBTYPE_2FX:
    	case SUBTYPE_3FX:
    	case SUBTYPE_5FX:
		    for(int idx=0; idx < subIndexCount; idx++)
    		{
    			if(line->betTimes + *(numCurrentBetCount(subtype[idx],issue,dindex[idx])) > currRestrictBetCount(subtype[idx],issue))
    			{
    				log_info("rk_verifyCommFun no pass line->subtype[%d] verify subtype[%d] \
    				  line->betCount[%d] line->betTimes[%d] currentBetCount[%d] currRestrictBetCount[%d]",\
    				  line->subtype,subtype[idx],line->betCount,line->betTimes,*numCurrentBetCount(subtype[idx],issue,dindex[idx]),\
    				  currRestrictBetCount(subtype[idx],issue));
    				return false;
    			}
    		}
            break;
	    default:
		    for(int jdx=0;jdx < betNumIndexCount;jdx++)
    		{
    			if(line->betTimes + *(numCurrentBetCount(line->subtype,issue,dindex[jdx])) > currRestrictBetCount(line->subtype,issue))
    			{
    				log_info("rk_verifyCommFun no pass line->subtype[%d] verify  \
    				  line->betCount[%d] line->betTimes[%d] currentBetCount[%d] currRestrictBetCount[%d]",\
    				  line->subtype,line->betCount,line->betTimes,*numCurrentBetCount(line->subtype,issue,dindex[jdx]),\
    				  currRestrictBetCount(line->subtype,issue));
    				return false;
    			}
    		}
            break;
    }
	return true;
}

void rk_saleDataAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint8 mysubtype[MAX_SUBTYPE_COUNT] = {0};
	uint8 count = rk_getUnitSubtype(line->subtype,mysubtype);
	if(line->subtype != SUBTYPE_3ZUX)
	{
	    for(int idx=0; idx < count; idx++)
	    {
	        if(commitFlag)
	        {
		        saleMoneyCommit(mysubtype[idx],issue) += (line->betCount * line->betTimes)/count * line->singleAmount;
		        currentBetCountCommit(mysubtype[idx],issue) += (line->betCount * line->betTimes)/count;
	        }
	        else
	        {
		        saleMoney(mysubtype[idx],issue) += (line->betCount * line->betTimes)/count * line->singleAmount;
		        currentBetCount(mysubtype[idx],issue) += (line->betCount * line->betTimes)/count;
	        }
	    }
	}
	else
	{
		GL_BETPART *betpart = GL_BETPART_A(line);
		int dan = betpart->size/2;
		switch(GL_BETTYPE_A(line))
		{
		case BETTYPE_BD:
			if(dan == 1) // 55
			{
				if(commitFlag)
				{
				    saleMoneyCommit(SUBTYPE_3ZX,issue) += 1 * line->singleAmount;
				    saleMoneyCommit(SUBTYPE_3Z3,issue) += 18 * line->singleAmount;
				    saleMoneyCommit(SUBTYPE_3Z6,issue) += 36 * line->singleAmount;
				    currentBetCountCommit(SUBTYPE_3ZX,issue) += 1;
				    currentBetCountCommit(SUBTYPE_3Z3,issue) += 18;
				    currentBetCountCommit(SUBTYPE_3Z6,issue) += 36;
				}
				else
				{
				    saleMoney(SUBTYPE_3ZX,issue) += 1 * line->singleAmount;
				    saleMoney(SUBTYPE_3Z3,issue) += 18 * line->singleAmount;
				    saleMoney(SUBTYPE_3Z6,issue) += 36 * line->singleAmount;
				    currentBetCount(SUBTYPE_3ZX,issue) += 1;
				    currentBetCount(SUBTYPE_3Z3,issue) += 18;
				    currentBetCount(SUBTYPE_3Z6,issue) += 36;
				}
			}
			else // dan =2 ,10
			{
				uint8 tmp[32] = {0};
				uint8 danNum[2] = {0};
			    for(int idx=0;idx < dan ;idx++)
			    {
			    	memset(tmp,0,sizeof(tmp));
				    bitToUint8((uint8*)betpart->bitmap + SSC_SEG_UNIT * idx, tmp, SSC_SEG_UNIT, 0);
				    danNum[idx] = tmp[0];
			    }
			    if(danNum[0] == danNum[1])
			    {
			    	if(commitFlag)
			    	{
					    saleMoneyCommit(SUBTYPE_3ZX,issue) += 1 * line->singleAmount;
					    saleMoneyCommit(SUBTYPE_3Z3,issue) += 9 * line->singleAmount;
					    currentBetCountCommit(SUBTYPE_3ZX,issue) += 1;
					    currentBetCountCommit(SUBTYPE_3Z3,issue) += 9;
			    	}
			    	else
			    	{
					    saleMoney(SUBTYPE_3ZX,issue) += 1 * line->singleAmount;
					    saleMoney(SUBTYPE_3Z3,issue) += 9 * line->singleAmount;
					    currentBetCount(SUBTYPE_3ZX,issue) += 1;
					    currentBetCount(SUBTYPE_3Z3,issue) += 9;
			    	}
			    }
			    else
			    {
			    	if(commitFlag)
			    	{
					    saleMoneyCommit(SUBTYPE_3Z3,issue) += 2 * line->singleAmount;
					    saleMoneyCommit(SUBTYPE_3Z6,issue) += 9 * line->singleAmount;
					    currentBetCountCommit(SUBTYPE_3Z3,issue) += 2;
					    currentBetCountCommit(SUBTYPE_3Z6,issue) += 9;
			    	}
			    	else
			    	{
					    saleMoney(SUBTYPE_3Z3,issue) += 2 * line->singleAmount;
					    saleMoney(SUBTYPE_3Z6,issue) += 9 * line->singleAmount;
					    currentBetCount(SUBTYPE_3Z3,issue) += 2;
					    currentBetCount(SUBTYPE_3Z6,issue) += 9;
			    	}
			    }
			}
			break;
		case BETTYPE_HZ:
			if(commitFlag)
			{
			    saleMoneyCommit(SUBTYPE_3ZX,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_DIRECT] * line->singleAmount;
	    		saleMoneyCommit(SUBTYPE_3Z3,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS3] * line->singleAmount;
		    	saleMoneyCommit(SUBTYPE_3Z6,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS6] * line->singleAmount;
			    currentBetCountCommit(SUBTYPE_3ZX,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_DIRECT];
	    		currentBetCountCommit(SUBTYPE_3Z3,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS3];
		    	currentBetCountCommit(SUBTYPE_3Z6,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS6];
			}
			else
			{
			    saleMoney(SUBTYPE_3ZX,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_DIRECT] * line->singleAmount;
	    		saleMoney(SUBTYPE_3Z3,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS3] * line->singleAmount;
		    	saleMoney(SUBTYPE_3Z6,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS6] * line->singleAmount;
			    currentBetCount(SUBTYPE_3ZX,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_DIRECT];
	    		currentBetCount(SUBTYPE_3Z3,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS3];
		    	currentBetCount(SUBTYPE_3Z6,issue) += SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS6];
			}
			break;
		}
	}
}

void rk_saleDataRelease(BETLINE *line,int issue)
{
	uint8 mysubtype[MAX_SUBTYPE_COUNT] = {0};
	uint8 count = rk_getUnitSubtype(line->subtype,mysubtype);
	if(line->subtype != SUBTYPE_3ZUX)
	{
	    for(int idx=0; idx < count; idx++)
	    {
	        saleMoney(mysubtype[idx],issue) -= (line->betCount * line->betTimes * line->singleAmount)/count;
	        currentBetCount(mysubtype[idx],issue) -= (line->betCount * line->betTimes)/count;
	    }
	}
	else
	{
		GL_BETPART *betpart = GL_BETPART_A(line);
		int dan = betpart->size/2;
		switch(GL_BETTYPE_A(line))
		{
		case BETTYPE_BD:
			if(dan == 1) // 55
			{
				saleMoney(SUBTYPE_3ZX,issue) -= 1 * line->singleAmount;
				saleMoney(SUBTYPE_3Z3,issue) -= 18 * line->singleAmount;
				saleMoney(SUBTYPE_3Z6,issue) -= 36 * line->singleAmount;
				currentBetCount(SUBTYPE_3ZX,issue) -= 1;
				currentBetCount(SUBTYPE_3Z3,issue) -= 18;
				currentBetCount(SUBTYPE_3Z6,issue) -= 36;
			}
			else // dan =2 ,10
			{
				uint8 tmp[32] = {0};
				uint8 danNum[2] = {0};
			    for(int idx=0;idx < dan ;idx++)
			    {
			    	memset(tmp,0,sizeof(tmp));
				    bitToUint8((uint8*)betpart->bitmap + SSC_SEG_UNIT * idx, tmp, SSC_SEG_UNIT, 0);
				    danNum[idx] = tmp[0];
			    }
			    if(danNum[0] == danNum[1])
			    {
					saleMoney(SUBTYPE_3ZX,issue) -= 1 * line->singleAmount;
					saleMoney(SUBTYPE_3Z3,issue) -= 9 * line->singleAmount;
					currentBetCount(SUBTYPE_3ZX,issue) -= 1;
					currentBetCount(SUBTYPE_3Z3,issue) -= 9;
			    }
			    else
			    {
					saleMoney(SUBTYPE_3Z3,issue) -= 2 * line->singleAmount;
					saleMoney(SUBTYPE_3Z6,issue) -= 9 * line->singleAmount;
					currentBetCount(SUBTYPE_3Z3,issue) -= 2;
					currentBetCount(SUBTYPE_3Z6,issue) -= 9;
			    }
			}
			break;
		case BETTYPE_HZ:
			saleMoney(SUBTYPE_3ZX,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_DIRECT] * line->singleAmount;
			saleMoney(SUBTYPE_3Z3,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS3] * line->singleAmount;
			saleMoney(SUBTYPE_3Z6,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS6] * line->singleAmount;
			currentBetCount(SUBTYPE_3ZX,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_DIRECT];
			currentBetCount(SUBTYPE_3Z3,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS3];
			currentBetCount(SUBTYPE_3Z6,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS6];
			break;
		}
	}
}


void rk_saleDataReleaseCommit(BETLINE *line,int issue)
{
	uint8 mysubtype[MAX_SUBTYPE_COUNT] = {0};
	uint8 count = rk_getUnitSubtype(line->subtype,mysubtype);
	if(line->subtype != SUBTYPE_3ZUX)
	{
	    for(int idx=0; idx < count; idx++)
	    {
	        saleMoneyCommit(mysubtype[idx],issue) -= (line->betCount * line->betTimes * line->singleAmount)/count;
	        currentBetCountCommit(mysubtype[idx],issue) -= (line->betCount * line->betTimes)/count;
	    }
	}
	else
	{
		GL_BETPART *betpart = GL_BETPART_A(line);
		int dan = betpart->size/2;
		switch(GL_BETTYPE_A(line))
		{
		case BETTYPE_BD:
			if(dan == 1) // 55
			{
				saleMoneyCommit(SUBTYPE_3ZX,issue) -= 1 * line->singleAmount;
				saleMoneyCommit(SUBTYPE_3Z3,issue) -= 18 * line->singleAmount;
				saleMoneyCommit(SUBTYPE_3Z6,issue) -= 36 * line->singleAmount;
				currentBetCountCommit(SUBTYPE_3ZX,issue) -= 1;
				currentBetCountCommit(SUBTYPE_3Z3,issue) -= 18;
				currentBetCountCommit(SUBTYPE_3Z6,issue) -= 36;
			}
			else // dan =2 ,10
			{
				uint8 tmp[32] = {0};
				uint8 danNum[2] = {0};
			    for(int idx=0;idx < dan ;idx++)
			    {
			    	memset(tmp,0,sizeof(tmp));
				    bitToUint8((uint8*)betpart->bitmap + SSC_SEG_UNIT * idx, tmp, SSC_SEG_UNIT, 0);
				    danNum[idx] = tmp[0];
			    }
			    if(danNum[0] == danNum[1])
			    {
					saleMoneyCommit(SUBTYPE_3ZX,issue) -= 1 * line->singleAmount;
					saleMoneyCommit(SUBTYPE_3Z3,issue) -= 9 * line->singleAmount;
					currentBetCountCommit(SUBTYPE_3ZX,issue) -= 1;
					currentBetCountCommit(SUBTYPE_3Z3,issue) -= 9;
			    }
			    else
			    {
					saleMoneyCommit(SUBTYPE_3Z3,issue) -= 2 * line->singleAmount;
					saleMoneyCommit(SUBTYPE_3Z6,issue) -= 9 * line->singleAmount;
					currentBetCountCommit(SUBTYPE_3Z3,issue) -= 2;
					currentBetCountCommit(SUBTYPE_3Z6,issue) -= 9;
			    }
			}
			break;
		case BETTYPE_HZ:
			saleMoneyCommit(SUBTYPE_3ZX,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_DIRECT] * line->singleAmount;
			saleMoneyCommit(SUBTYPE_3Z3,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS3] * line->singleAmount;
			saleMoneyCommit(SUBTYPE_3Z6,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS6] * line->singleAmount;
			currentBetCountCommit(SUBTYPE_3ZX,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_DIRECT];
			currentBetCountCommit(SUBTYPE_3Z3,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS3];
			currentBetCountCommit(SUBTYPE_3Z6,issue) -= SumPort3Star(betpart->bitmap[0]).subCount[NUM_TYPE_ASS6];
			break;
		}
	}
}


/*
void rk_saleDataRollback(BETLINE *line,int issue,bool commitFlag)
{
	if(commitFlag)
	{
		saleMoneyCommit(line->subtype,issue) -= line->betCount * line->betTimes;
		currentBetCountCommit(line->subtype,issue) -= line->betCount * line->betTimes;
	}
	else
	{
		saleMoney(line->subtype,issue) -= line->betCount * line->betTimes;
		currentBetCount(line->subtype,issue) -= line->betCount * line->betTimes;
	}
}
*/
void rk_1StarDirectAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[10] = {0};
	uint16  indexCount = rk_get1StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			OneStarBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
		}
		else
		{
			OneStarBet(issue,dindex[i]).betCount +=  line->betTimes;
		}
	}
}
void rk_1StarDirectRollback(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[10] = {0};
	uint16  indexCount = rk_get1StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			OneStarBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
		}
		else
		{
			OneStarBet(issue,dindex[i]).betCount -=  line->betTimes;
		}
	}
}

void rk_2StarDirectAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			TwoStarBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
		}
		else
		{
			TwoStarBet(issue,dindex[i]).betCount +=  line->betTimes;
		}
	}
}
void rk_2StarDirectRollback(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			TwoStarBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
		}
		else
		{
			TwoStarBet(issue,dindex[i]).betCount -=  line->betTimes;
		}
	}
}

void rk_2StarPortAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[100] = {0};
	uint16  indexCount = rk_get2StarPortNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			TwoStarBet(issue,dindex[i]).betCountPortCommit +=  line->betTimes;
		}
		else
		{
			TwoStarBet(issue,dindex[i]).betCountPort +=  line->betTimes;
		}
	}
}
void rk_2StarPortRollback(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[100] = {0};
	uint16  indexCount = rk_get2StarPortNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			TwoStarBet(issue,dindex[i]).betCountPortCommit -=  line->betTimes;
		}
		else
		{
			TwoStarBet(issue,dindex[i]).betCountPort -=  line->betTimes;
		}
	}
}

void rk_2StarCompAdder(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get2StarCompNumber(line,issue);
	if(commitFlag)
	{
		OneStarBet(issue,number%10).betCountCommit +=  line->betTimes;
		TwoStarBet(issue,number).betCountCommit +=  line->betTimes;
	}
	else
	{
		OneStarBet(issue,number%10).betCount += line->betTimes;
		TwoStarBet(issue,number).betCount += line->betTimes;
	}
}

void rk_2StarCompRollback(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get2StarCompNumber(line,issue);
	if(commitFlag)
	{
		OneStarBet(issue,number%10).betCountCommit -=  line->betTimes;
		TwoStarBet(issue,number).betCountCommit -=  line->betTimes;
	}
	else
	{
		OneStarBet(issue,number%10).betCount -= line->betTimes;
		TwoStarBet(issue,number).betCount -= line->betTimes;
	}
}

void rk_3StarDirectAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			ThreeStarBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
		}
		else
		{
			ThreeStarBet(issue,dindex[i]).betCount +=  line->betTimes;
		}
	}
}

void rk_3StarDirectRollback(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			ThreeStarBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
		}
		else
		{
			ThreeStarBet(issue,dindex[i]).betCount -=  line->betTimes;
		}
	}
}

void rk_3StarAss3Adder(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarAss3NumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			ThreeStarBet(issue,dindex[i]).betCountAss3Commit += line->betTimes;
		}
		else
		{
			ThreeStarBet(issue,dindex[i]).betCountAss3 +=  line->betTimes;
		}
	}
}

void rk_3StarAss3Rollback(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarAss3NumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			ThreeStarBet(issue,dindex[i]).betCountAss3Commit -=  line->betTimes;
		}
		else
		{
			ThreeStarBet(issue,dindex[i]).betCountAss3 -= line->betTimes;
		}
	}
}

void rk_3StarAss6Adder(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarAss6NumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			ThreeStarBet(issue,dindex[i]).betCountAss6Commit +=  line->betTimes;
		}
		else
		{
			ThreeStarBet(issue,dindex[i]).betCountAss6 +=  line->betTimes;
		}
	}
}

void rk_3StarAss6Rollback(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarAss6NumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			ThreeStarBet(issue,dindex[i]).betCountAss6Commit -=  line->betTimes;
		}
		else
		{
			ThreeStarBet(issue,dindex[i]).betCountAss6 -=  line->betTimes;
		}
	}
}

void rk_3StarPortAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarPortNumberIndex(line, dindex);
	for(int i=0;i<indexCount;i++)
	{
		uint8 mytype = rk_get3StarPortNumberType(dindex[i]);
		if(commitFlag)
		{
			switch(mytype)
			{
			case NUM_TYPE_DIRECT:
				ThreeStarBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
				break;
			case NUM_TYPE_ASS3:
				ThreeStarBet(issue,dindex[i]).betCountAss3Commit +=  line->betTimes;
				break;
			case NUM_TYPE_ASS6:
				ThreeStarBet(issue,dindex[i]).betCountAss6Commit +=  line->betTimes;
			}
		}
		else
		{
			switch(mytype)
			{
			case NUM_TYPE_DIRECT:
				ThreeStarBet(issue,dindex[i]).betCount +=  line->betTimes;
				break;
			case NUM_TYPE_ASS3:
				ThreeStarBet(issue,dindex[i]).betCountAss3 +=  line->betTimes;
				break;
			case NUM_TYPE_ASS6:
				ThreeStarBet(issue,dindex[i]).betCountAss6 +=  line->betTimes;
			}
		}
	}
}

void rk_3StarPortRollback(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarPortNumberIndex(line, dindex);
	for(int i=0;i<indexCount;i++)
	{
		uint8 mytype = rk_get3StarPortNumberType(dindex[i]);
		if(commitFlag)
		{
			switch(mytype)
			{
			case NUM_TYPE_DIRECT:
				ThreeStarBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
				break;
			case NUM_TYPE_ASS3:
				ThreeStarBet(issue,dindex[i]).betCountAss3Commit -=  line->betTimes;
				break;
			case NUM_TYPE_ASS6:
				ThreeStarBet(issue,dindex[i]).betCountAss6Commit -=  line->betTimes;
			}
		}
		else
		{
			switch(mytype)
			{
			case NUM_TYPE_DIRECT:
				ThreeStarBet(issue,dindex[i]).betCount -=  line->betTimes;
				break;
			case NUM_TYPE_ASS3:
				ThreeStarBet(issue,dindex[i]).betCountAss3 -=  line->betTimes;
				break;
			case NUM_TYPE_ASS6:
				ThreeStarBet(issue,dindex[i]).betCountAss6 -=  line->betTimes;
			}
		}
	}
}

void rk_3StarCompAdder(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get3StarCompNumber(line);
	if(commitFlag)
	{
		OneStarBet(issue,number%10).betCountCommit +=  line->betTimes;
		TwoStarBet(issue,number%100).betCountCommit +=  line->betTimes;
		ThreeStarBet(issue,number).betCountCommit +=  line->betTimes;
	}
	else
	{
		OneStarBet(issue,number%10).betCount +=  line->betTimes;
		TwoStarBet(issue,number%100).betCount +=  line->betTimes;
		ThreeStarBet(issue,number).betCount +=  line->betTimes;
	}
}

void rk_3StarCompRollback(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get3StarCompNumber(line);
	if(commitFlag)
	{
		OneStarBet(issue,number%10).betCountCommit -=  line->betTimes;
		TwoStarBet(issue,number%100).betCountCommit -=  line->betTimes;
		ThreeStarBet(issue,number).betCountCommit -=  line->betTimes;
	}
	else
	{
		OneStarBet(issue,number%10).betCount -=  line->betTimes;
		TwoStarBet(issue,number%100).betCount -=  line->betTimes;
		ThreeStarBet(issue,number).betCount -=  line->betTimes;
	}
}

void rk_5StarDirectAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[MAX_BETS_COUNT] = {0};
	GL_BETPART *betpart = GL_BETPART_A(line);
	uint16  indexCount = rk_get5StarDirectSegIndex(betpart->bitmap, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			FiveStarBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
		}
		else
		{
			FiveStarBet(issue,dindex[i]).betCount +=  line->betTimes;
		}
	}
}

void rk_5StarDirectRollback(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[MAX_BETS_COUNT] = {0};
	GL_BETPART *betpart = GL_BETPART_A(line);
	uint16  indexCount = rk_get5StarDirectSegIndex(betpart->bitmap, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			FiveStarBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
		}
		else
		{
			FiveStarBet(issue,dindex[i]).betCount -=  line->betTimes;
		}
	}
}

void rk_5StarCompAdder(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get5StarSegNumber(line);
	if(commitFlag)
	{
		FiveStarBet(issue,number).betCountCommit +=  line->betTimes;
		OneStarBet(issue,number%10).betCountCommit +=  line->betTimes;
		TwoStarBet(issue,number%100).betCountCommit +=  line->betTimes;
		ThreeStarBet(issue,number%1000).betCountCommit +=  line->betTimes;
	}
	else
	{
		FiveStarBet(issue,number).betCount +=  line->betTimes;
		OneStarBet(issue,number%10).betCount +=  line->betTimes;
		TwoStarBet(issue,number%100).betCount +=  line->betTimes;
		ThreeStarBet(issue,number%1000).betCount +=  line->betTimes;
	}
}

void rk_5StarCompRollback(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get5StarSegNumber(line);
	if(commitFlag)
	{
		FiveStarBet(issue,number).betCountCommit -=  line->betTimes;
		OneStarBet(issue,number%10).betCountCommit -=  line->betTimes;
		TwoStarBet(issue,number%100).betCountCommit -=  line->betTimes;
		ThreeStarBet(issue,number%1000).betCountCommit -=  line->betTimes;
	}
	else
	{
		FiveStarBet(issue,number).betCount -=  line->betTimes;
		OneStarBet(issue,number%10).betCount -=  line->betTimes;
		TwoStarBet(issue,number%100).betCount -=  line->betTimes;
		ThreeStarBet(issue,number%1000).betCount -=  line->betTimes;
	}
}

void rk_5StarWholeAdder(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get5StarSegNumber(line);
	if(commitFlag)
	{
		FiveStarBet(issue,number).betCountWholeCommit += line->betTimes;
		TwoStarBet(issue,number/1000).betCountFirstCommit += line->betTimes;
		TwoStarBet(issue,number%100).betCountLastCommit +=  line->betTimes;
		ThreeStarBet(issue,number/100).betCountFirstCommit +=  line->betTimes;
		ThreeStarBet(issue,number%1000).betCountLastCommit +=  line->betTimes;
	}
	else
	{
		FiveStarBet(issue,number).betCountWhole +=  line->betTimes;
        TwoStarBet(issue,number/1000).betCountFirst +=  line->betTimes;
   		TwoStarBet(issue,number%100).betCountLast +=  line->betTimes;
   		ThreeStarBet(issue,number/100).betCountFirst += line->betTimes;
   		ThreeStarBet(issue,number%1000).betCountLast += line->betTimes;
	}
}

void rk_5StarWholeRollback(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get5StarSegNumber(line);
	if(commitFlag)
	{
		FiveStarBet(issue,number).betCountWholeCommit -= line->betTimes;
		TwoStarBet(issue,number/1000).betCountFirstCommit -= line->betTimes;
		TwoStarBet(issue,number%100).betCountLastCommit -=  line->betTimes;
		ThreeStarBet(issue,number/100).betCountFirstCommit -=  line->betTimes;
		ThreeStarBet(issue,number%1000).betCountLastCommit -=  line->betTimes;
	}
	else
	{
		FiveStarBet(issue,number).betCountWhole -=  line->betTimes;
        TwoStarBet(issue,number/1000).betCountFirst -=  line->betTimes;
   		TwoStarBet(issue,number%100).betCountLast -= line->betTimes;
   		ThreeStarBet(issue,number/100).betCountFirst -= line->betTimes;
   		ThreeStarBet(issue,number%1000).betCountLast -= line->betTimes;
	}
}

void rk_dxdsAdder(BETLINE *line,int issue,bool commitFlag)
{
	GL_BETPART *betpart = GL_BETPART_A(line);
	SSC_DXDS_TYPE mytype = rk_getDxdsType(betpart->bitmap,issue);
	int numIndex = (int)mytype;

	if(commitFlag)
	{
		DxdsStarBet(issue,numIndex).betCountCommit +=  line->betTimes;
	}
	else
	{
		DxdsStarBet(issue,numIndex).betCount +=  line->betTimes;
	}
}

void rk_dxdsRollback(BETLINE *line,int issue,bool commitFlag)
{
	GL_BETPART *betpart = GL_BETPART_A(line);
	SSC_DXDS_TYPE mytype = rk_getDxdsType(betpart->bitmap,issue);
	int numIndex = (int)mytype;
	if(commitFlag)
	{
		DxdsStarBet(issue,numIndex).betCountCommit -=  line->betTimes;
	}
	else
	{
		DxdsStarBet(issue,numIndex).betCount -=  line->betTimes;
	}
}

void rk_1StarDirectMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[10] = {0};
	uint16  indexCount = rk_get1StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
	        if((OneStarBet(issue,dindex[i]).betCountCommit > numberMaxBetCountCommit(SUBTYPE_1ZX,issue))
	        	&& (!firstBetFlagCommit(SUBTYPE_1ZX,issue)) )
	        {
	        	numberMaxBetCountCommit(SUBTYPE_1ZX,issue) = OneStarBet(issue,dindex[i]).betCountCommit;
	        	firstBetNumberCommit(SUBTYPE_1ZX,issue) = dindex[i];
	        }
		}
		else
		{
	        if((OneStarBet(issue,dindex[i]).betCount > numberMaxBetCount(SUBTYPE_1ZX,issue))
	        	&& (!firstBetFlag(SUBTYPE_1ZX,issue)) )
	        {
	        	numberMaxBetCount(SUBTYPE_1ZX,issue) = OneStarBet(issue,dindex[i]).betCount;
	        	firstBetNumber(SUBTYPE_1ZX,issue) = dindex[i];
	        }
		}
	}
}

void rk_2StarDirectMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
			if((TwoStarBet(issue,dindex[i]).betCountCommit > numberMaxBetCountCommit(SUBTYPE_2ZX,issue))
		       	&& (!firstBetFlagCommit(SUBTYPE_2ZX,issue)) )
		    {
				numberMaxBetCountCommit(SUBTYPE_2ZX,issue) = TwoStarBet(issue,dindex[i]).betCountCommit;
		       	firstBetNumberCommit(SUBTYPE_2ZX,issue) = dindex[i];
		    }
		}
		else
		{
	        if((TwoStarBet(issue,dindex[i]).betCount > numberMaxBetCount(SUBTYPE_2ZX,issue))
	        	&& (!firstBetFlag(SUBTYPE_2ZX,issue)) )
	        {
	        	numberMaxBetCount(SUBTYPE_2ZX,issue) = TwoStarBet(issue,dindex[i]).betCount;
	        	firstBetNumber(SUBTYPE_2ZX,issue) = dindex[i];
	        }
		}
	}
}

void rk_2StarCompMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get2StarCompNumber(line,issue);
	if(commitFlag)
	{
        if((OneStarBet(issue,number%10).betCountCommit > numberMaxBetCountCommit(SUBTYPE_1ZX,issue))
        	&& (!firstBetFlagCommit(SUBTYPE_1ZX,issue)) )
        {
        	numberMaxBetCountCommit(SUBTYPE_1ZX,issue) = OneStarBet(issue,number%10).betCountCommit;
        	firstBetNumberCommit(SUBTYPE_1ZX,issue) = number%10;
        }

        if((TwoStarBet(issue,number).betCountCommit > numberMaxBetCountCommit(SUBTYPE_2ZX,issue))
        	&& (!firstBetFlagCommit(SUBTYPE_2ZX,issue)) )
        {
        	numberMaxBetCountCommit(SUBTYPE_2ZX,issue) = TwoStarBet(issue,number).betCountCommit;
        	firstBetNumberCommit(SUBTYPE_2ZX,issue) = number;
        }
	}
	else
	{
        if((OneStarBet(issue,number%10).betCount > numberMaxBetCount(SUBTYPE_1ZX,issue))
        	&& (!firstBetFlag(SUBTYPE_1ZX,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_1ZX,issue) = OneStarBet(issue,number%10).betCount;
        	firstBetNumber(SUBTYPE_1ZX,issue) = number%10;
        }
        if((TwoStarBet(issue,number).betCount > numberMaxBetCount(SUBTYPE_2ZX,issue))
        	&& (!firstBetFlag(SUBTYPE_2ZX,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_2ZX,issue) = TwoStarBet(issue,number).betCount;
        	firstBetNumber(SUBTYPE_2ZX,issue) = number;
        }
	}
}

void rk_2StarPortMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[100] = {0};
	uint16  indexCount = rk_get2StarPortNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
	        if((TwoStarBet(issue,dindex[i]).betCountPortCommit > numberMaxBetCountCommit(SUBTYPE_2ZUX,issue))
	        	&& (!firstBetFlagCommit(SUBTYPE_2ZUX,issue)) )
	        {
	        	numberMaxBetCountCommit(SUBTYPE_2ZUX,issue) = TwoStarBet(issue,dindex[i]).betCountPortCommit;
	        	firstBetNumberCommit(SUBTYPE_2ZUX,issue) = dindex[i];
	        }
		}
		else
		{
	        if((TwoStarBet(issue,dindex[i]).betCountPort > numberMaxBetCount(SUBTYPE_2ZUX,issue))
	        	&& (!firstBetFlag(SUBTYPE_2ZUX,issue)) )
	        {
	        	numberMaxBetCount(SUBTYPE_2ZUX,issue) = TwoStarBet(issue,dindex[i]).betCountPort;
	        	firstBetNumber(SUBTYPE_2ZUX,issue) = dindex[i];
	        }
		}
	}
}

void rk_3StarDirectMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
	        if((ThreeStarBet(issue,dindex[i]).betCountCommit > numberMaxBetCountCommit(SUBTYPE_3ZX,issue))
	        	&& (!firstBetFlagCommit(SUBTYPE_3ZX,issue)) )
	        {
	        	numberMaxBetCountCommit(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,dindex[i]).betCountCommit;
	        	firstBetNumberCommit(SUBTYPE_3ZX,issue) = dindex[i];
	        }
		}
		else
		{
	        if((ThreeStarBet(issue,dindex[i]).betCount > numberMaxBetCount(SUBTYPE_3ZX,issue))
	        	&& (!firstBetFlag(SUBTYPE_3ZX,issue)) )
	        {
	        	numberMaxBetCount(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,dindex[i]).betCount;
	        	firstBetNumber(SUBTYPE_3ZX,issue) = dindex[i];
	        }
		}
	}
}

void rk_3StarAss3MaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarAss3NumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
	        if((ThreeStarBet(issue,dindex[i]).betCountAss3Commit > numberMaxBetCountCommit(SUBTYPE_3Z3,issue))
	        	&& (!firstBetFlagCommit(SUBTYPE_3Z3,issue)) )
	        {
	        	numberMaxBetCountCommit(SUBTYPE_3Z3,issue) = ThreeStarBet(issue,dindex[i]).betCountAss3Commit;
	        	firstBetNumberCommit(SUBTYPE_3Z3,issue) = dindex[i];
	        }
		}
		else
		{
	        if((ThreeStarBet(issue,dindex[i]).betCountAss3 > numberMaxBetCount(SUBTYPE_3Z3,issue))
	        	&& (!firstBetFlag(SUBTYPE_3Z3,issue)) )
	        {
	        	numberMaxBetCount(SUBTYPE_3Z3,issue) = ThreeStarBet(issue,dindex[i]).betCountAss3;
	        	firstBetNumber(SUBTYPE_3Z3,issue) = dindex[i];
	        }
		}
	}
}

void rk_3StarAss6MaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarAss6NumberIndex(line, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
	        if((ThreeStarBet(issue,dindex[i]).betCountAss6Commit > numberMaxBetCountCommit(SUBTYPE_3Z6,issue))
	        	&& (!firstBetFlagCommit(SUBTYPE_3Z6,issue)) )
	        {
	        	numberMaxBetCountCommit(SUBTYPE_3Z6,issue) = ThreeStarBet(issue,dindex[i]).betCountAss6Commit;
	        	firstBetNumberCommit(SUBTYPE_3Z6,issue) = dindex[i];
	        }
		}
		else
		{
	        if((ThreeStarBet(issue,dindex[i]).betCountAss6 > numberMaxBetCount(SUBTYPE_3Z6,issue))
	        	&& (!firstBetFlag(SUBTYPE_3Z6,issue)) )
	        {
	        	numberMaxBetCount(SUBTYPE_3Z6,issue) = ThreeStarBet(issue,dindex[i]).betCountAss6;
	        	firstBetNumber(SUBTYPE_3Z6,issue) = dindex[i];
	        }
		}
	}
}

void rk_3StarCompMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get3StarCompNumber(line);
	if(commitFlag)
	{
        if((OneStarBet(issue,number%10).betCountCommit > numberMaxBetCountCommit(SUBTYPE_1ZX,issue))
        	&& (!firstBetFlagCommit(SUBTYPE_1ZX,issue)) )
        {
        	numberMaxBetCountCommit(SUBTYPE_1ZX,issue) = OneStarBet(issue,number%10).betCountCommit;
        	firstBetNumberCommit(SUBTYPE_1ZX,issue) = number%10;
        }
		if((TwoStarBet(issue,number%100).betCountCommit > numberMaxBetCountCommit(SUBTYPE_2ZX,issue))
	       	&& (!firstBetFlagCommit(SUBTYPE_2ZX,issue)) )
	    {
			numberMaxBetCountCommit(SUBTYPE_2ZX,issue) = TwoStarBet(issue,number%100).betCountCommit;
	       	firstBetNumberCommit(SUBTYPE_2ZX,issue) = number%100;
	    }
        if((ThreeStarBet(issue,number).betCountCommit > numberMaxBetCountCommit(SUBTYPE_3ZX,issue))
        	&& (!firstBetFlagCommit(SUBTYPE_3ZX,issue)) )
        {
        	numberMaxBetCountCommit(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,number).betCountCommit;
        	firstBetNumberCommit(SUBTYPE_3ZX,issue) = number;
        }
	}
	else
	{
        if((OneStarBet(issue,number%10).betCount > numberMaxBetCount(SUBTYPE_1ZX,issue))
        	&& (!firstBetFlag(SUBTYPE_1ZX,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_1ZX,issue) = OneStarBet(issue,number%10).betCount;
        	firstBetNumber(SUBTYPE_1ZX,issue) = number%10;
        }
		if((TwoStarBet(issue,number%100).betCount > numberMaxBetCount(SUBTYPE_2ZX,issue))
	       	&& (!firstBetFlag(SUBTYPE_2ZX,issue)) )
	    {
			numberMaxBetCount(SUBTYPE_2ZX,issue) = TwoStarBet(issue,number%100).betCount;
	       	firstBetNumber(SUBTYPE_2ZX,issue) = number%100;
	    }
        if((ThreeStarBet(issue,number).betCount > numberMaxBetCount(SUBTYPE_3ZX,issue))
        	&& (!firstBetFlag(SUBTYPE_3ZX,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,number).betCount;
        	firstBetNumber(SUBTYPE_3ZX,issue) = number;
        }
	}
}

void rk_3StarPortMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[1000] = {0};
	uint16  indexCount = rk_get3StarPortNumberIndex(line, dindex);
	for(int i=0;i<indexCount;i++)
	{
		uint8 mytype = rk_get3StarPortNumberType(dindex[i]);
		if(commitFlag)
		{
			switch(mytype)
			{
			case NUM_TYPE_DIRECT:
		        if((ThreeStarBet(issue,dindex[i]).betCountCommit > numberMaxBetCountCommit(SUBTYPE_3ZX,issue))
		        	&& (!firstBetFlagCommit(SUBTYPE_3ZX,issue)) )
		        {
		        	numberMaxBetCountCommit(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,dindex[i]).betCountCommit;
		        	firstBetNumberCommit(SUBTYPE_3ZX,issue) = dindex[i];
		        }
				break;
			case NUM_TYPE_ASS3:
		        if((ThreeStarBet(issue,dindex[i]).betCountAss3Commit > numberMaxBetCountCommit(SUBTYPE_3Z3,issue))
		        	&& (!firstBetFlagCommit(SUBTYPE_3Z3,issue)) )
		        {
		        	numberMaxBetCountCommit(SUBTYPE_3Z3,issue) = ThreeStarBet(issue,dindex[i]).betCountAss3Commit;
		        	firstBetNumberCommit(SUBTYPE_3Z3,issue) = dindex[i];
		        }
				break;
			case NUM_TYPE_ASS6:
		        if((ThreeStarBet(issue,dindex[i]).betCountAss6Commit > numberMaxBetCountCommit(SUBTYPE_3Z6,issue))
		        	&& (!firstBetFlagCommit(SUBTYPE_3Z6,issue)) )
		        {
		        	numberMaxBetCountCommit(SUBTYPE_3Z6,issue) = ThreeStarBet(issue,dindex[i]).betCountAss6Commit;
		        	firstBetNumberCommit(SUBTYPE_3Z6,issue) = dindex[i];
		        }
			}
		}
		else
		{
			switch(mytype)
			{
			case NUM_TYPE_DIRECT:
		        if((ThreeStarBet(issue,dindex[i]).betCount > numberMaxBetCount(SUBTYPE_3ZX,issue))
		        	&& (!firstBetFlag(SUBTYPE_3ZX,issue)) )
		        {
		        	numberMaxBetCount(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,dindex[i]).betCount;
		        	firstBetNumber(SUBTYPE_3ZX,issue) = dindex[i];
		        }
				break;
			case NUM_TYPE_ASS3:
		        if((ThreeStarBet(issue,dindex[i]).betCountAss3 > numberMaxBetCount(SUBTYPE_3Z3,issue))
		        	&& (!firstBetFlag(SUBTYPE_3Z3,issue)) )
		        {
		        	numberMaxBetCount(SUBTYPE_3Z3,issue) = ThreeStarBet(issue,dindex[i]).betCountAss3;
		        	firstBetNumber(SUBTYPE_3Z3,issue) = dindex[i];
		        }
				break;
			case NUM_TYPE_ASS6:
		        if((ThreeStarBet(issue,dindex[i]).betCountAss6 > numberMaxBetCount(SUBTYPE_3Z6,issue))
		        	&& (!firstBetFlag(SUBTYPE_3Z6,issue)) )
		        {
		        	numberMaxBetCount(SUBTYPE_3Z6,issue) = ThreeStarBet(issue,dindex[i]).betCountAss6;
		        	firstBetNumber(SUBTYPE_3Z6,issue) = dindex[i];
		        }
			}
		}
	}
}

void rk_5StarDirectMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	uint16 dindex[MAX_BETS_COUNT] = {0};
	GL_BETPART *betpart = GL_BETPART_A(line);
	uint16  indexCount = rk_get5StarDirectSegIndex(betpart->bitmap, dindex,issue);
	for(int i=0;i<indexCount;i++)
	{
		if(commitFlag)
		{
	        if((FiveStarBet(issue,dindex[i]).betCountCommit > numberMaxBetCountCommit(SUBTYPE_5ZX,issue))
	        	&& (!firstBetFlagCommit(SUBTYPE_5ZX,issue)) )
	        {
	        	numberMaxBetCountCommit(SUBTYPE_5ZX,issue) = FiveStarBet(issue,dindex[i]).betCountCommit;
	        	firstBetNumberCommit(SUBTYPE_5ZX,issue) = dindex[i];
	        }
		}
		else
		{
	        if((FiveStarBet(issue,dindex[i]).betCount > numberMaxBetCount(SUBTYPE_5ZX,issue))
	        	&& (!firstBetFlag(SUBTYPE_5ZX,issue)) )
	        {
	        	numberMaxBetCount(SUBTYPE_5ZX,issue) = FiveStarBet(issue,dindex[i]).betCount;
	        	firstBetNumber(SUBTYPE_5ZX,issue) = dindex[i];
	        }
		}
	}
}

void rk_5StarCompMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get5StarSegNumber(line);
	if(commitFlag)
	{
        if((OneStarBet(issue,number%10).betCountCommit > numberMaxBetCountCommit(SUBTYPE_1ZX,issue))
        	&& (!firstBetFlagCommit(SUBTYPE_1ZX,issue)) )
        {
        	numberMaxBetCountCommit(SUBTYPE_1ZX,issue) = OneStarBet(issue,number%10).betCountCommit;
        	firstBetNumberCommit(SUBTYPE_1ZX,issue) = number%10;
        }
		if((TwoStarBet(issue,number%100).betCountCommit > numberMaxBetCountCommit(SUBTYPE_2ZX,issue))
	       	&& (!firstBetFlagCommit(SUBTYPE_2ZX,issue)) )
	    {
			numberMaxBetCountCommit(SUBTYPE_2ZX,issue) = TwoStarBet(issue,number%100).betCountCommit;
	       	firstBetNumberCommit(SUBTYPE_2ZX,issue) = number%100;
	    }
        if((ThreeStarBet(issue,number%1000).betCountCommit > numberMaxBetCountCommit(SUBTYPE_3ZX,issue))
        	&& (!firstBetFlagCommit(SUBTYPE_3ZX,issue)) )
        {
        	numberMaxBetCountCommit(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,number%1000).betCountCommit;
        	firstBetNumberCommit(SUBTYPE_3ZX,issue) = number%1000;
        }
        if((FiveStarBet(issue,number).betCountCommit > numberMaxBetCountCommit(SUBTYPE_5ZX,issue))
        	&& (!firstBetFlagCommit(SUBTYPE_5ZX,issue)) )
        {
        	numberMaxBetCountCommit(SUBTYPE_5ZX,issue) = FiveStarBet(issue,number).betCountCommit;
        	firstBetNumberCommit(SUBTYPE_5ZX,issue) = number;
        }
	}
	else
	{
        if(OneStarBet(issue,number%10).betCount > numberMaxBetCount(SUBTYPE_1ZX,issue))
        	numberMaxBetCount(SUBTYPE_1ZX,issue) = OneStarBet(issue,number%10).betCount;
        if(TwoStarBet(issue,number%100).betCount > numberMaxBetCount(SUBTYPE_2ZX,issue))
        	numberMaxBetCount(SUBTYPE_2ZX,issue) = TwoStarBet(issue,number%100).betCount;
        if(ThreeStarBet(issue,number%1000).betCount > numberMaxBetCount(SUBTYPE_3ZX,issue))
        	numberMaxBetCount(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,number%1000).betCount;
        if(FiveStarBet(issue,number).betCount > numberMaxBetCount(SUBTYPE_5ZX,issue))
        	numberMaxBetCount(SUBTYPE_5ZX,issue) = FiveStarBet(issue,number).betCount;

        if((OneStarBet(issue,number%10).betCount > numberMaxBetCount(SUBTYPE_1ZX,issue))
        	&& (!firstBetFlag(SUBTYPE_1ZX,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_1ZX,issue) = OneStarBet(issue,number%10).betCount;
        	firstBetNumber(SUBTYPE_1ZX,issue) = number%10;
        }
		if((TwoStarBet(issue,number%100).betCount > numberMaxBetCount(SUBTYPE_2ZX,issue))
	       	&& (!firstBetFlag(SUBTYPE_2ZX,issue)) )
	    {
			numberMaxBetCount(SUBTYPE_2ZX,issue) = TwoStarBet(issue,number%100).betCount;
	       	firstBetNumber(SUBTYPE_2ZX,issue) = number%100;
	    }
        if((ThreeStarBet(issue,number%1000).betCount > numberMaxBetCount(SUBTYPE_3ZX,issue))
        	&& (!firstBetFlag(SUBTYPE_3ZX,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_3ZX,issue) = ThreeStarBet(issue,number%1000).betCount;
        	firstBetNumber(SUBTYPE_3ZX,issue) = number%1000;
        }
        if((FiveStarBet(issue,number).betCount > numberMaxBetCount(SUBTYPE_5ZX,issue))
        	&& (!firstBetFlag(SUBTYPE_5ZX,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_5ZX,issue) = FiveStarBet(issue,number).betCount;
        	firstBetNumber(SUBTYPE_5ZX,issue) = number;
        }
	}
}

void rk_5StarWholeMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	int number = rk_get5StarSegNumber(line);
	if(commitFlag)
	{
        if((FiveStarBet(issue,number).betCountWholeCommit > numberMaxBetCountCommit(SUBTYPE_5TX,issue))
        	&& (!firstBetFlagCommit(SUBTYPE_5TX,issue)) )
        {
        	numberMaxBetCountCommit(SUBTYPE_5TX,issue) = FiveStarBet(issue,number).betCountWholeCommit;
        	firstBetNumberCommit(SUBTYPE_5TX,issue) = number;
        }
	}
	else
	{
        if((FiveStarBet(issue,number).betCountWhole > numberMaxBetCount(SUBTYPE_5TX,issue))
        	&& (!firstBetFlag(SUBTYPE_5TX,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_5TX,issue) = FiveStarBet(issue,number).betCountWhole;
        	firstBetNumber(SUBTYPE_5TX,issue) = number;
        }
	}
}

void rk_dxdsMaxBetNumber(BETLINE *line,int issue,bool commitFlag)
{
	GL_BETPART *betpart = GL_BETPART_A(line);
	SSC_DXDS_TYPE mytype = rk_getDxdsType(betpart->bitmap,issue);
	int numIndex = (int)mytype;

	if(commitFlag)
	{
		if((DxdsStarBet(issue,numIndex).betCountCommit > numberMaxBetCountCommit(SUBTYPE_DXDS,issue))
	       	&& (!firstBetFlagCommit(SUBTYPE_DXDS,issue)) )
	    {
			numberMaxBetCountCommit(SUBTYPE_DXDS,issue) = DxdsStarBet(issue,numIndex).betCountCommit;
	       	firstBetNumberCommit(SUBTYPE_DXDS,issue) = numIndex;
	    }
	}
	else
	{
        if((DxdsStarBet(issue,numIndex).betCount > numberMaxBetCount(SUBTYPE_DXDS,issue))
        	&& (!firstBetFlag(SUBTYPE_DXDS,issue)) )
        {
        	numberMaxBetCount(SUBTYPE_DXDS,issue) = DxdsStarBet(issue,numIndex).betCount;
        	firstBetNumber(SUBTYPE_DXDS,issue) = numIndex;
        }
	}
}

/////////////////////////////////////////////////////////////////////////////////
void rk_initVerifyFun(void)
{
	rk_verifyFunAdder[SUBTYPE_1ZX] = rk_1StarDirectAdder;
	rk_verifyFunAdder[SUBTYPE_2ZX] = rk_2StarDirectAdder;
	rk_verifyFunAdder[SUBTYPE_2FX] = rk_2StarCompAdder;
	rk_verifyFunAdder[SUBTYPE_2ZUX] = rk_2StarPortAdder;
	rk_verifyFunAdder[SUBTYPE_3ZX] = rk_3StarDirectAdder;
	rk_verifyFunAdder[SUBTYPE_3Z3] = rk_3StarAss3Adder;
	rk_verifyFunAdder[SUBTYPE_3Z6] = rk_3StarAss6Adder;
	rk_verifyFunAdder[SUBTYPE_3FX] = rk_3StarCompAdder;
	rk_verifyFunAdder[SUBTYPE_3ZUX] = rk_3StarPortAdder;
	rk_verifyFunAdder[SUBTYPE_5ZX] = rk_5StarDirectAdder;
	rk_verifyFunAdder[SUBTYPE_5FX] = rk_5StarCompAdder;
	rk_verifyFunAdder[SUBTYPE_5TX] = rk_5StarWholeAdder;
	rk_verifyFunAdder[SUBTYPE_DXDS] = rk_dxdsAdder;

    rk_verifyFunRollback[SUBTYPE_1ZX] = rk_1StarDirectRollback;
    rk_verifyFunRollback[SUBTYPE_2ZX] = rk_2StarDirectRollback;
    rk_verifyFunRollback[SUBTYPE_2FX] = rk_2StarCompRollback;
    rk_verifyFunRollback[SUBTYPE_2ZUX] = rk_2StarPortRollback;
    rk_verifyFunRollback[SUBTYPE_3ZX] = rk_3StarDirectRollback;
    rk_verifyFunRollback[SUBTYPE_3Z3] = rk_3StarAss3Rollback;
    rk_verifyFunRollback[SUBTYPE_3Z6] = rk_3StarAss6Rollback;
    rk_verifyFunRollback[SUBTYPE_3FX] = rk_3StarCompRollback;
    rk_verifyFunRollback[SUBTYPE_3ZUX] = rk_3StarPortRollback;
    rk_verifyFunRollback[SUBTYPE_5ZX] = rk_5StarDirectRollback;
    rk_verifyFunRollback[SUBTYPE_5FX] = rk_5StarCompRollback;
    rk_verifyFunRollback[SUBTYPE_5TX] = rk_5StarWholeRollback;
    rk_verifyFunRollback[SUBTYPE_DXDS] = rk_dxdsRollback;


    rk_getMaxBetNumber[SUBTYPE_1ZX] = rk_1StarDirectMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_2ZX] = rk_2StarDirectMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_2FX] = rk_2StarCompMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_2ZUX] = rk_2StarPortMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_3ZX] = rk_3StarDirectMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_3Z3] = rk_3StarAss3MaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_3Z6] = rk_3StarAss6MaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_3FX] = rk_3StarCompMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_3ZUX] = rk_3StarPortMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_5ZX] = rk_5StarDirectMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_5FX] = rk_5StarCompMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_5TX] = rk_5StarWholeMaxBetNumber;
    rk_getMaxBetNumber[SUBTYPE_DXDS] = rk_dxdsMaxBetNumber;
}

uint32 rk_getFirst3StarBet(int num,int issue)
{
	uint32 bet = 0;
	for(int i=0;i<100;i++)
	{
		bet += ThreeStarBet(issue,FiveStarWholeIndex(num).indexFirst3Star[i]).betCountFirst;
	}
	return bet;
}

uint32 rk_getFirst3StarBetCommit(int num,int issue)
{
	uint32 bet = 0;
	for(int i=0;i<100;i++)
	{
		bet += ThreeStarBet(issue,FiveStarWholeIndex(num).indexFirst3Star[i]).betCountFirstCommit;
	}
	return bet;
}

uint32 rk_getLast3StarBet(int num,int issue)
{
	uint32 bet = 0;
	for(int i=0;i<100;i++)
	{
		bet += ThreeStarBet(issue,FiveStarWholeIndex(num).indexLast3Star[i]).betCountLast;
	}
	return bet;
}
uint32 rk_getLast3StarBetCommit(int num,int issue)
{
	uint32 bet = 0;
	for(int i=0;i<100;i++)
	{
		bet += ThreeStarBet(issue,FiveStarWholeIndex(num).indexLast3Star[i]).betCountLastCommit;
	}
	return bet;
}

uint32 rk_getFirst2StarBet(int num,int issue)
{
	uint32 bet = 0;
	for(int i=0;i<1000;i++)
	{
		bet += TwoStarBet(issue,FiveStarWholeIndex(num).indexFirst2Star[i]).betCountFirst;
	}
	return bet;
}

uint32 rk_getFirst2StarBetCommit(int num,int issue)
{
	uint32 bet = 0;
	for(int i=0;i<1000;i++)
	{
		bet += TwoStarBet(issue,FiveStarWholeIndex(num).indexFirst2Star[i]).betCountFirstCommit;
	}
	return bet;
}

uint32 rk_getLast2StarBet(int num,int issue)
{
	uint32 bet = 0;
	for(int i=0;i<1000;i++)
	{
		bet += TwoStarBet(issue,FiveStarWholeIndex(num).indexLast2Star[i]).betCountLast;
	}
	return bet;
}

uint32 rk_getLast2StarBetCommit(int num,int issue)
{
	uint32 bet = 0;
	for(int i=0;i<1000;i++)
	{
		bet += TwoStarBet(issue,FiveStarWholeIndex(num).indexLast2Star[i]).betCountLastCommit;
	}
	return bet;
}



void rk_releaseBets(uint16 singleAmount,int issue,bool subtypeArray[],bool commitFlag)
{
	for(int subtype = SUBTYPE_1ZX;subtype <= SUBTYPE_DXDS ;subtype++)
	{
		if(commitFlag)
		{
			if((subtypeArray[subtype]) && (numberMaxBetCountCommit(subtype,issue) >= initBetLimit(issue,subtype)))
			{
				if(!firstBetFlagCommit(subtype,issue))
				{
					firstBetCountCommit(subtype,issue) = currentBetCountCommit(subtype,issue);
					firstBetFlagCommit(subtype,issue) = true;
				}
				//money_t winMoney = rk_getMaxWinMoneyCommit(issue,subtype);
				money_t saleIncrease = saleMoneyCommit(subtype,issue) - firstBetCountCommit(subtype,issue) * singleAmount;
				uint32 newLimitBet = initBetLimit(issue,subtype) + (int)((saleIncrease * winPercentBet(issue))/winMoney(issue,subtype));
				if(newLimitBet > currRestrictBetCountCommit(subtype,issue))
				{
					currRestrictBetCountCommit(subtype,issue) = newLimitBet;
				}
			}
		}
		else
		{
			if((subtypeArray[subtype]) && (numberMaxBetCount(subtype,issue) >= initBetLimit(issue,subtype)))
			{
				if(!firstBetFlag(subtype,issue))
				{
					firstBetCount(subtype,issue) = currentBetCount(subtype,issue);
					firstBetFlag(subtype,issue) = true;
				}
				//money_t winMoney = rk_getMaxWinMoney(issue,subtype);
				money_t saleIncrease = saleMoney(subtype,issue) - firstBetCount(subtype,issue) * singleAmount;
				uint32 newLimitBet = initBetLimit(issue,subtype) + (int)((saleIncrease * winPercentBet(issue))/winMoney(issue,subtype));
				if(newLimitBet > currRestrictBetCount(subtype,issue))
				{
					log_info("ssc rk subtype[%d] releaseBets saleMoney[%lld] saleIncrease[%lld] oldLimitBet[%d] newLimitBet[%d]",\
							subtype,saleMoney(subtype,issue),saleIncrease,currRestrictBetCount(subtype,issue),newLimitBet);
					currRestrictBetCount(subtype,issue) = newLimitBet;
				}
			}
		}
	}
}



void gl_ssc_saveIssueInfoStatistic(int issue,money_t refuseMoney)
{
	issueStatRefuseMoney(issue) += refuseMoney;
	issueStatRefuseCount(issue)++;
}


//  风险控制验证接口
bool riskVerify(	TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;

    bool subtype[MAX_SUBTYPE_COUNT];
    memset((void *)subtype,0,sizeof(subtype));

	for(int acount = 0; acount < pTicket->issueCount; acount++)
	{
		issueIndex = rk_get_ssc_issueIndexBySeq( pTicket->issueSeq + acount);
		BETLINE *line =  (BETLINE *)GL_BETLINE(pTicket);
        for(int aline = 0;aline < pTicket->betlineCount; aline++)
        {
            if(!commitFlag)
            {
                if(rk_getNumRestrictFlag( line))
                {
                    log_info("riskVerify rk_getNumRestrictFlag! ");
                    goto ROCK_BACK;
                }
                if(!rk_verifyCommFun(line,issueIndex ))
                {
ROCK_BACK:
                    gl_ssc_saveIssueInfoStatistic(issueIndex,pTicket->amount);

                    for(int rcount = 0; rcount < acount+1; rcount++)
                    {
                    	issueIndex = rk_get_ssc_issueIndexBySeq(pTicket->issueSeq + rcount);
                        line = (BETLINE *)GL_BETLINE(pTicket);
                        for(int rline = 0;rline < aline; rline++)
                        {
                    	    rk_saleDataRelease(line,issueIndex);
                            rk_verifyFunRollback[line->subtype](line,issueIndex, commitFlag);
                            line = (BETLINE *) GL_BETLINE_NEXT(line);
                        }
                    }
/*
                NOTIFY_GL_RISK_CTRL nrk;
                memset((char *)&nrk,0,sizeof(nrk));
                nrk.issueNumber = issueTmp;
                nrk.subType = line->subtype;
                nrk.overMount = line->betCount * line->betTimes;
                om_notify(E_NOTIFY_GL_RISK_CTRL, _INFO, sizeof(nrk), &nrk);
*/
                    log_info("ssc rk no pass issue[%lld] subtype[%d] commit[%d]",\
                    		pTicket->issue,line->subtype,commitFlag?1:0);
                    return false;
                }
            }
            rk_saleDataAdder(line,issueIndex, commitFlag);
            rk_verifyFunAdder[line->subtype](line,issueIndex, commitFlag);
            rk_setReleaseSubtype(line->subtype,subtype);
            line = (BETLINE *) GL_BETLINE_NEXT(line);
        }
	}


    for(int acount = 0; acount < pTicket->issueCount; acount++)
    {
      	issueIndex = rk_get_ssc_issueIndexBySeq(pTicket->issueSeq + acount);
        BETLINE *line = (BETLINE *)GL_BETLINE(pTicket);
        for(int aline = 0;aline < pTicket->betlineCount; aline++)
        {
          	rk_getMaxBetNumber[line->subtype](line,issueIndex,commitFlag);
          	line = (BETLINE *) GL_BETLINE_NEXT(line);
        }
        rk_releaseBets(line->singleAmount,issueIndex,subtype,commitFlag);
    }

    log_info("ssc rk pass issue[%lld] commit[%d]",\
    		pTicket->issue,commitFlag?1:0);
    return true;
}


// 退票风险控制参数回滚接口
void riskRollback(TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;

    for(int acount = 0; acount < pTicket->issueCount; acount++)
    {
    	issueIndex = rk_get_ssc_issueIndexBySeq( pTicket->issueSeq + acount);
        BETLINE *line = (BETLINE *)GL_BETLINE(pTicket);
        for(int i=0;i<pTicket->betlineCount;i++)
        {
        	if(commitFlag)
        	    rk_saleDataReleaseCommit(line,issueIndex);
        	else
        		rk_saleDataRelease(line,issueIndex);
            rk_verifyFunRollback[line->subtype](line,issueIndex, commitFlag);
            line = (BETLINE *) GL_BETLINE_NEXT(line);
        }
    }
}

void rk_loadBaoOneDan3Star(int dan)
{
	int index;
	int jdx = 0;
	for(index = 0;index < 1000;index++)
	{
		int n1 = index/100;
		int n2 = (index - n1 * 100)/10;
		int n3 = index % 10;

		if( (n1 == dan) || (n2 == dan) || (n3 == dan))
		{
			BaoOneDan3Star(dan).index[jdx] = index;
			BaoOneDan3Star(dan).count++;
			jdx++;
		}
	}
}

void rk_loadSumDirect2Star(int sum,int index)
{
    if(SumDirect2Star(sum).count == 0)
    {
    	SumDirect2Star(sum).index[0] = index;
    	SumDirect2Star(sum).count++;
    }
    else
    {
        int count = SumDirect2Star(sum).count;
        for(int i = 0; i < count; i++)
        {
            if(SumDirect2Star(sum).index[i] == index)
            {
                return;
            }
        }
        SumDirect2Star(sum).index[count] = index;
        SumDirect2Star(sum).count++;
    }
}

void rk_loadSumPort2Star(int sum,int index)
{
    if(SumPort2Star(sum).count == 0)
    {
    	SumPort2Star(sum).index[0] = index;
    	SumPort2Star(sum).count++;
    }
    else
    {
        int count = SumPort2Star(sum).count;
        for(int i = 0; i < count; i++)
        {
            if(SumPort2Star(sum).index[i] == index)
            {
                return;
            }
        }
        SumPort2Star(sum).index[count] = index;
        SumPort2Star(sum).count++;
    }
}

void rk_loadBaoTwoDan3Star(int d1,int d2)
{
	if(d1 > d2)
		return;
	int index;
	int jdx = 0;
	for(index = 0;index < 1000;index++)
	{
		int n1 = index/100;
		int n2 = (index - n1 * 100)/10;
		int n3 = index % 10;

		if( ((d1 == n1) && (d2 == n2)) || \
			((d1 == n1) && (d2 == n3)) || \
			((d1 == n2) && (d2 == n1)) || \
			((d1 == n2) && (d2 == n3)) || \
			((d1 == n3) && (d2 == n1)) || \
			((d1 == n3) && (d2 == n2)) )

		{
			BaoTwoDan3Star(d1*10 + d2).index[jdx] = index;
			BaoTwoDan3Star(d1*10 + d2).count++;
			jdx++;
		}
	}
}

void rk_loadSubDirect2Star(int sub,int index)
{
    if(SubDirect2Star(sub).count == 0)
    {
    	SubDirect2Star(sub).index[0] = index;
    	SubDirect2Star(sub).count++;
    }
    else
    {
        int count = SubDirect2Star(sub).count;
        for(int i = 0; i < count; i++)
        {
            if(SubDirect2Star(sub).index[i] == index)
            {
                return;
            }
        }
        SubDirect2Star(sub).index[count] = index;
        SubDirect2Star(sub).count++;
    }
}

void rk_loadSubPort2Star(int sub,int index)
{
    if(SubPort2Star(sub).count == 0)
    {
    	SubPort2Star(sub).index[0] = index;
    	SubPort2Star(sub).count++;
    }
    else
    {
        int count = SubPort2Star(sub).count;
        for(int i = 0; i < count; i++)
        {
            if(SubPort2Star(sub).index[i] == index)
            {
                return;
            }
        }
        SubPort2Star(sub).index[count] = index;
        SubPort2Star(sub).count++;
    }
}

void rk_loadSumDirect3Star(int sum,int index)
{
    if(SumDirect3Star(sum).count == 0)
    {
    	SumDirect3Star(sum).index[0] = index;
    	SumDirect3Star(sum).count++;
    }
    else
    {
        int count = SumDirect3Star(sum).count;
        for(int i = 0; i < count; i++)
        {
                    if(SumDirect3Star(sum).index[i] == index)
                    {
                        return;
                    }
        }
        SumDirect3Star(sum).index[count] = index;
        SumDirect3Star(sum).count++;
    }
}

void rk_loadSumPort3Star(int sum,int index)
{
    if(SumPort3Star(sum).count == 0)
    {
    	SumPort3Star(sum).index[0] = index;
    	SumPort3Star(sum).count++;
    }
    else
    {
        int count = SumPort3Star(sum).count;
        for(int i = 0; i < count; i++)
        {
            if(SumPort3Star(sum).index[i] == index)
            {
                return;
            }
        }
        SumPort3Star(sum).index[count] = index;
        SumPort3Star(sum).count++;
    }
}

void rk_initPort3SumSubCount(void)
{
	uint8 numberFlag[1024] = {0};
	for(int sum=0; sum < 28; sum++)
	{
		SumPort3Star(sum).subCount[0] = SumPort3Star(sum).subCount[1] = SumPort3Star(sum).subCount[2] = 0;
		memset(numberFlag,0,sizeof(numberFlag));
		for(int numIndex=0; numIndex < SumPort3Star(sum).count; numIndex++)
		{
			if(numberFlag[ ThreeStarBet(0,SumPort3Star(sum).index[numIndex]).betCompact] == 0)
			{
				uint8 mytype = rk_get3StarPortNumberType(SumPort3Star(sum).index[numIndex]);
				SumPort3Star(sum).subCount[mytype]++;
				numberFlag[ ThreeStarBet(0,SumPort3Star(sum).index[numIndex]).betCompact] = 1;
			}
		}
	}
}

void rk_loadFiveStarWholeIndex(int n1,int n2,int n3,int n4,int n5,int index)
{
	int idx = 0;
	int f3s = n1*10000 + n2*1000 + n3*100;
	int l3s = n3*100 + n4*10 + n5;
	int f2s = n1*10000 + n2*1000;
	int l2s = n4*10 + n5;
	for(idx=0;idx < 100;idx++)
	{
		FiveStarWholeIndex(index).indexFirst3Star[idx] = f3s+idx;
		FiveStarWholeIndex(index).indexLast3Star[idx] = idx * 1000 + l3s;
	}

	for(idx=0;idx < 1000;idx++)
	{
		FiveStarWholeIndex(index).indexFirst2Star[idx] = f2s+idx;
		FiveStarWholeIndex(index).indexLast2Star[idx] = idx * 100 + l2s;
	}
}

void rk_ssc_betNumberInit(void)
{
	int num = 0;
	for(int issue = 0;issue < totalIssueCount;issue++)
	{
		for(num = 0;num < 10; num++)
		{
			uint8 cinNum[1] = {(uint8)num};
            uint8 NumMap[2] = {0};
            uint8 outNum[3] = {0};
            num2bit( cinNum,1,NumMap,0,0);
            bitToUint8(NumMap, outNum, 3,0);
			OneStarBet(issue,num).betCompact = *(uint16 *)NumMap;
			if(issue == 0)
				rk_loadBaoOneDan3Star(num);
		}

		for(num = 0;num < 100; num++)
		{
			uint8 n1 = num/10;
			uint8 n2 = num%10;
            uint8 inNum[2] = {n1,n2};
            for(int n=0;n<2;n++)
            {
                num2bit( &inNum[n],1,(uint8 *)(TwoStarBet(issue,num).betNumMap),n*2,0);
            }

            uint8 NumMap[2] = {0};
            uint8 outNum[3] = {0};
            num2bit( inNum,2,NumMap,0,0);
            bitToUint8(NumMap, outNum, 3,0);
            TwoStarBet(issue,num).betCompact = *(uint16 *)NumMap;

            if(issue == 0)
            {
				rk_loadSumDirect2Star(n1+n2,num);
				rk_loadSumPort2Star(n1+n2,num);
				rk_loadBaoTwoDan3Star(n1,n2);

				uint8 sub = (n1 > n2)?(n1 - n2):(n2 - n1);
				rk_loadSubDirect2Star(sub,num);
				rk_loadSubPort2Star(sub,num);
            }
		}

		for(num = 0;num < 1000; num++)
		{
			uint8 n1 = num/100;
			uint8 n2 = (num - n1*100)/10;
			uint8 n3 = num%10;
            uint8 inNum[3] = {n1,n2,n3};
            for(int n=0;n<3;n++)
            {
                num2bit( &inNum[n],1,(uint8 *)(ThreeStarBet(issue,num).betNumMap),n*2,0);
            }

            uint8 NumMap[2] = {0};
            uint8 outNum[3] = {0};
            num2bit( inNum,3,NumMap,0,0);
            bitToUint8(NumMap, outNum, 3,0);
            ThreeStarBet(issue,num).betCompact = *(uint16 *)NumMap;

            if(issue == 0)
            {
				rk_loadSumDirect3Star(n1+n2+n3,num);
				rk_loadSumPort3Star(n1+n2+n3,num);
            }

            memset(inNum,0,sizeof(inNum));
            if((n1 == n2) && (n2 != n3))
            {
            	inNum[0] = n1;
            	inNum[1] = n3;
            	for(int n=0;n<2;n++)
            	{
            	    num2bit( &inNum[n],1,(uint8 *)(ThreeStarBet(issue,num).betNumMapAss3),n*2,0);
            	}
            }

		}


		if(issue == 0)
		{
		    rk_initPort3SumSubCount();
		}

		for(num = 0;num < 100000; num++)
		{
			uint8 n1 = num/10000;
			uint8 n2 = (num - n1*10000)/1000;
			uint8 n3 = (num - n1*10000 - n2 * 1000)/100;
			uint8 n4 = (num - n1*10000 - n2 * 1000 - n3 *100)/10;
			uint8 n5 = num % 10;

			FiveStarNumIndex(n1,n2,n3,n4,n5) = num;

            uint8 inNum[5] = {n1,n2,n3,n4,n5};
            for(int n=0;n<5;n++)
            {
                num2bit( &inNum[n],1,(uint8 *)(FiveStarBet(issue,num).betNumMap),n*2,0);
            }

            if(issue == 0)
            	rk_loadFiveStarWholeIndex(n1,n2,n3,n4,n5,num);
		}


		num = 0;
		for(uint8 r1=0;r1<4;r1++)
		{
			uint8 left = 0x1 << r1;
			for(uint8 r2=0;r2<4;r2++)
			{
				uint8 right = 0x1 << r2;
				DxdsStarBet(issue,num).betRaws = (uint8)((left << 4)|right);
				//DxdsStarBet(issue,num).betCount = 0;
				num++;
			}
		}

		int idx = 0;
		int subtype = SSC_RK_SUBCODE[idx] ;

		for( ; subtype > 0; idx++)
		{
			currRestrictBetCount(subtype,issue) = initBetLimit(issue,subtype);
			currRestrictBetCountCommit(subtype,issue) = initBetLimit(issue,subtype);
			subtype = SSC_RK_SUBCODE[idx] ;
		}


	}
}




bool gl_ssc_rk_mem_get_meta( int *length)
{
	ts_notused(length);
    return true;
}

bool gl_ssc_rk_mem_save( void *buf, int *length)
{
	ts_notused(buf);
	ts_notused(length);
    return true;
}

bool gl_ssc_rk_mem_recovery( void *buf, int length)
{
	ts_notused(buf);
	ts_notused(length);
    return true;
}

void gl_ssc_rk_reinitData(void)
{
	int num;
	for(int issue=0;issue < totalIssueCount;issue++)
    {
		for(num = 0;num < 10; num++)
		{
			OneStarBet(issue,num).betCount = OneStarBet(issue,num).betCountCommit;
			OneStarBet(issue,num).betCountFirst = OneStarBet(issue,num).betCountFirstCommit;
			OneStarBet(issue,num).betCountLast = OneStarBet(issue,num).betCountLastCommit;
		}
		for(num = 0;num < 100; num++)
		{
			TwoStarBet(issue,num).betCount = TwoStarBet(issue,num).betCountCommit;
			TwoStarBet(issue,num).betCountFirst = TwoStarBet(issue,num).betCountFirstCommit;
			TwoStarBet(issue,num).betCountLast = TwoStarBet(issue,num).betCountLastCommit;
			TwoStarBet(issue,num).betCountPort = TwoStarBet(issue,num).betCountPortCommit;
		}
		for(num = 0;num < 1000; num++)
		{
			ThreeStarBet(issue,num).betCount = ThreeStarBet(issue,num).betCountCommit;
			ThreeStarBet(issue,num).betCountAss3 = ThreeStarBet(issue,num).betCountAss3Commit;
			ThreeStarBet(issue,num).betCountAss6 = ThreeStarBet(issue,num).betCountAss6Commit;
			ThreeStarBet(issue,num).betCountFirst = ThreeStarBet(issue,num).betCountFirstCommit;
			ThreeStarBet(issue,num).betCountLast = ThreeStarBet(issue,num).betCountLastCommit;
		}
		for(num = 0;num < 100000; num++)
		{
			FiveStarBet(issue,num).betCount = FiveStarBet(issue,num).betCountCommit;
			FiveStarBet(issue,num).betCountWhole = FiveStarBet(issue,num).betCountWholeCommit;
		}

		for(num = 0;num < 16; num++)
		{
			DxdsStarBet(issue,num).betCount = DxdsStarBet(issue,num).betCountCommit;
		}

		int idx = 0;
		int subtype = SSC_RK_SUBCODE[idx];
		for( ; subtype > 0; idx++)
		{
            currentBetCount(subtype,issue) = currentBetCountCommit(subtype,issue);
            currRestrictBetCount(subtype,issue) = currRestrictBetCountCommit(subtype,issue);
            saleMoney(subtype,issue) = saleMoneyCommit(subtype,issue);
            numberMaxBetCount(subtype,issue) = numberMaxBetCountCommit(subtype,issue);
            firstBetCount(subtype,issue) = firstBetCountCommit(subtype,issue);
            firstBetFlag(subtype,issue) = firstBetFlagCommit(subtype,issue);
            firstBetNumber(subtype,issue) = firstBetNumberCommit(subtype,issue);
            subtype = SSC_RK_SUBCODE[idx];
		}
    }

    return;
}

bool gl_ssc_sale_rk_verify(TICKET* pTicket)
{
	if( riskVerify(pTicket, false))
	{
		return true;
	}
	return false;
}


void gl_ssc_sale_rk_commit(TICKET* pTicket)
{
	 riskVerify(pTicket, true);
}


void gl_ssc_cancel_rk_rollback(TICKET* pTicket)
{
	riskRollback(pTicket, false);
}

void gl_ssc_cancel_rk_commit(TICKET* pTicket)
{
	riskRollback(pTicket, true);
}


////////////////////////////////////////////////////////////////



void getSSCwinMoney(int issue,uint8 subtype)
{
	int len = 0;
	DIVISION_PARAM *divisonParam = (DIVISION_PARAM *)gl_ssc_getDivisionTable(&len,0);

	PRIZE_PARAM *prizeParam = gl_ssc_getPrizeTableBegin();


	uint8 HighPrizeCode = 99;

	for(int i = 0; i < MAX_DIVISION_COUNT; i++)
	{
		if(divisonParam[i].subtypeCode == subtype)
		{
			if(divisonParam[i].prizeCode < HighPrizeCode)
				HighPrizeCode = divisonParam[i].prizeCode;
		}
	}

	for(int i = 0; i < MAX_PRIZE_COUNT; i++)
	{
		if(prizeParam[i].prizeCode == HighPrizeCode)
			winMoney(issue,subtype) = prizeParam[i].fixedPrizeAmount;
	}

    if (subtype == SUBTYPE_5TX)
    {
        money_t prize_5t1 = 0;
        money_t prize_5t2 = 0;
        money_t prize_5t3 = 0;

        for (int i = 0; i < MAX_PRIZE_COUNT; i++)
        {
            if (prizeParam[i].prizeCode == PRIZE_5TX1)
                prize_5t1 = prizeParam[i].fixedPrizeAmount;
            if (prizeParam[i].prizeCode == PRIZE_5TX2)
                prize_5t2 = prizeParam[i].fixedPrizeAmount;
            if (prizeParam[i].prizeCode == PRIZE_5TX3)
                prize_5t3 = prizeParam[i].fixedPrizeAmount;
        }
        winMoney(issue, SUBTYPE_5TX) = prize_5t1 + prize_5t2 * 2 + prize_5t3 * 2;
    }

/*
	if(issueTable[issue].used)
	{
	    for(int subtype = SSC_RK_SUBCODE[idx] ; subtype > 0; idx++)
	    {
	        for(int divisonIdx = 0; divisonIdx < MAX_DIVISION_COUNT; divisonIdx++)
	        {
		        if(divisonParam[divisonIdx].subtypeCode == subtype)
		        {
			        PRIZE_PARAM *prizeParam = (PRIZE_PARAM *)gl_ssc_getPrizeTable(issueTable[issue].issueNumber);

			        for(int prizeIdx = 0; prizeIdx < MAX_PRIZE_COUNT; prizeIdx++)
			        {
			    	    if(prizeParam[prizeIdx].prizeCode == divisonParam[divisonIdx].prizeCode)
			    	    {
			                if(prizeParam->fixedPrizeAmount > winMoney(issue,subtype))
				                winMoney(issue,subtype) = prizeParam->fixedPrizeAmount;
			    	    }
			        }
		        }
	        }
	        subtype = SSC_RK_SUBCODE[idx];
	    }
	}
*/
	return;
}


// load all issue param and init when host start
bool load_ssc_all_issue(char *rk_param)
{
	ts_notused(rk_param);
    rk_ssc_betNumberInit();

	return true;
}


//
void rk_clear_issue_betsData(int issue)
{
	int num;
	for(num = 0;num < 10; num++)
	{
	    OneStarBet(issue,num).betCount = 0;
	    OneStarBet(issue,num).betCountCommit = 0;

	    OneStarBet(issue,num).betCountFirst = 0;
	    OneStarBet(issue,num).betCountFirstCommit = 0;

	    OneStarBet(issue,num).betCountLast = 0;
	    OneStarBet(issue,num).betCountLastCommit = 0;
	}

	for(num = 0;num < 100; num++)
	{
	    TwoStarBet(issue,num).betCount = 0;
	    TwoStarBet(issue,num).betCountCommit = 0;

	    TwoStarBet(issue,num).betCountPort = 0;
	    TwoStarBet(issue,num).betCountPortCommit = 0;

	    TwoStarBet(issue,num).betCountFirst = 0;
	    TwoStarBet(issue,num).betCountFirstCommit = 0;

	    TwoStarBet(issue,num).betCountLast = 0;
	    TwoStarBet(issue,num).betCountLastCommit = 0;
	}
	for(num = 0;num < 1000; num++)
	{
	    ThreeStarBet(issue,num).betCount = 0;
	    ThreeStarBet(issue,num).betCountCommit = 0;

	    ThreeStarBet(issue,num).betCountAss3 = 0;
	    ThreeStarBet(issue,num).betCountAss3Commit = 0;

	    ThreeStarBet(issue,num).betCountAss6 = 0;
	    ThreeStarBet(issue,num).betCountAss6Commit = 0;

	    ThreeStarBet(issue,num).betCountFirst = 0;
	    ThreeStarBet(issue,num).betCountFirstCommit = 0;

	    ThreeStarBet(issue,num).betCountLast = 0;
	    ThreeStarBet(issue,num).betCountLastCommit = 0;
	}
	for(num = 0;num < 100000; num++)
	{
	    FiveStarBet(issue,num).betCount = 0;
	    FiveStarBet(issue,num).betCountCommit = 0;

	    FiveStarBet(issue,num).betCountWhole = 0;
	    FiveStarBet(issue,num).betCountWholeCommit = 0;
	}
	for(num = 0;num < 16; num++)
	{
		DxdsStarBet(issue,num).betCount = 0;
		DxdsStarBet(issue,num).betCountCommit = 0;
	}

	int idx = 0;
	for(int subtype = SSC_RK_SUBCODE[idx] ; subtype > 0; idx++)
	{
		currRestrictBetCount(subtype,issue) = initBetLimit(issue,subtype);
		currRestrictBetCountCommit(subtype,issue) = initBetLimit(issue,subtype);

        currentBetCount(subtype,issue) = currentBetCountCommit(subtype,issue) = 0;
        saleMoney(subtype,issue) = saleMoneyCommit(subtype,issue) = 0;
        numberMaxBetCount(subtype,issue) = numberMaxBetCountCommit(subtype,issue);
        firstBetCount(subtype,issue) = firstBetCountCommit(subtype,issue) = 0;
        firstBetFlag(subtype,issue) = firstBetFlagCommit(subtype,issue) = false;
        firstBetNumber(subtype,issue) = firstBetNumberCommit(subtype,issue) = 0;
        subtype = SSC_RK_SUBCODE[idx];
	}

}
/*
#define issueBeUsed(issue)                        d3_issue_info[issue].used
#define issueState(issue)                         d3_issue_info[issue].curState
*/
// load issue param when add issue by gl_drive , no need init ,need empty bets data
bool load_ssc_issue_rkdata(uint32 startIssueSeq,int issue_count, char *rkStr)
{
	uint32 ssc_rk_limit[SSC_SUBTYPE_COUNT];

	char rk_param[512] = {0};
	memcpy(rk_param,rkStr,strlen(rkStr));

	memset((void *)&ssc_rk_limit,0,sizeof(uint32) * SSC_SUBTYPE_COUNT);
    char *token,*str2,*subtoken;
    char *subCode;
    char *initLimit;
    char *saveptr1, *saveptr2,*saveptr3;

    token = strtok_r(rk_param, ";",&saveptr1);
    float percent = atof(token);
    token = strtok_r(NULL, ";",&saveptr1);

    for(str2 = token; ;str2 = NULL)
    {
        subtoken = strtok_r(str2, ",", &saveptr2);
        if (subtoken == NULL)
            break;
        subCode = strtok_r(subtoken,":",&saveptr3);
        initLimit = strtok_r(NULL,":",&saveptr3);

        ssc_rk_limit[atoi(subCode)] = atol(initLimit);
    }

    log_info("load_ssc_issue_rkdata issueSeq[%d] count[%d] rkParma[%s]",startIssueSeq, issue_count, rk_param);

    for(int i = 0; i < SSC_SUBTYPE_COUNT; i++)
    {
    	log_info("load_ssc_issue_rkdata ssc_rk_limit[%d][%d]",i,ssc_rk_limit[i]);
    }

	uint32 issueSeq = startIssueSeq;
    for(int issue_idx = 0; issue_idx < issue_count; issue_idx++)
    {
    	int issue = rk_get_ssc_issueIndexBySeq(issueSeq);
    	if (issue > -1)
    	{
    	    if( issueBeUsed(issue) )
		    {
   	        	winPercentBet(issue) = percent;
    	    	int idx = 0;
    	    	for(int subtype = SSC_RK_SUBCODE[idx] ; subtype > 0; idx++)
    	    	{
   	    	        initBetLimit(issue,subtype) = ssc_rk_limit[subtype];
   	    	        getSSCwinMoney( issue,(uint8)subtype);
   	    	        subtype = SSC_RK_SUBCODE[idx];

   	    	    }
   	    	    rk_clear_issue_betsData( issue);
		    }
    	    issueSeq++;
    	}
    }

	return true;
}

bool gl_ssc_rk_init()
{
    TRANSCTRL_PARAM * transParam = gl_getTransctrlParam(GAME_SSC);

	load_ssc_all_issue(transParam->riskCtrlParam);

	return true;
}




void gl_ssc_rk_issueData2File(const char *filePath,void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName,"%s/ssc_rk.snapshot", filePath);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
    	log_error("open %s error!",fileName);
    	return;
    }

    ssize_t ret = write( fp, buf, sizeof(GL_SSC_RK_CHKP_ISSUE_DATA));
    if(ret < 0)
    {
    	log_error("write %s error errno[%d]",fileName,errno);
    }
    close(fp);

}

bool gl_ssc_rk_issueFile2Data(const char *filePath,void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName,"%s/ssc_rk.snapshot", filePath);
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
    	log_error("open %s error!",fileName);
    	return false;
    }

    ssize_t ret = read( fp, buf, sizeof(GL_SSC_RK_CHKP_ISSUE_DATA));
    if(ret < 0)
    {
    	log_error("read %s error errno[%d]",fileName,errno);
    	return false;
    }
    close(fp);
    return true;
}


bool gl_ssc_rk_saveData(const char *filePath)
{
	int num;
	int count = 0;
	GL_SSC_RK_CHKP_ISSUE_DATA *rkIssueData =(GL_SSC_RK_CHKP_ISSUE_DATA *) malloc(sizeof(GL_SSC_RK_CHKP_ISSUE_DATA));
	if (NULL == rkIssueData)
	{
		log_error("gl_ssc_rk_saveData malloc return NULL!");
		return true;
	}
	memset((void *)rkIssueData, 0 ,sizeof(GL_SSC_RK_CHKP_ISSUE_DATA));

	ISSUE_INFO *issueInfo = gl_ssc_getIssueTable();
	for(int i = 0; i < totalIssueCount; i++)
	{
		if(issueInfo[i].used)
		{
			if((issueInfo[i].curState >= ISSUE_STATE_PRESALE) && (issueInfo[i].curState < ISSUE_STATE_CLOSED))
			{
				int issue = rk_get_ssc_issueIndexBySeq(issueInfo[i].serialNumber);


				rkIssueData->rkData[count].issueSeq = issueInfo[i].serialNumber;

				for(num = 0;num < 10; num++)
				{
					rkIssueData->rkData[count].oneStarbetCountCommit[num] = OneStarBet(issue,num).betCountCommit;
					rkIssueData->rkData[count].oneStarbetCountFirstCommit[num] = OneStarBet(issue,num).betCountFirstCommit;
					rkIssueData->rkData[count].oneStarbetCountLastCommit[num] = OneStarBet(issue,num).betCountLastCommit;
				}
				for(num = 0;num < 100; num++)
				{
					rkIssueData->rkData[count].twoStarbetCountCommit[num] = TwoStarBet(issue,num).betCountCommit;
					rkIssueData->rkData[count].twoStarbetCountFirstCommit[num] = TwoStarBet(issue,num).betCountFirstCommit;
					rkIssueData->rkData[count].twoStarbetCountLastCommit[num] = TwoStarBet(issue,num).betCountLastCommit;
					rkIssueData->rkData[count].twoStarbetCountPortCommit[num] = TwoStarBet(issue,num).betCountPortCommit;
				}
				for(num = 0;num < 1000; num++)
				{
					rkIssueData->rkData[count].threeStarbetCountCommit[num] = ThreeStarBet(issue,num).betCountCommit;
					rkIssueData->rkData[count].threeStarbetCountAss3Commit[num] = ThreeStarBet(issue,num).betCountAss3Commit;
					rkIssueData->rkData[count].threeStarbetCountAss6Commit[num] = ThreeStarBet(issue,num).betCountAss6Commit;
					rkIssueData->rkData[count].threeStarbetCountFirstCommit[num] = ThreeStarBet(issue,num).betCountFirstCommit;
					rkIssueData->rkData[count].threeStarbetCountLastCommit[num] = ThreeStarBet(issue,num).betCountLastCommit;
				}
				for(num = 0;num < 100000; num++)
				{
					rkIssueData->rkData[count].fiveStarbetCountCommit[num] = FiveStarBet(issue,num).betCountCommit;
					rkIssueData->rkData[count].fiveStarbetCountWholeCommit[num] = FiveStarBet(issue,num).betCountWholeCommit;
				}

				for(num = 0;num < 16; num++)
				{
					rkIssueData->rkData[count].DXDSbetCountCommit[num] = DxdsStarBet(issue,num).betCountCommit;
				}

				int idx = 0;
				int subtype = SSC_RK_SUBCODE[idx];
				for( ; subtype > 0; idx++)
				{
					rkIssueData->rkData[count].salesDataCommit[subtype].currentBetCount = currentBetCountCommit(subtype,issue);
					rkIssueData->rkData[count].salesDataCommit[subtype].currRestrictBetCount = currRestrictBetCountCommit(subtype,issue);
					rkIssueData->rkData[count].salesDataCommit[subtype].saleMoneyBySubtype = saleMoneyCommit(subtype,issue);
					rkIssueData->rkData[count].salesDataCommit[subtype].numberMaxBetCount = numberMaxBetCountCommit(subtype,issue);
					rkIssueData->rkData[count].salesDataCommit[subtype].firstBetCount = firstBetCountCommit(subtype,issue);
					rkIssueData->rkData[count].salesDataCommit[subtype].firstBetFlag = firstBetFlagCommit(subtype,issue);
					rkIssueData->rkData[count].salesDataCommit[subtype].firstBetCount = firstBetNumberCommit(subtype,issue);
		            subtype = SSC_RK_SUBCODE[idx];
				}
				count++;
			}
		}
	}
	gl_ssc_rk_issueData2File(filePath,(void *)rkIssueData);
	free(rkIssueData);
    return true;
}



bool gl_ssc_rk_restoreData(const char *filePath)
{
	int num;

	GL_SSC_RK_CHKP_ISSUE_DATA *rkIssueData = (GL_SSC_RK_CHKP_ISSUE_DATA *)malloc(sizeof(GL_SSC_RK_CHKP_ISSUE_DATA));
	if (NULL == rkIssueData)
	{
		log_error("gl_ssc_rk_saveData malloc return NULL!");
		return true;
	}

	memset((void *)rkIssueData, 0 ,sizeof(rkIssueData));
	if(gl_ssc_rk_issueFile2Data(filePath,(void *)rkIssueData))
	{
		for(int count = 0; count < totalIssueCount; count++)
		{
			if(rkIssueData->rkData[count].issueSeq > 0)
			{
				int issue = rk_get_ssc_issueIndexBySeq(rkIssueData->rkData[count].issueSeq);
                if(issue >= 0)
                {
					for(num = 0;num < 10; num++)
					{
						OneStarBet(issue,num).betCountCommit = rkIssueData->rkData[count].oneStarbetCountCommit[num];
						OneStarBet(issue,num).betCountFirstCommit = rkIssueData->rkData[count].oneStarbetCountFirstCommit[num];
						OneStarBet(issue,num).betCountLastCommit = rkIssueData->rkData[count].oneStarbetCountLastCommit[num];
					}
					for(num = 0;num < 100; num++)
					{
						TwoStarBet(issue,num).betCountCommit = rkIssueData->rkData[count].twoStarbetCountCommit[num];
						TwoStarBet(issue,num).betCountFirstCommit = rkIssueData->rkData[count].twoStarbetCountFirstCommit[num];
						TwoStarBet(issue,num).betCountLastCommit = rkIssueData->rkData[count].twoStarbetCountLastCommit[num];
						TwoStarBet(issue,num).betCountPortCommit = rkIssueData->rkData[count].twoStarbetCountPortCommit[num];
					}
					for(num = 0;num < 1000; num++)
					{
						ThreeStarBet(issue,num).betCountCommit = rkIssueData->rkData[count].threeStarbetCountCommit[num];
						ThreeStarBet(issue,num).betCountAss3Commit = rkIssueData->rkData[count].threeStarbetCountAss3Commit[num] ;
						ThreeStarBet(issue,num).betCountAss6Commit = rkIssueData->rkData[count].threeStarbetCountAss6Commit[num] ;
						ThreeStarBet(issue,num).betCountFirstCommit = rkIssueData->rkData[count].threeStarbetCountFirstCommit[num] ;
						ThreeStarBet(issue,num).betCountLastCommit = rkIssueData->rkData[count].threeStarbetCountLastCommit[num] ;
					}
					for(num = 0;num < 100000; num++)
					{
						FiveStarBet(issue,num).betCountCommit = rkIssueData->rkData[count].fiveStarbetCountCommit[num];
						FiveStarBet(issue,num).betCountWholeCommit = rkIssueData->rkData[count].fiveStarbetCountWholeCommit[num] ;
					}

					for(num = 0;num < 16; num++)
					{
						DxdsStarBet(issue,num).betCountCommit = rkIssueData->rkData[count].DXDSbetCountCommit[num];
					}

					int idx = 0;
					int subtype = SSC_RK_SUBCODE[idx];
					for( ; subtype > 0; idx++)
					{
						currentBetCountCommit(subtype,issue) = rkIssueData->rkData[count].salesDataCommit[subtype].currentBetCount ;
						currRestrictBetCountCommit(subtype,issue) = rkIssueData->rkData[count].salesDataCommit[subtype].currRestrictBetCount;
						saleMoneyCommit(subtype,issue) = rkIssueData->rkData[count].salesDataCommit[subtype].saleMoneyBySubtype;
						numberMaxBetCountCommit(subtype,issue) = rkIssueData->rkData[count].salesDataCommit[subtype].numberMaxBetCount;
						firstBetCountCommit(subtype,issue) = rkIssueData->rkData[count].salesDataCommit[subtype].firstBetCount;
						firstBetFlagCommit(subtype,issue) = rkIssueData->rkData[count].salesDataCommit[subtype].firstBetFlag ;
						firstBetNumberCommit(subtype,issue) = rkIssueData->rkData[count].salesDataCommit[subtype].firstBetCount;
						subtype = SSC_RK_SUBCODE[idx];
					}
                }
			}
		}
		free(rkIssueData);
		return true;
	}
	else
	{
		free(rkIssueData);
		return false;
	}

}


bool gl_ssc_rk_getReportData(uint32 issueSeq,void *data)
{
	ts_notused(issueSeq);
	ts_notused(data);
    return true;
}


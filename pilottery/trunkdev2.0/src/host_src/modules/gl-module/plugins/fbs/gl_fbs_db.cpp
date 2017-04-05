#include "global.h"
#include "gl_inf.h"

#include "gl_fbs_db.h"

#define GL_FBS_SHM_KEY      (GL_SHM_KEY + GAME_FBS)

#define SHARE_MEM_REDUN  32


static int32 ncGlobalMem = 0;
static int32 ncGlobalLen = 0;

static FBS_DATABASE_PTR fbs_database_ptr = NULL;




//�淨����
static const FBS_SUBTYPE_PARAM SubTypeParams[FBS_SUBTYPE_NUM] = {
    {false,0,"NULL","NULL",0,0},
    {true,   FBS_SUBTYPE_WIN,   "WIN",   "Winner Pool",                          ENABLED,  1000},
    {true,   FBS_SUBTYPE_HCP,   "HCP",   "Handicap Pool",                        ENABLED,  1000},
    {true,   FBS_SUBTYPE_TOT,   "TOT",   "Totals Goals",                         ENABLED,  1000},
    {true,   FBS_SUBTYPE_SCR,   "SCR",   "Score Pool",                           ENABLED,  1000},
    {true,   FBS_SUBTYPE_HFT,   "HFT",   "HalfTime/FullTime Pool",               ENABLED,  1000},
    {true,   FBS_SUBTYPE_OUOD,  "OUOD",  "Totals Goals (over/under odd/even)",   ENABLED,  1000},
};



//�����ַ���
static const char *WIN_ResultString[FBS_SUBTYPE_WIN_SEL] = {
    "",
    "3",  //FBS_WIN_HomeTeam
    "1",  //FBS_WIN_Draw
    "0",  //FBS_WIN_AwayTeam
    "-"   //FBS_WIN_All
};
static const char *HCP_ResultString[FBS_SUBTYPE_HCP_SEL] = {
    "",
    "3",  //FBS_HCP_HomeTeam
    "0",  //FBS_HCP_AwayTeam
    "-"   //FBS_HCP_All
};
static const char *TOT_ResultString[FBS_SUBTYPE_TOT_SEL] = {
    "",
    "0",  //FBS_TOT_0
    "1",  //FBS_TOT_1
    "2",  //FBS_TOT_2
    "3",  //FBS_TOT_3
    "4",  //FBS_TOT_4
    "5",  //FBS_TOT_5
    "6",  //FBS_TOT_6
    "7+", //FBS_TOT_7_More
    "-",  //FBS_TOT_All
};
static const char *SCR_ResultString[FBS_SUBTYPE_SCR_SEL] = {
    "",
    "1:0",  //FBS_SCR_1_0
    "2:0",  //FBS_SCR_2_0
    "2:1",  //FBS_SCR_2_1
    "3:0",  //FBS_SCR_3_0
    "3:1",  //FBS_SCR_3_1
    "3:2",  //FBS_SCR_3_2
    "4:0",  //FBS_SCR_4_0
    "4:1",  //FBS_SCR_4_1
    "4:2",  //FBS_SCR_4_2
    "HomeWinOther",  //FBS_SCR_HomeWinOther
    "0:0",  //FBS_SCR_0_0
    "1:1",  //FBS_SCR_1_1
    "2:2",  //FBS_SCR_2_2
    "3:3",  //FBS_SCR_3_3
    "DrawOther",  //FBS_SCR_DrawOther
    "0:1",  //FBS_SCR_0_1
    "0:2",  //FBS_SCR_0_2
    "1:2",  //FBS_SCR_1_2
    "0:3",  //FBS_SCR_0_3
    "1:3",  //FBS_SCR_1_3
    "2:3",  //FBS_SCR_2_3
    "0:4",  //FBS_SCR_0_4
    "1:4",  //FBS_SCR_1_4
    "2:4",  //FBS_SCR_2_4
    "AwayWinOther",  //FBS_SCR_AwayWinOther
    "-",    //FBS_SCR_All
};
static const char *HFT_ResultString[FBS_SUBTYPE_HFT_SEL] = {
    "",
    "3_3",  //FBS_HFT_Home_Home
    "3_1",  //FBS_HFT_Home_Draw
    "3_0",  //FBS_HFT_Home_Away
    "1_3",  //FBS_HFT_Draw_Home
    "1_1",  //FBS_HFT_Draw_Draw
    "1_0",  //FBS_HFT_Draw_Away
    "0_3",  //FBS_HFT_Away_Home
    "0_1",  //FBS_HFT_Away_Draw
    "0_0",  //FBS_HFT_Away_Away
    "-"     //FBS_HFT_All_All
};
static const char *OUOD_ResultString[FBS_SUBTYPE_OUOD_SEL] = {
    "",
    "Over/Odd",  //FBS_OUOD_Over_Odd
    "Over/Even", //FBS_OUOD_Over_Even
    "Under/Odd", //FBS_OUOD_Under_Odd
    "Under/Even" //FBS_OUOD_Under_Even
    "-",         //FBS_OUOD_All_ALL
};


uint32 BET_SELECT[31][17] = {
    // m C n     1C1   2C1   3C1   4C1   5C1   6C1   7C1   8C1   9C1   10C1  11C1  12C1  13C1  14C1  15C1
    {0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 },
    {1,    1,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'����'
    {2,    1,    0,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'2��1'
    {2,    3,    2,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'2��3':  [2, 1]
    {3,    1,    0,    0,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'3��1':  [3]
    {3,    4,    0,    3,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'3��4':  [3, 2]
    {3,    7,    3,    3,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'3��7':  [3, 2, 1]
    {4,    1,    0,    0,    0,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'4��1':  [4]
    {4,    5,    0,    0,    4,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'4��5':  [4, 3]
    {4,    11,   0,    6,    4,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'4��11': [4, 3, 2]
    {4,    15,   4,    6,    4,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'4��15': [4, 3, 2, 1]
    {5,    1,    0,    0,    0,    0,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'5��1':  [5]
    {5,    6,    0,    0,    0,    5,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'5��6':  [5, 4]
    {5,    16,   0,    0,    10,   5,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'5��16': [5, 4, 3]
    {5,    26,   0,    10,   10,   5,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'5��26': [5, 4, 3, 2]
    {5,    31,   5,    10,   10,   5,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'5��31': [5, 4, 3, 2, 1]
    {6,    1,    0,    0,    0,    0,    0,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'6��1':  [6]
    {6,    7,    0,    0,    0,    0,    6,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'6��7':  [6, 5]
    {6,    22,   0,    0,    0,    15,   6,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'6��22': [6, 5, 4]
    {6,    42,   0,    0,    20,   15,   6,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'6��42': [6, 5, 4, 3]
    {6,    57,   0,    15,   20,   15,   6,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'6��57': [6, 5, 4, 3, 2]
    {6,    63,   6,    15,   20,   15,   6,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0 }, //'6��63': [6, 5, 4, 3, 2, 1]
    {7,    1,    0,    0,    0,    0,    0,    0,    1,    0,    0,    0,    0,    0,    0,    0,    0 }, //'7��1':  [7]
    {8,    1,    0,    0,    0,    0,    0,    0,    0,    1,    0,    0,    0,    0,    0,    0,    0 }, //'8��1':  [8]
    {9,    1,    0,    0,    0,    0,    0,    0,    0,    0,    1,    0,    0,    0,    0,    0,    0 }, //'9��1':  [9]
    {10,   1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    1,    0,    0,    0,    0,    0 }, //'10��1': [10]
    {11,   1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    1,    0,    0,    0,    0 }, //'11��1': [11]
    {12,   1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    1,    0,    0,    0 }, //'12��1': [12]
    {13,   1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    1,    0,    0 }, //'13��1': [13]
    {14,   1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    1,    0 }, //'14��1': [14]
    {15,   1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    1 }, //'15��1': [15]
};

const char *FbsResultString(uint8 subtype, uint8 result_enum)
{
    if (result_enum == FBS_DRAW_All) {
        return "-";
    }

    if (subtype == FBS_SUBTYPE_WIN)
        return WIN_ResultString[result_enum];
    if (subtype == FBS_SUBTYPE_HCP)
        return HCP_ResultString[result_enum];
    if (subtype == FBS_SUBTYPE_TOT)
        return TOT_ResultString[result_enum];
    if (subtype == FBS_SUBTYPE_SCR)
        return SCR_ResultString[result_enum];
    if (subtype == FBS_SUBTYPE_HFT)
        return HFT_ResultString[result_enum];
    if (subtype == FBS_SUBTYPE_OUOD)
        return OUOD_ResultString[result_enum];
    return "unknown";
}




const int MAX_BUFSIZE = 2048;

static GL_PLUGIN_INFO fbs_plugin_info;

//extern GAME_RISK_KOCTTY_ISSUE_DATA *rk_koctty_issueData;
//extern FBS_ISSUE *fbs_issue_info;
int totalIssueCount = 0;;







// share interface
bool gl_fbs_mem_creat(int issue_count)
{
    ts_notused(issue_count);

	int32 ret = -1;
    IPCKEY keyid;

    ncGlobalLen = sizeof(FBS_DATABASE) + SHARE_MEM_REDUN;

    //����keyid
    keyid = ipcs_shmkey(GL_FBS_SHM_KEY);

    //���������ڴ�
    ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT | IPC_EXCL | 0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_create::create globalSection(gl) failure");
        return false;
    }

    //�ڴ�ӳ��
    fbs_database_ptr = (FBS_DATABASE_PTR) sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void*) -1 == fbs_database_ptr)
    {
        log_error("gl_create::attach globalSection(gl) failure.");
        return false;
    }

    //��ʼ�������ڴ�
    memset(fbs_database_ptr, 0, ncGlobalLen);

    //�Ͽ��빲���ڴ��ӳ��
    ret = sysv_detach_shm(fbs_database_ptr);
    if (ret < 0)
    {
        log_error("gl_create:deattach globalSection(gl) failure.");
        return false;
    }

    log_info("gl_fbs_mem_creat success! shm_key[%#x] shm_id[%d] size[%d] issueCount[%d]", keyid, ncGlobalMem, ncGlobalLen, issue_count);
    return true;
}

//ɾ�������ڴ�
bool gl_fbs_mem_destroy()
{
    int32 ret = -1;

    //������������ڴ��ɾ�������ڴ��ڲ�ͬ�������У���Ҫ������γ���
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_FBS_SHM_KEY);

    ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    //ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_destroy::open globalSection(gl) failure.");
        return false;
    }

    //ɾ�������ڴ�
    ret = sysv_ctl_shm(ncGlobalMem, IPC_RMID, NULL);
    if (ret < 0)
    {
        log_error("gl_destroy:delete globalSection(gl) failure.");
        return false;
    }

    log_info("gl_fbs_mem_destroy success!");
    return true;
}

//ӳ�乲���ڴ���
bool gl_fbs_mem_attach()
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_FBS_SHM_KEY);

    ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    //ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_init::open globalSection(gl) failure.");
        return false;
    }

    fbs_database_ptr = (FBS_DATABASE_PTR)sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((char *) -1 == (char *)fbs_database_ptr) {
        log_error("gl_init::attach globalSection(gl) failure.");
        return false;
    }

    totalIssueCount = FBS_MAX_ISSUE_NUM;

    return true;
}

//�رչ����ڴ�����ӳ��
bool gl_fbs_mem_detach()
{
    int32 ret = -1;

    if (NULL == fbs_database_ptr)
    {
        log_error("gl_close::globalSection(gl) pointer is NULL;");
        return false;
    }

    //�Ͽ��빲���ڴ��ӳ��
    ret = sysv_detach_shm(fbs_database_ptr);
    if (ret < 0)
    {
        log_error("gl_close:deattach globalSection(gl) failure.");
        return false;
    }

    ncGlobalMem = 0;
    fbs_database_ptr = NULL;
    return true;
}


// next  no can see out of .so
void *gl_fbs_get_mem_db(void)
{
    return fbs_database_ptr;
}

bool gl_fbs_load_memdata(void)
{
	//��ʼ���淨����
	FBS_SUBTYPE_PARAM *param = NULL;
    for (int i=0;i<FBS_SUBTYPE_NUM;i++) {
        param = &fbs_database_ptr->subtype_params[i];
        param->used = SubTypeParams[i].used;
        param->code = SubTypeParams[i].code;
        strcpy(param->abbr, SubTypeParams[i].abbr);
        strcpy(param->name, SubTypeParams[i].name);
        param->status = SubTypeParams[i].status;
        param->singleAmount = SubTypeParams[i].singleAmount;
    }

    //k-debug:test
    //gl_fbs_load_newMatch();

    log_info("FBS load memory Finish!");
	return true;
}

int gl_fbs_getSingleAmount(char *buffer, size_t len)
{
    char tmp[256] = {0};

    for (uint8 subtype = FBS_SUBTYPE_WIN; subtype <= FBS_SUBTYPE_OUOD; subtype++)
    {
        FBS_SUBTYPE_PARAM *subParam = gl_fbs_get_subtypeParam(subtype);
        sprintf(tmp, "%s%s=%d", tmp, subtypeAbbr[GAME_FBS][subtype], subParam->singleAmount);

        if (subtype != FBS_SUBTYPE_OUOD)
        {
            strcat(tmp, ",");
        }
    }

    if (strlen(tmp) + 1 > len)
    {
        log_error("gl_fbs_getSingleAmount() len not enough.");
        return -1;
    }
    memcpy(buffer, tmp, strlen(tmp)+1);

    return 0;
}


//ͨ�������ַ����޸��ڴ�����
int gl_fbs_update_configuration(char *config_string)
{
	ts_notused(config_string);
    return 0;
}

//�õ�ָ���淨����Ϣ
FBS_SUBTYPE_PARAM* gl_fbs_get_subtypeParam(uint32 subtype)
{
    if (subtype==0 || subtype>=FBS_SUBTYPE_NUM)
        return NULL;
    return &fbs_database_ptr->subtype_params[subtype];
}

int gl_fbs_load_issue(int n, DB_FBS_ISSUE *issue_list)
{
    int i = 0;
    FBS_ISSUE *issue = NULL;
    for (int j = 0; j < n; j++) {
        for (i = 0; i < FBS_MAX_ISSUE_NUM; i++) {
            issue = &fbs_database_ptr->issue_array[i];
            if (!issue->used) {
                break;
            }
        }
        //�ҵ�λ�ã�����
        if (i < FBS_MAX_ISSUE_NUM) {
            issue->used = true;
            issue->idx = i;
            issue->state = ISSUE_STATE_OPENED;
            issue->issue_number = issue_list[j].issue_number;
            issue->issue_date = issue_list[j].issue_date;
            issue->publish_time = issue_list[j].publish_time;

            log_debug("gl_fbs_load_issue.j[%d]i[%d]issue[%u]n[%d]", j, i, issue->issue_number, n);
        } else {
            log_error("load issue fail[%d]", i);
            return -1;
        }
    }

    return 0;
}


FBS_ISSUE* gl_fbs_get_issue(uint32 issue_number)
{
    int i = 0;
    FBS_ISSUE* issue = NULL;
    for (i=0;i<FBS_MAX_ISSUE_NUM;i++) {
        issue = &fbs_database_ptr->issue_array[i];
        if (issue->used && issue->issue_number==issue_number)
            return issue;
    }
    log_debug("issue is NULL[%u]", issue_number);
    return NULL;
}

int gl_fbs_del_issue(uint32 issue_number)
{
	FBS_ISSUE *issue = NULL;
	for (int i = 0; i < FBS_MAX_ISSUE_NUM; i++) {
		issue = &fbs_database_ptr->issue_array[i];
		if (issue->used && issue->issue_number==issue_number) {
			//match���������ۼӣ�����Ҫ��0
			memset(issue, 0, sizeof(FBS_ISSUE));

			issue->used = false;

			break;
		}
	}
    return 0;
}

FBS_MATCH* gl_fbs_get_match(uint32 issue_number, uint32 match_code)
{
    FBS_MATCH* match = NULL;
    FBS_ISSUE* issue = gl_fbs_get_issue(issue_number);
    if (issue != NULL) {
        for (int i = 0; i < FBS_MAX_ISSUE_MATCH; i++) {
        	match = &issue->match_array[i];
        	if (match->used && match->match_code==match_code) {
        	    return match;
        	}
        }
    }
    log_debug("match is NULL[%u]", match_code);
    return NULL;
}

FBS_MATCH* gl_fbs_get_match_by_match_code(uint32 match_code)
{
    int i = 0;
    FBS_ISSUE* issue = NULL;
    FBS_MATCH* match = NULL;
    for (i=0;i<FBS_MAX_ISSUE_NUM;i++) {
        issue = &fbs_database_ptr->issue_array[i];
        if (!issue->used) {
            continue;
        }

        //�ҵ�issue
        for (int j = 0; j < FBS_MAX_ISSUE_MATCH; j++) {
            match = &issue->match_array[j];
            if (match->used && match->match_code==match_code) {
                return match;
            }
        }
    }

    log_debug("match is NULL[%u]", match_code);
    return NULL;
}

int gl_fbs_del_match(uint32 match_code)
{
	uint32 issue_number = match_code / 1000;
	FBS_ISSUE *issue = NULL;
	FBS_MATCH *match = NULL;
	int i = 0;
	for (i = 0; i < FBS_MAX_ISSUE_NUM; i++) {
		issue = &fbs_database_ptr->issue_array[i];
		if (issue->used && issue->issue_number==issue_number) {
			break;
		}
	}

	for (int j = 0; j < FBS_MAX_ISSUE_MATCH; j++) {
		match = &issue->match_array[j];
		if (match->used && match->match_code == match_code) {
			match->used = false;
			break;
		}
	}

    return 0;
}


//reply����ʵʱ�ο�SPֵ
int gl_fbs_calc_rt_odds(FBS_TICKET *ticket)
{
    int i,j,m;
    //issue_ptr->bet_amount += ticket->bet_amount;

    FBS_MATCH *match_ptr = NULL;
    char *ptr = ticket->data + ticket->match_count*sizeof(FBS_BETM);
    FBS_ORDER *order = NULL;
    int sl = 0;
    for (i=0;i<ticket->order_count;i++) {
        //�Զ�������ѭ��
        order = (FBS_ORDER*)(ptr + sl);
        if (order->result_count == 0) {
            log_error("fbs_calc_realtime_odds()  order->result_count-->0 error. issueNumber[%u] error",
                    ticket->issue_number);
            return -1;
        }
        money_t amt_match = rounding(order->bet_amount/BET_SELECT[order->bet_type][0]); //������ÿ�������ϵ�Ͷע���
        //money_t amt_result = rounding(order->bet_amount/(order->bet_type*order->result_count)); //������ÿ�������ϵ�Ͷע���

        //���ֵ��غ͹���Ͷע��ʽ�����н���SP�ļ���
        FBS_BETM *betm = NULL;
        M_RESULT_ODDS *resodds = NULL;
        if (order->bet_type == BET_1C1) {
            //����Ͷע
            match_ptr = gl_fbs_get_match_by_match_code(order->match_code_set[0]);
            if (match_ptr == NULL) {
                log_error("check match is NULL, match_code[%d]", order->match_code_set[0]);
                return -1;
            }

            //match_ptr = &issue_ptr->match_array[order->match_code_set[0]%1000]; //�ڴ�ָ��

            //���±������淨Ͷע���
            match_ptr->odds_array[ticket->sub_type].used = true;
            match_ptr->odds_array[ticket->sub_type].bet_amount += amt_match;
            match_ptr->odds_array[ticket->sub_type].single_amount += amt_match;
            
            for (m=0;m<ticket->match_count;m++) {
                betm = (FBS_BETM*)(ticket->data + m*sizeof(FBS_BETM));
                if (betm->match_code == order->match_code_set[0])
                    break;
            }

            //����Ͷע������Ͷע��SPֵ
            for (m=0;m<betm->result_count;m++) {
                resodds = &match_ptr->odds_array[ticket->sub_type].odds[betm->results[m]];
                resodds->used = true;
                resodds->amount += rounding(amt_match / betm->result_count);
                resodds->single_amount += rounding(amt_match / betm->result_count);
                resodds->sp_old = resodds->sp;
                resodds->sp = rounding(match_ptr->odds_array[ticket->sub_type].bet_amount*1000/resodds->amount);
            }

            //k-debug:
            log_debug("sale single match[%u]order[%d][%ld],amt_match[%ld]",
                   match_ptr->match_code, order->ord_no, order->bet_amount, amt_match);
        } else {
            //����Ͷע
            for (j=0;j<order->match_count;j++) {
                //�Դ˶����ĳ��ν���ѭ��
                match_ptr = gl_fbs_get_match_by_match_code(order->match_code_set[j]);
                if (match_ptr == NULL) {
                    log_error("check match is NULL, match_code[%d]", order->match_code_set[j]);
                    return -1;
                }

                //match_ptr = &issue_ptr->match_array[order->match_code_set[j]%1000]; //�ڴ�ָ��

                //���±������淨Ͷע���
                match_ptr->odds_array[ticket->sub_type].used = true;
                match_ptr->odds_array[ticket->sub_type].bet_amount += amt_match;
                match_ptr->odds_array[ticket->sub_type].multiple_amount += amt_match;

                for (m=0;m<ticket->match_count;m++) {
                    betm = (FBS_BETM*)(ticket->data + m*sizeof(FBS_BETM));
                    if (betm->match_code == order->match_code_set[j])
                        break;
                }

                //����Ͷע������Ͷע��SPֵ
                for (m=0;m<betm->result_count;m++) {
                    resodds = &match_ptr->odds_array[ticket->sub_type].odds[betm->results[m]];
                    resodds->used = true;
                    resodds->amount += rounding(amt_match / betm->result_count);
                    resodds->multiple_amount += rounding(amt_match / betm->result_count);
                    resodds->sp_old = resodds->sp;
                    resodds->sp = rounding(match_ptr->odds_array[ticket->sub_type].bet_amount*1000/resodds->amount);
                }

                //k-debug:
                log_debug("sale mul match[%u]order[%d][%ld],amt_match[%ld]",
                        match_ptr->match_code, order->ord_no, order->bet_amount, amt_match);
            }
        }
        sl += order->length;
    }

    //�淨���仯�ˣ����п��۳��ε��淨���������¼���SP
    FBS_ISSUE *fbsIssue = gl_fbs_get_issueTable();
    M_RESULT_ODDS *resodds = NULL;
    for (int i = 0; i < FBS_MAX_ISSUE_NUM; i++)
    {
        if (!fbsIssue->used) {
            fbsIssue++;
            continue;
        }

        FBS_MATCH *match = fbsIssue->match_array;
        for (int j = 0; j < FBS_MAX_ISSUE_MATCH; j++)
        {
            if ( (!match->used) || ((match->state != M_STATE_OPEN) && (match->state != M_STATE_ARRANGE)) ) {
                match++;
                continue;
            }

            for (int k = FBS_SUBTYPE_WIN; k < FBS_SUBTYPE_NUM; k++)
            {
                for (int m = 0; m < FBS_SUBTYPE_MAX_SEL_NUM; m++)
                {
                    resodds = match->odds_array[k].odds + m;
                    if (!resodds->used) {
                        continue;
                    }
                    resodds->sp_old = resodds->sp;
                    resodds->sp = rounding(match->odds_array[k].bet_amount*1000/resodds->amount);
                }
            }

            match++;
        }

        fbsIssue++;
    }


    return 0;
}

// gl_task_draw_fbs������
//�����ڴ�match �����Ϣ
int gl_fbs_update_match_result(uint32 issue_number, uint32 match_code, SUB_RESULT s_results[], uint8 match_result[])
{
    FBS_MATCH* match = gl_fbs_get_match(issue_number, match_code);
    if (NULL==match) {
        log_error("gl_fbs_update_match_result() error. match_code[%u] error",match_code);
        return -1;
    }

    //���±��������Ϣ
    //match first half time result sets
    match->fht_win_result = match_result[0];  //�ϰ볡������� M_WIN_HOME, M_WIN_DRAW, M_WIN_AWAY
    match->fht_home_goals = match_result[1];  //�ϰ볡���ӽ�����
    match->fht_away_goals = match_result[2];  //�ϰ볡�Ͷӽ�����
    match->fht_total_goals = match->fht_home_goals + match->fht_away_goals; //�ϰ볡�ܽ�����
    //match second half time result sets
    match->sht_win_result = match_result[3];  //�°볡������� M_WIN_HOME, M_WIN_DRAW, M_WIN_AWAY
    match->sht_home_goals = match_result[4];  //�°볡���ӽ�����
    match->sht_away_goals = match_result[5];  //�°볡�Ͷӽ�����
    match->sht_total_goals = match->sht_home_goals + match->sht_away_goals; //�°볡�ܽ�����
	//match full time result sets
    match->ft_win_result = match_result[6];   //ȫ��������� M_WIN_HOME, M_WIN_DRAW, M_WIN_AWAY
    match->ft_home_goals = match->fht_home_goals + match->sht_home_goals;   //ȫ�����ӽ�����
    match->ft_away_goals = match->fht_away_goals + match->sht_away_goals;   //ȫ���Ͷӽ�����
    match->ft_total_goals = match->ft_home_goals + match->ft_away_goals;  //ȫ���ܽ�����
    match->first_goal = match_result[7];      //�Ǹ������Ƚ���  M_TERM_HOME or M_TERM_AWAY

    //��������
    M_ODDS *odds_ptr = NULL;
    for (int i=FBS_SUBTYPE_WIN;i<=FBS_SUBTYPE_OUOD;i++) {
        //��������ö��ֵ
        match->fbs_result[i] = s_results[i].result;
        //���¿�����final SP
        odds_ptr = &match->odds_array[i];
        odds_ptr->bet_amount = s_results[i].amount;
        odds_ptr->single_amount = s_results[i].single_amount;
        odds_ptr->multiple_amount = s_results[i].multiple_amount;
        odds_ptr->odds[s_results[i].result].amount = s_results[i].result_amount;
        odds_ptr->odds[s_results[i].result].single_amount = s_results[i].single_result_amount;
        odds_ptr->odds[s_results[i].result].multiple_amount = s_results[i].multiple_result_amount;
        odds_ptr->odds[s_results[i].result].sp_old = odds_ptr->odds[s_results[i].result].sp;
        odds_ptr->odds[s_results[i].result].sp = s_results[i].final_sp;
        
    }

    //���±���״̬
    match->state = M_STATE_CONFIRM;
    match->draw_time = get_now();

    log_info("Update Match Rssults -> WIN[ %s ]  HCP[ %s ]  TOT[ %s ]  SCR[ %s ]  HFT[ %s ]  OUOD[ %s ]",
        WIN_ResultString[match->fbs_result[FBS_SUBTYPE_WIN]],
        HCP_ResultString[match->fbs_result[FBS_SUBTYPE_HCP]],
        TOT_ResultString[match->fbs_result[FBS_SUBTYPE_TOT]],
        SCR_ResultString[match->fbs_result[FBS_SUBTYPE_SCR]],
        HFT_ResultString[match->fbs_result[FBS_SUBTYPE_HFT]],
        OUOD_ResultString[match->fbs_result[FBS_SUBTYPE_OUOD]] );
    return 0;
}

POOL_PARAM *gl_fbs_getPoolParam(void)
{
	return NULL;
}

void *gl_fbs_getSubtypeTable(int *len)
{
    if (NULL != len)
    {
        *len = sizeof(FBS_SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;
    }
    return fbs_database_ptr->subtype_params;
}


ISSUE_INFO *gl_fbs_get_currIssue(void)
{
	return NULL;
}

int get_fbs_issueMaxCount(void)
{
    int cnt = 0;
    FBS_ISSUE *issue = gl_fbs_get_issueTable();
    for(int i = 0; i < FBS_MAX_ISSUE_NUM ; i++)
    {
        if(issue[i].used)
        {
            cnt++;
        }
    }

    return cnt;
}

//�ⲿ�ж��Ƿ�Ϊ���Ƿ����
FBS_ISSUE *gl_fbs_get_issueTable(void)
{
	return fbs_database_ptr->issue_array;
}

uint32 gl_fbs_get_minIssue(void)
{
    //ȡ��Ŀǰ״̬Ϊ�����۵���С�ں�
    FBS_ISSUE *fbsIssue = gl_fbs_get_issueTable();
    uint32 issue = 99999999 * 10;
    for (int m = 0; m < FBS_MAX_ISSUE_NUM; m++)
    {
        if ( (fbsIssue[m].used) && (fbsIssue[m].state == ISSUE_STATE_OPENED) ) {
            log_debug("all issue:[%u], used[%d]", fbsIssue[m].issue_number, fbsIssue[m].used);
            if (fbsIssue[m].issue_number < issue) {
                issue = fbsIssue[m].issue_number;
            }
        }
    }

    if (99999999 * 10 == issue) {
        issue = 0;
    }

    return issue;

}

uint32 gl_fbs_get_issueMaxSeq(void)
{
    uint32 seq = 0;
    FBS_ISSUE *allIssueInfo = gl_fbs_get_issueTable();

    for(int i = 0; i < FBS_MAX_ISSUE_NUM ; i++)
    {
        if(allIssueInfo[i].used)
        {
            if(allIssueInfo[i].issue_number > seq)
                seq = allIssueInfo[i].issue_number;
        }
    }

    return seq;
}


int gl_fbs_load_match(int n, uint32 issue_number, DB_FBS_MATCH *match_list)
{
    int i = 0;
    int j = 0;
    FBS_ISSUE *issue = NULL;
    for (j = 0; j < FBS_MAX_ISSUE_NUM; j++) {
        issue = &fbs_database_ptr->issue_array[j];
        if (issue->used && issue->issue_number == issue_number) {
            break;
        }
    }

    //δ�ҵ��ڴ�
    if (j >= FBS_MAX_ISSUE_NUM) {
        log_error("find issue[%u] fail", issue_number);
        return -1;
    }

    log_debug("gl_fbs_load_match.n[%d]issue[%u].issue_number[%u]",
            n, issue->issue_number, issue_number);
    FBS_MATCH *match = NULL;

    for (j = 0; j < n; j++)
    {
        DB_FBS_MATCH *dbMatch = match_list + j;
        for (i = 0; i < FBS_MAX_ISSUE_MATCH; i++)
        {
            match = issue->match_array + i;
            if (!match->used) {
                break;
            }
        }

        if (i >= FBS_MAX_ISSUE_MATCH) {
            log_error("find match fail.j[%d],i[%d]", j, i);
            return -1;
        }

        log_debug("load match. i[%d]match_code[%u]", i, dbMatch->match_code);

        //�ҵ���, ����
        match->subtype_status[1] = ENABLED;
        match->subtype_status[2] = ENABLED;
        match->subtype_status[3] = ENABLED;
        match->subtype_status[4] = ENABLED;
        match->subtype_status[5] = ENABLED;
        match->subtype_status[6] = ENABLED;

        match->used = true;
        match->idx = i;
        match->match_code = dbMatch->match_code;
        match->seq = dbMatch->seq;
        match->status = dbMatch->is_sale;
        match->competition = dbMatch->competition;
        match->round = dbMatch->round;
        match->home_code = dbMatch->home_code;
        match->away_code = dbMatch->away_code;
        match->date = dbMatch->match_date;
        strcpy(match->venue, dbMatch->venue);
        match->match_time = dbMatch->match_start_time;
//        match->result_time = dbMatch->result_time;
//        match->draw_time = dbMatch->draw_time;
        match->sale_time = dbMatch->begin_sale_time;
        match->close_time = dbMatch->end_sale_time;
        match->state = dbMatch->match_status;
        match->localState = match->state;
        match->home_handicap = dbMatch->home_handicap;
        match->home_handicap_point5 = dbMatch->home_handicap_point5;
//        match->fht_win_result = dbMatch->fht_win_result;
//        match->fht_home_goals = dbMatch->fht_home_goals;
//        match->fht_away_goals = dbMatch->fht_away_goals;
//        match->fht_total_goals = dbMatch->fht_total_goals;
//        match->sht_win_result = dbMatch->sht_win_result;
//        match->sht_home_goals = dbMatch->sht_home_goals;
//        match->sht_away_goals = dbMatch->sht_away_goals;
//        match->sht_total_goals = dbMatch->sht_total_goals;
//        match->ft_win_result = dbMatch->ft_win_result;
//        match->ft_home_goals = dbMatch->ft_home_goals;
//        match->ft_away_goals = dbMatch->ft_away_goals;
//        match->ft_total_goals = dbMatch->ft_total_goals;
//        match->first_goal = dbMatch->first_goal;
    }

    return 0;
}


int gl_fbs_load_newMatch(void)
{
	log_info("*********FBS:load new match begin....");
	FBS_DATABASE_PTR db = (FBS_DATABASE_PTR)gl_fbs_get_mem_db();
	db->issue_array[0].used = true;
	db->issue_array[0].idx = 0;
	db->issue_array[0].issue_number = 160128;
	db->issue_array[0].publish_time = 0;
	//db->issue_array[0].bet_amount = 0;

	db->issue_array[0].match_array[0].used = true;
	db->issue_array[0].match_array[0].idx = 0;
	db->issue_array[0].match_array[0].match_code = 160128001;
	db->issue_array[0].match_array[0].seq = 1;
	db->issue_array[0].match_array[0].status = ENABLED;

	db->issue_array[0].match_array[0].subtype_status[1] = ENABLED;
	db->issue_array[0].match_array[0].subtype_status[2] = ENABLED;
	db->issue_array[0].match_array[0].subtype_status[3] = ENABLED;
	db->issue_array[0].match_array[0].subtype_status[4] = ENABLED;
	db->issue_array[0].match_array[0].subtype_status[5] = ENABLED;
	db->issue_array[0].match_array[0].subtype_status[6] = ENABLED;

	db->issue_array[0].match_array[0].competition = 1;
	db->issue_array[0].match_array[0].round = 1;
	db->issue_array[0].match_array[0].home_code = 1601281;
	//db->issue_array[0].match_array[0].home_term[0] = 'a';
	db->issue_array[0].match_array[0].away_code = 1601282;
	//db->issue_array[0].match_array[0].away_term[0] = 'b';
	db->issue_array[0].match_array[0].date = 20160128;
	db->issue_array[0].match_array[0].venue[0] = 'c';
	db->issue_array[0].match_array[0].match_time = 0;
	db->issue_array[0].match_array[0].result_time = 0;
	db->issue_array[0].match_array[0].draw_time = 0;
	db->issue_array[0].match_array[0].sale_time = 0;
	db->issue_array[0].match_array[0].close_time = 0;

	db->issue_array[0].match_array[0].state = M_STATE_OPEN;
	db->issue_array[0].match_array[0].home_handicap = 0;
	db->issue_array[0].match_array[0].home_handicap_point5 = 5;
	//db->issue_array[0].match_array[0].odds_array = M_STATE_OPEN;

	db->issue_array[1].used = false;

	log_info("*********FBS:load new match end....");

	return 0;
}

// --------------------------------------------------------------------------
/*
Ͷע�ַ���

1 ------- WIN -------

��Ϸ | �淨 | ���ط�ʽ | �������� | ѡ��ı���(2λ��+��+��+3λ��)��������Ϣ               | Ʊ��� | Ͷע���� | Ʊ��չ���
FBS  | WIN  | 1C1      | 1        | [160101032:1] + [035:1] + [036:1] + [035:0]           | 1000   | 4        | FLAG
FBS  | WIN  | 2C1      | 1        | [032:1-2-3] + [035:1-3] + [036:1-3] + [035:0]         | 1000   | 28       | FLAG
FBS  | WIN  | 3C1      | 1        | [032:3] + [035:1] + [036:1] + [035:0]                 | 1000   | 4        | FLAG

2 ------- HCP -------

��Ϸ | �淨 | ���ط�ʽ | �������� | ѡ��ı�����������Ϣ                                  | Ʊ��� | Ͷע���� | Ʊ��չ���
FBS  | HCP  | 3C1      | 1        | [032:1] + [035:1] + [036:0]                           | 1000   | 1        | FLAG
FBS  | HCP  | 3C1      | 1        | [032:2] + [035:2] + [036:0] + [035:0]                 | 1000   | 4        | FLAG
FBS  | HCP  | 3C1      | 1        | [032:1-2] + [035:3] + [036:1-2] + [035:0]             | 1000   | 12       | FLAG

3 ------- TOT -------

��Ϸ | �淨 | ���ط�ʽ | �������� | ѡ��ı�����������Ϣ                                  | Ʊ��� | Ͷע���� | Ʊ��չ���
FBS  | TOT  | 1C1      | 1        | [032:1] + [035:3] + [036:4] + [035:7]                 | 1000   | 4        | FLAG
FBS  | TOT  | 2C1      | 1        | [032:1] + [035:3] + [036:4] + [035:7]                 | 1000   | 6        | FLAG
FBS  | TOT  | 2C1      | 1        | [032:1-3-15] + [035:3-21] + [036:4] + [035:7]         | 1000   | 23       | FLAG
FBS  | TOT  | 3C1      | 1        | [032:0] + [035:3] + [036:4] + [035:7]                 | 1000   | 4        | FLAG

4 ------- SCR -------

5 ------- HFT -------

6 ------- OUOD -------

*/
int gl_fbs_format_ticket(const char* buf, FBS_TICKET *ticket)
{
	ts_notused(buf);
	uint8 matchBetOption[256] = {0};
	uint32 issue = 99999999*10;

	issue = gl_fbs_get_minIssue();
	if (0 == issue) {
	    return -1;
	}

	FBS_BETM *bm = (FBS_BETM*)ticket->data;
	for (int i = 0; i < ticket->match_count; i++) {
	    matchBetOption[i] = bm->result_count;

	    //set ticket->issue_number
//	    FBS_ISSUE *fbsIssue = gl_fbs_get_issueTable();
//	    for (int m = 0; m < FBS_MAX_ISSUE_NUM; m++)
//	    {
//	        if (fbsIssue[m].used) {
//	            log_debug("all issue:[%u], used[%d]", fbsIssue[m].issue_number, fbsIssue[m].used);
//	            FBS_MATCH *match = gl_fbs_get_match(fbsIssue[m].issue_number, bm->match_code);
//	            if ( (match != NULL) && (issue > fbsIssue[m].issue_number) ) {
//	                issue = fbsIssue[m].issue_number;
//
//	                break;
//	            }
//	        }
//	    }

		log_info("fbs_tkt_bm:match_code[%d],result_count[%d],bm->results[%s],issue[%u]",
		        bm->match_code,bm->result_count,bm->results, issue);
		bm++;
	}

	ticket->issue_number = issue;
	ticket->bet_count = gl_fbs_getBetCount(ticket->bet_type, ticket->match_count, matchBetOption) * ticket->bet_times;

	//k-debug:FBS
	log_info("bet_count:%d, issue[%u]", ticket->bet_count, ticket->issue_number);
	log_info("fbs_tkt:%d,%d,%d,%d,%d, %lld,%d,%d,%d,%d, %d,%d",
			ticket->length,
			ticket->game_code,
			ticket->sub_type,
			ticket->issue_number,
			ticket->bet_type,
			ticket->bet_amount,
			ticket->bet_count,
			ticket->bet_times,
			ticket->flag,
			ticket->is_train,
			ticket->match_count,
			ticket->order_count);
	return 0;
}


int gl_fbs_ticket_verify(const FBS_TICKET* ticket, uint32 *outDate)//�������һ�������Ĺر�����(����������)
{
	//��֤subtype, match, betcount
    //uint8 matchBetOption[256] = {0};
	FBS_BETM *bm = (FBS_BETM*)ticket->data;
	FBS_MATCH *match = NULL;
	if (ticket->sub_type > FBS_SUBTYPE_OUOD) {
		log_error("check sub_type failed, subtype[%d]",
		    	 ticket->sub_type);
		    		return SYS_RESULT_GAME_SUBTYPE_ERR;
	}

	//����Ҫ>=���ط�ʽ��ĳ���
	if (ticket->match_count < BET_SELECT[ticket->bet_type][0]) {
	    log_error("match count error.matchCnt[%d]betType[%d]",
	            ticket->match_count, ticket->bet_type);
	    return SYS_RESULT_FBS_MATCH_ERR;
	}

    for (int i = 0; i < ticket->match_count; i++) {
        //matchBetOption[i] = bm->result_count;
    	match = gl_fbs_get_match_by_match_code(bm->match_code);
    	if (match == NULL) {
    		log_error("check match is NULL, match_code[%d]", bm->match_code);
    		return SYS_RESULT_FBS_MATCH_ERR;
    	} else if ( (match->status != ENABLED)
    	         || (match->state != M_STATE_OPEN) || (match->localState != M_STATE_OPEN) ) {
    	    //k-debug:test
    	    //|| (match->state != M_STATE_OPEN) ) {
    		log_error("check match failed, match_code[%d], status[%d], state[%d],localState[%d]",
    				bm->match_code, match->status, match->state, match->localState);
    		return SYS_RESULT_FBS_MATCH_ERR;
    	} else if (match->subtype_status[ticket->sub_type] != ENABLED) {
    		log_error("check match failed, match_code[%d], subtype[%d], subtype_status[%d]",
    				bm->match_code, ticket->sub_type, match->subtype_status[ticket->sub_type]);
    		return SYS_RESULT_GAME_SUBTYPE_ERR;
    	}

    	if (*outDate < match->close_time) {
    	    *outDate = match->close_time;
    	}

    	bm++;
    }

    int betCnt = ticket->bet_count;
    FBS_SUBTYPE_PARAM *subtype = gl_fbs_get_subtypeParam(ticket->sub_type);
    if (subtype == NULL) {
        log_error("subtype is NULL [%d]", ticket->sub_type);
        return SYS_RESULT_GAME_SUBTYPE_ERR;
    }
    if (betCnt * subtype->singleAmount != ticket->bet_amount) {
        log_error("gl_fbs_ticket_verify fail.hostMoney[%d]*[%d],termMoney[%ld]",
                betCnt, subtype->singleAmount, ticket->bet_amount);
        return SYS_RESULT_SELL_TICKET_AMOUNT_ERR;
    }


    return 0;
}


// �������a[1..n]����ѡm��Ԫ�ص�������ϡ�
// a[1..n]��ʾ��ѡ����nΪ��ѡ����С��n>=m>0��
// b[1..M]�����洢��ǰ����е�Ԫ��(����洢����Ԫ���±�)��
// c[n..m]�����洢n��ȡm��Ԫ�����е����,c�����п��ܻ�ǳ���
// cFlag����c[]�±�
// ����M��ʾ����������һ�������Ԫ�صĸ�����M=m��������������������������
// *bet_countע��
int combine( int n,
		     int m,
		     uint8 a[],
		     uint8 b[],
		     uint8 c[],
		     int cFlag,
		     const int M,
		     int *bet_count)
{
    int i,j,s;
    static int idx = 0;
    if (1 == cFlag) {
    	idx = 0;
    	cFlag = 0;
    }
    // ע�������ѭ����Χ
    for(i=n; i>=m; i--) {
        b[m-1] = i - 1;
        if (m > 1) {
            combine(i-1,m-1,a,b,c,cFlag,M,bet_count);
        } else {
            // m == 1, ���һ�����
            s = 1;
            for(j=M-1;j>=0;j--) {
                s *= a[b[j]];
                c[idx++] = b[j];
                printf("%d ", b[j]);
            }
            *bet_count += s;
            printf(" --- betCount[%d]  TotalBetCount[%d]\n", s, *bet_count);
        }
    }
    return 0;
}

// betType ���ط�ʽ
// matchCount ѡ��ı�������
// matchBetOption ÿ������Ͷע�Ľ������,���鳤�ȵ��ڱ�������,ÿ���ֽڴ����ⳡ����ѡ��Ľ����Ŀ(�൱�ڸ�ʽ),ֻͶעһ���������1
int gl_fbs_split_order(FBS_TICKET *ticket)
{
    log_debug("bettype[%d], matchCnt[%d]", ticket->bet_type, ticket->match_count);

    FBS_SUBTYPE_PARAM *subtype = gl_fbs_get_subtypeParam(ticket->sub_type);
    if (subtype == NULL) {
        log_error("subtype is NULL [%d]", ticket->sub_type);
        return -1;
    }

	uint8 betType = ticket->bet_type;
	uint8 matchCount = ticket->match_count;
	uint8 matchBetOption[256] = {0};
	uint8 tmpMatchBetOption[256] = {0};
	uint32 matchIdx[FBS_MAX_TICKET_MATCH] = {0};
	FBS_BETM *bm = (FBS_BETM*)ticket->data;
	for (int i = 0; i < ticket->match_count; i++) {
		matchBetOption[i] = bm->result_count;
		tmpMatchBetOption[i] = 1;
		matchIdx[i] = bm->match_code;
		bm++;
	}

	log_info("split:%d,%d,%d", betType, matchCount, matchBetOption[0]);

	log_info("split:%d,%d,%d,%d,%d,%lld,%d,%d,%d,%d,%d,%d",
			ticket->length,
			ticket->game_code,
			ticket->sub_type,
			ticket->issue_number,
			ticket->bet_type,
			ticket->bet_amount,
			ticket->bet_count,
			ticket->bet_times,
			ticket->flag,
			ticket->is_train,
			ticket->match_count,
			ticket->order_count);

    int32 bet_count = 0;
    //k-debug
    //static malloc
    //nmCombine ����nԪ��ȡm���������ϸ
    unsigned char nmCombine[1024*1024] = {0};

    FBS_ORDER *order = (FBS_ORDER*)(ticket->data + ticket->match_count * sizeof(FBS_BETM));

    char betTypeTable[16] = {BET_0,
                             BET_1C1,  BET_2C1,  BET_3C1,  BET_4C1,  BET_5C1,
                             BET_6C1,  BET_7C1,  BET_8C1,  BET_9C1,  BET_10C1,
                             BET_11C1, BET_12C1, BET_13C1, BET_14C1, BET_15C1};

    if (betType==0 || betType>BET_15C1) {
        printf("betType[%s] error\n", BetTypeString[betType]);
        return -1;
    }
    if (matchCount < BET_SELECT[betType][0]) {
        printf("betType[%s] matchCount[%d] error\n", BetTypeString[betType], matchCount);
        return -1;
    }
    unsigned char tmp[1024] = {0};
    int i = 0;
    int idxNo = 1;

    uint32 betCnt = 1;

    for (i=2;i<17;i++) //17  (BET_SELECT[31][17])
        if (BET_SELECT[betType][i] > 0) {
            memset(nmCombine, 0, sizeof(nmCombine));
            memset(tmp, 0, sizeof(tmp));
            int idxMatch = 0;
            bet_count = 0;
            //�����match count ���ж��ٸ� i-1 �����������
            combine(matchCount, i-1, tmpMatchBetOption, tmp, nmCombine, 1, i-1, &bet_count);

            log_debug("i[%d] bet_count[%d]", i, bet_count);

            //�������ε����     ��Ϊ��ʽ  (��ABC 3��2C1,��ΪAB,AC,BC)
            for (int k = 0; k < bet_count; k++) {
                order->ord_no = idxNo++;
                order->bet_type = betTypeTable[i-1];
                order->match_count = i - 1;
                order->result_count = 0;//��ʼΪ0
                betCnt = 1;

                for (int k1 = 0; k1 < i - 1; k1++) {
                    order->match_code_set[k1] = matchIdx[nmCombine[idxMatch]];
                    order->result_count = matchBetOption[nmCombine[idxMatch]];
                    betCnt *= matchBetOption[nmCombine[idxMatch]];
                    idxMatch++;
                }

                order->bet_count = 1 * betCnt * ticket->bet_times;
                order->bet_amount = order->bet_count * subtype->singleAmount;

                order->length = sizeof(FBS_ORDER) + sizeof(uint32) * order->match_count;
                ticket->order_count++;
                ticket->length += order->length;

                //k-debug:FBS
                log_info("fbs_order:len[%d],no[%d],bet_type[%d],bet_amount[%lld], \
                        bet_cnt[%d],match_cnt[%d],result_cnt[%d],match_set_0[%d],ord_cnt[%d]",
                        order->length,
                        order->ord_no,
                        order->bet_type,
                        order->bet_amount,
                        order->bet_count,
                        order->match_count,
                        order->result_count,
                        order->match_code_set[0],
                        ticket->order_count);
                for (int z = 0; z < order->match_count; z++)
                {
                    log_info("match set [%d]", order->match_code_set[z]);
                }
                log_info("%d,%d,%d", nmCombine[0],nmCombine[1],nmCombine[2]);

                order = (FBS_ORDER*)((char*)order + order->length);
            }
        }
    return 0;
}


//get Count
// �������a[1..n]����ѡm��Ԫ�ص�������ϡ�
// a[1..n]��ʾ��ѡ����nΪ��ѡ����С��n>=m>0��
// b[1..M]�����洢��ǰ����е�Ԫ��(����洢����Ԫ���±�)��
// ����M��ʾ����������һ�������Ԫ�صĸ�����M=m��������������������������
// *bet_countע��
int combine_1(int n, int m, uint8 a[], uint8 b[], const int M, int *bet_count)
{
    int i,j,s;
    // ע�������ѭ����Χ
    for(i=n; i>=m; i--) {
        b[m-1] = i - 1;
        if (m > 1) {
            combine_1(i-1,m-1,a,b,M,bet_count);
        } else {
            // m == 1, ���һ�����
            s = 1;
            for(j=M-1;j>=0;j--) {
                s *= a[b[j]];
                printf("%d ", b[j]);
            }
            *bet_count += s;
            printf(" --- betCount[%d]  TotalBetCount[%d]\n", s, *bet_count);
        }
    }
    return 0;
}

// betType ���ط�ʽ
// matchCount ѡ��ı�������
// matchBetOption ÿ������Ͷע�Ľ������,���鳤�ȵ��ڱ�������,ÿ���ֽڴ����ⳡ����ѡ��Ľ����Ŀ(�൱�ڸ�ʽ),ֻͶעһ���������1
int gl_fbs_getBetCount(uint8 betType, uint8 matchCount, unsigned char *matchBetOption)
{
    int32 bet_count = 0;
    if (betType==0 || betType>BET_15C1) {
        printf("betType[%s] error\n", BetTypeString[betType]);
        return -1;
    }
    if (matchCount < BET_SELECT[betType][0]) {
        printf("betType[%s] matchCount[%d] error\n", BetTypeString[betType], matchCount);
        return -1;
    }
    unsigned char tmp[1024] = {0};
    int i = 0;
    for (i=2;i<17;i++)
        if (BET_SELECT[betType][i] > 0)
            //�����match count ���ж��ٸ� i-1 �����������
            combine_1(matchCount, i-1, matchBetOption, tmp, i-1, &bet_count);
    return bet_count;
}

/*
//����㷨 ��n����ѡm���������������
int comb(int n, int m)
{
    int count,i,mx;
    for(mx=n,count=1,i=n-m;n>i;n--)
        count*=n;
    for(i=mx-n;i>1;count/=i--);
    return count;
}
*/


int test_bet_count(int cnt)
{
    int i = 0;
    uint32 bet_count = 0;

    int matchCount = 15;
    unsigned char *matchBetOption = (unsigned char*)malloc(matchCount);
    time_t begin1 = time(0);
    for (i=0;i<cnt;i++) {
        memset(matchBetOption, 1, matchCount);
        matchBetOption[0] = 2;
        matchBetOption[1] = 1;
        matchBetOption[2] = 1;
        matchBetOption[3] = 3;
        matchBetOption[4] = 2;
        bet_count = gl_fbs_getBetCount(BET_6C63, matchCount, matchBetOption);
        //printf("bet_count [ %d ] --> match[ %u ] betType[ %s ]\n", bet_count, matchCount, BetTypeString[betType]);
    }
    time_t end1 = time(0);
    for (int i=0;i<matchCount;i++) {
        printf("match [ %u ] --->  %d\n", i, matchBetOption[i]);
    }
    printf("Count[%d] --- Cost %u seconds\n", cnt, (uint32)(end1-begin1));
    return 0;
}


//������淨������������������ϴ�DB��OMS���ʹ��
int gl_fbs_sale_calc(uint32 issue_number, uint32 match_code, char *outBuf)
{
    FBS_MATCH* match = gl_fbs_get_match(issue_number, match_code);
    if (match == NULL) {
        log_error("gl_fbs_sale_calc-->match not used[%u]", match_code);
        return -1;
    }

    cJSON *json_result_root = cJSON_CreateObject();
    cJSON *json_subtype_item = NULL;
    cJSON *json_list_item = NULL;
    cJSON *json_listArray = NULL;

    for (int idxSubtype = FBS_SUBTYPE_WIN; idxSubtype < FBS_SUBTYPE_NUM; idxSubtype++)
    {
        M_ODDS *odds = NULL;
        char subtype_abbr[10] = {0};
        int loopNum = 0;
        const char **pRetStr = NULL;

        json_subtype_item = cJSON_CreateObject();

        odds = match->odds_array + idxSubtype;
        memcpy(subtype_abbr, SubTypeParams[idxSubtype].abbr, sizeof(subtype_abbr));


        switch(idxSubtype) {
            case FBS_SUBTYPE_WIN: //WIN
            {
                loopNum = FBS_SUBTYPE_WIN_SEL;
                pRetStr = WIN_ResultString;
                break;
            }
            case FBS_SUBTYPE_HCP: //HCP
            {
                loopNum = FBS_SUBTYPE_HCP_SEL;
                pRetStr = HCP_ResultString;
                break;
            }
            case FBS_SUBTYPE_TOT: //TOT
            {
                loopNum = FBS_SUBTYPE_TOT_SEL;
                pRetStr = TOT_ResultString;
                break;
            }
            case FBS_SUBTYPE_SCR: //SCR
            {
                loopNum = FBS_SUBTYPE_SCR_SEL;
                pRetStr = SCR_ResultString;
                break;
            }
            case FBS_SUBTYPE_HFT: //HFT
            {
                loopNum = FBS_SUBTYPE_HFT_SEL;
                pRetStr = HFT_ResultString;
                break;
            }
            case FBS_SUBTYPE_OUOD: //OUOD
            {
                loopNum = FBS_SUBTYPE_OUOD_SEL;
                pRetStr = OUOD_ResultString;
                break;
            }
        }
        //cJSON_AddNumberToObject(json_subtype_item, "bet_amount", odds->bet_amount);
        cJSON_AddNumberToObject(json_subtype_item, "sa", odds->single_amount);
        cJSON_AddNumberToObject(json_subtype_item, "ma", odds->multiple_amount);

        json_listArray = cJSON_CreateArray();

        //����������1��ʼ
        for (int i = 1; i < loopNum - 1; i++) {
            json_list_item = cJSON_CreateObject();
            M_RESULT_ODDS *retOdds = odds->odds + i;
//            if (pRetStr[i] == NULL) {
//                log_debug("gl_fbs_sale_calc [%d][%d]", idxSubtype, i);
//                cJSON_AddStringToObject(json_list_item, "result", "--");//1:0,2:0,3,2,1....
//            } else {
//                cJSON_AddStringToObject(json_list_item, "result", pRetStr[i]);//1:0,2:0,3,2,1....
//            }

            cJSON_AddNumberToObject(json_list_item, "ret", i);//1:0,2:0,3,2,1....
            //cJSON_AddNumberToObject(json_list_item, "bet_amount", retOdds->amount);
            cJSON_AddNumberToObject(json_list_item, "sa", retOdds->single_amount);
            cJSON_AddNumberToObject(json_list_item, "ma", retOdds->multiple_amount);
            cJSON_AddNumberToObject(json_list_item, "sp", retOdds->sp);//�ο�spֵ (ʵ�ʵ�ֵ��Ҫ ���� 1000) (����С�����3λ)
            //����ֵ�����10���ó��ٷֱ�
//            if (match->odds_array[FBS_SUBTYPE_WIN].bet_amount == 0) {
//                cJSON_AddNumberToObject(json_list_item, "popularity", 0);
//            } else {
//                cJSON_AddNumberToObject(json_list_item, "popularity", retOdds->amount * 1000 / match->odds_array[FBS_SUBTYPE_WIN].bet_amount);
//            }
            cJSON_AddItemToArray(json_listArray, json_list_item);
        }

        cJSON_AddItemToObject(json_subtype_item, "list", json_listArray);
        cJSON_AddItemToObject(json_result_root, subtype_abbr, json_subtype_item);

    }

    char *ret = cJSON_PrintUnformatted(json_result_root);
    int ret_len = strlen(ret);

    if (ret_len >= 4096) {
        log_error("ret_len > 4096[%d]", ret_len);
        log_debug("%s", ret);
        free(ret);
        cJSON_Delete(json_result_root);
        return -1;
    }
    memcpy(outBuf, ret, ret_len);

    free(ret);
    cJSON_Delete(json_result_root);
    //k-debug:
    log_debug("len[%d]", ret_len);

    return 0;
}












int gl_fbs_sale_rk_verify(FBS_TICKET* ticket)
{
	ts_notused(ticket);
    return 0;
}
int gl_fbs_sale_rk_commit(FBS_TICKET* ticket)
{
	ts_notused(ticket);
    return 0;
}
int gl_fbs_cancel_rk_rollback(FBS_TICKET* ticket)
{
	ts_notused(ticket);
    return 0;
}
int gl_fbs_cancel_rk_commit(FBS_TICKET* ticket)
{
	ts_notused(ticket);
    return 0;
}



















bool gl_fbs_chkp_saveData(const char *filePath)
{
    /*
    GL_ISSUE_CHKP_DATA data;
    memset(&data, 0, sizeof(GL_ISSUE_CHKP_DATA));
    ISSUE_INFO *issue_chkp = NULL;
    ISSUE_INFO *issueInfo = gl_koctty_getIssueTable();

    for(int i = 0; i < koctty_plugin_info.issueCount; i++)
    {
        if(!issueInfo[i].used)
            continue;

        issue_chkp = &data.issueData[i];
        issue_chkp->used = true;
        issue_chkp->gameCode = issueInfo[i].gameCode;
        issue_chkp->issueNumber = issueInfo[i].issueNumber;
        issue_chkp->serialNumber = issueInfo[i].serialNumber;

        issue_chkp->stat.issueSaleAmount = issueInfo[i].stat.issueSaleAmount;
        issue_chkp->stat.issueSaleCount = issueInfo[i].stat.issueSaleCount;
        issue_chkp->stat.issueSaleBetCount = issueInfo[i].stat.issueSaleBetCount;
        issue_chkp->stat.issueCancelAmount = issueInfo[i].stat.issueCancelAmount;
        issue_chkp->stat.issueCancelCount = issueInfo[i].stat.issueCancelCount;
        issue_chkp->stat.issueCancelBetCount = issueInfo[i].stat.issueCancelBetCount;
        issue_chkp->stat.issueRefuseAmount = issueInfo[i].stat.issueRefuseAmount;
        issue_chkp->stat.issueRefuseCount = issueInfo[i].stat.issueRefuseCount;

    }

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/koctty_issue.snapshot", filePath);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
    	log_error("open %s error!",fileName);
    	return -1;
    }
    ssize_t ret = write(fp, (const void *)&data, sizeof(GL_ISSUE_CHKP_DATA));
    if(ret < 0)
    {
    	log_error("write %s error errno[%d]",fileName, errno);
        return -1;
    }
    close(fp);

    return gl_koctty_rk_saveData(filePath);
    */
    return true;
}

bool gl_fbs_chkp_restoreData(const char *filePath)
{
    /*
    GL_ISSUE_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/koctty_issue.snapshot", filePath);
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
    	log_error("open %s error!", fileName);
    	return -1;
    }
    ssize_t ret = read(fp, (void *)&data, sizeof(GL_ISSUE_CHKP_DATA));
    if(ret < 0)
    {
    	log_error("read %s error errno[%d]",fileName,errno);
        return -1;
    }
    close(fp);

    ISSUE_INFO *issue_chkp = NULL;

    ISSUE_INFO *issueInfo = NULL;

    for(int i = 0; i < koctty_plugin_info.issueCount; i++)
    {
        issue_chkp = &data.issueData[i];
        if(!issue_chkp->used)
            continue;

        issueInfo = gl_koctty_get_issueInfo2(issue_chkp->serialNumber);
        if (NULL == issueInfo)
        {
            log_warn("tms chkp_restore() gl_koctty_get_issueInfo2[%d]", issue_chkp->serialNumber);
            continue;
        }

        issueInfo->stat.issueSaleAmount = issue_chkp->stat.issueSaleAmount;
        issueInfo->stat.issueSaleCount = issue_chkp->stat.issueSaleCount;
        issueInfo->stat.issueSaleBetCount = issue_chkp->stat.issueSaleBetCount;
        issueInfo->stat.issueCancelAmount = issue_chkp->stat.issueCancelAmount;
        issueInfo->stat.issueCancelCount = issue_chkp->stat.issueCancelCount;
        issueInfo->stat.issueCancelBetCount = issue_chkp->stat.issueCancelBetCount;
        issueInfo->stat.issueRefuseAmount = issue_chkp->stat.issueRefuseAmount;
        issueInfo->stat.issueRefuseCount = issue_chkp->stat.issueRefuseCount;

    }
    if(isGameBeRiskControl(GAME_KOCTTY))
        return gl_koctty_rk_restoreData(filePath);
    */
    return true;
}

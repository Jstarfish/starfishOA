#include "global.h"
#include "gl_inf.h"
#include "tms_inf.h"
#include "otl_inf.h"
#include "otlPool.h"
#include "otlv4.h"

#define OTL_STREAM_BUF 1

#define OTL_ORA11G_R2 // Compile OTL 4.0/OCI11R2
#define OTL_STREAM_READ_ITERATOR_ON
#define OTL_STL
#define OTL_STREAM_POOLING_ON
#define OTL_ORA_UTF8

#if defined(_MSC_VER)
#define OTL_BIGINT __int64 // Enabling VC++ 64-bit integers
#define OTL_UBIGINT unsigned __int64 // Enabling VC++ 64-bit integers
#else
#define OTL_BIGINT long long // Enabling G++ 64-bit integers
#define OTL_UBIGINT unsigned long long // Enabling G++ 64-bit integers
#endif

#define MAX_XML_STRING_LENGTH    (1024*1000)

static otlPool *otlp = NULL;

static map<INM_MSG_TYPE, char *> jsonPilMap = {
	{ INM_TYPE_T_AUTH,  "begin p_set_auth(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_SIGNIN,  "begin p_set_login(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_SIGNOUT,  "begin p_set_logoff(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_GAME_INFO,  "begin p_set_get_gameinfo(:f1<char[1024],in>,:f2<char[2048],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_AGENCY_BALANCE,  "begin p_set_get_accinfo(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_INQUIRY_TICKET_DETAIL,  "begin p_set_get_lotinfo(:f1<char[1024],in>,:f2<char[2048],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_CHANGE_PWD,  "begin p_set_modify_pass(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_SELL_TICKET,  "begin p_set_sale(:f1<char[4096],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_PAY_TICKET, "begin p_set_pay(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
	{ INM_TYPE_T_CANCEL_TICKET, "begin p_set_cancel(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
    { INM_TYPE_O_PAY_TICKET, "begin p_set_pay(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
    { INM_TYPE_O_CANCEL_TICKET, "begin p_set_cancel(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
    { INM_TYPE_T_INQUIRY_WIN,  "begin p_set_get_lotinfo(:f1<char[1024],in>,:f2<char[2048],out>,:f3<int,out>,:f4<char[200],out>); end;" },
    { INM_TYPE_N_HB,  "begin p_set_term_online (:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
    { INM_TYPE_AP_AUTODRAW, "begin p_set_paperless_pay(:f1<char[1024],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
    { INM_TYPE_AP_SELL_TICKET,  "begin p_set_paperless_sale(:f1<char[4096],in>,:f2<char[1024],out>,:f3<int,out>,:f4<char[200],out>); end;" },
};




/*******************************************************************************/
void otl_changeTimeStr2Local(const char *timeStr, uint32 *t1, uint32 *t2)
{
    //HH:mm-HH:mm
    int a, b, c, d;
    const char *format = "%02d:%02d-%02d:%02d";
    sscanf(timeStr, format, &a, &b, &c, &d);

    *t1 = a * 100 + b;
    *t2 = c * 100 + d;
}

time_t getTimeByOtlTime(otl_datetime *otlTime)
{
    struct tm t;
    bzero((void *)&t, sizeof(tm));

    t.tm_year = otlTime->year - 1900;
    t.tm_mon = otlTime->month - 1;
    t.tm_mday = otlTime->day;
    t.tm_hour = otlTime->hour;
    t.tm_min = otlTime->minute;
    t.tm_sec = otlTime->second;

    return mktime(&t);
}


bool otl_connectDB(char * user, char * pass, char * serviceurl, int min)
{
	std::string username(user);
	std::string passwd(pass);
	std::string servicename(serviceurl);
    int max = min * 2;

	otlp = new otlPool;
	if (otlp == NULL)
	{
		log_error("new otlPool failure!");
		return false;
	}
	else
	{
		if (otlp->init_pool(username, passwd, servicename, max, min) != 0)
		{
			log_error("init_pool failure!");
			return false;
		}
	}
	return true;
}

void otl_disConnectDB(void)
{
    delete otlp;
}



int otl_json_sp_pil(int type,char * req, char *rsp)
{
	log_debug("otl_json_sp_pil req:%s", req);
	int errorCode = 0;
	string errorStr;
	string rspstr;

	map<INM_MSG_TYPE, char *>::iterator iter = jsonPilMap.find((INM_MSG_TYPE)type);
	if (iter == jsonPilMap.end()) {
		log_error("otl_json_sp_pil unknow type:%d!",type);
		return 1;
	}


	otl_connect* dbConn = otlp->get_connect();
	if (dbConn == NULL)
	{
		log_error("otl_json_sp_pil get_connect failure!");
		return 1;
	}
	try {
		otl_nocommit_stream stm_json;
		stm_json.open(1, iter->second, *dbConn);
		stm_json << req;
		while (!stm_json.eof())
		{
			stm_json >> rspstr >> errorCode >> errorStr;
		}
		stm_json.flush();
		dbConn->commit();
		stm_json.close();
	}
	catch (otl_exception& p) {
		log_error("otl_json_sp_pil msg[%s]", p.msg);
		log_error("otl_json_sp_pil text[%s]", p.stm_text);
		log_error("otl_json_sp_pil info[%s]", p.var_info);
		otlp->release_conn(dbConn);
		return 1;
	}
	otlp->release_conn(dbConn);

	if (errorCode == 0)
	{
		memcpy(rsp, rspstr.c_str(), rspstr.length());
        log_debug("otl_json_sp_pil rsp:%s", rsp);
		return 0;
	}
	else
	{
		log_warn("otl_json_sp_pil type[%d] errorCode[%d] errorStr[%s]",type, errorCode, errorStr.c_str());
		return errorCode;
	}

}

/************************************************************************************************/
const char *sqlString_setIssueStatusPil = \
"begin" \
" P_SET_ISSUE_STATUS(:f1<int,in>,:f2<ubigint,in>,:f3<int,in>,:f4<timestamp,in>,:f5<int,out>,:f6<char[200],out>);" \
"end;";

bool otl_set_issue_status(uint8 game_code, uint64 issue_num, int32 issue_status, int32 real_time)
{
	int errorCode = 0;
	string errorStr;

	time_t time_tmp = (time_t)real_time;
	struct tm  *tm_ptr = localtime(&time_tmp);

	otl_value<otl_datetime> mytime;
	mytime.v.year = tm_ptr->tm_year + 1900;
	mytime.v.month = tm_ptr->tm_mon + 1;
	mytime.v.day = tm_ptr->tm_mday;
	mytime.v.hour = tm_ptr->tm_hour;
	mytime.v.minute = tm_ptr->tm_min;
	mytime.v.second = tm_ptr->tm_sec;
	mytime.set_non_null();


	otl_connect* dbConn = otlp->get_connect();
	if (dbConn == NULL)
	{
		log_error("get_connect failure!");
		return false;
	}

	otl_stream stm_proc_setIssueStatus;

	try {
		stm_proc_setIssueStatus.open(1, sqlString_setIssueStatusPil, *dbConn);
		stm_proc_setIssueStatus << (int)game_code << issue_num << issue_status << mytime;
		while (!stm_proc_setIssueStatus.eof())
		{
			stm_proc_setIssueStatus >> errorCode >> errorStr;
		}
		stm_proc_setIssueStatus.close();

	}
	catch (otl_exception& p) {
		//send_otlDealFalseNotify("otl_set_issue_status");
		log_error("otl_set_issue_status msg[%s]", p.msg);
		log_error("otl_set_issue_status text[%s]", p.stm_text);
		log_error("otl_set_issue_status info[%s]", p.var_info);
		otlp->release_conn(dbConn);
		return false;
	}
	otlp->release_conn(dbConn);

	if (errorCode == 0)
		return true;
	else
	{
		//send_otlDealFalseNotify("otl_set_issue_status");
		log_error("otl_set_issue_status errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
		return false;
	}
}

/************************************************************************************************/
const char *sqlString_getIssueInfoByIssueNum = "select * from  ISS_GAME_ISSUE where GAME_CODE=:f1<int> and issue_number=:f2<ubigint>";

bool otl_get_issue_info(uint8 game_code, uint64 issue_num, GIDB_ISSUE_INFO *issue_info)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    otl_datetime planStartTime;
    otl_datetime planCloseTime;
    otl_datetime planDrawTime;
    otl_datetime realStartTime;
    otl_datetime realCloseTime;
    otl_datetime realDrawTime;
    otl_datetime realPayTime;


    log_info("otl_get_issue_info enter game_code[%d] issue_num[%lld].", game_code, issue_num);


    otl_stream stm_get_issueInfoByIssueNum;
    try {
        stm_get_issueInfoByIssueNum.open(OTL_STREAM_BUF, sqlString_getIssueInfoByIssueNum, *dbConn);
        otl_stream_read_iterator<otl_stream, otl_exception, otl_lob_stream> rs;
        stm_get_issueInfoByIssueNum << (int)game_code << issue_num;
        rs.attach(stm_get_issueInfoByIssueNum);
        while (rs.next_row())
        {
            rs.get("ISSUE_SEQ", issue_info->serialNumber);
            rs.get("ISSUE_STATUS", (int &)(issue_info->status));
            rs.get("PLAN_START_TIME", planStartTime);
            rs.get("PLAN_CLOSE_TIME", planCloseTime);
            rs.get("PLAN_REWARD_TIME", planDrawTime);
            rs.get("REAL_START_TIME", realStartTime);
            rs.get("REAL_CLOSE_TIME", realCloseTime);
            rs.get("REAL_REWARD_TIME", realDrawTime);
            rs.get("ISSUE_END_TIME", realPayTime);
            rs.get("PAY_END_DAY", issue_info->payEndDay);
            rs.get("FINAL_DRAW_NUMBER", issue_info->draw_code_str);

            issue_info->estimate_start_time = getTimeByOtlTime(&planStartTime);
            issue_info->estimate_close_time = getTimeByOtlTime(&planCloseTime);
            issue_info->estimate_draw_time = getTimeByOtlTime(&planDrawTime);
            issue_info->real_start_time = getTimeByOtlTime(&realStartTime);
            issue_info->real_close_time = getTimeByOtlTime(&realCloseTime);
            issue_info->real_draw_time = getTimeByOtlTime(&realDrawTime);
            issue_info->real_pay_time = getTimeByOtlTime(&realPayTime);

            issue_info->gameCode = game_code;
            issue_info->issueNumber = issue_num;

        }
        rs.detach();
        stm_get_issueInfoByIssueNum.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_get_issue_info");
        log_error("otl_get_issue_info msg[%s]", p.msg);
        log_error("otl_get_issue_info text[%s]", p.stm_text);
        log_error("otl_get_issue_info info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }

    otlp->release_conn(dbConn);
    return true;
}


/************************************************************************************************/
const char *sqlString_getIssueInfoByIssueSerial = "select * from  ISS_GAME_ISSUE where GAME_CODE=:f1<int> and issue_seq=:f2<unsigned>";

bool otl_get_issue_info2(uint8 game_code, uint32 issue_serial, GIDB_ISSUE_INFO *issue_info)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    otl_datetime planStartTime;
    otl_datetime planCloseTime;
    otl_datetime planDrawTime;
    otl_datetime realStartTime;
    otl_datetime realCloseTime;
    otl_datetime realDrawTime;
    otl_datetime realPayTime;


    log_info("otl_get_issue_info2 enter game_code[%d] issue_serial[%d] ", game_code, issue_serial);


    otl_stream stm_get_issueInfoByIssueSeq;
    try {
        stm_get_issueInfoByIssueSeq.open(OTL_STREAM_BUF, sqlString_getIssueInfoByIssueSerial, *dbConn);
        otl_stream_read_iterator<otl_stream, otl_exception, otl_lob_stream> rs;
        stm_get_issueInfoByIssueSeq << (int)game_code << issue_serial;
        rs.attach(stm_get_issueInfoByIssueSeq);
        while (rs.next_row())
        {
            rs.get("ISSUE_NUMBER", issue_info->issueNumber);
            rs.get("ISSUE_STATUS", (int &)(issue_info->status));
            rs.get("PLAN_START_TIME", planStartTime);
            rs.get("PLAN_CLOSE_TIME", planCloseTime);
            rs.get("PLAN_REWARD_TIME", planDrawTime);
            rs.get("REAL_START_TIME", realStartTime);
            rs.get("REAL_CLOSE_TIME", realCloseTime);
            rs.get("REAL_REWARD_TIME", realDrawTime);
            rs.get("ISSUE_END_TIME", realPayTime);
            rs.get("PAY_END_DAY", issue_info->payEndDay);
            rs.get("FINAL_DRAW_NUMBER", issue_info->draw_code_str);

            issue_info->estimate_start_time = getTimeByOtlTime(&planStartTime);
            issue_info->estimate_close_time = getTimeByOtlTime(&planCloseTime);
            issue_info->estimate_draw_time = getTimeByOtlTime(&planDrawTime);
            issue_info->real_start_time = getTimeByOtlTime(&realStartTime);
            issue_info->real_close_time = getTimeByOtlTime(&realCloseTime);
            issue_info->real_draw_time = getTimeByOtlTime(&realDrawTime);
            issue_info->real_pay_time = getTimeByOtlTime(&realPayTime);

            issue_info->gameCode = game_code;
            issue_info->serialNumber = issue_serial;

        }
        rs.detach();
        stm_get_issueInfoByIssueSeq.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_get_issue_info2");
        log_error("otl_get_issue_info2 msg[%s]", p.msg);
        log_error("otl_get_issue_info2 text[%s]", p.stm_text);
        log_error("otl_get_issue_info2 info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }

    otlp->release_conn(dbConn);
    return true;
}


/************************************************************************************************/
const char *sqlString_fbs_get_competition = "select COMPETITION_CODE,COMPETITION_ABBR,COMPETITION_NAME from FBS_COMPETITION order by COMPETITION_CODE";

bool otl_fbs_getCompetition(int *count, DB_FBS_COMPETITION *comp)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    log_info("otl_fbs_getCompetition enter.");
    int row = 0;

    otl_stream stm_get_competition;
    try {
        stm_get_competition.open(OTL_STREAM_BUF, sqlString_fbs_get_competition, *dbConn);
        stm_get_competition.rewind();
        while (!stm_get_competition.eof())
        {
            stm_get_competition >> comp->code >> comp->abbr >> comp->name;
            row++;
            comp++;
        }
        stm_get_competition.close();
        log_info("otl_fbs_getCompetition out! row[%d]", row);
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_getCompetition msg[%s]", p.msg);
        log_error("otl_fbs_getCompetition text[%s]", p.stm_text);
        log_error("otl_fbs_getCompetition info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    *count = row;
    otlp->release_conn(dbConn);
    return true;
}

/************************************************************************************************/
const char *sqlString_fbs_get_team = "select TEAM_CODE,COUNTRY_CODE,FULL_NAME,SHORT_NAME from FBS_COMPETITION_TEAM order by TEAM_CODE";

bool otl_fbs_getTeam(int *count, DB_FBS_TEAM *team)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    log_info("otl_fbs_getTeam enter.");
    int row = 0;

    otl_stream stm_get_team;
    try {
        stm_get_team.open(OTL_STREAM_BUF, sqlString_fbs_get_team, *dbConn);
        stm_get_team.rewind();
        while (!stm_get_team.eof())
        {
            stm_get_team >> team->teamCode >> team->countryCode >> team->name >> team->abbr;
            row++;
            team++;
        }
        stm_get_team.close();
        log_info("otl_fbs_getTeam out! row[%d]", row);
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_getTeam msg[%s]", p.msg);
        log_error("otl_fbs_getTeam text[%s]", p.stm_text);
        log_error("otl_fbs_getTeam info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    *count = row;

    otlp->release_conn(dbConn);
    return true;
}

/************************************************************************************************/
const char *sqlString_fbs_get_one_new_issue = "select FBS_ISSUE_NUMBER,FBS_ISSUE_DATE,PUBLISH_TIME from FBS_ISSUE where \
GAME_CODE = :f1<int> and FBS_ISSUE_NUMBER > :f2<unsigned> and PUBLISH_STATUS=1 and \
FBS_ISSUE_NUMBER in (select distinct FBS_ISSUE_NUMBER from FBS_MATCH minus select distinct FBS_ISSUE_NUMBER from FBS_MATCH where STATUS <> 1)";

int otl_fbs_getOneNewIssue(uint8 gameCode, uint32 maxissue, DB_FBS_ISSUE *issue)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return -1;
    }
    log_info("otl_fbs_getOneNewIssue enter maxissue[%d]", maxissue);

    otl_datetime releaseTime;
    int row = 0;

    otl_stream stm_get_issue;
    try {
        stm_get_issue.open(OTL_STREAM_BUF, sqlString_fbs_get_one_new_issue, *dbConn);
        stm_get_issue << (int)gameCode << maxissue;
        while (!stm_get_issue.eof())
        {
            stm_get_issue >> issue->issue_number >> issue->issue_date >> releaseTime;
            issue->publish_time = getTimeByOtlTime(&releaseTime);
            row++;
        }
        stm_get_issue.close();
        log_info("otl_fbs_getOneNewIssue out! row[%d]", row);
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_getOneNewIssue msg[%s]", p.msg);
        log_error("otl_fbs_getOneNewIssue text[%s]", p.stm_text);
        log_error("otl_fbs_getOneNewIssue info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return -1;
    }
    otlp->release_conn(dbConn);
    return row;
}

/************************************************************************************************/
const char *sqlString_fbs_get_matchByIssue = "select match_code,match_seq,is_sale,competition,\
competition_round,home_team_code,guest_team_code,match_date,location,match_start_date,match_end_date,\
begin_sale_time,end_sale_time,status,win_level_los_score,win_los_score \
from fbs_match where game_code = :f1<int>  and fbs_issue_number = :f2<unsigned> order by match_code";

bool otl_fbs_getMatchByIssue(uint8 gameCode, uint32 issuenum, int *count, DB_FBS_MATCH *fbsm)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    int row = 0;
    float win_lose_score = 0.0;
    otl_datetime matchDate;
    otl_datetime matchStartTime;
    otl_datetime matchEndTime;
    otl_datetime saleStartTime;
    otl_datetime saleEndTime;
    otl_datetime matchResultTime;
    otl_datetime rewardTime;

    log_info("otl_fbs_getMatch enter issue_num[%u].", issuenum);

    otl_stream stm_get_match;
    try {
        stm_get_match.open(OTL_STREAM_BUF, sqlString_fbs_get_matchByIssue, *dbConn);
        stm_get_match << (int)gameCode << issuenum;
        while(!stm_get_match.eof())
        {
            stm_get_match >> (int &)(fbsm->match_code) >> (int &)(fbsm->seq) >> (int &)(fbsm->is_sale) >> (int &)(fbsm->competition)
                >> (int &)(fbsm->round) >> (int &)(fbsm->home_code) >> (int &)(fbsm->away_code) >> matchDate >> fbsm->venue 
                >> matchStartTime >> matchEndTime >> saleStartTime >> saleEndTime >> (int &)(fbsm->match_status)
                >> (int &)(fbsm->home_handicap) >> win_lose_score;

            fbsm->match_date = getTimeByOtlTime(&matchDate);
            fbsm->match_start_time = getTimeByOtlTime(&matchStartTime);
            fbsm->match_end_time = getTimeByOtlTime(&matchEndTime);
            fbsm->begin_sale_time = getTimeByOtlTime(&saleStartTime);
            fbsm->end_sale_time = getTimeByOtlTime(&saleEndTime);
            fbsm->home_handicap_point5 = (int32) (10 * win_lose_score);

            fbsm++;
            row++;
        }

        stm_get_match.close();
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_getMatch code[%d]", p.code);
        log_error("otl_fbs_getMatch msg[%s]", p.msg);
        log_error("otl_fbs_getMatch text[%s]", p.stm_text);
        log_error("otl_fbs_getMatch info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    *count = row;
    otlp->release_conn(dbConn);
    log_info("otl_fbs_getMatch exit row[%d].", row);
    return true;
}


/************************************************************************************************/
const char *sqlString_fbs_get_allMatchsByIssue = "select match_code,match_seq,is_sale,competition,\
competition_round,home_team_code,home.short_name home_team_name,guest_team_code,guest.short_name guest_team_name,match_date,\
location,match_start_date,match_end_date,begin_sale_time,end_sale_time,status,win_level_los_score,win_los_score \
from fbs_match tb join FBS_COMPETITION_TEAM home on(home.TEAM_CODE = tb.home_team_code) join FBS_COMPETITION_TEAM guest on(guest.TEAM_CODE = tb.guest_team_code)\
where tb.game_code = :f1<int>  and tb.fbs_issue_number = :f2<unsigned> order by tb.match_code";

bool otl_fbs_getAllMatchsByIssue(uint8 gameCode, uint32 issuenum, int *count, DB_FBS_MATCH *fbsm)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    int row = 0;
    float win_lose_score = 0.0;
    otl_datetime matchDate;
    otl_datetime matchStartTime;
    otl_datetime matchEndTime;
    otl_datetime saleStartTime;
    otl_datetime saleEndTime;
    otl_datetime matchResultTime;
    otl_datetime rewardTime;

    log_info("otl_fbs_getMatch enter issue_num[%u].", issuenum);

    otl_stream stm_get_match;
    try {
        stm_get_match.open(OTL_STREAM_BUF, sqlString_fbs_get_allMatchsByIssue, *dbConn);
        stm_get_match << (int)gameCode << issuenum;
        while (!stm_get_match.eof())
        {
            stm_get_match >> (int &)(fbsm->match_code) >> (int &)(fbsm->seq) >> (int &)(fbsm->is_sale) >> (int &)(fbsm->competition)
                >> (int &)(fbsm->round) >> (int &)(fbsm->home_code) >> (int &)(fbsm->away_code) >> matchDate >> fbsm->venue 
                >> matchStartTime >> matchEndTime >> saleStartTime >> saleEndTime >> (int &)(fbsm->match_status)
                >> (int &)(fbsm->home_handicap) >> win_lose_score;

            fbsm->match_date = getTimeByOtlTime(&matchDate);
            fbsm->match_start_time = getTimeByOtlTime(&matchStartTime);
            fbsm->match_end_time = getTimeByOtlTime(&matchEndTime);
            fbsm->begin_sale_time = getTimeByOtlTime(&saleStartTime);
            fbsm->end_sale_time = getTimeByOtlTime(&saleEndTime);
            fbsm->home_handicap_point5 = (int32)(10 * win_lose_score);

            fbsm++;
            row++;
        }

        stm_get_match.close();
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_getMatch msg[%s]", p.msg);
        log_error("otl_fbs_getMatch text[%s]", p.stm_text);
        log_error("otl_fbs_getMatch info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    *count = row;
    otlp->release_conn(dbConn);
    log_info("otl_fbs_getMatch exit row[%d].", row);
    return true;
}

/************************************************************************************************/
const char *sqlString_fbs_get_matchOdds = "select * from fbs_match_odds a,fbs_match_result b \
where  a.GAME_CODE = :f1<int> and a.match_code=:f2<unsigned> and a.match_result_code=b.match_result_code";

bool otl_fbs_getMatchOdds(uint8 gameCode, uint32 matchCode, int *count, DB_FBS_ODDS *fbsm)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    log_info("otl_fbs_getMatchOdds enter.");

    int row = 0;

    otl_stream stm_get_matchOdds;
    try {
        stm_get_matchOdds.open(OTL_STREAM_BUF, sqlString_fbs_get_matchOdds, *dbConn);
        otl_stream_read_iterator<otl_stream, otl_exception, otl_lob_stream> rs;
        stm_get_matchOdds << (int)gameCode << matchCode;
        rs.attach(stm_get_matchOdds);
        while (rs.next_row())
        {
            rs.get("a.MATCH_SUBTYPE_CODE", (int &)(fbsm->subtype_code));
            rs.get("a.BET_AMOUNT", (money_t &)(fbsm->bet_amount));
            rs.get("a.SINGLE_AMOUNT", (money_t &)(fbsm->single_amount));
            rs.get("a.MULTIPLE_AMOUNT", (money_t &)(fbsm->multiple_amount));
            rs.get("b.MATCH_RESULT_CODE", (int &)(fbsm->match_result_code));
            rs.get("b.BET_AMOUNT", (money_t &)(fbsm->re_amount));
            rs.get("b.SINGLE_AMOUNT", (money_t &)(fbsm->re_single_amount));
            rs.get("b.MULTIPLE_AMOUNT", (money_t &)(fbsm->re_multiple_amount));
            rs.get("b.REF_SP_VALUE", (float &)(fbsm->sp));
            rs.get("b.REF_SP_OLD_VALUE", (float &)(fbsm->sp_old));
            rs.get("b.REF_ODDS", (float &)(fbsm->odds));
            rs.get("b.REF_OLD_ODDS", (float &)(fbsm->odds_old));
            fbsm++;
            row++;
        }
        rs.detach();
        stm_get_matchOdds.close();
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_getMatchOdds msg[%s]", p.msg);
        log_error("otl_fbs_getMatchOdds text[%s]", p.stm_text);
        log_error("otl_fbs_getMatchOdds info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    *count = row;

    otlp->release_conn(dbConn);
    return true;
}

/************************************************************************************************/
const char *sqlString_setMatchResult = "update FBS_MATCH_RESULT set MATCH_REAL_TIME_INFO = :f1<char[4096]> \
where GAME_CODE = :f2<int> and FBS_ISSUE_NUMBER = :f3<unsigned> and MATCH_CODE = :f4<unsigned>";

bool otl_fbs_update_match_result(uint8 game,uint32 issue, uint32 match, char * result)
{
    //log_info("otl_fbs_update_match_result issue[%u] match[%u] result[%s] ", issue, match, result);

    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    otl_stream stm_proc_setMatchResult;
    try {
        stm_proc_setMatchResult.open(1, sqlString_setMatchResult, *dbConn);
        stm_proc_setMatchResult << result << (int)game << issue << match;
        stm_proc_setMatchResult.flush();
        stm_proc_setMatchResult.close();
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_update_match_result msg[%s]", p.msg);
        log_error("otl_fbs_update_match_result text[%s]", p.stm_text);
        log_error("otl_fbs_update_match_result info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    return true;
}

/*************************************************************************************/
//ϵͳ����ʱ�����OMSͨ����־���
const char * sqlString_update_omsLog = "update SYS_HOST_COMM_LOG set LOG_STATUS=1 where LOG_STATUS=0";

bool otl_cleanOmsCommLog()
{
    log_debug("otl_cleanOmsCommLog enter");
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    otl_stream stm_update_omsLog;
    try {
        stm_update_omsLog.open(OTL_STREAM_BUF, sqlString_update_omsLog, *dbConn);
        stm_update_omsLog.set_commit(1);
        stm_update_omsLog.rewind();
        dbConn->commit();
        stm_update_omsLog.close();

    }
    catch (otl_exception& p) {
        log_error("otl_cleanOmsCommLog msg[%s]", p.msg);
        log_error("otl_cleanOmsCommLog text[%s]", p.stm_text);
        log_error("otl_cleanOmsCommLog info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }

    otlp->release_conn(dbConn);
    log_debug("otl_cleanOmsCommLog return");
    return true;
}


/************************************************************************************************/
//�ս���ýӿ�(OMS)
const char *sqlString_set_om_daySwitch = \
"begin" \
" p_om_set_day_close(:f1<unsigned,in>,:f2<int,out>,:f3<char[200],out>);" \
"end;";

bool otl_switch_session_oms(uint32 date)
{
    int yyyy = date / 10000;
    int mm = date / 100 % 100;
    int dd = date % 100;

    otl_value<otl_datetime> mytime;
    mytime.v.year = yyyy;
    mytime.v.month = mm;
    mytime.v.day = dd;
    mytime.v.hour = 0;
    mytime.v.minute = 0;
    mytime.v.second = 0;
    mytime.set_non_null();

    int errorCode = 0;
    string errorStr;

    log_info("otl_switch_session_om enter date[%d]", date);

    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    otl_stream stm_set_om_day_switch;
    try {
        stm_set_om_day_switch.open(1, sqlString_set_om_daySwitch, *dbConn);
        stm_set_om_day_switch << date;
        while (!stm_set_om_day_switch.eof())
        {
            stm_set_om_day_switch >> errorCode >> errorStr;
        }
        stm_set_om_day_switch.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_switch_session_om");
        log_error("otl_switch_session_om msg[%s]", p.msg);
        log_error("otl_switch_session_om text[%s]", p.stm_text);
        log_error("otl_switch_session_om info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
        return true;
    else
    {
        //send_otlDealFalseNotify("otl_switch_session_om");
        log_error("otl_switch_session_om errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
    return true;
}

/************************************************************************************************/
const char *sqlString_get_gameName = "select GAME_CODE,BASIC_TYPE,SHORT_NAME,FULL_NAME,ISSUING_ORGANIZATION \
		from  INF_GAMES order by GAME_CODE";

int otl_getGameName(GAME_PARAM gameParam[], otl_connect* dbConn)
{
    int row = 0;
    log_info("otl_getGameName enter ");
    otl_stream stm_get_gameName;
    try {
        stm_get_gameName.open(OTL_STREAM_BUF, sqlString_get_gameName, *dbConn);
        stm_get_gameName.rewind();
        while (!stm_get_gameName.eof())
        {
            stm_get_gameName >> (int &)gameParam[row].gameCode >> (int &)gameParam[row].gameType >> gameParam[row].gameAbbr >> gameParam[row].gameName >> gameParam[row].organizationName;
            row++;
        }
        stm_get_gameName.close();
        log_info("otl_getGameName out! row[%d]", row);
    }
    catch (otl_exception& p) {
        log_error("otl_getGameName msg[%s]", p.msg);
        log_error("otl_getGameName text[%s]", p.stm_text);
        log_error("otl_getGameName info[%s]", p.var_info);
    }
    return row;
}


/************************************************************************************************/
const char *sqlString_get_gamePolicy = "select FUND_RATE,ADJ_RATE,THEORY_RATE,TAX_THRESHOLD,TAX_RATE,DRAW_LIMIT_DAY \
		from  (select * from GP_POLICY order by HIS_POLICY_CODE desc)  where GAME_CODE=:f1<int> and rownum=1";

int otl_getGamePolicy(uint8 gameCode, POLICY_PARAM *gameParam, otl_connect* dbConn)
{
    int row = 0;
    log_info("otl_getGamePolicy enter gameCode[%d]", (int)gameCode);
    otl_stream stm_get_gamePolicy;
    try {
        stm_get_gamePolicy.open(OTL_STREAM_BUF, sqlString_get_gamePolicy, *dbConn);
        stm_get_gamePolicy << (int)gameCode;
        while (!stm_get_gamePolicy.eof())
        {
            stm_get_gamePolicy >> (int &)(gameParam->publicFundRate) >> (int &)gameParam->adjustmentFundRate >> (int &)gameParam->returnRate >> (int &)gameParam->taxStartAmount >> (int &)gameParam->taxRate >> (int &)gameParam->payEndDay;
            //log_info("otl_getGamePolicy enter row[%d] FundRate[%d] adjustmentFundRate[%d] returnRate[%d] taxStartAmount[%d] taxRate[%d] payEndDay[%d]",row,
            //    gameParam->publicFundRate,gameParam->adjustmentFundRate,gameParam->returnRate,gameParam->taxStartAmount,gameParam->taxRate,gameParam->payEndDay);
            row++;
        }
        stm_get_gamePolicy.close();
        log_info("otl_getGamePolicy out! row[%d]", row);
    }
    catch (otl_exception& p) {
        log_error("otl_getGamePolicy msg[%s]", p.msg);
        log_error("otl_getGamePolicy text[%s]", p.stm_text);
        log_error("otl_getGamePolicy info[%s]", p.var_info);
    }
    return row;
}

/************************************************************************************************/
const char *sqlString_get_gameTransctrl = "select * from GP_STATIC a, GP_DYNAMIC b,GP_HISTORY c  \
		where a.game_code=b.game_code and b.game_code=c.game_code and a.game_code=:f1<int> and rownum=1 order by c.his_his_code desc ";

int otl_getGameTransctrl(uint8 gameCode, TRANSCTRL_PARAM *gameParam, otl_connect* dbConn)
{
    int row = 0;
    char server_time_1[32];
    char server_time_2[32];
    log_info("otl_getGameTransctrl enter ");
    otl_stream stm_get_gameTransctrl;
    try {
        stm_get_gameTransctrl.open(OTL_STREAM_BUF, sqlString_get_gameTransctrl, *dbConn);
        otl_stream_read_iterator<otl_stream, otl_exception, otl_lob_stream> rs;
        stm_get_gameTransctrl << (int)gameCode;
        rs.attach(stm_get_gameTransctrl);
        while (rs.next_row())
        {
            rs.get("DRAW_MODE", (int &)(gameParam->drawType));
            rs.get("IS_SALE", (int &)(gameParam->saleFlag));
            rs.get("IS_CANCEL", (int &)(gameParam->cancelFlag));
            rs.get("IS_PAY", (int &)(gameParam->payFlag));
            rs.get("IS_AUTO_DRAW", (int &)(gameParam->autoDraw));
            rs.get("CANCEL_SEC", (int &)gameParam->cancelTime);
            rs.get("ISSUE_CLOSE_ALERT_TIME", (int &)gameParam->countDownTimes);
            rs.get("SINGLELINE_MAX_AMOUNT", (int &)(gameParam->maxTimesPerBetLine));
            rs.get("SINGLETICKET_MAX_LINE", (int &)gameParam->maxBetLinePerTicket);
            rs.get("SINGLETICKET_MAX_ISSUES", (int &)(gameParam->maxIssueCount));

            rs.get("SINGLETICKET_MAX_AMOUNT", (long &)gameParam->maxAmountPerTicket);
            rs.get("LIMIT_PAYMENT", (long &)gameParam->gamePayLimited);

            rs.get("LIMIT_PAYMENT2", (long &)gameParam->branchCenterPayLimited);
            rs.get("LIMIT_CANCEL2", (long &)gameParam->branchCenterCancelLimited);

            rs.get("LIMIT_BIG_PRIZE", (long &)gameParam->bigPrize);
            rs.get("AUDIT_SINGLE_TICKET_SALE", (long &)gameParam->saleLimit);
            rs.get("AUDIT_SINGLE_TICKET_PAY", (long &)gameParam->payLimit);
            rs.get("AUDIT_SINGLE_TICKET_CANCEL", (long &)gameParam->cancelLimit);
            rs.get("SALER_PAY_LIMIT", (long &)gameParam->commonTellerPayLimited);
            rs.get("SALER_CANCEL_LIMIT", (long &)gameParam->commonTellerCancelLimited);
            rs.get("IS_OPEN_RISK", (int &)(gameParam->riskCtrl));
            rs.get("RISK_PARAM", gameParam->riskCtrlParam);

            rs.get("SERVICE_TIME_1", server_time_1);
            rs.get("SERVICE_TIME_2", server_time_2);

            otl_changeTimeStr2Local(server_time_1, &gameParam->service_time_1_b, &gameParam->service_time_1_e);
            otl_changeTimeStr2Local(server_time_2, &gameParam->service_time_2_b, &gameParam->service_time_2_e);
            row++;

            log_info("otl_getGameTransctrl out! row[%d]  drawType[%d] saleFlag[%d] cancelTime[%d] bigPrize[%lld] cancelLimit[%lld] riskOpen[%d] riskCtrlParam[%s]",
                row, gameParam->drawType, gameParam->saleFlag, gameParam->cancelTime, gameParam->bigPrize, gameParam->cancelLimit, (int)(gameParam->riskCtrl), gameParam->riskCtrlParam);
        }
        rs.detach();
        stm_get_gameTransctrl.close();
        log_info("otl_getGameTransctrl out! row[%d]", row);
    }
    catch (otl_exception& p) {
        log_error("otl_getGameTransctrl msg[%s]", p.msg);
        log_error("otl_getGameTransctrl text[%s]", p.stm_text);
        log_error("otl_getGameTransctrl info[%s]", p.var_info);
    }
    return row;
}


// ------------------------------  data load interface ---------------------------
int otl_getGameList(GAME_LIST *game_list)
{
    char notifyMsg[256] = { 0 };

    GAME_PARAM gameParam[MAX_GAME_NUMBER];
    POLICY_PARAM policyParam;
    TRANSCTRL_PARAM transParam;
    bzero((void *)gameParam, sizeof(GAME_PARAM)*MAX_GAME_NUMBER);

    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    int gameCount = otl_getGameName(gameParam, dbConn);

    for (int idx = 0; idx < gameCount; idx++)
    {
        log_info("otl_getGameList gameCode[%d]", gameParam[idx].gameCode);
        GAME_DATA *game_data = NULL;
        game_data = (GAME_DATA *)malloc(sizeof(GAME_DATA));
        if (game_data == NULL)
        {
            log_error("otl_getGameList malloc NULL!");
            return -1;
        }
        bzero(game_data, sizeof(GAME_DATA));
        memcpy((void *)&(game_data->gameEntry), (void *)&(gameParam[idx]), sizeof(GAME_PARAM));

        bzero((void *)&policyParam, sizeof(POLICY_PARAM));
        if (otl_getGamePolicy(gameParam[idx].gameCode, &policyParam, dbConn) < 1)
        {
            log_error("otl_getGameList otl_getGamePolicy no data!");
            sprintf(notifyMsg, "game[%d] otl_getGamePolicy no data", gameParam[idx].gameCode);
            //send_otlDealFalseNotify(notifyMsg);
            return -1;
        }
        memcpy((void *)&(game_data->policyParam), (void *)&policyParam, sizeof(POLICY_PARAM));

        bzero((void *)&transParam, sizeof(TRANSCTRL_PARAM));
        if (otl_getGameTransctrl(gameParam[idx].gameCode, &transParam, dbConn) < 1)
        {
            log_error("otl_getGameList otl_getGameTransctrl no data!");
            sprintf(notifyMsg, "game[%d] otl_getGameTransctrl no data", gameParam[idx].gameCode);
            //send_otlDealFalseNotify(notifyMsg);
            return -1;
        }
        memcpy((void *)&(game_data->transctrlParam), (void *)&transParam, sizeof(TRANSCTRL_PARAM));

        game_list->push_back(game_data);

    }
    otlp->release_conn(dbConn);
    return gameCount;
}


/************************************************************************************************/
const char *sqlString_get_rngList = "select DEVICE_ID,DEVICE_NAME,IP_ADDR,GAME_CODE\
		from INF_DEVICES  where DEVICE_TYPE=1";
int otl_getRngList(RNG_LIST *rng_list)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    int row = 0;
    RNG_PARAM *rng_param = NULL;
    log_info("otl_getRngList enter ");
    otl_stream stm_get_rngList;
    try {
        stm_get_rngList.open(OTL_STREAM_BUF, sqlString_get_rngList, *dbConn);
        while (!stm_get_rngList.eof())
        {
            rng_param = (RNG_PARAM *)malloc(sizeof(RNG_PARAM));
            if (rng_param == NULL)
            {
                log_error("otl_getRngList malloc NULL!);");
                return -1;
            }
            bzero(rng_param, sizeof(RNG_PARAM));
            stm_get_rngList >> (int &)rng_param->rngId >> rng_param->rngName >> rng_param->rngIp >> (int &)rng_param->gameCode;
            rng_param->workStatus = 0;
            rng_param->status = ENABLED;
            rng_param->used = true;
            log_info("otl_getRngList out! row[%d]  rngId[%d]  rngName[%s] rngIp[%s]  gameCode[%d]",
                row, rng_param->rngId, rng_param->rngName, rng_param->rngIp, rng_param->gameCode);

            rng_list->push_back(rng_param);
            row++;
        }
        stm_get_rngList.close();
        log_info("otl_getRngList out! row[%d]", row);
    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_getRngList");
        log_error("otl_getRngList msg[%s]", p.msg);
        log_error("otl_getRngList text[%s]", p.stm_text);
        log_error("otl_getRngList info[%s]", p.var_info);
    }

    otlp->release_conn(dbConn);
    return row;
}

/************************************************************************************************/
#define SQL_BATCH_NUM  5000

otl_nocommit_stream stm_update_rngStatus;
otl_nocommit_stream stm_update_ticketTsn;
otl_nocommit_stream stm_insert_sysevent;

const char * sqlString_update_rngStatus = "update INF_DEVICES set DEVICE_STATUS=:t1<unsigned> where DEVICE_ID=:t2<unsigned>";
const char * sqlString_update_ticketTsn = "update HIS_SELLTICKET set SALE_TSN =:t1<char[25]> where APPLYFLOW_SELL =:t2<char[25]>";
const char * sqlString_insert_systemEvent = "insert into SYS_EVENTS(EVENT_ID,SERVER_ADDR,EVENT_TYPE,EVENT_LEVEL,EVENT_CONTENT,EVENT_TIME) \
values( f_get_eventid_seq(), :f2<char[50]>, :f3<int>, :f4<int>, :f5<char[256]>, :f6<timestamp>)";

bool otl_insertNotifyEvent(const char *host_ip, int type, uint8 level, char * msg, uint32 when)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    stm_insert_sysevent.set_flush(false);
    stm_insert_sysevent.open(SQL_BATCH_NUM, sqlString_insert_systemEvent, *dbConn);
    stm_insert_sysevent.set_commit(0);

    time_t time_tmp = (time_t)when;
    struct tm  *tm_ptr = localtime(&time_tmp);

    otl_value<otl_datetime> eventTime;
    eventTime.v.year = tm_ptr->tm_year + 1900;
    eventTime.v.month = tm_ptr->tm_mon + 1;
    eventTime.v.day = tm_ptr->tm_mday;
    eventTime.v.hour = tm_ptr->tm_hour;
    eventTime.v.minute = tm_ptr->tm_min;
    eventTime.v.second = tm_ptr->tm_sec;
    eventTime.set_non_null();

    try {
        stm_insert_sysevent << host_ip << type << (int)level << msg << eventTime;
        stm_insert_sysevent.flush();
        stm_insert_sysevent.close();
        dbConn->commit();
    }
    catch (otl_exception& p) {

        log_error("otl_insertNotifyEvent msg[%s]", p.msg);
        log_error("otl_insertNotifyEvent text[%s]", p.stm_text);
        log_error("otl_insertNotifyEvent info[%s]", p.var_info);
        log_error("otl_insertNotifyEvent code[%d]", p.code);
        otlp->release_conn(dbConn);
        return false;
    }

    otlp->release_conn(dbConn);
    return true;
}

bool otl_setRngStatus(DB_RNG data[], int count)
{
    try {
        for (int i = 0; i < count; i++)
        {
            if (data[i].used)
            {
                stm_update_rngStatus << (uint32)(data[i].workStatus) << data[i].rngId;
            }
        }

    }
    catch (otl_exception& p) {
        log_error("otl_setRngStatus  msg[%s]", p.msg);
        log_error("otl_setRngStatus  text[%s]", p.stm_text);
        log_error("otl_setRngStatus  info[%s]", p.var_info);
        return false;
    }
    return true;
}

bool otl_setTicketTSN(DB_TSN data[], int count)
{
    try {
        for (int i = 0; i < count; i++)
        {
            if (data[i].used)
            {
                stm_update_ticketTsn << data[i].tsn << data[i].reqfn_ticket;
            }
        }
    }
    catch (otl_exception& p) {
        log_error("otl_setTicketTSN  msg[%s]", p.msg);
        log_error("otl_setTicketTSN  text[%s]", p.stm_text);
        log_error("otl_setTicketTSN  info[%s]", p.var_info);
        return false;
    }
    return true;
}

bool otl_data_commit_omDB(DB_STAT *data)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    try {
        stm_update_rngStatus.set_flush(false);
        stm_update_rngStatus.open(SQL_BATCH_NUM, sqlString_update_rngStatus, *dbConn);
        stm_update_rngStatus.set_commit(0);

        stm_update_ticketTsn.set_flush(false);
        stm_update_ticketTsn.open(SQL_BATCH_NUM, sqlString_update_ticketTsn, *dbConn);
        stm_update_ticketTsn.set_commit(0);
    }
    catch (otl_exception& p) {
        log_error("otl_data_commit_omDB detail msg[%s]", p.msg);
        log_error("otl_data_commit_omDB detail text[%s]", p.stm_text);
        log_error("otl_data_commit_omDB detail info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    if (data->rngCnt > 0)
    {
        if (!otl_setRngStatus(data->db_rng, MAX_RNG_NUMBER))
        {
            otlp->release_conn(dbConn);
            return false;
        }
    }
    if (data->tsnCnt > 0)
    {
        if (!otl_setTicketTSN(data->db_tsn, data->tsnCnt))
        {
            otlp->release_conn(dbConn);
            return false;
        }
    }

    try {
        stm_update_rngStatus.flush();
        stm_update_ticketTsn.flush();
        dbConn->commit();
        stm_update_ticketTsn.close();
        stm_update_rngStatus.close();
    }
    catch (otl_exception& p) {
        log_error("otl_data_commit_omDB detail msg[%s]", p.msg);
        log_error("otl_data_commit_omDB detail text[%s]", p.stm_text);
        log_error("otl_data_commit_omDB detail info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    return true;
}


/************************************************************************************************/
bool write_xml_file(char* filepath, otl_long_string myxml)
{
    ofstream out(filepath);
    if (!out)
    {
        log_error("open[%s] error!", filepath);
        return false;
    }
    out << myxml.v;
    out.close();
    return true;
}

bool write_binstr_file(char* filepath, string myxml)
{
    ofstream out(filepath);
    if (!out)
    {
        log_error("open[%s] error!", filepath);
        return false;
    }
    out << myxml;
    out.close();
    return true;
}

//bool read_xml_file(char* filepath,otl_long_string &myxml)
bool read_xml_file(char* filepath, string &myxml)
{
    ifstream in(filepath);
    if (!in)
    {
        log_error("open[%s] error!", filepath);
        return false;
    }
    string tmpstr((istreambuf_iterator <char>(in)), istreambuf_iterator <char>());
    in.close();
    myxml = tmpstr;
    return true;
}

/************************************************************************************************/
const char *sqlString_setErrorInfo = \
"begin" \
" P_SET_ISSUE_ERROR_INFO(:f1<int,in>,:f2<ubigint,in>,:f5<int,out>,:f6<char[200],out>);" \
"end;";

bool otl_set_issue_process_error(uint8 game_code, uint64 issue_num)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    int errorCode = 0;
    string errorStr;
    otl_stream stm_proc_setErrorInfo;
    try {
        stm_proc_setErrorInfo.open(1, sqlString_setErrorInfo, *dbConn);
        stm_proc_setErrorInfo << (int)game_code << issue_num;

        while (!stm_proc_setErrorInfo.eof())
        {
            stm_proc_setErrorInfo >> errorCode >> errorStr;
        }
        stm_proc_setErrorInfo.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_set_issue_process_error");
        log_error("otl_set_issue_process_error msg[%s]", p.msg);
        log_error("otl_set_issue_process_error text[%s]", p.stm_text);
        log_error("otl_set_issue_process_error info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode != 0)
    {
        //send_otlDealFalseNotify("otl_set_issue_process_error");
        log_error("otl_set_issue_process_error errorCode[%d].", errorCode);
        log_error("otl_set_issue_process_error errorStr[%s].", errorStr.c_str());
        return false;
    }
    return true;
}

/************************************************************************************************/
const char *sqlString_setTicketStat = \
"begin" \
" P_SET_ISSUE_TICKET_STAT(:f1<int,in>,:f2<ubigint,in>,\
		:f3<bigint,in>,:f4<unsigned,in>,:f5<unsigned,in>,:f6<bigint,in>,:f7<unsigned,in>,:f8<unsigned,in>,:f9<int,out>,:f10<char[200],out>);" \
"end;";

bool otl_set_issue_ticket_stat(uint8 game_code, uint64 issue_num, TICKET_STAT *ts)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    int errorCode = 0;
    string errorStr;
    otl_stream stm_proc_setTicketStat;

    try {
        stm_proc_setTicketStat.open(1, sqlString_setTicketStat, *dbConn);
        stm_proc_setTicketStat << (int)game_code << issue_num << ts->s_amount << ts->s_ticketCnt\
            << ts->s_betCnt << ts->c_amount << ts->c_ticketCnt << ts->c_betCnt;
        while (!stm_proc_setTicketStat.eof())
        {
            stm_proc_setTicketStat >> errorCode >> errorStr;
        }
        stm_proc_setTicketStat.close();
    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_set_issue_ticket_stat");
        log_error("otl_set_issue_ticket_stat msg[%s]", p.msg);
        log_error("otl_set_issue_ticket_stat text[%s]", p.stm_text);
        log_error("otl_set_issue_ticket_stat info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
        return true;
    else
    {
        //send_otlDealFalseNotify("otl_set_issue_ticket_stat");
        log_error("otl_set_issue_ticket_stat errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
}

/************************************************************************************************/
const char *sqlString_getIssuePoll = \
"begin" \
" P_SET_ISSUE_POOL_GET(:f1<int,in>,:f2<int,out>,:f3<char[200],out>,:f4<char[200],out>,:f5<bigint,out>);" \
"end;";

bool otl_get_issue_pool(uint8 game_code, POOL_AMOUNT *pool)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    int errorCode = 0;
    string errorStr, pool_name;

    otl_stream stm_proc_getIssuePoll;
    try {
        stm_proc_getIssuePoll.open(1, sqlString_getIssuePoll, *dbConn);
        stm_proc_getIssuePoll << (int)game_code;

        while (!stm_proc_getIssuePoll.eof())
        {
            stm_proc_getIssuePoll >> errorCode >> errorStr >> pool->poolName >> pool->poolAmount;
        }
        stm_proc_getIssuePoll.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_get_issue_pool");
        log_error("otl_get_issue_pool msg[%s]", p.msg);
        log_error("otl_get_issue_pool text[%s]", p.stm_text);
        log_error("otl_get_issue_pool info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode != 0)
    {
        //send_otlDealFalseNotify("otl_get_issue_pool");
        log_error("otl_get_issue_pool errorCode[%d].", errorCode);
        log_error("otl_get_issue_pool errorStr[%s].", errorStr.c_str());
        return false;
    }
    memcpy(pool->poolName, pool_name.c_str(), ENTRY_NAME_LEN);
    return true;
}

/************************************************************************************************/
/*
const char * sqlString_up_win_local = "\
update ISS_GAME_ISSUE_XML set \
winner_local_info=empty_clob() \
where game_code=:f1<int> and issue_number=:f2<ubigint> \
returning winner_local_info into :f3<clob>";
*/
const char * sqlString_up_win_local = "update ISS_GAME_ISSUE_XML \
set winner_local_info = to_clob(:f1<char[6000]>) where game_code=:f2<int> and issue_number=:f3<ubigint>";
/*
const char * sqlString_up_win_confirm = "\
update ISS_GAME_ISSUE_XML set \
winner_confirm_info=empty_clob() \
where game_code=:f1<int> and issue_number=:f2<ubigint> \
returning winner_confirm_info into :f3<clob>";
*/
const char * sqlString_up_win_confirm = "update ISS_GAME_ISSUE_XML \
set winner_confirm_info = to_clob(:f1<char[6000]>) where game_code=:f2<int> and issue_number=:f3<ubigint>";

bool otl_set_issue_calc_results(uint8 game_code, uint64 issue_num, int flag, char *filename)
{
    string myxml;
    log_debug("otl_set_issue_calc_results read_xml_file[%s]", filename);
    if (!read_xml_file(filename, myxml))
    {
        log_error("otl_set_issue_calc_results read_xml_file error!");
        return false;
    }
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    otl_stream stm_up_win_local;
    otl_stream stm_up_win_confirm;

    try {
        if (flag == WINNER_LOCAL_FILE)
        {
            stm_up_win_local.open(1, sqlString_up_win_local, *dbConn);
            stm_up_win_local << myxml.c_str() << (int)game_code << issue_num;
            stm_up_win_local.close();
        }
        else
        {
            stm_up_win_confirm.open(1, sqlString_up_win_confirm, *dbConn);
            stm_up_win_confirm << myxml.c_str() << (int)game_code << issue_num;
            stm_up_win_confirm.close();
        }
    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_set_issue_calc_results");
        log_error("otl_set_issue_calc_results msg[%s]", p.msg);
        log_error("otl_set_issue_calc_results text[%s]", p.stm_text);
        log_error("otl_set_issue_calc_results info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    return true;
}


/************************************************************************************************/
const char *sqlString_setIssuePoll = \
"begin" \
" P_SET_ISSUE_POOL_MODIFY(:f1<int,in>,:f2<ubigint,in>,:f3<bigint,in>,:f4<bigint,in>,:f5<int,out>,:f6<char[200],out>);" \
"end;";

bool otl_set_issue_pool(uint8 game_code, uint64 issue_num, GL_PRIZE_CALC *przCalc)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    int errorCode = 0;
    string errorStr;
    otl_stream stm_proc_setIssuePoll;

    try {
        stm_proc_setIssuePoll.open(1, sqlString_setIssuePoll, *dbConn);
        stm_proc_setIssuePoll << (int)game_code << issue_num << przCalc->poolUsed.poolAmount << przCalc->highPrize2Adjust;

        while (!stm_proc_setIssuePoll.eof())
        {
            stm_proc_setIssuePoll >> errorCode >> errorStr;
        }
        stm_proc_setIssuePoll.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_set_issue_pool");
        log_error("otl_set_issue_pool msg[%s]", p.msg);
        log_error("otl_set_issue_pool text[%s]", p.stm_text);
        log_error("otl_set_issue_pool info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode != 0)
    {
        //send_otlDealFalseNotify("otl_set_issue_pool");
        log_error("otl_set_issue_pool errorCode[%d].", errorCode);
        log_error("otl_set_issue_pool errorStr[%s].", errorStr.c_str());
        return false;
    }
    return true;
}

/************************************************************************************************/
const char *sqlString_setWinningStat = \
"begin" \
" P_SET_ISSUE_WINNING_STAT(:f1<int,in>,:f2<ubigint,in>,:f3<bigint,in>,:f4<bigint,in>,:f5<bigint,in>,:f6<bigint,in>,:f7<bigint,in>,:f8<int,out>,:f9<char[200],out>);" \
"end;";

bool otl_set_issue_winning_stat(uint8 game_code, uint64 issue_num, WIN_TICKET_STAT *t)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    int errorCode = 0;
    string errorStr;

    money_t p_total_winning_amount = t->winAmount;		// IN		NUMBER,	--�ܹ��н����
    money_t p_total_winning_bet_count = t->winBet;	    // IN		NUMBER,	--�ܹ��н�ע��

    money_t p_high_winning_count = t->bigPrizeCnt;		// IN		NUMBER,	--�ߵȽ��н�����
    money_t p_high_winning_amount = t->bigPrizeAmount;	// IN		NUMBER,	--�ߵȽ��н����
    money_t ticketCount = t->winCnt;

    otl_stream stm_proc_setWinningStat;
    try {
        stm_proc_setWinningStat.open(1, sqlString_setWinningStat, *dbConn);
        stm_proc_setWinningStat << (int)game_code << issue_num << ticketCount \
            << p_total_winning_amount << p_total_winning_bet_count \
            << p_high_winning_count << p_high_winning_amount;
        while (!stm_proc_setWinningStat.eof())
        {
            stm_proc_setWinningStat >> errorCode >> errorStr;
        }
        stm_proc_setWinningStat.close();
    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_set_issue_winning_stat");
        log_error("otl_set_issue_winning_stat msg[%s]", p.msg);
        log_error("otl_set_issue_winning_stat text[%s]", p.stm_text);
        log_error("otl_set_issue_winning_stat info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
        return true;
    else
    {
        //send_otlDealFalseNotify("otl_set_issue_winning_stat");
        log_error("otl_set_issue_winning_stat errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
}

/************************************************************************************************/
const char *sqlString_getDrawNotice = \
"begin" \
" P_SET_ISSUE_DRAW_NOTICE(:f1<int,in>,:f2<ubigint,in>,:f4<int,out>,:f5<char[200],out>);" \
"end;";

bool otl_set_drawNotice_xml(uint8 game_code, uint64 issue_num)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    int errorCode = 0;
    string errorStr;
    otl_stream stm_proc_getDrawNotice;
    try {
        stm_proc_getDrawNotice.open(1, sqlString_getDrawNotice, *dbConn);
        stm_proc_getDrawNotice << (int)game_code << issue_num;
        stm_proc_getDrawNotice >> errorCode >> errorStr;

        stm_proc_getDrawNotice.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_set_drawNotice_xml");
        log_error("otl_set_drawNotice_xml msg[%s]", p.msg);
        log_error("otl_set_drawNotice_xml text[%s]", p.stm_text);
        log_error("otl_set_drawNotice_xml info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
    {
        return true;
    }
    else
    {
        //send_otlDealFalseNotify("otl_set_drawNotice_xml");
        log_error("otl_set_drawNotice_xml errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
}

/************************************************************************************************/
const char *sqlString_getWinXml = "select winning_brodcast from ISS_GAME_ISSUE_XML where GAME_CODE=:f1<int> and issue_number=:f2<ubigint>";

bool otl_get_drawNotice_xml(uint8 gameCode, uint64 issueNumber, char *filepath)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    otl_long_string myxml(MAX_XML_STRING_LENGTH);
    otl_lob_stream lob;
    otl_stream stm_get_win_xml;
    try {
        stm_get_win_xml.open(OTL_STREAM_BUF, sqlString_getWinXml, *dbConn);
        stm_get_win_xml << (int)gameCode << issueNumber;
        while (!stm_get_win_xml.eof()) {
            stm_get_win_xml >> lob;
            int n = 0;
            while (!lob.eof())
            {
                ++n;
                lob >> myxml;
            }
            lob.close();

        }
        stm_get_win_xml.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_get_drawNotice_xml");
        log_error("otl_get_drawNotice_xml msg[%s]", p.msg);
        log_error("otl_get_drawNotice_xml stm text[%s]", p.stm_text);
        log_error("otl_get_drawNotice_xml info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);

    if (myxml.len() > 0)
    {
        return write_xml_file(filepath, myxml);
    }
    else
    {
        //send_otlDealFalseNotify("otl_get_drawNotice_xml");
        log_error("otl_get_drawNotice_xml myxml.len <= 0 ");
        return false;
    }

    return true;
}

/************************************************************************************************/
const char * sqlString_setIssueMatchStr = "update ISS_GAME_ISSUE_XML set WINNING_PROCESS =:t1<char[100]> where GAME_CODE = :gamecode<int> and ISSUE_NUMBER = :issue<ubigint>";

bool  otl_set_issueMatchStr(uint8 game_code, uint64 issue_num, char *matchStr)
{
    log_info("otl_set_issueMatchStr gamecode[%d] issue_num[%lld] matchStr[%s] ", game_code, issue_num, matchStr);
    char tmpStr[100] = { 0 };
    memcpy(tmpStr, matchStr, strlen(matchStr));

    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    try {
        otl_stream stm_proc_setIssueMatchStr;
        stm_proc_setIssueMatchStr.open(1, sqlString_setIssueMatchStr, *dbConn);
        stm_proc_setIssueMatchStr << tmpStr << (int)game_code << issue_num;
        stm_proc_setIssueMatchStr.close();
    }
    catch (otl_exception& p) {
        log_error("otl_set_issueMatchStr msg[%s]", p.msg);
        log_error("otl_set_issueMatchStr text[%s]", p.stm_text);
        log_error("otl_set_issueMatchStr info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    return true;
}

/************************************************************************************************/
const char *sqlString_setIssueEndWinFile = \
"begin" \
" p_mis_trans_win_data(:f1<int,in>,:f2<ubigint,in>,:f3<char[200],in>,:f4<int,out>,:f5<char[200],out>);" \
"end;";

bool otl_send_issue_winfile(uint8 game_code, uint64 issue_number, char * winFile)
{
    int errorCode = 0;
    string errorStr;
    char data_file[200] = { 0 };
    memcpy(data_file, winFile, strlen(winFile));
    log_info("otl_send_issue_winfile gamecode[%d] issue_num[%lld] winFile[%s] ", game_code, issue_number, winFile);

    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    try {
        otl_stream stm_proc_setIssueEndWinFile;
        stm_proc_setIssueEndWinFile.open(1, sqlString_setIssueEndWinFile, *dbConn);
        stm_proc_setIssueEndWinFile << (int)game_code << issue_number << data_file;
        stm_proc_setIssueEndWinFile >> errorCode >> errorStr;
        stm_proc_setIssueEndWinFile.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_send_issue_winfile");
        log_error("otl_send_issue_winfile msg[%s]", p.msg);
        log_error("otl_send_issue_winfile text[%s]", p.stm_text);
        log_error("otl_send_issue_winfile info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
    {
        return true;
    }
    else
    {
        //send_otlDealFalseNotify("otl_send_issue_winfile");
        log_error("otl_send_issue_winfile errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
}

/************************************************************************************************/
const char *sqlString_setIssueRkStat = \
"begin" \
" p_set_issue_risk_stat(:f1<int,in>,:f2<ubigint,in>,:f3<bigint,in>,:f4<unsigned,in>,:f5<int,out>,:f6<char[200],out>);" \
"end;";

bool otl_set_issue_rk_stat(uint8 game_code, uint64 issue_num, money_t ticketAmount, uint32 ticketCount)
{
    int errorCode = 0;
    string errorStr;
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    otl_stream stm_proc_setIssueRkStat;

    try {
        stm_proc_setIssueRkStat.open(1, sqlString_setIssueRkStat, *dbConn);
        stm_proc_setIssueRkStat << (int)game_code << issue_num << ticketAmount << ticketCount;
        while (!stm_proc_setIssueRkStat.eof())
        {
            stm_proc_setIssueRkStat >> errorCode >> errorStr;
        }
        stm_proc_setIssueRkStat.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_set_issue_rk_stat");
        log_error("otl_set_issue_rk_stat msg[%s]", p.msg);
        log_error("otl_set_issue_rk_stat text[%s]", p.stm_text);
        log_error("otl_set_issue_rk_stat info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
        return true;
    else
    {
        //send_otlDealFalseNotify("otl_set_issue_rk_stat");
        log_error("otl_set_issue_rk_stat errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
}

/************************************************************************************************/
const char *sqlString_setTdsDrawNotice = \
"begin" \
" p_set_tds_issue_draw_notice(:f1<int,in>,:f2<ubigint,in>,:f4<int,out>,:f5<char[200],out>);" \
"end;";

bool otl_set_drawNotice_tds(uint8 game_code, uint64 issue_num)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    int errorCode = 0;
    string errorStr;
    otl_stream stm_proc_setTdsDrawNotice;
    try {
        stm_proc_setTdsDrawNotice.open(1, sqlString_setTdsDrawNotice, *dbConn);
        stm_proc_setTdsDrawNotice << (int)game_code << issue_num;
        stm_proc_setTdsDrawNotice >> errorCode >> errorStr;

        stm_proc_setTdsDrawNotice.close();

    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_set_drawNotice_xml");
        log_error("otl_set_drawNotice_tds msg[%s]", p.msg);
        log_error("otl_set_drawNotice_tds text[%s]", p.stm_text);
        log_error("otl_set_drawNotice_tds info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
    {
        return true;
    }
    else
    {
        //send_otlDealFalseNotify("otl_set_drawNotice_xml");
        log_error("otl_set_drawNotice_tds errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
}

/************************************************************************************************/
const char *sqlString_fbs_get_issue = "select FBS_ISSUE_NUMBER,FBS_ISSUE_DATE,PUBLISH_TIME from FBS_ISSUE where PUBLISH_STATUS=1 and FBS_ISSUE_NUMBER \
in (select FBS_ISSUE_NUMBER from FBS_MATCH where GAME_CODE = :f1<int> and STATUS < 3) order by FBS_ISSUE_NUMBER";

bool otl_fbs_getIssueWhenStart(uint8 gameCode, int *count, DB_FBS_ISSUE *issue)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    log_info("otl_fbs_getIssue enter.");

    otl_datetime releaseTime;
    int row = 0;

    otl_stream stm_get_issue;
    try {
        stm_get_issue.open(OTL_STREAM_BUF, sqlString_fbs_get_issue, *dbConn);
        stm_get_issue << (int)gameCode;
        while (!stm_get_issue.eof())
        {
            stm_get_issue >> issue->issue_number >> issue->issue_date >> releaseTime;
            issue->publish_time = getTimeByOtlTime(&releaseTime);
            row++;
            issue++;
        }
        stm_get_issue.close();
        log_info("otl_fbs_getIssue out! row[%d]", row);
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_getIssue msg[%s]", p.msg);
        log_error("otl_fbs_getIssue text[%s]", p.stm_text);
        log_error("otl_fbs_getIssue info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    *count = row;
    otlp->release_conn(dbConn);
    return true;
}


/************************************************************************************************/
const char *sqlString_fbs_set_matchStatus = "update FBS_MATCH set STATUS=:f1<int> where  GAME_CODE = :f2<int> and MATCH_CODE=:f3<unsigned>";

bool otl_fbs_set_match_state(uint8 gameCode, uint32 match_code, uint8 state)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    log_info("otl_fbs_set_match_state match[%u] state[%d]", match_code, state);

    otl_stream stm_set_match;
    try {
        stm_set_match.open(OTL_STREAM_BUF, sqlString_fbs_set_matchStatus, *dbConn);
        stm_set_match << (int)state << (int)gameCode << match_code;
        stm_set_match.close();
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_set_match_state msg[%s]", p.msg);
        log_error("otl_fbs_set_match_state text[%s]", p.stm_text);
        log_error("otl_fbs_set_match_state info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    return true;
}

/************************************************************************************************/
const char *sqlString_setMatchDrawResults = "update FBS_MATCH_WIN_RESULT set BET_AMOUNT = :f1<bigint>, \
SINGLE_BET_AMOUNT = :f2<bigint>,MULTIPLE_BET_AMOUNT = :f3<bigint>,MATCH_RESULT_ENUM = :f4<int>, \
RESULT_AMOUNT = :f5<bigint>,SINGLE_RESULT_AMOUNT = :f6<bigint>,MULTIPLE_RESULT_AMOUNT = :f7<bigint>,REF_SP_VALUE = :f8<double>, \
WIN_AMOUNT = :f9<bigint>,SINGLE_WIN_AMOUNT = :f10<bigint>,MULTIPLE_WIN_AMOUNT = :f11<bigint> \
where GAME_CODE = :f12<int> and MATCH_CODE = :f13<unsigned> and MATCH_SUBTYPE_CODE = :f14<int>";

bool otl_fbs_set_match_draw_result(uint8 gameCode, uint32 match_code, SUB_RESULT s_results[])
{
    log_info("otl_fbs_set_match_draw_result match[%u]  ", match_code);

    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    try {
        otl_nocommit_stream stm_proc_setMatchDrawResult;
        stm_proc_setMatchDrawResult.open(1, sqlString_setMatchDrawResults, *dbConn);
        stm_proc_setMatchDrawResult.set_commit(0);
        for (int i = 0; i < FBS_SUBTYPE_NUM; i++)
        {
            if (s_results[i].code > 0)
                stm_proc_setMatchDrawResult << s_results[i].amount << s_results[i].single_amount
                << s_results[i].multiple_amount << (int)(s_results[i].result) << s_results[i].result_amount
                << s_results[i].single_result_amount << s_results[i].multiple_result_amount
                << (double)(s_results[i].final_sp) / 1000.0 << s_results[i].win_amount
                << s_results[i].single_win_amount << s_results[i].multiple_win_amount
                << (int)gameCode << match_code << (int)(s_results[i].code);
        }
        stm_proc_setMatchDrawResult.flush();
        dbConn->commit();
        stm_proc_setMatchDrawResult.close();
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_set_match_draw_result msg[%s]", p.msg);
        log_error("otl_fbs_set_match_draw_result text[%s]", p.stm_text);
        log_error("otl_fbs_set_match_draw_result info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    return true;
}

bool otl_fbs_set_match_process_error(uint8 game_code, uint32 issue_num, uint32 match_code)
{
    return true;
}


/************************************************************************************************/
const char *sqlString_get_fbs_oneMatchByCode = "select fbs_issue_number,match_code,match_seq,\
home_team_code,guest_team_code,reward_time,status from FBS_MATCH  where game_code=:f1<int> and match_code=:f2<unsigned>";

bool otl_fbs_get_match_info(uint8 game_code, uint32 match_code, GIDB_FBS_MATCH_INFO *match)
{
    log_info("otl_fbs_get_match_info enter gameCode[%d] match_code[%d]", game_code, match_code);

    otl_datetime drawTime;
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("otl_fbs_get_match_info get_connect failure!");
        return false;
    }
    try {
        otl_stream stm_get_IssuePrizeInfo;
        stm_get_IssuePrizeInfo.open(OTL_STREAM_BUF, sqlString_get_fbs_oneMatchByCode, *dbConn);
        stm_get_IssuePrizeInfo << (int)game_code << match_code;
        while (!stm_get_IssuePrizeInfo.eof())
        {
            stm_get_IssuePrizeInfo >> (int &)(match->issue_number) 
                >> (int &)(match->match_code)
                >> (int &)(match->seq)
                >> (int &)(match->home_code)
                >> (int &)(match->away_code)
                >> drawTime
                >> (int &)(match->state);

            match->draw_time = getTimeByOtlTime(&drawTime);
        }
        stm_get_IssuePrizeInfo.close();
        log_info("otl_fbs_get_match_info ok! ");
    }
    catch (otl_exception& p) {
        log_error("otl_fbs_get_match_info msg[%s]", p.msg);
        log_error("otl_fbs_get_match_info text[%s]", p.stm_text);
        log_error("otl_fbs_get_match_info info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    return true;
}


/************************************************************************************************/
const char *sqlString_del_Issue = \
"begin" \
" p_om_issue_delete(:f1<int,in>,:f2<ubigint,in>,:f3<int,out>,:f4<char[200],out>);" \
"end;";

bool otl_delIssue(int gameCode, uint64 issueNumber)
{
    log_info("otl_delIssue enter gameCode[%d] issueSeq[%lld]", gameCode, issueNumber);
    int errorCode = 0;
    string errorStr;
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    try {

        otl_stream stm_del_Issue;
        stm_del_Issue.open(1, sqlString_del_Issue, *dbConn);
        stm_del_Issue << gameCode << issueNumber;
        stm_del_Issue >> errorCode >> errorStr;
        stm_del_Issue.close();
        log_info("otl_delIssue ok! ");
    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_delIssue");
        log_error("otl_delIssue msg[%s]", p.msg);
        log_error("otl_delIssue text[%s]", p.stm_text);
        log_error("otl_delIssue info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
    {
        return true;
    }
    else
    {
        //send_otlDealFalseNotify("otl_delIssue");
        log_error("otl_delIssue errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
}

/************************************************************************************************/
const char *sqlString_get_gameNewIssue = "\
		select * from (select ISSUE_NUMBER,ISSUE_SEQ,PLAN_START_TIME,PLAN_CLOSE_TIME, PLAN_REWARD_TIME, PAY_END_DAY,CALC_WINNING_CODE \
		from  ISS_GAME_ISSUE where GAME_CODE=:f1<int> and ISSUE_SEQ>:f2<unsigned> and ISSUE_STATUS=0 and IS_PUBLISH=1 order by ISSUE_SEQ) \
        where rownum<=:f3<int> ";

int otl_getGameNewIssueList(uint8 game_code, ISSUE_NEWCFG_LIST *issue_list, int issueCount, uint32 seq)
{
    log_info("otl_getGameNewIssueList enter game_code[%d] issueCount[%d] loadOldIssue seq[%d]", game_code, issueCount, seq);

    int row = 0;
    otl_datetime issueStartTime;
    otl_datetime issueCloseTime;
    otl_datetime issueDrawTime;
    ISSUE_CFG_DATA *tmpIssueData = NULL;
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    try {

        otl_stream stm_get_gameNewIssue;
        stm_get_gameNewIssue.open(OTL_STREAM_BUF, sqlString_get_gameNewIssue, *dbConn);
        stm_get_gameNewIssue << (int)game_code << seq << issueCount;

        while (!stm_get_gameNewIssue.eof())
        {
            tmpIssueData = (ISSUE_CFG_DATA *)malloc(sizeof(ISSUE_CFG_DATA));
            if (tmpIssueData == NULL)
            {
                log_error("otl_getGameIssueList malloc return NULL!");
                otlp->release_conn(dbConn);
                return -1;
            }
            memset(tmpIssueData, 0, sizeof(ISSUE_CFG_DATA));

            stm_get_gameNewIssue >> tmpIssueData->issueNumber
                >> tmpIssueData->serialNumber
                >> issueStartTime
                >> issueCloseTime
                >> issueDrawTime
                >> tmpIssueData->payEndDay
                >> tmpIssueData->winConfigStr;


            tmpIssueData->startTime = getTimeByOtlTime(&issueStartTime);
            tmpIssueData->closeTime = getTimeByOtlTime(&issueCloseTime);
            tmpIssueData->drawTime = getTimeByOtlTime(&issueDrawTime);

            tmpIssueData->gameCode = game_code;

            issue_list->push_back(tmpIssueData);
            row++;
        }
        stm_get_gameNewIssue.close();
        log_info("otl_getGameNewIssueList out! game_code[%d] row[%d]", game_code, row);
    }
    catch (otl_exception& p) {

        log_error("otl_getGameNewIssueList msg[%s]", p.msg);
        log_error("otl_getGameNewIssueList text[%s]", p.stm_text);
        log_error("otl_getGameNewIssueList info[%s]", p.var_info);
    }

    otlp->release_conn(dbConn);
    return row;
}

/************************************************************************************************/
const char *sqlString_get_gameOldIssue = "\
       select * from (select * from ISS_GAME_ISSUE order by ISSUE_SEQ) where GAME_CODE=:f1<int> and  ISSUE_STATUS<4 and IS_PUBLISH=1 and  rownum<=:f2<int>";

int otl_getGameOldIssueList(uint8 game_code, ISSUE_OLDCFG_LIST *issue_list, int issueCount)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    int row = 0;
    otl_datetime issueStartTime;
    otl_datetime issueCloseTime;
    otl_datetime issueDrawTime;

    log_info("otl_getGameOldIssueList enter game_code[%d] issueCount[%d] ", game_code, issueCount);

    ISSUE_INFO *tmpIssueData = NULL;
    otl_stream stm_get_gameOldIssue;
    try {
        stm_get_gameOldIssue.open(OTL_STREAM_BUF, sqlString_get_gameOldIssue, *dbConn);
        otl_stream_read_iterator<otl_stream, otl_exception, otl_lob_stream> rs;
        stm_get_gameOldIssue << (int)game_code << issueCount;
        rs.attach(stm_get_gameOldIssue);
        while (rs.next_row())
        {
            tmpIssueData = (ISSUE_INFO *)malloc(sizeof(ISSUE_INFO));
            if (tmpIssueData == NULL)
            {
                log_error("otl_getGameOldIssueList malloc return NULL!");
                return -1;
            }
            memset(tmpIssueData, 0, sizeof(ISSUE_INFO));

            rs.get("ISSUE_NUMBER", tmpIssueData->issueNumber);
            rs.get("ISSUE_SEQ", tmpIssueData->serialNumber);
            rs.get("ISSUE_STATUS", (int &)(tmpIssueData->curState));
            rs.get("PLAN_START_TIME", issueStartTime);
            rs.get("PLAN_CLOSE_TIME", issueCloseTime);
            rs.get("PLAN_REWARD_TIME", issueDrawTime);
            rs.get("PAY_END_DAY", tmpIssueData->payEndDay);
            rs.get("FINAL_DRAW_NUMBER", tmpIssueData->drawCodeStr);
            rs.get("CALC_WINNING_CODE", tmpIssueData->winConfigStr);

            rs.get("ISSUE_SALE_AMOUNT", tmpIssueData->stat.issueSaleAmount);
            rs.get("ISSUE_SALE_TICKETS", tmpIssueData->stat.issueSaleCount);
            rs.get("ISSUE_SALE_BETS", tmpIssueData->stat.issueSaleBetCount);
            rs.get("ISSUE_CANCEL_AMOUNT", tmpIssueData->stat.issueCancelAmount);
            rs.get("ISSUE_CANCEL_TICKETS", tmpIssueData->stat.issueCancelCount);
            rs.get("ISSUE_CANCEL_BETS", tmpIssueData->stat.issueCancelBetCount);
            rs.get("ISSUE_RICK_AMOUNT", tmpIssueData->stat.issueRefuseAmount);
            rs.get("ISSUE_RICK_TICKETS", tmpIssueData->stat.issueRefuseCount);

            tmpIssueData->startTime = getTimeByOtlTime(&issueStartTime);
            tmpIssueData->closeTime = getTimeByOtlTime(&issueCloseTime);
            tmpIssueData->drawTime = getTimeByOtlTime(&issueDrawTime);

            tmpIssueData->gameCode = game_code;
            tmpIssueData->localState = tmpIssueData->curState;
            tmpIssueData->used = true;

            //log_info("otl_getGameOldIssueList sss issue_list[%d] [%p]",row,tmpIssueData);

            issue_list->push_back(tmpIssueData);

            //log_info("otl_getGameOldIssueList nnn issue_list[%d] [%p]",row,tmpIssueData);
            row++;
        }
        rs.detach();
        stm_get_gameOldIssue.close();
        log_info("otl_getGameOldIssueList out! row[%d]", row);
    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_getGameOldIssueList");
        log_error("otl_getGameOldIssueList msg[%s]", p.msg);
        log_error("otl_getGameOldIssueList text[%s]", p.stm_text);
        log_error("otl_getGameOldIssueList info[%s]", p.var_info);
    }

    otlp->release_conn(dbConn);
    return row;
}

/************************************************************************************************/
const char *sqlString_get_IssuePrizeInfo = "select PRIZE_LEVEL,LEVEL_PRIZE from ISS_GAME_PRIZE_RULE where GAME_CODE=:f1<int> and ISSUE_NUMBER=:f2<ubigint>";

int otl_getIssuePrizeInfo(uint8 gameCode, uint64 issue, PRIZE_PARAM_ISSUE prize[])
{
    log_info("otl_getIssuePrizeInfo enter gameCode[%d] issue[%lld]", gameCode, issue);
    int ret = 0;
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    try {
        otl_stream stm_get_IssuePrizeInfo;
        stm_get_IssuePrizeInfo.open(OTL_STREAM_BUF, sqlString_get_IssuePrizeInfo, *dbConn);
        stm_get_IssuePrizeInfo << (int)gameCode << issue;
        while (!stm_get_IssuePrizeInfo.eof())
        {
            stm_get_IssuePrizeInfo >> (int &)(prize[ret].prizeCode) >> prize[ret].prizeAmount;
            ret++;
        }
        stm_get_IssuePrizeInfo.close();
        log_info("otl_getIssuePrizeInfo ok! ");
    }
    catch (otl_exception& p) {
        log_error("otl_getIssuePrizeInfo msg[%s]", p.msg);
        log_error("otl_getIssuePrizeInfo text[%s]", p.stm_text);
        log_error("otl_getIssuePrizeInfo info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return -1;
    }
    otlp->release_conn(dbConn);
    return ret;
}


/************************************************************************************************/
const char *sqlString_get_fbsPolicyByIssue = "select f.publish_time, g.theory_rate, g.adj_rate, g.draw_limit_day \
from FBS_ISSUE f, GP_POLICY g where f.game_code = :f1<int> and f.fbs_issue_number = :f2<unsigned> \
and  g.HIS_POLICY_CODE = (select HIS_POLICY_CODE from FBS_CURRENT_PARAM where GAME_CODE = :f3<int> and ISSUE_NUMBER = :f4<unsigned>)";

bool otl_getFbsIssuePolicy(uint8 gameCode, uint32 issue, DB_ISSUE_POLICY *pol)
{
    log_info("otl_getFbsIssuePolicy enter gameCode[%d] issue[%u]", gameCode, issue);

    otl_datetime issuePublisTime;
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    try {
        otl_stream stm_get_IssuePolicyInfo;
        stm_get_IssuePolicyInfo.open(OTL_STREAM_BUF, sqlString_get_fbsPolicyByIssue, *dbConn);
        stm_get_IssuePolicyInfo << (int)gameCode << issue << (int)gameCode << issue;
        while (!stm_get_IssuePolicyInfo.eof())
        {
            stm_get_IssuePolicyInfo >> issuePublisTime >> pol->returnRate >> pol->adjustmentFundRate >> pol->payEndDay;
            pol->payEndDay = getTimeByOtlTime(&issuePublisTime);
            pol->isValid = true;
        }
        stm_get_IssuePolicyInfo.close();
        log_info("otl_getFbsIssuePolicy ok! ");
    }
    catch (otl_exception& p) {
        log_error("otl_getFbsIssuePolicy msg[%s]", p.msg);
        log_error("otl_getFbsIssuePolicy text[%s]", p.stm_text);
        log_error("otl_getFbsIssuePolicy info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    return true;
}


/************************************************************************************************/
const char *sqlString_fbs_get_allMatchsByOneMatch = "select fbs_issue_number,match_code,match_seq,is_sale,competition,\
competition_round, home_team_code, guest_team_code, match_date,location, match_start_date, match_end_date, begin_sale_time, \
end_sale_time,reward_time, status, win_level_los_score, win_los_score \
from fbs_match \
where game_code = :f1<int> and fbs_issue_number = (select fbs_issue_number from FBS_MATCH where match_code = :f2<unsigned>) order by match_code";

bool otl_get_allMatchesByOneMatch(uint8 gameCode, uint32 match_code, DB_FBS_MATCH *fbsm, int *count)
{
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }

    int row = 0;
    float win_lose_score = 0.0;
    otl_datetime matchDate;
    otl_datetime matchStartTime;
    otl_datetime matchEndTime;
    otl_datetime saleStartTime;
    otl_datetime saleEndTime;
    otl_datetime matchResultTime;
    otl_datetime rewardTime;

    log_info("otl_get_allMatchesByOneMatch enter match_code[%u].", match_code);

    otl_stream stm_get_match;
    try {
        stm_get_match.open(OTL_STREAM_BUF, sqlString_fbs_get_allMatchsByOneMatch, *dbConn);
        stm_get_match << (int)gameCode << match_code;
        while (!stm_get_match.eof())
        {
            stm_get_match >> (int &)(fbsm->issue_number) >> (int &)(fbsm->match_code) >> (int &)(fbsm->seq) >> (int &)(fbsm->is_sale) >> (int &)(fbsm->competition)
                >> (int &)(fbsm->round) >> (int &)(fbsm->home_code) >> (int &)(fbsm->away_code) >> matchDate >> fbsm->venue >> matchStartTime 
                >> matchEndTime >> saleStartTime >> saleEndTime >> rewardTime >> (int &)(fbsm->match_status) >> (int &)(fbsm->home_handicap) >> win_lose_score;

            fbsm->match_date = getTimeByOtlTime(&matchDate);
            fbsm->match_start_time = getTimeByOtlTime(&matchStartTime);
            fbsm->match_end_time = getTimeByOtlTime(&matchEndTime);
            fbsm->begin_sale_time = getTimeByOtlTime(&saleStartTime);
            fbsm->end_sale_time = getTimeByOtlTime(&saleEndTime);
            fbsm->reward_time = getTimeByOtlTime(&rewardTime);
            fbsm->home_handicap_point5 = (int32)(10 * win_lose_score);

            fbsm++;
            row++;
        }

        stm_get_match.close();
    }
    catch (otl_exception& p) {
        log_error("otl_get_allMatchesByOneMatch msg[%s]", p.msg);
        log_error("otl_get_allMatchesByOneMatch text[%s]", p.stm_text);
        log_error("otl_get_allMatchesByOneMatch info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    *count = row;
    otlp->release_conn(dbConn);
    log_info("otl_get_allMatchesByOneMatch exit row[%d].", row);
    return true;
}


/************************************************************************************************/
const char *sqlString_ap_paid = \
"begin" \
" p_cncp_paid(:f1<int,in>,:f2<ubigint,in>,:f3<int,out>,:f4<char[200],out>);" \
"end;";

bool otl_ap_pay_over(int gameCode, uint64 issueNumber)
{
    log_info("otl_ap_pay_over enter gameCode[%d] issueSeq[%lld]", gameCode, issueNumber);
    int errorCode = 0;
    string errorStr;
    otl_connect* dbConn = otlp->get_connect();
    if (dbConn == NULL)
    {
        log_error("get_connect failure!");
        return false;
    }
    try {

        otl_stream stm_del_Issue;
        stm_del_Issue.open(1, sqlString_ap_paid, *dbConn);
        stm_del_Issue << gameCode << issueNumber;
        stm_del_Issue >> errorCode >> errorStr;
        stm_del_Issue.close();
        log_debug("otl_ap_pay_over end.");
    }
    catch (otl_exception& p) {
        //send_otlDealFalseNotify("otl_delIssue");
        log_error("otl_ap_pay_over msg[%s]", p.msg);
        log_error("otl_ap_pay_over text[%s]", p.stm_text);
        log_error("otl_ap_pay_over info[%s]", p.var_info);
        otlp->release_conn(dbConn);
        return false;
    }
    otlp->release_conn(dbConn);
    if (errorCode == 0)
    {
        return true;
    }
    else
    {
        //send_otlDealFalseNotify("otl_delIssue");
        log_error("otl_ap_pay_over errorCode[%d] errorStr[%s]", errorCode, errorStr.c_str());
        return false;
    }
}
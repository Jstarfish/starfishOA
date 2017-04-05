#include "global.h"
#include"gl_inf.h"


int32 shm_flag = 0;

int32 game = 1;
int32 issue = 1;
int32 z = 0;

uint32 g_session_no = 5;


int32 test_game_issue_path()
{
    char path[256] = {0};
    int32 len = 256;

    uint8 game_code = 4;
    uint32 issue_num = 120921007;

    ts_get_session_dir(g_session_no, path, len);
    printf("ts_get_session_dir(%d) -> %s\n", g_session_no, path);

    ts_get_session_game_dir(g_session_no, game_code, path, len);
    printf("ts_get_session_game_dir(%d, %d) -> %s\n", g_session_no, game_code, path);

    ts_get_session_xml_filepath(g_session_no, path, len);
    printf("ts_get_session_xml_filepath(%d) -> %s\n", g_session_no, path);

    ts_get_session_tf_filepath(g_session_no, path, len);
    printf("ts_get_session_tf_filepath(%d) -> %s\n", g_session_no, path);

    ts_get_session_issue_match_filepath(g_session_no, game_code, issue_num, path, len);
    printf("ts_get_session_issue_match_filepath(%d, %d, %d) -> %s\n", g_session_no, game_code, issue_num, path);

    ts_get_session_issue_winner_filepath(g_session_no, game_code, issue_num, WINNER_LOCAL_FILE, path, len);
    printf("ts_get_session_issue_winner_filepath(%d, %d, %d) -> %s\n", g_session_no, game_code, issue_num, path);

    ts_get_session_issue_winner_filepath(g_session_no, game_code, issue_num, WINNER_CONFIRM_FILE, path, len);
    printf("ts_get_session_issue_winner_filepath(%d, %d, %d) -> %s\n", g_session_no, game_code, issue_num, path);

    ts_get_session_issue_draw_announce_filepath(g_session_no, game_code, issue_num, path, len);
    printf("ts_get_session_issue_draw_announce_filepath(%d, %d, %d) -> %s\n", g_session_no, game_code, issue_num, path);


    ts_get_game_dir(game_code, path, len);
    printf("ts_get_game_dir(%d) -> %s\n", game_code, path);

    ts_get_game_issue_dir(game_code, path, len);
    printf("ts_get_game_issue_dir(%d) -> %s\n", game_code, path);

    ts_get_game_issue_filepath(game_code, path, len);
    printf("ts_get_game_issue_filepath(%d) -> %s\n", game_code, path);

    ts_get_game_issue_ticket_filepath(game_code, issue_num, path, len);
    printf("ts_get_game_issue_ticket_filepath(%d, %d) -> %s\n", game_code, issue_num, path);

    return 0;
}



int32 game_issue_test_insert()
{
	int32 ret = 0;

	int32 i = 0;
	int32 j = 0;
	for (i=1; i<game+1; i++)
    {
    	GIDB_ISSUE_HANDLE * pHandle = gidb_get_issue_handle(i);
    	if ( NULL == pHandle )
        {
        	printf("gidb_get_issue_handle(%d) failure.\n", i);
        	return -1;
        }

    	for (j=1; j<issue; j++)
        {
        	GIDB_ISSUE_INFO is_info;
        	memset((char *)&is_info, 0, sizeof(GIDB_ISSUE_INFO));
        	is_info.gameCode = i;
        	is_info.game_code = i;
        	is_info.gameId = i+900;
        	is_info.issueNumber = j;
        	is_info.serialNumber = j;
        	is_info.status = j;
        	is_info.estimate_start_time = j+100;
        	is_info.estimate_close_time = j+200;
        	is_info.estimate_draw_time = j+300;
        	is_info.payEndDay = j+900;

        	ret = pHandle->gidb_insert_issue(pHandle, i, j, &is_info);
        	if ( 0 > ret )
            {
            	printf("gidb_insert_issue() failure.\n");
            	return -1;
            }


            /*
            ret = pHandle->gidb_set_issue_realtime(pHandle, i, j, j+40000, ISSUE_STATE_OPENED);
        	if ( 0 > ret )
            {
            	printf("gidb_set_issue_realtime(%d,%d, ISSUE_STATE_OPENED) failure.\n", i, j);
            	return -1;
            }
            ret = pHandle->gidb_set_issue_realtime(pHandle, i, j, j+50000, ISSUE_STATE_CLOSED);
        	if ( 0 > ret )
            {
            	printf("gidb_set_issue_realtime(%d,%d, ISSUE_STATE_CLOSED) failure.\n", i, j);
            	return -1;
            }
            ret = pHandle->gidb_set_issue_realtime(pHandle, i, j, j+60000, ISSUE_STATE_DRAWNUM_INPUTED);
        	if ( 0 > ret )
            {
            	printf("gidb_set_issue_realtime(%d,%d, ISSUE_STATE_DRAWNUM_INPUTED) failure.\n", i, j);
            	return -1;
            }
            ret = pHandle->gidb_set_issue_realtime(pHandle, i, j, j+70000, ISSUE_STATE_MATCHED);
        	if ( 0 > ret )
            {
            	printf("gidb_set_issue_realtime(%d,%d, ISSUE_STATE_MATCHED) failure.\n", i, j);
            	return -1;
            }
            ret = pHandle->gidb_set_issue_realtime(pHandle, i, j, j+80000, ISSUE_STATE_ISSUE_END);
        	if ( 0 > ret )
            {
            	printf("gidb_set_issue_realtime(%d,%d, ISSUE_STATE_ISSUE_END) failure.\n", i, j);
            	return -1;
            }

            ret = pHandle->gidb_set_issue_payEndDay(pHandle, i, j, j+100000);
        	if ( 0 > ret )
            {
            	printf("gidb_set_issue_payEndDay(%d,%d, %d) failure.\n", i, j, j+100000);
            	return -1;
            }    

            for (int32 n=TICKETS_STAT_BLOB_KEY; n<=WFUND_INFO_CONFIRM_BLOB_KEY; n++)
            {
                char buf_[4096];
            	buf_[0] = 11;
            	buf_[1] = 31;
            	buf_[2] = 51;
            	buf_[3] = 71;
            	buf_[4] = 91;
            	buf_[4091] = 21;
            	buf_[4092] = 41;
            	buf_[4093] = 61;
            	buf_[4094] = 81;
            	buf_[4095] = 101;
                ret = pHandle->gidb_set_issue_field_blob(pHandle, i, j, (ISSUE_FIELD_BLOB_KEY)n, buf_, 4096);
            	if ( 0 > ret )
                {
                	printf("gidb_set_issue_field_blob() failure.\n");
                	return -1;
                }
            }

            for (int32 m=DRAW_CODE_TEXT_KEY; m<=DRAW_ANNOUNCE_TEXT_KEY; m++)
            {
                char str_[4096];
                sprintf(str_, "%d_%d_%d_%d", i, j, m, i+j+m);
                ret = pHandle->gidb_set_issue_field_text(pHandle, i, j, (ISSUE_FIELD_TEXT_KEY)m, str_);
            	if ( 0 > ret )
                {
                	printf("gidb_set_issue_field_text() failure.\n");
                	return -1;
                }
            }
            */

        	if ( (j == 1) || ( (j%1000) == 0 ) )
            {
            	printf("Game_%d test success!\n", i);
            }
        }    
    }
	return 0;
}


int32 game_issue_test_update()
{
	int32 ret = 0;

	int32 gameIdx = 1;
	int32 issueIdx = 1002;
    int32 opIdx = 0;
	int32 idx = 0;
	int32 idxx = 0;
	int32 cnt = 0;

	ISSUE_FIELD_BLOB_KEY fb;
	ISSUE_FIELD_TEXT_KEY ft;

	time_t t;
    srand((unsigned) time(&t));

	while( cnt < z )
    {
    	gameIdx = rand()%game;
    	if (gameIdx == 0)
        	gameIdx = 1;
        issueIdx = rand()%issue;
    	if (issueIdx == 0)
        	issueIdx = 1;

    	idx = rand()%8;
    	if (idx == 0)
        	idx = 1;
    	fb = (ISSUE_FIELD_BLOB_KEY)idx;

    	idxx = rand()%4;
    	if (idxx == 0)
        	idxx = 1;
    	ft = (ISSUE_FIELD_TEXT_KEY)idxx;

    	printf("game[%d] issue[%d] field_blob[%d] field_text[%d]\n", gameIdx, issueIdx, fb, ft);



    	GIDB_ISSUE_HANDLE * handle = gidb_get_issue_handle(gameIdx);
    	if ( NULL == handle )
        {
        	printf("-1- gidb_get_issue_handle(%d) failure.\n", gameIdx);
        	return -1;
        }
    	printf(" ---> gidb_get_issue_handle(%d) <---  SUCCESS.\n", gameIdx);



    	GIDB_ISSUE_INFO i0_;
        ret = handle->gidb_get_issue_info(handle, gameIdx, issueIdx, &i0_);
    	if ( 0 > ret )
        {
        	printf("gidb_get_issue_info *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_get_issue_info(%d, %d) <---  SUCCESS.\n", gameIdx, issueIdx);



    	GIDB_ISSUE_INFO i1_;
        ret = handle->gidb_get_issue_info2(handle, gameIdx, issueIdx, &i1_);
    	if ( 0 > ret )
        {
        	printf("gidb_get_issue_info2 *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_get_issue_info2(%d, %d) <---  SUCCESS.\n", gameIdx, issueIdx);



    	ret = handle->gidb_set_issue_status(handle, gameIdx, issueIdx, 7);
    	if ( 0 > ret )
        {
        	printf("gidb_set_issue_status *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_set_issue_status(%d, %d) <---  SUCCESS.\n", gameIdx, issueIdx);
        


    	uint8 s_ = 234;
        ret = handle->gidb_get_issue_status(handle, gameIdx, issueIdx, &s_);
    	if ( 0 > ret )
        {
        	printf("gidb_get_issue_status *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_get_issue_status(%d, %d) <---  SUCCESS.\n", gameIdx, issueIdx);



        

    	ret = handle->gidb_set_issue_realtime(handle, gameIdx, issueIdx, get_now(), 1);
    	if ( 0 > ret )
        {
        	printf("gidb_set_issue_realtime *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_set_issue_realtime(%d, %d) <---  SUCCESS.\n", gameIdx, issueIdx);




    	ret = handle->gidb_set_issue_payEndDay(handle, gameIdx, issueIdx, get_now());
    	if ( 0 > ret )
        {
        	printf("gidb_set_issue_payEndDay *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_set_issue_payEndDay(%d, %d) <---	SUCCESS.\n", gameIdx, issueIdx);




    	char buf_[4096];
    	buf_[0] = 1;
    	buf_[1] = 3;
    	buf_[2] = 5;
    	buf_[3] = 7;
    	buf_[4] = 9;
    	buf_[4091] = 2;
    	buf_[4092] = 4;
    	buf_[4093] = 6;
    	buf_[4094] = 8;
    	buf_[4095] = 10;
        ret = handle->gidb_set_issue_field_blob(handle, gameIdx, issueIdx, fb, buf_, 4096);
    	if ( 0 > ret )
        {
        	printf("gidb_set_issue_field_blob *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_set_issue_field_blob(%d, %d) <---	SUCCESS.\n", gameIdx, issueIdx);




        

    	char buf__[4096];
    	int32 len = 0;
        ret = handle->gidb_get_issue_field_blob(handle, gameIdx, issueIdx, fb, buf__, &len);
    	if ( 0 > ret )
        {
        	printf("gidb_get_issue_field_blob *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	if (len != 4096)
        {
        	printf("gidb_get_issue_field_blob() Length[%d] error!\n", len);
        }
    	printf(" ---> gidb_get_issue_field_blob() %d %d %d %d %d -- %d %d %d %d %d\n",
            	buf__[0], buf__[1], buf__[2], buf__[3], buf__[4],
            	buf__[4091], buf__[4092], buf__[4093], buf__[4094], buf__[4095] );
    	printf(" ---> gidb_get_issue_field_blob(%d, %d) <---	SUCCESS.\n", gameIdx, issueIdx);




        

    	char str_[4096] = {0};
    	sprintf(str_, "abcdefghijklmnopqrstunwxyz1234567890");
        ret = handle->gidb_set_issue_field_text(handle, gameIdx, issueIdx, ft, str_);
    	if ( 0 > ret )
        {
        	printf("gidb_set_issue_field_text *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_set_issue_field_text(%d, %d) <---	SUCCESS.\n", gameIdx, issueIdx);





    	char str[4096] = {0};
        ret = handle->gidb_get_issue_field_text(handle, gameIdx, issueIdx, ft, str);
    	if ( 0 > ret )
        {
        	printf("gidb_get_issue_field_text *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_get_issue_field_text(%d, %d) <---	SUCCESS.\n", gameIdx, issueIdx);





    	/*
    	ret = handle->gidb_cleanup_issue(handle, gameIdx, issueIdx);
    	if ( 0 > ret )
        {
        	printf("gidb_cleanup_issue *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
        	return -1;
        }
    	printf(" ---> gidb_cleanup_issue(%d, %d) <---	SUCCESS.\n", gameIdx, issueIdx);
    	*/


    	cnt++;
    }


    

	gameIdx = 1;
	issueIdx = 1002;
    opIdx = 0;
	idx = 0;
	idxx = 0;
	cnt = 0;
	while(cnt < z)
    {
    	gameIdx = rand()%game;
    	if (gameIdx == 0)
        	continue;
        issueIdx = rand()%issue;
    	if (issueIdx == 0)
        	continue;

        GIDB_ISSUE_HANDLE * pHandle = gidb_get_issue_handle(gameIdx);
    	if ( NULL == pHandle )
        {
        	printf("-1- gidb_get_issue_handle(%d) failure.\n", gameIdx);
        	return -1;
        }

    	opIdx = rand()%12;
    	printf("[%d %d %d]\n", gameIdx, issueIdx, opIdx);

        switch (opIdx)
        {
            case 0:
            {
            	GIDB_ISSUE_INFO i0;
                ret = pHandle->gidb_get_issue_info(pHandle, gameIdx, issueIdx, &i0);
            	if ( 0 > ret )
                {
                	printf("gidb_get_issue_info *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	case 1:
            {
            	GIDB_ISSUE_INFO i1;
                ret = pHandle->gidb_get_issue_info2(pHandle, gameIdx, issueIdx, &i1);
            	if ( 0 > ret )
                {
                	printf("gidb_get_issue_info2 *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	case 2:
            {
            	ret = pHandle->gidb_set_issue_status(pHandle, gameIdx, issueIdx, 7);
            	if ( 0 > ret )
                {
                	printf("gidb_set_issue_status *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	case 3:
            {
            	uint8 s = 234;
                ret = pHandle->gidb_get_issue_status(pHandle, gameIdx, issueIdx, &s);
            	if ( 0 > ret )
                {
                	printf("gidb_get_issue_status *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	case 4:
            {
            	ret = pHandle->gidb_set_issue_realtime(pHandle, gameIdx, issueIdx, get_now(), 1);
            	if ( 0 > ret )
                {
                	printf("gidb_set_issue_realtime *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	case 5:
            {
            	ret = pHandle->gidb_set_issue_payEndDay(pHandle, gameIdx, issueIdx, get_now());
            	if ( 0 > ret )
                {
                	printf("gidb_set_issue_payEndDay *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	case 6:
            {
            	idx = rand()%9;
            	if ( (idx < 1) || (idx > 8) )
                	idx = 8;
            	ISSUE_FIELD_BLOB_KEY filed_key0 = (ISSUE_FIELD_BLOB_KEY)idx;
            	char buf[4096];
            	buf[0] = 1;
            	buf[1] = 3;
            	buf[2] = 4;
            	buf[3] = 7;
            	buf[4] = 9;
            	buf[4091] = 2;
            	buf[4092] = 4;
            	buf[4093] = 6;
            	buf[4094] = 8;
            	buf[4095] = 10;
                ret = pHandle->gidb_set_issue_field_blob(pHandle, gameIdx, issueIdx, filed_key0, buf, 4096);
            	if ( 0 != ret )
                {
                	printf("gidb_set_issue_field_blob *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	case 7:
            {
            	idx = rand()%9;
            	if ( (idx < 1) || (idx > 8) )
                	idx = 8;
            	ISSUE_FIELD_BLOB_KEY filed_key1 = (ISSUE_FIELD_BLOB_KEY)idx;
            	char buf[10240];
            	int32 len = 0;
                ret = pHandle->gidb_get_issue_field_blob(pHandle, gameIdx, issueIdx, filed_key1, buf, &len);
            	if ( 0 != ret )
                {
                	printf("gidb_get_issue_field_blob *** failure ***! gameIdx[%d] issueIdx[%d]. retValue[%d]\n", gameIdx, issueIdx, ret);
                	return -1;
                }

            	printf("gidb_get_issue_field_blob() %d %d %d %d %d -- %d %d %d %d %d\n",
                	buf[0], buf[1], buf[2], buf[3], buf[4],
                	buf[4091], buf[4092], buf[4093], buf[4094], buf[4095] );
                break;
            }
        	case 8:
            {
            	idxx = rand()%5;
            	if ( (idxx < 1) || (idxx > 4) )
                	idxx = 4;
            	ISSUE_FIELD_TEXT_KEY filed_key2 = (ISSUE_FIELD_TEXT_KEY)idxx;
            	char str[4096] = {0};
            	sprintf(str, "abcdefghijklmnopqrstunwxyz1234567890");
                ret = pHandle->gidb_set_issue_field_text(pHandle, gameIdx, issueIdx, filed_key2, str);
            	if ( 0 != ret )
                {
                	printf("gidb_set_issue_field_text *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	case 9:
            {
            	idxx = rand()%5;
            	if ( (idxx < 1) || (idxx > 4) )
                	idxx = 4;
            	ISSUE_FIELD_TEXT_KEY filed_key3 = (ISSUE_FIELD_TEXT_KEY)idxx;
            	char str[10240] = {0};
                ret = pHandle->gidb_get_issue_field_text(pHandle, gameIdx, issueIdx, filed_key3, str);
            	if ( 0 != ret )
                {
                	printf("gidb_get_issue_field_text *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                break;
            }
        	default:
            {
            	/*
            	ret = pHandle->gidb_cleanup_issue(pHandle, gameIdx, issueIdx);
            	if ( 0 > ret )
                {
                	printf("gidb_cleanup_issue *** failure ***! gameIdx[%d] issueIdx[%d].\n", gameIdx, issueIdx);
                	return -1;
                }
                */
                break;
            }
        }
    	cnt++;
    }
	return 0;
}

int32 game_issue_test_select()
{
	int32 ret = 0;

	int32 i = 0;
	int32 j = 0;
	for (i=1; i<game+1; i++)
    {
    	GIDB_ISSUE_HANDLE * pHandle = gidb_get_issue_handle(i);
    	if ( NULL == pHandle )
        {
        	printf("gidb_get_issue_handle(%d) failure.\n", i);
        	return -1;
        }

    	for (j=1; j<issue; j++)
        {
        	GIDB_ISSUE_INFO is_info;
        	memset((char *)&is_info, 0, sizeof(GIDB_ISSUE_INFO));
        	is_info.gameCode = i;
        	is_info.game_code = i;
        	is_info.gameId = i+900;
        	is_info.issueNumber = 700000000;
        	is_info.serialNumber = 800000000;
        	is_info.status = j;

        	is_info.estimate_start_time = j+100;
        	is_info.estimate_close_time = j+200;
        	is_info.estimate_draw_time = j+300;
        	is_info.real_start_time = j+400;
        	is_info.real_close_time = j+500;
        	is_info.real_draw_time = j+600;
        	is_info.real_pay_time = j+700;
    
        	is_info.payEndDay = j+800;
        	char tmp[256] = {0};
        	sprintf(tmp, "Game[%d] IssueNumber[%d] IssueSerialNumber[%d] Status[%d]", is_info.gameCode, is_info.issueNumber, is_info.serialNumber, is_info.status);
        	strcpy(is_info.draw_code_str, tmp);
            
        	ret = pHandle->gidb_insert_issue(pHandle, i, j, &is_info);
        	if ( 0 > ret )
            {
            	printf("gidb_insert_issue() failure.\n");
            	return -1;
            }

        	if ( (j == 1) || ( (j%1000) == 0 ) )
            {
            	printf("Game_%d test success!\n", i);
            }
        }    
    }
	return 0;
}















int32 test_program()
{
	printf("--------- test test_game_issue_path() --------------\n");
	test_game_issue_path();

	if (shm_flag > 0)
    {
    	printf("--------- test game_issue_test_insert() --------------\n");
    	game_issue_test_insert();
    }

	printf("--------- test game_issue_test_update() --------------\n");
	//game_issue_test_update();

	return 0;
}



int32 test_program_ticket()
{
	printf("--------- test test_program_ticket() --------------\n");

    for (int32 i=1; i<game+1; i++)
    {
    	for (int32 j=1; j<issue; j++)
        {
            GIDB_TICKET_HANDLE * pHandle = gidb_get_ticket_handle(i, j);
        	if ( NULL == pHandle )
            {
            	printf("gidb_get_ticket_handle(%d) failure.\n", i);
            	return -1;
            }
        }
    }

    return 0;
}









char *l_opt_arg;  
char* const short_options = "c:g:i:z:";  
struct option long_options[] = {
    { "create",     1,   NULL,    'c'},
    { "game",       1,   NULL,    'g'},
    { "issue",      1,   NULL,    'i'},
    { "zzz",        1,   NULL,    'z'},
    {      NULL,    0,   NULL,    0  },
};


int main(int argc, char *argv[])
{
    int32 ret = 0;

    int c;
	while((c = getopt_long (argc, argv, short_options, long_options, NULL)) != -1)  
    {  
        switch (c)  
        {  
            case 'c':
                l_opt_arg = optarg;
                shm_flag = atoi(l_opt_arg);
                printf("shm_flag [%d]\n", shm_flag);
                break;  
            case 'g':
                l_opt_arg = optarg;
                game = atoi(l_opt_arg);
                printf("game [%d]\n", game);
                break;  
            case 'i':  
                l_opt_arg = optarg;
                issue = atoi(l_opt_arg);
                printf("issue [%d]\n", issue);
                break;
            case 'z':
                l_opt_arg = optarg;
                z = atoi(l_opt_arg);
                printf("z [%d]\n", z);
                break;
            default:
                printf("Usage: sqlite_test -c 1 -g 8 -i 8 -z 8\n");
                exit(1);
        }
    }

    //准备相关的目录
    system("rm -rf /home/taishan/run_dir/data/*");

    char cmd_str[256] = {0};

    char path_str[1024] = {0};
    ts_get_session_dir(g_session_no, path_str, 1024);
    mkdir(path_str,0777);

    mkdir(GAME_DATA_SUBDIR,0777);

    for (int32 i=1; i<game+1; i++)
    {
        //创建session下的game相关目录
        ts_get_session_game_dir(g_session_no, i, path_str, 1024);
        mkdir(path_str,0777);

        //创建data下的game相关目录
        ts_get_game_dir(i, path_str, 1024);
        mkdir(path_str,0777);
        ts_get_game_issue_dir(i, path_str, 1024);
        mkdir(path_str,0777);
    }

    sleep(1);

    if (shm_flag > 0)
    {
    	ret = gidb_shm_create();
    	if ( 0 > ret )
        {
        	printf("gidb_shm_create() failure!\n");
        	return -1;
        }
    }
	ret = gidb_shm_init();
	if ( 0 > ret )
    {
    	printf("gidb_shm_init() failure!\n");
    	goto exit_entry;
    }
	printf("gidb_shm_init() ok.\n");




	printf("\n------------> GIDB TEST begin <-------------\n\n");
	ret = test_program();
	if ( 0 > ret )
    {
    	printf("test_program() found error!\n");
    	goto exit_entry;
    }

    ret = test_program_ticket();
	if ( 0 > ret )
    {
    	printf("test_program_ticket() found error!\n");
    	goto exit_entry;
    }
	printf("\n------------> GIDB TEST end   <-------------\n\n");




exit_entry:

	gidb_close_all_db();

	ret = gidb_shm_close();
	if ( 0 > ret )
    {
    	printf("gidb_shm_close() failure!\n");
    }
	printf("gidb_shm_close() ok.\n");
	if (shm_flag > 0)
    {
    	ret = gidb_shm_destroy();
    	if ( 0 > ret )
        {
        	printf("gidb_shm_destroy() failure!\n");
        	return -1;
        }
    }
	return 0;
}



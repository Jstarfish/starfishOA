#include "global.h"
#include "tfe_inf.h"
#include "gl_inf.h"
#include "tms_inf.h"

#define MY_TASK_NAME "tfe_adder\0"

static volatile int exit_signal_fired = 0;

GAME_PLUGIN_INTERFACE *game_plugins_handle = NULL;

FID fid;
MQUE *q = NULL;
int thread_count = 8;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

char fund_server_ip[16];
int  fund_server_port;
const int http_timeout = 3;

const char * HTTP_MSG_VERSION = "1.0.0";
const char * HTTP_REQUEST = "POST /do HTTP/1.1\r\nHOST: %s:%d\r\nAccept: */*\r\nContent-Length: %d\r\n\r\n";
const char * HTTP_RESPONSE = "HTTP/1.1 200 OK\r\nServer: taishan\r\nContent-Type: text/html;charset=utf-8\r\nContent-Length: %d\r\nConnection: close\r\n\r\n%s";

int timeout_connect(const char * ip, int port, int timeout_sec)
{
	int ret = 0;
	struct sockaddr_in address;
	bzero(&address, sizeof(address));
	address.sin_family = AF_INET;
	inet_pton(AF_INET, ip, &address.sin_addr);
	address.sin_port = htons(port);

	int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	assert(sockfd >= 0);

	struct timeval timeout;
	timeout.tv_sec = timeout_sec;
	timeout.tv_usec = 0;
	socklen_t len = sizeof(timeout);

	ret = setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, &timeout, len);
	assert(ret != -1);

	ret = connect(sockfd, (struct sockaddr *)&address, sizeof(address));
	if (ret == -1)
	{
		if (errno == EINPROGRESS)
		{
			log_error("connecting ip[%s] port[%d] timeout[%d] logic.",ip,port, timeout_sec);
			return -1;
		}
		log_error("connecting to server failure, ip[%s] port[%d] timeout[%d]", ip, port, timeout_sec);
		return -1;
	}
	return sockfd;
}

int call_http_service(const char * ip_address, int port, int msg_length, char *request_msg, int timeout, char *recv_msg)
{
	int size_recv, total_size = 0;
	struct timeval begin, now;
	int ret = 0;
	int socket_desc;
	char message[2048] = { 0 };
	char chunk[512];
	double timediff;

	char tmpbuf[4096] = { 0 };
	char *pm = tmpbuf;
	uint16  resp_len = 0;
	

	sprintf(message, HTTP_REQUEST, ip_address, port, msg_length);
	strncat(message, request_msg, msg_length);

	log_debug("--------------SEND HTTP Post----------------\n%s\n", message);

	socket_desc = timeout_connect(ip_address, port, timeout);
	if (socket_desc < 0)
	{
		log_error("socket connect failed,ip[%s] port[%d]", ip_address,port);
		return 1;
	}

	if (send(socket_desc, message, strlen(message), 0) < 0)
	{
		log_error("Send failed,ip[%s] port[%d]", ip_address, port);
		return 1;
	}

	fcntl(socket_desc, F_SETFL, O_NONBLOCK);
	gettimeofday(&begin, NULL);

	while (1)
	{
		gettimeofday(&now, NULL);
		timediff = (now.tv_sec - begin.tv_sec) + 1e-6 * (now.tv_usec - begin.tv_usec);

		if (timediff > timeout)
		{
			if (total_size > 0)
			{
				if (total_size < 96)
				{
					ret = 2;
				}
				else
				{
					if (strncasecmp(tmpbuf, HTTP_RESPONSE, 15) == 0)
					{
						char *res_length = strcasestr(tmpbuf, "Content-Length:");
						if (res_length == NULL)
						{
							log_error("no Content-Length: find!\n");
							ret = 2;
						}
						else
						{
							res_length += 16;
							resp_len = atoi(res_length);
							resp_len += 4;
							if (strlen(res_length) >= resp_len)
							{
								char *msg_hd = strcasestr(tmpbuf, "\r\n\r\n");
								if (msg_hd == NULL)
								{
									log_error("no \\r\\n\\r\\n find! \n");
									ret = 2;
								}
								else // message ok!
								{
									msg_hd += 4;
									stpcpy(recv_msg, msg_hd);
									break;
								}
							}
						}
					}
					else
					{
						log_error("http head isn't 200 OK! :%s", tmpbuf);
						ret = 1;
					}
				}
			}
			else
			{
				ret = 2;
			}
			break;
		}

		memset(chunk, 0, sizeof(chunk));  //clear the variable
		if ((size_recv = recv(socket_desc, chunk, sizeof(chunk), 0)) < 0)
		{
			if (errno == EWOULDBLOCK || errno == EAGAIN)
			{
				usleep(1000);
			}
			else
			{
				ret = 1;
				break;
			}

		}
		else
		{
			total_size += size_recv;
			memcpy(pm, chunk, size_recv);
			pm += size_recv;

			if (total_size > 96)
			{
				if (strncasecmp(tmpbuf, HTTP_RESPONSE, 15) == 0)
				{
					char *res_length = strcasestr(tmpbuf, "Content-Length:");
					if (res_length == NULL)
					{
						log_error("no Content-Length: find!\n");
						ret = 1;
						break;
					}
					else
					{
						res_length += 16;
						resp_len = atoi(res_length);
						resp_len += 4;
						if (strlen(res_length) >= resp_len)
						{
							char *msg_hd = strcasestr(tmpbuf, "\r\n\r\n");
							if (msg_hd == NULL)
							{
								log_error("no \\r\\n\\r\\n find! \n");
								ret = 1;
							}
							else
							{
								msg_hd += 4;
								stpcpy(recv_msg, msg_hd);
							}
							break;
						}
					}
				}
				else
				{
					log_error("http head isn't 200 OK! :%s", tmpbuf);
					ret = 1;
					break;
				}
			}
		}
	}
	close(socket_desc);
	return ret;
}

int get_HttpMethod(int func)
{
	switch (func)
	{
	case INM_TYPE_T_SELL_TICKET:
		return 100101;

	case INM_TYPE_T_PAY_TICKET:
		return 100102;

	case INM_TYPE_T_CANCEL_TICKET:
		return 100103;

	case INM_TYPE_O_PAY_TICKET:
		return 100201;

	case INM_TYPE_O_CANCEL_TICKET:
		return 100202;

	default:
		return -1;
	}

}

void setParamJson(int func, char *inm_buf, cJSON *param)
{
	switch (func)
	{
	case INM_TYPE_T_SELL_TICKET:
	{
		INM_MSG_T_SELL_TICKET *pInm = (INM_MSG_T_SELL_TICKET *)inm_buf;
		char agency_str[16] = { 0 };
		sprintf(agency_str, "%llu", pInm->header.agencyCode);
		cJSON_AddStringToObject(param, "outletCode", agency_str);
		cJSON_AddNumberToObject(param, "amount", pInm->ticket.amount);
		cJSON_AddNumberToObject(param, "comm", pInm->saleCommissionRate);
		cJSON_AddStringToObject(param, "refNo", pInm->reqfn_ticket);
		break;
	}
	case INM_TYPE_T_PAY_TICKET:
	{
		INM_MSG_T_PAY_TICKET *pInm = (INM_MSG_T_PAY_TICKET *)inm_buf;
		char agency_str[16] = { 0 };
		sprintf(agency_str, "%llu", pInm->header.agencyCode);
		cJSON_AddStringToObject(param, "outletCode", agency_str);
		cJSON_AddNumberToObject(param, "amount", pInm->winningAmountWithTax);
		cJSON_AddNumberToObject(param, "comm", pInm->payCommissionRate);
		cJSON_AddStringToObject(param, "refNo", pInm->reqfn_ticket);
		break;
	}
	case INM_TYPE_T_CANCEL_TICKET:
	{
		INM_MSG_T_CANCEL_TICKET *pInm = (INM_MSG_T_CANCEL_TICKET *)inm_buf;
		char agency_sale[16] = { 0 };
		char agency_cancle[16] = { 0 };
		sprintf(agency_sale, "%llu", pInm->saleAgencyCode);
		sprintf(agency_cancle, "%llu", pInm->header.agencyCode);
		cJSON_AddStringToObject(param, "saleCode", agency_sale);
		cJSON_AddStringToObject(param, "cancelCode", agency_cancle);
		cJSON_AddNumberToObject(param, "amount", pInm->ticket.amount);
		cJSON_AddNumberToObject(param, "saleComm", pInm->commissionAmount);
		cJSON_AddStringToObject(param, "refNo", pInm->reqfn_ticket);
		break;
	}
	case INM_TYPE_O_PAY_TICKET:
	{
		INM_MSG_O_PAY_TICKET *pInm = (INM_MSG_O_PAY_TICKET *)inm_buf;
		char agency_str[16] = { 0 };
		sprintf(agency_str, "%u", pInm->areaCode_pay);
		cJSON_AddStringToObject(param, "outletCode", agency_str);
		cJSON_AddNumberToObject(param, "amount", pInm->winningAmountWithTax);
		cJSON_AddNumberToObject(param, "comm", pInm->payCommissionRate);
		cJSON_AddStringToObject(param, "refNo", pInm->reqfn_ticket);
		break;
	}

	case INM_TYPE_O_CANCEL_TICKET:
	{
		INM_MSG_O_CANCEL_TICKET *pInm = (INM_MSG_O_CANCEL_TICKET *)inm_buf;
		char agency_sale[16] = { 0 };
		char area_cancel[16] = { 0 };
		sprintf(agency_sale, "%llu", pInm->saleAgencyCode);
		sprintf(area_cancel, "%u", pInm->areaCode_cancel);
		cJSON_AddStringToObject(param, "outletCode", agency_sale);
		cJSON_AddNumberToObject(param, "saleComm", pInm->saleCommissionRate);
		cJSON_AddStringToObject(param, "orgCode", area_cancel);
		cJSON_AddNumberToObject(param, "amount", pInm->cancelAmount);
		cJSON_AddStringToObject(param, "refNo", pInm->reqfn_ticket);
		break;
	}
	default:
		break;
	}
	return;
}


void inm2json(char *inm_buf, char *jsonBuf)
{
	INM_MSG_T_HEADER *inm_header = (_INM_MSG_T_HEADER *)inm_buf;

	int func = inm_header->inm_header.type;
	int method_str = get_HttpMethod(func);

	cJSON *param = cJSON_CreateObject();
	setParamJson(func, inm_buf, param);

	cJSON *jsonReq = cJSON_CreateObject();
	cJSON_AddStringToObject(jsonReq, "version", HTTP_MSG_VERSION);
	cJSON_AddNumberToObject(jsonReq, "type", inm_header->inm_header.gltp_type);
	cJSON_AddNumberToObject(jsonReq, "func", method_str);
	cJSON_AddNumberToObject(jsonReq, "token", 0);
	cJSON_AddNumberToObject(jsonReq, "msn", inm_header->msn);
	cJSON_AddNumberToObject(jsonReq, "when", inm_header->inm_header.when);
	cJSON_AddItemToObject(jsonReq, "params", param);

	char *msgstr = cJSON_PrintUnformatted(jsonReq);
	memcpy(jsonBuf, msgstr, strlen(msgstr));
	free(msgstr);
	cJSON_Delete(jsonReq);
	return;
}

cJSON *cJSON_Get(cJSON *object, const char *string, int dt)
{
	cJSON *item = cJSON_GetObjectItem(object, string);
	if (item == NULL || item->type != dt) {
		log_error("Json Message field [ %s ] parse error.", string);
		return NULL;
	}
	return item;
}

int jsonStrParse(char *inm_buf, char *buf)
{
	INM_MSG_T_HEADER *inm_header = (_INM_MSG_T_HEADER *)inm_buf;

	cJSON *json_root = cJSON_Parse(buf);
	if (!json_root) {
		log_warn("Json parse error before: [%s]", cJSON_GetErrorPtr());
		inm_header->inm_header.status = SYS_RESULT_FAILURE;
		return 1;
	}

	cJSON *json_errcode = cJSON_Get(json_root, "errcode", cJSON_Number);
	if (json_errcode == NULL) 
	{ 
		cJSON_Delete(json_root);
		log_warn("Json parse error get errcode");
		inm_header->inm_header.status = SYS_RESULT_FAILURE;
		return 1; 
	}
	int  errcode = json_errcode->valueint;
	if (errcode != 0)
	{
		cJSON *json_errstr = cJSON_Get(json_root, "errmesg", cJSON_String);
		if (json_errstr == NULL) {
			log_warn("cJSON_Get err msg failure."); 
			cJSON_Delete(json_root); 
			inm_header->inm_header.status = SYS_RESULT_FAILURE;
			return 1;
		}
		log_warn("err msg [%s]", json_errstr->valuestring);
		inm_header->inm_header.status = SYS_RESULT_FAILURE;
		return errcode;
	}
	/*
	cJSON *json_version = cJSON_Get(json_root, "version", cJSON_String);if (json_version == NULL) { cJSON_Delete(json_root); return -1; }
	cJSON *json_type = cJSON_Get(json_root, "type", cJSON_Number); if (json_type == NULL) { cJSON_Delete(json_root); return -1; }
	cJSON *json_func = cJSON_Get(json_root, "func", cJSON_Number); if (json_func == NULL) { cJSON_Delete(json_root); return -1; }
	cJSON *json_token = cJSON_Get(json_root, "token", cJSON_Number); if (json_token == NULL) { cJSON_Delete(json_root); return -1; }
	cJSON *json_msn = cJSON_Get(json_root, "msn", cJSON_Number); if (json_msn == NULL) { cJSON_Delete(json_root); return -1; }
	cJSON *json_when = cJSON_Get(json_root, "when", cJSON_Number); if (json_when == NULL) { cJSON_Delete(json_root); return -1; }
	*/
	cJSON *json_result = cJSON_GetObjectItem(json_root, "result");
	if (json_result == NULL || (json_result->type != cJSON_String && json_result->type != cJSON_Array && json_result->type != cJSON_Object))
	{
		log_warn("Message field [ params ] parse error."); 
		cJSON_Delete(json_root);
		inm_header->inm_header.status = SYS_RESULT_T_HTTP_TIMEOUT;
		return 1;
	}

	cJSON *json_balance = cJSON_Get(json_result, "balance", cJSON_Number);
	if (json_balance == NULL)
	{
		log_warn("Message cJSON_Get balance error!");
		inm_header->inm_header.status = SYS_RESULT_T_HTTP_TIMEOUT;
		return 1;
	}

	switch (inm_header->inm_header.type)
	{
	case INM_TYPE_T_SELL_TICKET:
	{
		INM_MSG_T_SELL_TICKET *pInm = (INM_MSG_T_SELL_TICKET *)inm_buf;
		pInm->availableCredit = json_balance->valuedouble;
		break;
	}
	case INM_TYPE_T_PAY_TICKET:
	{
		INM_MSG_T_PAY_TICKET *pInm = (INM_MSG_T_PAY_TICKET *)inm_buf;
		pInm->availableCredit = json_balance->valuedouble;
		break;
	}
	case INM_TYPE_T_CANCEL_TICKET:
	{
		INM_MSG_T_CANCEL_TICKET *pInm = (INM_MSG_T_CANCEL_TICKET *)inm_buf;
		pInm->availableCredit = json_balance->valuedouble;
		break;
	}
	case INM_TYPE_O_PAY_TICKET:
	{
		INM_MSG_O_PAY_TICKET *pInm = (INM_MSG_O_PAY_TICKET *)inm_buf;
		pInm->availableCredit = json_balance->valuedouble;
		break;
	}
	case INM_TYPE_O_CANCEL_TICKET:
	{
		INM_MSG_O_CANCEL_TICKET *pInm = (INM_MSG_O_CANCEL_TICKET *)inm_buf;
		pInm->availableCredit = json_balance->valuedouble;
		break;
	}

	default:
		log_warn("unknow inm message type[%d]", inm_header->inm_header.type);
		break;
	}
	cJSON_Delete(json_root);
	return 0;
}

static int process_saleTicket(char * buf)
{
	int ret = 0;
	int jt = 0;
	bool rk_back = false;
    INM_MSG_T_SELL_TICKET* pInm = (INM_MSG_T_SELL_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=pInm->header.inm_header.status) || (pInm->ticket.isTrain))
        return 0;

    pthread_mutex_lock(&mutex);
    //在这里保护验证一下，售票的期次是否已关闭
    ISSUE_INFO* issue_ptr = game_plugins_handle[pInm->ticket.gameCode].get_issueInfo(pInm->ticket.issue);
    if ((NULL==issue_ptr) || (issue_ptr->localState>=ISSUE_STATE_CLOSED))
    {
        pInm->header.inm_header.status = SYS_RESULT_SELL_NOISSUE_ERR;
        pthread_mutex_unlock(&mutex);
        return 0;
    }

    //游戏风险控制
    if ( (isGameBeRiskControl(pInm->ticket.gameCode)) &&
        (NULL!=game_plugins_handle[pInm->ticket.gameCode].sale_rk_verify) )
	{
	    ret = game_plugins_handle[pInm->ticket.gameCode].sale_rk_verify(&pInm->ticket);
        if (false == ret)
        {
            pInm->header.inm_header.status = SYS_RESULT_RISK_CTRL_ERR;
            pthread_mutex_unlock(&mutex);
            return 0;
        }
    }
    pthread_mutex_unlock(&mutex);

    //http 向资金管理系统验证销售
	char reqmsg[256] = { 0 };
	inm2json(buf, reqmsg);
	char recvbuf[2048] = { 0 };
	ret = call_http_service(fund_server_ip, fund_server_port, strlen(reqmsg), reqmsg, http_timeout, recvbuf);

	if (ret > 0)
	{
		if (ret == 2) // timeout
		{
			log_error("call_http_service timeout!");
			pInm->header.inm_header.status = SYS_RESULT_T_HTTP_TIMEOUT;
		}
		else
		{
			log_error("call_http_service error:[%d]", ret);
			pInm->header.inm_header.status = SYS_RESULT_FAILURE;
		}
		rk_back = true;
	}
	else
	{
		log_debug("call_http_service ok. recv[%s]", recvbuf);
		jt = jsonStrParse(buf, recvbuf);
		if (jt == 0)
			log_debug("jsonStrParse ok!\n");
		else
		{
			log_debug("jsonStrParse jt=[%d] \n", jt);
			rk_back = true;
		}
	}

	if (rk_back)
	{
		pthread_mutex_lock(&mutex);
		if ((isGameBeRiskControl(pInm->ticket.gameCode)) &&
			(NULL != game_plugins_handle[pInm->ticket.gameCode].cancel_rk_rollback))
		{
			game_plugins_handle[pInm->ticket.gameCode].cancel_rk_rollback(&pInm->ticket);
		}
		pthread_mutex_unlock(&mutex);
	}


    return 0;
}



static int process_payTicket(char * buf)
{
    int ret = 0;
    INM_MSG_T_PAY_TICKET* pInm = (INM_MSG_T_PAY_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=pInm->header.inm_header.status) || (pInm->isTrain))
        return 0;

    //http 向资金管理系统验证兑奖
	char reqmsg[256] = { 0 };
	inm2json(buf, reqmsg);
	char recvbuf[2048] = { 0 };
	ret = call_http_service(fund_server_ip, fund_server_port, strlen(reqmsg), reqmsg, http_timeout, recvbuf);
	if (ret > 0)
	{
		if (ret == 2) // timeout
		{
			log_error("call_http_service timeout!");
			pInm->header.inm_header.status = SYS_RESULT_T_HTTP_TIMEOUT;
		}
		else
		{
			log_error("call_http_service error:[%d]", ret);
			pInm->header.inm_header.status = SYS_RESULT_FAILURE;
		}
	}
	else
	{
		log_debug("call_http_service ok. recv[%s]", recvbuf);
		int jt = jsonStrParse(buf, recvbuf);
		if (jt == 0)
			log_debug("jsonStrParse ok!\n");
		else
		{
			log_debug("jsonStrParse jt=[%d] \n", jt);
		}
	}
    return 0;
}



static int process_oms_payTicket(char * buf)
{
	int ret = 0;
    INM_MSG_O_PAY_TICKET* pInm = (INM_MSG_O_PAY_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=pInm->header.inm_header.status) || (pInm->isTrain))
        return 0;

    //http 向资金管理系统验证中心兑奖
	char reqmsg[256] = { 0 };
	inm2json(buf, reqmsg);
	char recvbuf[2048] = { 0 };
	ret = call_http_service(fund_server_ip, fund_server_port, strlen(reqmsg), reqmsg, http_timeout, recvbuf);
	if (ret > 0)
	{
		if (ret == 2) // timeout
		{
			log_error("call_http_service timeout!");
			pInm->header.inm_header.status = SYS_RESULT_T_HTTP_TIMEOUT;
		}
		else
		{
			log_error("call_http_service error:[%d]", ret);
			pInm->header.inm_header.status = SYS_RESULT_FAILURE;
		}
	}
	else
	{
		log_debug("call_http_service ok. recv[%s]", recvbuf);
		int jt = jsonStrParse(buf, recvbuf);
		if (jt == 0)
			log_debug("jsonStrParse ok!\n");
		else
		{
			log_debug("jsonStrParse jt=[%d] \n", jt);
		}
	}

    return 0;
}

static int process_cancelTicket(char * buf)
{
    int ret = 0;
    INM_MSG_T_CANCEL_TICKET* pInm = (INM_MSG_T_CANCEL_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=pInm->header.inm_header.status) || (pInm->ticket.isTrain))
        return 0;

    //http 向资金管理系统验证退票
	char reqmsg[256] = { 0 };
	inm2json(buf, reqmsg);
	char recvbuf[2048] = { 0 };
	ret = call_http_service(fund_server_ip, fund_server_port, strlen(reqmsg), reqmsg, http_timeout, recvbuf);
	if (ret > 0)
	{
		if (ret == 2) // timeout
		{
			log_error("call_http_service timeout!");
			pInm->header.inm_header.status = SYS_RESULT_T_HTTP_TIMEOUT;
		}
		else
		{
			log_error("call_http_service error:[%d]", ret);
			pInm->header.inm_header.status = SYS_RESULT_FAILURE;
		}
	}
	else
	{
		log_debug("call_http_service ok. recv[%s]", recvbuf);
		int jt = jsonStrParse(buf, recvbuf);
		if (jt == 0)
			log_debug("jsonStrParse ok!\n");
		else
		{
			log_debug("jsonStrParse jt=[%d] \n", jt);
		}
	}

    pthread_mutex_lock(&mutex);
    if ( (isGameBeRiskControl(pInm->ticket.gameCode)) &&
        (NULL!=game_plugins_handle[pInm->ticket.gameCode].cancel_rk_rollback) )
	{
	    game_plugins_handle[pInm->ticket.gameCode].cancel_rk_rollback(&pInm->ticket);
    }
    pthread_mutex_unlock(&mutex);
    return 0;
}

static int process_oms_cancelTicket(char * buf)
{
    int ret = 0;
    INM_MSG_O_CANCEL_TICKET* pInm = (INM_MSG_O_CANCEL_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=pInm->header.inm_header.status) || (pInm->isTrain))
        return 0;

    //http 向资金管理系统验证中心退票
	char reqmsg[256] = { 0 };
	inm2json(buf, reqmsg);
	char recvbuf[2048] = { 0 };
	ret = call_http_service(fund_server_ip, fund_server_port, strlen(reqmsg), reqmsg, http_timeout, recvbuf);
	if (ret > 0)
	{
		if (ret == 2) // timeout
		{
			log_error("call_http_service timeout!");
			pInm->header.inm_header.status = SYS_RESULT_T_HTTP_TIMEOUT;
		}
		else
		{
			log_error("call_http_service error:[%d]", ret);
			pInm->header.inm_header.status = SYS_RESULT_FAILURE;
		}
	}
	else
	{
		log_debug("call_http_service ok. recv[%s]", recvbuf);
		int jt = jsonStrParse(buf, recvbuf);
		if (jt == 0)
			log_debug("jsonStrParse ok!\n");
		else
		{
			log_debug("jsonStrParse jt=[%d] \n", jt);
		}
	}

    pthread_mutex_lock(&mutex);
    if ( (isGameBeRiskControl(pInm->gameCode)) &&
        (NULL!=game_plugins_handle[pInm->gameCode].cancel_rk_rollback) )
	{
	    game_plugins_handle[pInm->ticket.gameCode].cancel_rk_rollback(&pInm->ticket);
    }
    pthread_mutex_unlock(&mutex);
    return 0;
}

static int process_agencyMarginalCredit(char * buf)
{
    ts_notused(buf);
#if 0
    int ret = 0;
    INM_MSG_O_AGENCY_MARGINALCREDIT* pInm = (INM_MSG_O_AGENCY_MARGINALCREDIT*)buf;

    money_t amount = 0;
    ret = tms_mgr()->marginalCreditForAdder(pInm->agencyIndex, pInm->marginalCreditLimit, pInm->tempMarginalCreditLimit, &amount);
    if (ret != SYS_RESULT_SUCCESS)
    {
        pInm->header.inm_header.status = ret;
        return 0;
    }
    pInm->availableCredit = amount;
#endif
    return 0;
}

static int process_agencyDeposit(char * buf)
{
    ts_notused(buf);
#if 0
    int ret = 0;
    INM_MSG_O_AGNECY_DEPOSITAMOUNT* pInm = (INM_MSG_O_AGNECY_DEPOSITAMOUNT*)buf;

    money_t amount = 0;
    ret = tms_mgr()->depositForAdder(pInm->agencyIndex, pInm->depositAmount, &amount);
    if (ret != SYS_RESULT_SUCCESS)
    {
        pInm->header.inm_header.status = ret;
        return 0;
    }
    pInm->availableCredit = amount;
#endif
    return 0;
}


static void tfe_adder_dispatcher(char *inm_buf)
{
    INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;
    pInm->version = sysdb_version();
    switch (pInm->type)
    {
        case INM_TYPE_T_SELL_TICKET:
            process_saleTicket(inm_buf);
            break;

        case INM_TYPE_T_PAY_TICKET:
            process_payTicket(inm_buf);
            break;
        case INM_TYPE_O_PAY_TICKET:
            process_oms_payTicket(inm_buf);
            break;

        case INM_TYPE_T_CANCEL_TICKET:
            process_cancelTicket(inm_buf);
            break;
        case INM_TYPE_O_CANCEL_TICKET:
            process_oms_cancelTicket(inm_buf);
            break;

        case INM_TYPE_O_TMS_AGENCY_MARGINALCREDIT:
            process_agencyMarginalCredit(inm_buf);
            break;

        case INM_TYPE_O_TMS_AGNECY_DEPOSITAMOUNT:
            process_agencyDeposit(inm_buf);
            break;

        case INM_TYPE_SYS_SWITCH_SESSION:
        {
            //清除销售站零时信用额度
            //tms_mgr()->cleanAgencyTmpMarginalCredit(0);
            break;
        }
        case INM_TYPE_TFE_CHECK_POINT:
        {
            if (pInm->status == 0xFFFF)
            {
                //safe close checkpoint
                exit_signal_fired = 1;
            }
            break;
        }
        default:
            break;
    }
    return;
}

static void tfe_adder_generate_tsn(char *inm_buf)
{
    INM_MSG_HEADER *pInmHeader = (INM_MSG_HEADER *)inm_buf;
    tfe_t_file_offset(&pInmHeader->tfe_file_idx, &pInmHeader->tfe_offset);
    time_t curtime = 0;
    time(&curtime);
    pInmHeader->tfe_when = (uint32)curtime;
    struct tm lt;
    localtime_r(&curtime, &lt);
    uint32 date = (lt.tm_year+1900)*10000 + (lt.tm_mon+1)*100 + lt.tm_mday;

    switch (pInmHeader->type)
    {
        case INM_TYPE_T_SELL_TICKET: {
            INM_MSG_T_SELL_TICKET* pInmSell = (INM_MSG_T_SELL_TICKET*)pInmHeader;
            pInmSell->unique_tsn = generate_digit_tsn(date, pInmSell->header.inm_header.tfe_file_idx, pInmSell->header.inm_header.tfe_offset);
        	generate_tsn(pInmSell->unique_tsn, pInmSell->rspfn_ticket);
            break;
        }
        case INM_TYPE_T_PAY_TICKET: {
            INM_MSG_T_PAY_TICKET* pInmPay = (INM_MSG_T_PAY_TICKET*)pInmHeader;
            pInmPay->unique_tsn_pay = generate_digit_tsn(date, pInmPay->header.inm_header.tfe_file_idx, pInmPay->header.inm_header.tfe_offset);
        	generate_tsn(pInmPay->unique_tsn_pay, pInmPay->rspfn_ticket_pay);
            break;
        }
        case INM_TYPE_O_PAY_TICKET: {
            INM_MSG_O_PAY_TICKET* pInmOmsPay = (INM_MSG_O_PAY_TICKET*)pInmHeader;
            pInmOmsPay->unique_tsn_pay = generate_digit_tsn(date, pInmOmsPay->header.inm_header.tfe_file_idx, pInmOmsPay->header.inm_header.tfe_offset);
        	generate_tsn(pInmOmsPay->unique_tsn_pay, pInmOmsPay->rspfn_ticket_pay);
        	break;
        }
        case INM_TYPE_T_CANCEL_TICKET: {
            INM_MSG_T_CANCEL_TICKET* pInmCancel = (INM_MSG_T_CANCEL_TICKET*)pInmHeader;
            pInmCancel->unique_tsn_cancel = generate_digit_tsn(date, pInmCancel->header.inm_header.tfe_file_idx, pInmCancel->header.inm_header.tfe_offset);
        	generate_tsn(pInmCancel->unique_tsn_cancel, pInmCancel->rspfn_ticket_cancel);
            break;
        }
        case INM_TYPE_O_CANCEL_TICKET: {
            INM_MSG_O_CANCEL_TICKET* pInmOmsCancel = (INM_MSG_O_CANCEL_TICKET*)pInmHeader;
            pInmOmsCancel->unique_tsn_cancel = generate_digit_tsn(date, pInmOmsCancel->header.inm_header.tfe_file_idx, pInmOmsCancel->header.inm_header.tfe_offset);
        	generate_tsn(pInmOmsCancel->unique_tsn_cancel, pInmOmsCancel->rspfn_ticket_cancel);
            break;
        }
        default: {
            break;
        }
    }
    return;
}

void *adder_process_thread(void *arg)
{
    ts_notused(arg);
    int len = 0;
    char inm_buf[INM_MSG_BUFFER_LENGTH] = {0};
    while (0 == exit_signal_fired) {
        len = bq_recv(fid, inm_buf, INM_MSG_BUFFER_LENGTH, 500);
        if (len < 0) {
            log_error("bq_recv() len < 0.");
            break;
        } else if (len == 0) {
            //receive timeout
            continue;
        }
        tfe_adder_dispatcher(inm_buf);

        INM_MSG_HEADER *pInmHeader = (INM_MSG_HEADER *)inm_buf;
        char *inm_msg = (char*)malloc(pInmHeader->length);
        memcpy(inm_msg,inm_buf,pInmHeader->length);
        mque_item *item = (mque_item*)malloc(sizeof(mque_item));
        item->ptr = inm_msg;
        q->enqueue(q, item);
    }
    log_error("adder_process_thread process failure. exit");
    return 0;
}

static void signal_handler(int sig)
{
    ts_notused(sig);
    exit_signal_fired = 1;

    return;
}

static int init_signal(void)
{
    signal(SIGPIPE, SIG_IGN);

    struct sigaction sas;
    memset(&sas, 0, sizeof(sas));
    sas.sa_handler = signal_handler;
    sigemptyset(&sas.sa_mask);
    sas.sa_flags |= SA_INTERRUPT;
    if (sigaction(SIGINT, &sas, NULL) == -1)
    {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }

    if (sigaction(SIGTERM, &sas, NULL) == -1)
    {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }
    return 0;
}

int main(int argc, char *argv[])
{
    ts_notused(argc);
    ts_notused(argv);

    int pid = -1;

    logger_init(MY_TASK_NAME);

    int ret = init_signal();
    if (0 != ret)
    {
        log_error("init_signal() failed.");
        return -1;
    }

    pid = getpid();

    log_info("%s start\n", MY_TASK_NAME);

    if (!sysdb_init())
    {
        log_error("sysdb_init() failed.");
        return -1;
    }

    if (!bq_init())
    {
        sysdb_close();
		log_error("bq_init() failed.");
        return -1;
    }

    if (!tms_mgr()->TMSInit())
    {
        sysdb_close();
		bq_close();
        log_error("tms_mgr()->TMSInit() failed.");
        return -1;
    }

    if (!gl_init())
    {
        sysdb_close();
		bq_close();
        log_error("gl_init() failed.");
        return -1;
    }

    if (gl_game_plugins_init()!=0)
    {
        sysdb_close();
		bq_close();
        log_error("gl_game_plugins_init() failed.");
        return -1;
    }
    game_plugins_handle = gl_plugins_handle();

    char follow_str[128];
    sprintf(follow_str, "%d", TFE_TASK_FLUSH);
	ret = tfe_t_init(TFE_TASK_ADDER, 0, follow_str, false);
    if (0!=ret)
    {
        sysdb_close();
		bq_close();
		gl_close();		
        log_error("tfe_t_init() failed.");
        return -1;
    }

    fid = getFidByName(MY_TASK_NAME);
    if (!bq_register(fid, MY_TASK_NAME, pid))
    {
        sysdb_close();
		bq_close();
		gl_close();
		log_error("bq_register() failed.");
        return -1;
    }

    q = mque_create();
    if (NULL == q) {
        sysdb_close();
		bq_close();
		gl_close();
        log_error("mque_create() failed.");
        return -1;
    }

	SYS_DATABASE_PTR sysdb = sysdb_getDatabasePtr();
	memcpy(fund_server_ip, sysdb->fund_server_ip, strlen(sysdb->fund_server_ip));
	fund_server_port = sysdb->fund_server_port;
        
    //创建线程
    pthread_t   threadId;
    for (int i=0;i<thread_count;i++) {
        ret = pthread_create(&threadId, NULL, adder_process_thread, NULL);
        if(ret!=0) {
            sysdb_close(); bq_close(); gl_close();
            log_error("Start adder_process_thread failure.");
            return -1;
        }
    }

    sysdb_setTaskStatus(SYS_TASK_TFE_ADDER, SYS_TASK_STATUS_RUN);
    log_info("%s init success\n", MY_TASK_NAME);

    static char inm_buf[INM_MSG_BUFFER_LENGTH] = {0};
    mque_item* item = NULL;
    while (0 == exit_signal_fired)
    {
        item = q->dequeue(q,500);
        if (NULL == item)
            continue;

        INM_MSG_HEADER *pInmMsg = (INM_MSG_HEADER *)item->ptr;
        memcpy(inm_buf+TFE_HEADER_LENGTH,(char*)pInmMsg,pInmMsg->length);
        free(item->ptr); free(item);
        pInmMsg = (INM_MSG_HEADER *)(inm_buf+TFE_HEADER_LENGTH);

        tfe_adder_generate_tsn((char*)pInmMsg);
        while(1) {
        	ret = tfe_t_write((const unsigned char *)inm_buf, (TFE_HEADER_LENGTH+pInmMsg->length));
            if (ret == TFE_TIMEOUT) {
            	tfe_adder_generate_tsn((char*)pInmMsg);
                log_debug("tfe_adder append TFE_TIMEOUT. ret [%d]", ret);
                continue;
            } else if (ret < 0) {
            	log_warn("tfe_adder append record failed. ret [%d]", ret);
            	ts_sleep(100*1000,0);
            	continue;
            }
            break;
        }
    }

    sysdb_setTaskStatus(SYS_TASK_TFE_ADDER, SYS_TASK_STATUS_EXIT);

    bq_unregister(fid);

    gl_game_plugins_close();
    game_plugins_handle = NULL;

	gl_close();	

	tms_mgr()->TMSClose();

    bq_close();

    sysdb_close();

    if (1 == exit_signal_fired)
    {
        log_info("exit signal fired.");
    }

    log_info("%s exit\n", MY_TASK_NAME);
    return 0;
}




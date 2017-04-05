#include "global.h"
#include "otlPool.h"


using namespace std;
unsigned int otlPool::total_con_cout = 0;
otlPool* otlPool::p_conn_pool = new otlPool();
otlPool* otlPool::create_conn_pool()
{
	return p_conn_pool;
}


otlPool::otlPool(void)
{
	p_con_list = NULL;
	max_con_count = 3;
	min_con_count = 2;
	b_startup = false;
    forward = true;
    pthread_mutex_init(&(this->mutex), NULL);
	otl_connect::otl_initialize(1); //线程模型
}


otlPool::~otlPool(void)
{
	otl_destroy();
    pthread_mutex_destroy(&(this->mutex));
	otl_connect::otl_terminate();
}

int otlPool::init_pool(std::string user_name, std::string pwd, std::string tns, unsigned int max_conn, unsigned int min_conn)
{
	user_name = user_name;
	pwd = pwd;
	tns = tns;
	max_con_count = (max_conn > DEFAULT_CON_COUNT) ? max_conn : DEFAULT_CON_COUNT;
	min_con_count = (min_conn > DEFAULT_CON_COUNT) ? min_conn : DEFAULT_CON_COUNT;
	conn_str = user_name + "/" + pwd + "@" + tns;
	try
	{
		if (otl_malloc_conn() != 0)
		{
			log_debug("%s\n", "otlPool Init Error");
			abort();
		}
		pthread_t localThreadId;
		if (0 != pthread_create(&localThreadId, NULL, otl_thread_fun, this))
			abort();

		b_startup = true;
		sleep(1);
	}
	catch (otl_exception& e)
	{
		log_error("otlPool::init_pool msg[%s]", e.msg);
		log_error("otlPool::init_pool text[%s]", e.stm_text);
		log_error("otlPool::init_pool info[%s]", e.var_info);
		return -1;
	}
	catch (std::exception&e)
	{
		log_error("otlPool::init_pool what[%s]", e.what());
		return -1;
	}
	return 0;
}

otl_connect* otlPool::get_connect()
{
	int use = 0;
	otl_connect* pconn = NULL;
	otl_lock();
    if (forward)
    {
        otl_con_list::iterator it = p_con_list->begin();
        while (it != p_con_list->end())
        {
            use = it->second.used;
            pconn = it->first;
            if (use == 0)
            {
                it->second.used = 1;
                forward = false;
                otl_unlock();
                return pconn;
            }
            ++it;
            pconn = NULL;
        }
    }
    else
    {
        otl_con_list::reverse_iterator  it = p_con_list->rbegin();
        while (it != p_con_list->rend())
        {
            use = it->second.used;
            pconn = it->first;
            if (use == 0)
            {
                it->second.used = 1;
                forward = true;
                otl_unlock();
                return pconn;
            }
            ++it;
            pconn = NULL;
        }
    }
    log_debug("otlPool::get_connect find no db connect, create new...");
	// apply one connect from DB if map of pool is NULL
	if (pconn == NULL && (p_con_list->size() < max_con_count))
	{
		try
		{
			pconn = new otl_connect;
			if (NULL == pconn)
			{
				otl_unlock();
				log_error("otlPool::get_connect new otl_connect fail may be not memory");
				return NULL;
			}
			pconn->rlogon(this->conn_str.c_str(), 1);
		}
		catch (otl_exception& e)
		{
			delete pconn;
			pconn = NULL;
			log_error("otlPool::get_connect msg[%s]", e.msg);
			log_error("otlPool::get_connect text[%s]", e.stm_text);
			log_error("otlPool::get_connect info[%s]", e.var_info);
		}
		if (pconn)
		{
			dbconn_stat st = { 1, time(NULL) };
			p_con_list->insert(otl_con_list::value_type(pconn, st));
			otl_unlock();
			log_debug("otlPool::get_connect new connect");
			return pconn;
		}

	}
	otl_unlock();
	log_error("pool had empty");
	return NULL;
}

int otlPool::release_conn(otl_connect* pconn, bool is_delete_conn)
{

	if (pconn == NULL)
	{
		return 0;
	}
	otl_lock();
	otl_con_list::iterator it = p_con_list->find(pconn);
	if (it != p_con_list->end())
	{
		if (is_delete_conn == false)
		{
			it->second.used = 0;
			it->second.lastusd = time(NULL);
			otl_unlock();
            log_debug("otlPool::release_conn release");
			return 0;
		}
		try
		{
			p_con_list->erase(pconn);
			pconn->logoff();
			delete pconn;
			pconn = NULL;

		}
		catch (otl_exception&e)
		{
			delete pconn;
			pconn = NULL;
            otl_unlock();
			log_error("otlPool::release_conn msg[%s]", e.msg);
			log_error("otlPool::release_conn text[%s]", e.stm_text);
			log_error("otlPool::release_conn info[%s]", e.var_info);

			return -1;
		}
	}
	otl_unlock();
	return 0;
}


int otlPool::otl_malloc_conn()
{
	otl_connect* pcon = NULL;
	otl_lock();
	if (this->p_con_list == NULL)
	{
		this->p_con_list = new otl_con_list();
	}

	while (this->p_con_list->size() < max_con_count)
	{
		try
		{
			pcon = new otl_connect();
			if (pcon == NULL)
			{
				otl_unlock();
				log_error("new otl_connect fail may be not memory");
				return -1;
			}
			pcon->rlogon(this->conn_str.c_str(), 1);
		}
		catch (otl_exception&e)
		{
			delete pcon;
			pcon = NULL;
			otl_unlock();
			log_error("otlPool::otl_malloc_conn msg[%s]", e.msg);
			log_error("otlPool::otl_malloc_conn text[%s]", e.stm_text);
			log_error("otlPool::otl_malloc_conn info[%s]", e.var_info);
			return -1;
		}
		dbconn_stat st = { 0, time(NULL) };
		this->p_con_list->insert(otl_con_list::value_type(pcon, st));
	}
	otl_unlock();
	return 0;
}

bool otlPool::otl_check_conn(otl_connect* pconn)
{
	int ret = -1;
	try
	{
		otl_stream stream;
		stream.open(1, "select 1 from dual", *pconn);
		if (!stream.eof())
		{
			stream >> ret;
		}
		stream.close();
	}

	catch (otl_exception& e)
	{
		log_error("otlPool::otl_check_conn msg[%s]", e.msg);
		log_error("otlPool::otl_check_conn text[%s]", e.stm_text);
		log_error("otlPool::otl_check_conn info[%s]", e.var_info);
		return false;
	}
	return ret == 1 ? true : false;
}

void* otlPool::otl_thread_fun(void* arg)
{
	otlPool* p_pool = static_cast<otlPool*>(arg);
	assert(p_pool);

	while (p_pool->b_startup == true)
	{
		otl_refresh_pool(p_pool);
		sleep(1);
	}
	p_pool->otl_lock();
	if (p_pool->p_con_list != NULL)
	{
		delete p_pool->p_con_list;
		p_pool->p_con_list = NULL;
	}
	p_pool->otl_unlock();
	return (void *)NULL;
}


void otlPool::otl_refresh_pool(void * pParam)
{
	otlPool * pool = static_cast<otlPool*>(pParam);
	int use;
	int ret = 0;

	int used = 0;
	int no_used = 0;
	int total = 0;

	otl_connect* pconn = NULL;
	pool->otl_lock();

	otl_con_list::iterator ck = pool->p_con_list->begin();
	while (ck != pool->p_con_list->end())
	{
		total++;
		use = ck->second.used;
		pconn = ck->first;

		if (use == 0)
		{
			no_used++;
            if (time(NULL) - ck->second.lastusd >= REFRESH_INTER_SENCOND)
            {
                if (!pool->otl_check_conn(pconn))
                {
                    pool->p_con_list->erase(ck);
                    if (pconn != NULL)
                    {
                        delete pconn;
                        pconn = NULL;
                    }
                    log_warn("one db connect failure.");
                    ck++;
                }
                else
                {
                    ck->second.lastusd = time(NULL);
                    ck++;
                }
                ret++;
            }
            else
            {
                ck++;
            }
		}
		else
		{
            ck++;
			used++;
		}
	}

	if (pool->p_con_list->size() < pool->max_con_count)
	{
		try
		{
			pconn = new otl_connect;
			if (NULL == pconn)
			{
				pool->otl_unlock();
				log_error("new otl_connect failure");
				return;
			}
			pconn->rlogon(pool->conn_str.c_str(), 1);
		}
		catch (otl_exception& e)
		{
			delete pconn;
			pconn = NULL;
			log_error("otlPool::otl_refresh_pool msg[%s]", e.msg);
			log_error("otlPool::otl_refresh_pool text[%s]", e.stm_text);
			log_error("otlPool::otl_refresh_pool info[%s]", e.var_info);
		}
		if (pconn)
		{
			dbconn_stat st = { 0, time(NULL) };
			pool->p_con_list->insert(otl_con_list::value_type(pconn, st));
			no_used++;
		}
	}

	pool->otl_unlock();
	if (ret > 0)
	{
		log_debug("DB pool counts:%d,used:%d,free:%d ret:%d", total, used, no_used,ret);
		return;
	}
    return;
}

void otlPool::otl_destroy()
{
	otl_lock();
	//log_debug("otl_destroy lock\n");
	otl_con_list::iterator it = p_con_list->begin();
	otl_connect* pconn = NULL;
	while (it != p_con_list->end())
	{
		pconn = it->first;
		p_con_list->erase(pconn);
		if (pconn->connected)
		{
			pconn->logoff();
		}
		delete pconn;
		pconn = NULL;
		it = p_con_list->begin();
	}

	b_startup = false;
	otl_unlock();
	//log_debug("otl_destroy unlock\n");

}
void otlPool::otl_lock()
{
	pthread_mutex_lock(&(this->mutex));

}
void otlPool::otl_unlock()
{
	pthread_mutex_unlock(&(this->mutex));
}

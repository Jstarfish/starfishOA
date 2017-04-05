#ifndef  _OTLPOOL_H_
#define  _OTLPOOL_H_

#define OTL_NO_THROW
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


#include "otlv4.h"

class otl_connect;

/************************************************************************/
/* OTL连接池单例模式												    */
/************************************************************************/
typedef struct _dbconn_stat
{
	int  used;
	time_t lastusd;
}dbconn_stat;

typedef std::map<otl_connect*, dbconn_stat>   otl_con_list;   //连接链表
#define  DEFAULT_CON_COUNT          2                         //缺省的连接个数
#define  REFRESH_INTER_MINUTE		3                         //每隔REFRESH_INTER分钟刷新连接池的连接防止和数据库断掉
#define  REFRESH_INTER_SENCOND      (60 * REFRESH_INTER_MINUTE)


class otlPool
{
public:
	otlPool(void);
	~otlPool(void);
public:
	int init_pool(std::string user_name,std::string pwd,std::string tns,unsigned int max_conn, unsigned int min_conn );
	otl_connect* get_connect();
	int release_conn(otl_connect* pconn,bool is_delete_conn=false);
	void otl_destroy();
	static otlPool* create_conn_pool();

private:
	void otl_lock();
	void otl_unlock();
	int otl_malloc_conn();
	bool otl_check_conn(otl_connect* pconn);
	static void otl_refresh_pool(void * arg); //线程处理函数刷新连接池
	static void* otl_thread_fun(void* arg);//线程函数

private:
	unsigned int max_con_count; //最大连接个数
	unsigned int min_con_count; //最小连接个数
	static unsigned int total_con_cout;	//总共创建的连接个数
	otl_con_list* p_con_list;
	static otlPool* p_conn_pool;
	std::string user_name;
	std::string pwd;
	std::string tns;
	std::string conn_str;
	pthread_mutex_t mutex;
	bool b_startup;//是否启动
    bool forward;
};


#endif

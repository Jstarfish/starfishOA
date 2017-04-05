#ifndef NCPCMOD_H_INCLUDED
#define NCPCMOD_H_INCLUDED

#include "ncpc_inf.h"


int ncpc_loadConf(const char *xmlFileName);
cJSON *cJSON_Get(cJSON *object, const char *string, int dt);

//-------------NOTIFY INTERFACE--------------------
#if R("---NCPC notify interface---")

int32 ncpc_notify_link(NCP_RECORD *pNcpRec);

#endif



#endif


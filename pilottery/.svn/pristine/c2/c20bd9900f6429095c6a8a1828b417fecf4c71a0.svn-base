#ifndef GL_KOC7LX_MATCH_H_
#define GL_KOC7LX_MATCH_H_


int gl_koc7lx_createDrawnum(
        const uint8 xcode[], 
        uint8 len);

int gl_koc7lx_betlineSelect(
        const BETLINE *betline,
        GL_KOC7LX_SELECTNUM &selNum);

int gl_koc7lx_FSPartMatch(
        const GL_BETPART *bp,
        const GL_KOC7LX_DRAWNUM *drawnum,
        GL_KOC7LX_MATCHNUM &matchNum);

int gl_koc7lx_DTPartMatch(
        const GL_BETPART *bp,
        const GL_KOC7LX_DRAWNUM *drawnum,
        GL_KOC7LX_MATCHNUM &matchNum);

int gl_koc7lx_betpartMatch(
        uint8 bettype,
        const GL_BETPART *bp,
        const GL_KOC7LX_DRAWNUM *drawnum,
        GL_KOC7LX_MATCHNUM &matchNum);

int gl_koc7lx_betlineMatch(
        SUBTYPE_PARAM *subtype,
        DIVISION_PARAM *division,
        const BETLINE *betline,
        uint32 matchRet[]);

int gl_koc7lx_ticketMatch(
        const TICKET *ticket, 
        const char *subtype, 
        const char *division, 
        uint32 matchRet[]);

#endif /* GL_KOC7LX_MATCH_H_ */



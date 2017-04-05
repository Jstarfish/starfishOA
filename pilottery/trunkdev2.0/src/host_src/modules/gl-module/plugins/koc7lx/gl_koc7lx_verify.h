#ifndef GL_KOC7LX_VERIFY_H_
#define GL_KOC7LX_VERIFY_H_

//----VERIFY----//
int gl_koc7lx_ticketVerify(const TICKET *ticket);

int gl_koc7lx_betlineVerify(const BETLINE *betline);

int gl_koc7lx_betpartVerify(
        uint8 bettype,
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_koc7lx_DSPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_koc7lx_FSPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_koc7lx_DTPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);



//----BETLINE COUNT----//
int gl_koc7lx_betlineCount(
        const BETLINE *betline);

int gl_koc7lx_betpartCount(
        uint8 bettype,
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_koc7lx_FSbetCount(
             const GL_BETPART* bp,
             const SUBTYPE_PARAM* subparam);

int gl_koc7lx_DTbetCount(
             const GL_BETPART* bp,
             const SUBTYPE_PARAM* subparam);

#endif /* GL_KOC7LX_VERIFY_H_ */



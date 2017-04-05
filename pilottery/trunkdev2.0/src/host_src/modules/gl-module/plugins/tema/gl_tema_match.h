/*
 * gl_tema_match.h
 *
 *  Created on: 2011-6-30
 *      Author: Administrator
 */

#ifndef GL_KOC_MATCH_H_
#define GL_TEMA_MATCH_H_

int gl_tema_createDrawnum(const uint8 xcode[], uint8 len);
int gl_tema_ticketMatch(const TICKET *ticket, const char *subtype, const char *division, uint32 matchRet[]);
int gl_tema_betlineMatch(SUBTYPE_PARAM* subtype, DIVISION_PARAM *division, const BETLINE *betline, uint32 matchRet[]);
int gl_tema_betpartMatch(
				 uint8 bettype,
				 uint8 flagAB, //0£ºAÇø  1£ºBÇø
				 const GL_BETPART *bp,
				 const GL_TEMA_DRAWNUM *drawnum,
				 const DIVISION_PARAM *division,
				 GL_TEMA_MATCHNUM &matchNum);
int gl_tema_FSPartMatch(
			  uint8 flagAB,
			  const GL_BETPART *bp,
			  const GL_TEMA_DRAWNUM *drawnum,
			  const DIVISION_PARAM *division,
			  GL_TEMA_MATCHNUM &matchNum);

#endif /* GL_TEMA_MATCH_H_ */

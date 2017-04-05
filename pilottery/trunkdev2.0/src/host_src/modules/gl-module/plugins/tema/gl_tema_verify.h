/*
 * gl_tema_verify.h
 *
 *  Created on: 2011-6-30
 *      Author: Administrator
 */

#ifndef GL_TEMA_VERIFY_H_
#define GL_TEMA_VERIFY_H_


int gl_tema_ticketVerify(const TICKET* ticket);
int gl_tema_betlineVerify(const BETLINE* betline);
int gl_tema_betpartVerify(
	    uint8 bettype,
	    uint8 flagAB, //0£ºAÇø  1£ºBÇø
	    const GL_BETPART* bp,
	    const SUBTYPE_PARAM* subparam);
int gl_tema_DSPartVerify(
		uint8 flagAB,
   		const GL_BETPART* bp,
		const SUBTYPE_PARAM* subparam);
int gl_tema_FSPartVerify(
		uint8 flagAB,
   		const GL_BETPART* bp,
		const SUBTYPE_PARAM* subparam);


////
int gl_tema_betlineCount(
			  const BETLINE* betline);
int gl_tema_betpartCount(
			  uint8 bettype,
			  uint8 flagAB,
			  const GL_BETPART* bp,
			  const SUBTYPE_PARAM* subparam);
int gl_tema_FSbetCount(
			 uint8 flagAB,
			 const GL_BETPART* bp,
			 const SUBTYPE_PARAM* subparam);

#endif /* GL_TEMA_VERIFY_H_ */

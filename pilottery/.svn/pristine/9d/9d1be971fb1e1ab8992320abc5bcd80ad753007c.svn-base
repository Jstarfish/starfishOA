#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    Forrest Cao   2012.02
"""

import os, string, time
import tornado.ioloop
import tornado.web
import tornado.websocket
import json
import sqlite3
import ctypes as ct

from handler import baseHandler
import tsapi as tsapi

gstr = tsapi.get_game_list()
g_game_pair = {}
g_game_list = []
gpair = gstr.split()
for g in gpair:
    p = g.split(':')
    g_game_pair[p[0]] = p[1]
    g_game_list.append(p[1])
print g_game_list, g_game_pair

tidx_dir = "/ts_host/data/tidx_data"
game_dir = "/ts_host/data/game_data"
issue_shm_dir = "/dev/shm/ts_game"
#game_dir = os.path.join(os.path.dirname(__file__), "db")

page_size = 30

def ticket_index_path(date):
    global tidx_dir
    tpath = tidx_dir + "/%s.idx" % date
    if not os.path.exists(tpath):
        return None
    return tpath

def sale_ticket_path(game,issue):
    global game_dir
    tpath = game_dir + "/game_%s/issue_%s.db" % (game, issue)
    if not os.path.exists(tpath):
        return None
    return tpath

def win_ticket_path(game,issue):
    global game_dir
    tpath = game_dir + "/game_%s/issue_win_%s.db" % (game, issue)
    if not os.path.exists(tpath):
        return None
    return tpath

def issue_list_path(game):
    global issue_shm_dir
    tpath = issue_shm_dir + "/game_%s.db" % (game)
    if not os.path.exists(tpath):
        return None
    return tpath

def draw_procedure_path(game,issue):
    global game_dir
    tpath = game_dir + "/game_%s/draw/draw_issue_%s.db" % (game, issue)
    if not os.path.exists(tpath):
        return None
    return tpath

def draw_log_path(game):
    global game_dir
    tpath = game_dir + "/game_%s/drawlog_%s" % (game, game)
    if not os.path.exists(tpath):
        return None
    return tpath

def match_ticket_path(game,issue):
    global game_dir
    tpath = game_dir + "/game_%s/draw/draw_issue_%s.db" % (game, issue)
    if not os.path.exists(tpath):
        return None
    return tpath

def dump_issue_status(issue_status):
    if issue_status==0:
        return "RANGED"
    elif issue_status==1:
        return "PRESALE"
    elif issue_status==2:
        return "OPENED"
    elif issue_status==3:
        return "CLOSING"
    elif issue_status==4:
        return "CLOSED"
    elif issue_status==5:
        return "SEALED"
    elif issue_status==6:
        return "DRAWNUM_INPUTED"
    elif issue_status==7:
        return "MATCHED"
    elif issue_status==8:
        return "FUND_INPUTED"
    elif issue_status==9:
        return "LOCAL_CALCED"
    elif issue_status==10:
        return "PRIZE_ADJUSTED"
    elif issue_status==11:
        return "PRIZE_CONFIRMED"
    elif issue_status==12:
        return "DB_IMPORTED"
    elif issue_status==13:
        return "END"
    else:
        return "UNKNOW"

def issue_xml_path(game,issue,xml_type):
    global game_dir
    tpath = ''
    if xml_type=='draw_announce':
        tpath = game_dir + "/game_%s/draw_announce_issue_%s.xml" % (game, issue)
    elif xml_type=='winner_local':
        tpath = game_dir + "/game_%s/draw/issue_%s_winner_local.xml" % (game, issue)
    else: #winner_confirm
        tpath = game_dir + "/game_%s/draw/issue_%s_winner_confirm.xml" % (game, issue)

    if not os.path.exists(tpath):
        return None
    return tpath

def get_game_list():
    global g_game_list
    return g_game_list
def get_game_name(game_code):
    global g_game_pair
    if g_game_pair.has_key(game_code):
        return g_game_pair[game_code]
    return None

def pack_db_field(description, res):
    records = {}
    i = 0
    for j in description:
        records[j[0]] = res[i]
        i+=1
    return records

def dump_blob(blob_buffer):
    str = 'Length [ %d ]<br>' % len(blob_buffer)
    i = 0
    for ch in blob_buffer:
        hv = hex(ord(ch)).replace('0x', '')
        if len(hv) == 1:
            hv = '0' + hv
        str += hv
        i += 1
        if i%16 == 0:
            str += "<br>"
        else:
            str += '&nbsp;&nbsp;'
    return str

def format_timestamp(timestamp):
    if timestamp==0:
        return ''
    timeArray = time.localtime(timestamp)
    return time.strftime("%Y-%m-%d %H:%M:%S", timeArray)


def page_make(_counts_, _page_, _page_size_, _pre_url_):

    floatPages = float(_counts_) / _page_size_
    intPages = _counts_ / _page_size_
    _pages_ = intPages
    if intPages == 0:
        _pages_ = 1
    if floatPages > intPages:
        _pages_ = intPages + 1

    first_p = """<a href="%s&page=%s" title="First Page">&laquo; First</a>""" % ( _pre_url_, 1 )

    if _page_ > 1:
        prev_p = """<a href="%s&page=%s" title="Previous Page">&laquo; Previous</a>""" % ( _pre_url_, (_page_-1) )
    else:
        prev_p = "&laquo; Previous&nbsp;&nbsp;"

    if _pages_ - _page_ > 0 :
        next_p = """<a href="%s&page=%s" title="Next Page">Next &raquo;</a>""" % ( _pre_url_, (_page_+1) )
    else:
        next_p = "&nbsp;&nbsp;Next &raquo;"

    last_p = """<a href="%s&page=%s" title="Last Page">Last &raquo;</a>""" % ( _pre_url_, _pages_ )

    totalRecords = """TotalRecords <span class="number">%s</span>&nbsp;&nbsp;&nbsp;&nbsp;""" % _counts_
    if _counts_ == 0:
        _pages_ = 0
    totalPages = """TotalPages <span class="number">%s</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;""" % _pages_

    if _counts_ != 0:
        page_10 = ""
        if _pages_ <= 10 :
            for i in range(_pages_):
                k = i + 1
                if k == _page_ :
                    page_10 += """<a href="%s&page=%s" class="number current" title="%s">%s</a>""" % ( _pre_url_, k, k, k)
                else:
                    page_10 += """<a href="%s&page=%s" class="number" title="%s">%s</a>""" % ( _pre_url_, k, k, k)
        else:
            if _page_ <= 5:
                for i in range(10):
                    k = i + 1
                    if k == _page_ :
                        page_10 += """<a href="%s&page=%s" class="number current" title="%s">%s</a>""" % ( _pre_url_, k, k, k)
                    else:
                        page_10 += """<a href="%s&page=%s" class="number" title="%s">%s</a>""" % ( _pre_url_, k, k, k)
            else:
                p = _page_ - 5
                t = _pages_ - _page_
                if t < 5 :
                    p -= 5 - t
                for i in range(10) :
                    k = i + p + 1
                    if k > _pages_:
                        break
                    if k == _page_ :
                        page_10 += """<a href="%s&page=%s" class="number current" title="%s">%s</a>""" % ( _pre_url_, k, k, k)
                    else:
                        page_10 += """<a href="%s&page=%s" class="number" title="%s">%s</a>""" % ( _pre_url_, k, k, k)
    
        p_str =  "%s%s%s%s%s%s%s" % ( totalRecords, totalPages, first_p, prev_p, page_10, next_p, last_p )
    else:
        p_str = "-------  Empty Results  -------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"""
    return p_str


class saleticket(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        game = self.get_argument("game_code", '')
        issue = self.get_argument("issue_number", '')
        agency = self.get_argument("agency_code", '')
        page_str = self.get_argument("page", '1')
        page = string.atoi(page_str,10)

        if game=='' or issue=='':
            self.render('saleticket.html', game_list=get_game_list(),game_code=game,issue_number=issue,agency_code=agency,t_l=[],page_str='')
            return

        tpath = sale_ticket_path(game,issue)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            #self.render('saleticket.html', game_code=game,issue_number=issue,agency_code=agency,t_l=[],page_str='')
            return
        #print tpath

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        if agency == "":
            cur.execute("select count(*) from sale_ticket_table")
        else:
            cur.execute("select count(*) from sale_ticket_table where agency_code=%s" % (agency))
        rs_cnt = cur.fetchone()
        counts = rs_cnt[0]

        global page_size
        start = (page - 1) * page_size
        if agency == "":
            cur.execute("select * from sale_ticket_table limit %d offset %d" % (page_size,start))
        else:
            cur.execute("select * from sale_ticket_table where agency_code=%s limit %d offset %d" % (agency,page_size,start))
        records_tmp = cur.fetchall()
        records = []
        if len(records_tmp) > 0:
            for line_temp in records_tmp:
                line = pack_db_field(cur.description, line_temp)
                records.append(line)
        cur.close()
        conn.close()

        page_s = page_make(counts, page, page_size, "/saleticket/?game_code=%s&issue_number=%s&agency_code=%s"%(game,issue,agency))

        self.render('saleticket.html', game_list=get_game_list(),game_code=game,issue_number=issue,agency_code=agency,t_l=records,page_str=page_s,fmts=format_timestamp)

class q_saleticket(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        error = ""
        ff = self.get_argument("ffr", '1')
        tsn = self.get_argument("ticket_tsn", '')
        game = self.get_argument("game_code", '')
        issue = self.get_argument("issue_number", '')
        if len(tsn)!=24:
            error = "TSN input error"
            self.render('q_saleticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob,error_info=error)
            return

        (date,unique_tsn) = tsapi.extract_tsn(tsn)
        print date,unique_tsn

        # search tidx ticket index table
        tpath = ticket_index_path(date)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            #self.render('q_saleticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob)
            return

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        cur.execute("select * from ticket_idx_table where unique_tsn='%s'" % unique_tsn)
        records_tmp = cur.fetchone()
        if records_tmp==None:
            error = "Not found ticket"
            self.render('q_saleticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob,error_info=error)
            return
        game_c = records_tmp[3]
        issue = records_tmp[4]
        cur.close()
        conn.close()
        game = get_game_name(str(game_c))
        print "Query Sale Ticket[ %s ] -> game[%s] issue[%s]" % (tsn, game, issue)

        tpath = sale_ticket_path(game,issue)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            #self.render('q_saleticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob)
            return

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        cur.execute("select * from sale_ticket_table where unique_tsn='%s'" % unique_tsn)
        records_tmp = cur.fetchone()
        records = {}
        if records_tmp==None:
            error = "Not found ticket"
            self.render('q_saleticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob,error_info=error)
            return
        records = pack_db_field(cur.description, records_tmp)
        cur.close()
        conn.close()
        self.render('q_saleticket.html', ffr=ff,ticket_tsn=tsn,t_d=records,fmts=format_timestamp,dump=dump_blob,error_info=error)


class winticket(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        game = self.get_argument("game_code", '')
        issue = self.get_argument("issue_number", '')
        agency = self.get_argument("agency_code", '')
        page_str = self.get_argument("page", '1')
        page = string.atoi(page_str,10)

        if game=='' or issue=='':
            self.render('winticket.html', game_list=get_game_list(),game_code=game,issue_number=issue,agency_code=agency,t_l=[],page_str='')
            return

        tpath = win_ticket_path(game,issue)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            return
        #print tpath

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        if agency == "":
            cur.execute("select count(*) from win_ticket_table")
        else:
            cur.execute("select count(*) from win_ticket_table where agency_code=%s" % (agency))
        rs_cnt = cur.fetchone()
        #print 'rs_cnt -> ', rs_cnt
        counts = rs_cnt[0]

        global page_size
        start = (page - 1) * page_size

        if agency == "":
            cur.execute("select * from win_ticket_table limit %d offset %d" % (page_size,start))
        else:
            cur.execute("select * from win_ticket_table where agency_code=%s limit %d offset %d" % (agency,page_size,start))
        records_tmp = cur.fetchall()
        records = []
        if len(records_tmp) > 0:
            for line_temp in records_tmp:
                line = pack_db_field(cur.description, line_temp)
                records.append(line)
        cur.close()
        conn.close()

        page_s = page_make(counts, page, page_size, "/winticket/?game_code=%s&issue_number=%s&agency_code=%s"%(game,issue,agency))

        self.render('winticket.html', game_list=get_game_list(),game_code=game,issue_number=issue,agency_code=agency,t_l=records,page_str=page_s,fmts=format_timestamp)

class q_winticket(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        error = ""
        ff = self.get_argument("ffr", '1')
        tsn = self.get_argument("ticket_tsn", '')
        game = self.get_argument("game_code", '')
        issue = self.get_argument("issue_number", '')
        if len(tsn)!=24:
            error = "TSN input error"
            self.render('q_winticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob,error_info=error)
            return

        (date,unique_tsn) = tsapi.extract_tsn(tsn)

        # search tidx ticket index table
        tpath = ticket_index_path(date)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            #self.render('q_winticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob)
            return

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        cur.execute("select * from ticket_idx_table where unique_tsn='%s'" % unique_tsn)
        records_tmp = cur.fetchone()
        if records_tmp==None:
            error = "Not found ticket"
            self.render('q_winticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob,error_info=error)
            return
        game_c = records_tmp[3]
        issue = records_tmp[4]
        cur.close()
        conn.close()
        game = get_game_name(str(game_c))
        print "Query Win Ticket[ %s ] -> game[%s] issue[%s]" % (tsn, game, issue)

        tpath = win_ticket_path(game,issue)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            return
        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             return
        cur = conn.cursor()
        cur.execute("select * from win_ticket_table where unique_tsn='%s'" % unique_tsn)
        records_tmp = cur.fetchone()
        records = {}
        if records_tmp==None:
            error = "Not found ticket"
            self.render('q_winticket.html', ffr=ff,ticket_tsn=tsn,t_d={},dump=dump_blob,error_info=error)
            return
        records = pack_db_field(cur.description, records_tmp)
        cur.close()
        conn.close()

        self.render('q_winticket.html', ffr=ff,ticket_tsn=tsn,t_d=records,fmts=format_timestamp,dump=dump_blob,error_info=error)


class issuelist(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        game = self.get_argument("game_code", '')
        page_str = self.get_argument("page", '1')
        page = string.atoi(page_str,10)

        if game=='':
            self.render('issuelist.html', game_list=get_game_list(),game_code=game,t_l=[],page_str='')
            return

        tpath = issue_list_path(game)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            return
        print tpath

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        cur.execute("select count(*) from issue_table")
        rs_cnt = cur.fetchone()
        print 'rs_cnt -> ', rs_cnt
        counts = rs_cnt[0]

        global page_size
        start = (page - 1) * page_size

        cur.execute("select * from issue_table ORDER BY issue_number desc limit %d offset %d" % (page_size,start))
        records_tmp = cur.fetchall()
        records = []
        if len(records_tmp) > 0:
            for line_temp in records_tmp:
                line = pack_db_field(cur.description, line_temp)
                records.append(line)
        cur.close()
        conn.close()

        page_s = page_make(counts, page, page_size, "/issuelist/?game_code=%s"%(game))

        self.render('issuelist.html', game_list=get_game_list(),game_code=game,t_l=records,page_str=page_s,fmts=format_timestamp,dumpstatus=dump_issue_status)

def dump_issueBlobField(type_key, blob_buffer):
    dump_string = tsapi.dump_issue_blob_field(type_key, blob_buffer)
    print dump_string

    _dd_ = {}
    _ll_ = []
    if type_key == 1: #D_TICKETS_STAT_BLOB_KEY
        ll = dump_string.split(';')
        _dd_['s_ticketCnt'] = ll[0];
        _dd_['s_betCnt'] = ll[1];
        _dd_['s_amount'] = ll[2];
        _dd_['c_ticketCnt'] = ll[3];
        _dd_['c_betCnt'] = ll[4];
        _dd_['c_amount'] = ll[5];
        return _dd_
    elif type_key == 2: #D_WLEVEL_STAT_BLOB_KEY
        ll = dump_string.split('/')
        for al in ll:
            _d_ = {}
            sl = al.split(';')
            _d_['code'] = sl[0];
            _d_['value'] = sl[1];
            _ll_.append(_d_)
        return _ll_
    elif type_key == 3: #D_WPRIZE_LEVEL_BLOB_KEY
        ll = dump_string.split('/')
        for al in ll:
            _d_ = {}
            sl = al.split(';')
            _d_['prize_code'] = sl[0];
            _d_['hflag'] = sl[1];
            _d_['count'] = sl[2];
            _d_['money_amount'] = sl[3];
            _ll_.append(_d_)
        return _ll_
    elif type_key == 4: #D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY
        ll = dump_string.split('/')
        for al in ll:
            _d_ = {}
            sl = al.split(';')
            _d_['prize_code'] = sl[0];
            _d_['hflag'] = sl[1];
            _d_['count'] = sl[2];
            _d_['money_amount'] = sl[3];
            _ll_.append(_d_)
        return _ll_
    elif type_key == 5 or type_key == 6: #D_WFUND_INFO_BLOB_KEY  or  D_WFUND_INFO_CONFIRM_BLOB_KEY
        ll = dump_string.split(';')
        _dd_['saleAmount'] = ll[0];
        _dd_['poolName'] = ll[1];
        _dd_['poolAmount'] = ll[2];
        _dd_['adjustAmount'] = ll[3];
        _dd_['publishAmount'] = ll[4];
        _dd_['returnRate'] = ll[5];
        _dd_['prizeAmount'] = ll[6];
        _dd_['poolName_Used'] = ll[7];
        _dd_['poolAmount_Used'] = ll[8];
        _dd_['highPrize2Adjust'] = ll[9];
        _dd_['moneyEnough'] = ll[10];
        return _dd_
    return {}
    
class drawprocedure(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        game = self.get_argument("game_code", '')
        issue = self.get_argument("issue_number", '')
        page_str = self.get_argument("page", '1')
        page = string.atoi(page_str,10)

        if game=='' or issue=='':
            self.render('drawprocedure.html', game_list=get_game_list(),game_code=game,issue_number=issue,t_d={},fmts=format_timestamp,dumpstatus=dump_issue_status,dump=dump_issueBlobField)
            return

        tpath = draw_procedure_path(game,issue)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            return
        print tpath

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        cur.execute("select * from draw_table")
        records_tmp = cur.fetchone()
        records = {}
        if len(records_tmp) > 0:
            records = pack_db_field(cur.description, records_tmp)
        cur.close()
        conn.close()

        self.render('drawprocedure.html', game_list=get_game_list(),game_code=game,issue_number=issue,t_d=records,fmts=format_timestamp,dumpstatus=dump_issue_status,
            TICKETS_STAT=dump_issueBlobField(1,records['TICKETS_STAT_KEY']),
            WLEVEL_STAT=dump_issueBlobField(2,records['WLEVEL_STAT_KEY']),
            WPRIZE_LEVEL=dump_issueBlobField(3,records['WPRIZE_TABLE_KEY']),
            WPRIZE_LEVEL_CONFIRM=dump_issueBlobField(4,records['WPRIZE_TABLE_CONFIRM_KEY']),
            WFUND_INFO=dump_issueBlobField(5,records['WFUND_INFO_KEY']),
            WFUND_INFO_CONFIRM=dump_issueBlobField(6,records['WFUND_INFO_CONFIRM_KEY'])
            )

class issue_xml(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        game = self.get_argument("game_code", '')
        issue = self.get_argument("issue_number", '')
        xtype = self.get_argument("xml_type", '')

        if game=='' or issue=='' or xtype=='':
            self.render('issue_xml.html', game_list=get_game_list(),game_code=game,issue_number=issue,xml_type=xtype,xml_content='')
            return

        tpath = issue_xml_path(game,issue,xtype)
        print tpath
        if tpath is None:
            raise tornado.web.HTTPError(501)
            return

        file = open(tpath)
        xml_str_0 = file.read()
        print xml_str_0
        xml_str_1 = xml_str_0.replace('\"','\\\"')
        xml_str_2 = xml_str_1.replace('\r','')
        xml_str = xml_str_2.replace('\n','')
        print xml_str
        file.close()

        self.render('issue_xml.html', game_list=get_game_list(),game_code=game,issue_number=issue,xml_type=xtype,xml_content=xml_str)

class drawlog(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        game = self.get_argument("game_code", '')
        page_str = self.get_argument("page", '1')
        page = string.atoi(page_str,10)

        if game=='':
            self.render('drawlog.html', game_list=get_game_list(),game_code=game,t_l=[],page_str='',fmts=format_timestamp)
            return

        tpath = draw_log_path(game)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            return
        print tpath

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        cur.execute("select count(*) from draw_log_table")
        rs_cnt = cur.fetchone()
        print 'rs_cnt -> ', rs_cnt
        counts = rs_cnt[0]

        global page_size
        start = (page - 1) * page_size

        cur.execute("select * from draw_log_table order by msgid desc limit %d offset %d" % (page_size,start))
        records_tmp = cur.fetchall()
        records = []
        if len(records_tmp) > 0:
            for line_temp in records_tmp:
                line = pack_db_field(cur.description, line_temp)
                records.append(line)
        cur.close()
        conn.close()
        
        page_s = page_make(counts, page, page_size, "/drawlog/?game_code=%s"%(game))

        self.render('drawlog.html', game_list=get_game_list(),game_code=game,t_l=records,page_str=page_s,fmts=format_timestamp)


class drawcode(baseHandler):
    def get(self):
        return self.post()

    @tornado.web.authenticated
    def post(self):
        game = self.get_argument("game_code", '')
        page_str = self.get_argument("page", '1')
        page = string.atoi(page_str,10)

        if game=='':
            self.render('drawcode.html', game_list=get_game_list(),game_code=game,t_l=[],page_str='',fmts=format_timestamp)
            return

        tpath = draw_log_path(game)
        if tpath is None:
            raise tornado.web.HTTPError(501)
            return
        print tpath

        conn = sqlite3.connect(tpath)
        if not conn:
             raise tornado.web.HTTPError(501)
             #self.write_error(501)
             return
        cur = conn.cursor()
        cur.execute("select count(*) from draw_code_table")
        rs_cnt = cur.fetchone()
        print 'rs_cnt -> ', rs_cnt
        counts = rs_cnt[0]

        global page_size
        start = (page - 1) * page_size

        cur.execute("select * from draw_code_table order by msgid desc limit %d offset %d" % (page_size,start))
        records_tmp = cur.fetchall()
        records = []
        if len(records_tmp) > 0:
            for line_temp in records_tmp:
                line = pack_db_field(cur.description, line_temp)
                records.append(line)
        cur.close()
        conn.close()
        
        page_s = page_make(counts, page, page_size, "/drawcode/?game_code=%s"%(game))

        self.render('drawcode.html', game_list=get_game_list(),game_code=game,t_l=records,page_str=page_s,fmts=format_timestamp)


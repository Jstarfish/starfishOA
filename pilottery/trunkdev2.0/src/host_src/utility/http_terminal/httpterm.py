#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    Forrest Cao   2012.02

"""

import sys
import time
import threading
import Queue
import httplib, urllib
from urllib import quote
import json

url = "192.168.26.160:20080"
thread_num = 1
method = "POST" #GET

g_msn = 1
failure_count = 0
success_count = 0
q = Queue.Queue(0)
def echo_msg(agency_code,msn,echo_str):
    echo_msg_d = {}
    echo_msg_d["version"] = "1.1.1"
    echo_msg_d["type"] = 5
    echo_msg_d["func"] = 1
    echo_msg_d["token"] = agency_code
    echo_msg_d["msn"] = msn
    echo_msg_d["when"] = int(time.time())
    params = {}
    params["echo"] = echo_str
    echo_msg_d["params"] = params
    return "%s" % json.dumps(echo_msg_d)

def sale_msg(agency_code,msn,reqfn,bet_string):
    sale_msg_d = {}
    sale_msg_d["version"] = "1.1.1"
    sale_msg_d["type"] = 5
    sale_msg_d["func"] = 5001
    sale_msg_d["token"] = agency_code
    sale_msg_d["msn"] = msn
    sale_msg_d["when"] = int(time.time())
    params = {}
    params["reqfn"] = reqfn
    params["bet_string"] = bet_string
    sale_msg_d["params"] = params
    return "%s" % json.dumps(sale_msg_d)


def sendHttpReq(_queue_,_method_):
    global failure_count, success_count
    while True:
        msg = _queue_.get()

        conn = httplib.HTTPConnection(url)
        s = ""
        if _method_ == "GET":
            s = "/do?" + quote(msg)
            conn.request("GET", s)
            print "Tx  [get] ->  %s" % msg
        else:
            conn.request("POST", "/do", msg)
            print "Tx  [post] ->  %s" % msg
        r = conn.getresponse()
        print "STATUS [%s]  REASON [%s]" % (r.status, r.reason)
        print "Rx->  %s" % r.read()
        if r.status != 200:
            failure_count += 1
        else:
            success_count += 1
        conn.close()

class WorkThread(threading.Thread):
    def __init__(self,func,args,name=''):
        threading.Thread.__init__(self)
        self.setName(name)
        self.setDaemon(True)
        self.func=func
        self.args=args

    def run(self):
        print "thread[", self.getName(), "] start. ", time.ctime()
        apply(self.func, self.args)
        print "thread[", self.getName(), "] end. ", time.ctime()

if __name__=='__main__':
    if len(sys.argv) != 3:
        print "Input argument error."
        sys.exit()
    agency_code = int(sys.argv[1])
    in_filepath = sys.argv[2]
    print agency_code, in_filepath

    que = Queue.Queue(0)
    threads=[]
    for i in range(thread_num):
        t = WorkThread(sendHttpReq, (que,method), 'thread_%d'%i)
        threads.append(t)
    for i in range(thread_num):
        threads[i].start()

    que.put(echo_msg(agency_code,g_msn,"echo message test"))
    g_msn += 1
    while success_count != 1:
        time.sleep(1)
    print "Communication test success."

    success_count = 0
    failure_count = 0    
    sequence = 0
    in_file = open(in_filepath)
    r_line = in_file.readline()
    while r_line:
        sequence += 1

        request_flowno = time.strftime("%Y%m%d%H%M%S")[2:] + "%06d" % sequence
        bet_string = r_line
        que.put(sale_msg(agency_code,g_msn,request_flowno,bet_string))
        g_msn += 1

        r_line = in_file.readline()
    in_file.close()

    while (success_count+failure_count) != sequence:
        print "Total Request[%d]  success_count[%d] failure_count[%d]" % (sequence,success_count,failure_count)
        time.sleep(1)

    print "\nProcess summary Count [%d]" % sequence
    print "Failure Count [%d]\n" % failure_count


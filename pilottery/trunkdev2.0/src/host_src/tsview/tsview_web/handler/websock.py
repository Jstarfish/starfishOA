#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    Forrest Cao   2012.02

"""

import tornado.ioloop
import tornado.web
import tornado.websocket
import json


class wsHandler(tornado.websocket.WebSocketHandler):
    clients = set()

    def get_message(self, _id_, type, msg):
        msg_d = {}
        msg_d['id'] = _id_
        msg_d['type'] = 'sys'
        msg_d['time'] = time.strftime("%y-%m-%d %H:%M:%S", time.localtime())
        msg_d['message'] = msg
        return json.dumps(msg_d)

    @staticmethod
    def send_to_all(message):
        print "***wsHandler[%s] message[%s]" % (wsHandler, message)
        for c in wsHandler.clients:
            print "c ", c
            c.write_message(message)
        
    def open(self):
        message = self.get_message(id(self), 'sys', 'Welcome to WebSocket')
        self.write_message(message)
        print message
        
        message = self.get_message(id(self), 'sys', str(id(self))+' has joined')
        wsHandler.send_to_all(message)
        print message

        self.clients.add(self)

    def on_close(self):
        self.clients.remove(self)
        
        message = self.get_message(id(self), 'sys', str(id(self))+' has left')
        wsHandler.send_to_all(message)

    def on_message(self, message):
        message = self.get_message(id(self), 'user', message)
        wsHandler.send_to_all(message)

idx = 0
def timer_handle():
    global idx
    print '111  &&&&&&&&&& wsHandler[%s]' % wsHandler
    print '1'
    idx = idx + 1
    print '2'
    m_d = {}
    print '3'
    m_d['id'] = idx
    m_d['type'] = 'sys'
    print '4'
    m_d['time'] = time.strftime("%y-%m-%d %H:%M:%S", time.localtime())
    print '5'
    m_d['message'] = "caoxifeng"
    print '222  &&&&&&&&&& wsHandler[%s]' % wsHandler
    wsHandler.send_to_all(json.dumps(m_d))


class whTimer(object): 
    def __init__(self, interval, function, args=[], kwargs={}): 
        self.interval = interval 
        self.function = function 
        self.args = args 
        self.kwargs = kwargs
        print "args = ", args
        print "kwargs = ", kwargs

    def start(self): 
        self.stop() 
        import threading 
        self._timer = threading.Timer(self.interval, self._run)
        self._timer.setDaemon(True) 
        self._timer.start()

    def restart(self): 
        self.start()

    def stop(self): 
        if self.__dict__.has_key("_timer"): 
            self._timer.cancel() 
            del self._timer

    def _run(self): 
        try:
            print "---",self.function
            #self.function(*self.args, **self.kwargs)
            self.function()
        except: 
            pass 
        self.restart()

def init_websock():
    wh_timer = whTimer(3, timer_handle, ())
    wh_timer.start()

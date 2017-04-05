#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    Forrest Cao   2012.02

"""

import tornado.ioloop
import tornado.web
import tornado.websocket
import json

class baseHandler(tornado.web.RequestHandler):
    def get(self):
        #self.write_error(404)
        raise tornado.web.HTTPError(404)

    def write_error(self, status_code, **kwargs):
        if status_code == 404:
            self.render('notfound_404.html')
        elif status_code == 501:
            self.render('servererror_500.html')
        else:
            self.render('servererror_500.html')
            #self.write('error:' + str(status_code))
            #super(RequestHandler, self).write_error(status_code, **kwargs)

    def get_current_user(self):
        return self.get_secure_cookie('tsview_user')

class login(baseHandler):
    def get(self):
        self.render('login.html')

    def post(self):
        user = self.get_argument("username")
        pwd = self.get_argument("password")
        if (user=='admin') and (pwd=='123456'):
            self.set_secure_cookie("tsview_user", self.get_argument("username"), expires_days=1)
        self.redirect('/', permanent=True)

class logout(baseHandler):
    def get(self):
        self.clear_cookie("tsview_user")
        self.redirect('/', permanent=True)

class index(baseHandler):
    @tornado.web.authenticated
    def get(self):
        print "Hi,", self.current_user
		#if not self.request.headers.get("Cookie"):  
        #    self.write("Please enable your Cookie option of your browser.")
        #    return
        self.render('index.html')

class menu(baseHandler):
    def get(self):
        self.render('menu.html', username=self.get_current_user())

class home(baseHandler):
    def get(self):
        self.render('home.html')


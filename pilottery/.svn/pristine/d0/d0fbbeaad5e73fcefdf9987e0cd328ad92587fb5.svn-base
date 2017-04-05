#

import os, time
import tornado.httpserver
import tornado.ioloop
import tornado.web
import tornado.websocket
import json

from tornado.options import define, options
define("port", default=8080, help="run on the given port", type=int)

from handler import tsapi
from handler import websock
from handler import handler
from handler import handler_bi

settings = { 
    "static_path" : os.path.join(os.path.dirname(__file__), "static"), 
    "template_path" : os.path.join(os.path.dirname(__file__), "templates"), 
    "gzip" : True, 
    "debug" : True,
    "login_url" : '/login/',
    "cookie_secret" : "61oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=",
}

application = tornado.web.Application([
        (r'/wsoc/', websock.wsHandler),

        (r'/', handler.index),
        (r'/login/', handler.login),
        (r'/logout/', handler.logout),
        (r'/menu/', handler.menu),
        (r'/home/', handler.home),

        (r'/saleticket/', handler_bi.saleticket),
        (r'/q_saleticket/', handler_bi.q_saleticket),
        (r'/winticket/', handler_bi.winticket),
        (r'/q_winticket/', handler_bi.q_winticket),
        (r'/issuelist/', handler_bi.issuelist),
        (r'/drawprocedure/', handler_bi.drawprocedure),
        (r'/issue_xml/', handler_bi.issue_xml),
        (r'/drawcode/', handler_bi.drawcode),
        (r'/drawlog/', handler_bi.drawlog),
        
        (r'.*', handler.baseHandler),
    ],
    **settings
)

if __name__ == "__main__":
    tornado.options.parse_command_line()

    if tsapi.init()==False:
        print "tsapi.init() error !!!"
        sys.exit()

    #websock.init_websock()

    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()


#(r'.*', handler.errorHandler),
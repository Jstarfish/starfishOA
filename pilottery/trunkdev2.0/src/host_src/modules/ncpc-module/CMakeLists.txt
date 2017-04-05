
ADD_LIBRARY(ncpc SHARED ncpcmod.cpp)
#VERSION standfor ncpc.so version; SOVERSION standfor API version
SET_TARGET_PROPERTIES(ncpc PROPERTIES VERSION 1.0 SOVERSION 0)

ADD_EXECUTABLE(ncpc_task ncpc_task.cpp ncpc_net.cpp ncpc_message.cpp ncpc_message_ncp.cpp ncpc_message_terminal.cpp ncpc_http_message.cpp ncpc_http_parse.cpp)
TARGET_LINK_LIBRARIES(ncpc_task ncpc frmwk sysdb bqueues tms gl dbotl leveldb)

ADD_EXECUTABLE(ncpc_ap_pay ncpc_ap_pay.cpp)
TARGET_LINK_LIBRARIES(ncpc_ap_pay frmwk bqueues sysdb gl dbotl)

#ADD_EXECUTABLE(load_test load_test.cpp)
#TARGET_LINK_LIBRARIES(load_test pthread)


INSTALL(TARGETS ncpc ncpc_task ncpc_ap_pay
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)




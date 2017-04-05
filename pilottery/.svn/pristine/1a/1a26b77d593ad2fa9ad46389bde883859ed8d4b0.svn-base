
# FILE(GLOB SRC_LIST "*.cpp")
# ADD_EXECUTABLE(tsview ${SRC_LIST}) 
ADD_EXECUTABLE(tsview tsview.cpp win_bqueues.cpp win_gl.cpp win_gl_issue.cpp win_gl_rk.cpp win_ncpc.cpp win_sysdb.cpp win_tfe.cpp win_tms.cpp win_toolbox.cpp tsdialog.cpp win_help.cpp) 
TARGET_LINK_LIBRARIES(tsview ncursesw menu panel form frmwk ncpc tms gl tfe sysdb bqueues)

ADD_LIBRARY(ts4py SHARED ts4py.cpp)
TARGET_LINK_LIBRARIES(ts4py frmwk sysdb ncpc bqueues gl tms tfe rt dl)
#VERSION standfor so version; SOVERSION standfor API version
SET_TARGET_PROPERTIES(ts4py PROPERTIES VERSION 1.0 SOVERSION 0)

INSTALL(TARGETS tsview ts4py
        RUNTIME DESTINATION sbin
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)

INSTALL(DIRECTORY tsview_web DESTINATION sbin)


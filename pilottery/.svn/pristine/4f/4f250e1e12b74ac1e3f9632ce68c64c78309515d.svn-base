ADD_EXECUTABLE(gl_driver gl_task_issue.cpp)
TARGET_LINK_LIBRARIES(gl_driver frmwk bqueues sysdb gl dbotl) 

ADD_EXECUTABLE(gl_fbs_driver gl_task_fbs_issue.cpp)
TARGET_LINK_LIBRARIES(gl_fbs_driver frmwk bqueues sysdb gl dbotl) 

ADD_EXECUTABLE(gl_draw gl_task_draw.cpp)
TARGET_LINK_LIBRARIES(gl_draw frmwk bqueues sysdb gl dbotl)

# FBS
ADD_EXECUTABLE(gl_draw_FBS gl_task_draw_fbs.cpp)
TARGET_LINK_LIBRARIES(gl_draw_FBS frmwk bqueues sysdb gl dbotl)


#ADD_EXECUTABLE(gidb_test gidb_test.cpp)
#TARGET_LINK_LIBRARIES(gidb_test frmwk bqueues sysdb gl)


INSTALL(TARGETS gl_driver gl_fbs_driver gl_draw gl_draw_FBS
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)



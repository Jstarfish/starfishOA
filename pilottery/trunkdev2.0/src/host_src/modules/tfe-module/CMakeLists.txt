
ADD_LIBRARY(tfe SHARED tfemod.cpp)
TARGET_LINK_LIBRARIES(tfe dl)
#VERSION standfor so version; SOVERSION standfor API version
SET_TARGET_PROPERTIES(tfe PROPERTIES VERSION 1.0 SOVERSION 0)

ADD_EXECUTABLE(tfe_adder tfe_task_adder.cpp)
TARGET_LINK_LIBRARIES(tfe_adder frmwk bqueues sysdb tfe tms gl)

ADD_EXECUTABLE(tfe_flush tfe_task_flush.cpp)
TARGET_LINK_LIBRARIES(tfe_flush frmwk bqueues sysdb tfe)

ADD_EXECUTABLE(tfe_reply tfe_task_reply.cpp tfe_reply_function.cpp)
TARGET_LINK_LIBRARIES(tfe_reply frmwk bqueues sysdb tfe gl tms ncpc)

ADD_EXECUTABLE(tfe_scan tfe_task_scan.cpp)
TARGET_LINK_LIBRARIES(tfe_scan frmwk bqueues sysdb tfe gl dbotl)

ADD_EXECUTABLE(tfe_updater tfe_task_updater.cpp)
TARGET_LINK_LIBRARIES(tfe_updater frmwk bqueues sysdb tfe gl dbotl)

ADD_EXECUTABLE(tfe_updater_db tfe_task_updater_db.cpp)
TARGET_LINK_LIBRARIES(tfe_updater_db frmwk bqueues sysdb tfe tms gl dbotl)

#ADD_EXECUTABLE(tfe_updater_db2 tfe_task_updater_db2.cpp)
#TARGET_LINK_LIBRARIES(tfe_updater_db2 frmwk bqueues sysdb tfe gl dbotl)

ADD_EXECUTABLE(tsnUpgrade tsn_upgrade.cpp)
TARGET_LINK_LIBRARIES(tsnUpgrade frmwk bqueues sysdb tfe gl dbotl)

#INSTALL(TARGETS tfe tfe_adder tfe_flush tfe_reply tfe_scan tfe_updater tfe_updater_db tfe_updater_db2 tsnUpgrade
INSTALL(TARGETS tfe tfe_adder tfe_flush tfe_reply tfe_scan tfe_updater tfe_updater_db tsnUpgrade
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)


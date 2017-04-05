
ADD_LIBRARY(sysdb SHARED sysdb.cpp)
TARGET_LINK_LIBRARIES(sysdb pthread)
#VERSION standfor so version; SOVERSION standfor API version
SET_TARGET_PROPERTIES(sysdb PROPERTIES VERSION 1.0 SOVERSION 0)

ADD_EXECUTABLE(tstop tstop.cpp ts_utils.cpp)
TARGET_LINK_LIBRARIES(tstop frmwk tfe tms gl ncpc sysdb bqueues dbotl)

INSTALL(TARGETS sysdb tstop
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)


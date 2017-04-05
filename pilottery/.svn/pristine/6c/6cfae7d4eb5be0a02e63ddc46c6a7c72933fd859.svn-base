
ADD_LIBRARY(bqueues SHARED bqueues.cpp)
TARGET_LINK_LIBRARIES(bqueues pthread)
#VERSION standfor so version; SOVERSION standfor API version
SET_TARGET_PROPERTIES(bqueues PROPERTIES VERSION 1.0 SOVERSION 0)

#ADD_EXECUTABLE(bqueuesd bqueuesd.cpp bqueuesnet.cpp)
#TARGET_LINK_LIBRARIES(bqueuesd frmwk bqueues sysdb)

#INSTALL(TARGETS bqueues bqueuesd
INSTALL(TARGETS bqueues
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)


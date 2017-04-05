
ADD_LIBRARY(frmwk SHARED hcipc.cpp hclogit.cpp hcnetio.cpp md5.cpp crc16.cpp hctimes.cpp hcutils.cpp xml.cpp cjson.cpp)
TARGET_LINK_LIBRARIES(frmwk rt)
#VERSION standfor so version; SOVERSION standfor API version
SET_TARGET_PROPERTIES(frmwk PROPERTIES VERSION 1.0 SOVERSION 0)

INSTALL(TARGETS frmwk
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)




SET(vhost_src vhost.cpp)
ADD_EXECUTABLE(vhost ${vhost_src})
TARGET_LINK_LIBRARIES(vhost ev)

INSTALL(TARGETS vhost
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)

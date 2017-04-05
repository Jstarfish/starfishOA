
ADD_EXECUTABLE(rng_server rng_server.cpp 3des.cpp)
TARGET_LINK_LIBRARIES(rng_server pthread frmwk sysdb bqueues gl)

INSTALL(TARGETS rng_server
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)


ADD_EXECUTABLE(dummyserver dummy_server.cpp 3des.cpp crc16.cpp)
TARGET_LINK_LIBRARIES(dummyserver)

#ADD_EXECUTABLE(dummyclient dummy_client.cpp 3des.cpp crc16.cpp)
#TARGET_LINK_LIBRARIES(dummyclient)

ADD_EXECUTABLE(rngclient client.cpp 3des.cpp crc16.cpp sample.cpp knuth.cpp
                         xml.cpp game_manager.cpp shm_mod.cpp)
TARGET_LINK_LIBRARIES(rngclient pthread fmapiv100)

INSTALL(TARGETS dummyserver rngclient
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs)

ADD_EXECUTABLE(rngview rng_view.cpp shm_mod.cpp)
TARGET_LINK_LIBRARIES(rngview ncurses)

INSTALL(TARGETS rngview
        RUNTIME DESTINATION sbin
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs)
